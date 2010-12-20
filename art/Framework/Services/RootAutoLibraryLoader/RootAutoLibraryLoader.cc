//
// Package:     LibraryLoader
// Class  :     RootAutoLibraryLoader
//


#include "art/Framework/Services/RootAutoLibraryLoader/RootAutoLibraryLoader.h"

#include "art/Framework/PluginManager/PluginCapabilities.h"
#include "art/Framework/PluginManager/PluginManager.h"
#include "art/Framework/PluginManager/ProblemTracker.h"
#include "art/Framework/Services/RootAutoLibraryLoader/stdNamespaceAdder.h"
#include "art/Utilities/DebugMacros.h"

#include "boost/regex.hpp"

#include "Cintex/Cintex.h"
#include "G__ci.h"
#include "Reflex/Type.h"
#include "TClass.h"
#include "TROOT.h"

#include <iostream>
#include <map>
#include <string>


//
// constants, enums and typedefs
//
namespace {
  //Based on http://root.cern.ch/lxr/source/cintex/src/CINTSourceFile.h
  // If a Cint dictionary is accidently loaded as a side effect of loading a CMS
  // library Cint must have a file name assigned to that dictionary else Cint may crash
  class CintCrashPreventionSentry {
  public:
    CintCrashPreventionSentry()
    {
      G__setfilecontext("{CMS auto library loader}", &oldIFile_);
    }

    ~CintCrashPreventionSentry()
    {
      G__input_file* ifile = G__get_ifile();
      if (ifile) {
        *ifile = oldIFile_;
      }
    }

  private:
    G__input_file oldIFile_;
  };
}

//
// static data member definitions
//
//hold onto the previous autolibrary loader
typedef int (*CallbackPtr) G__P((char*,char*));
static CallbackPtr gPrevious = 0;
static const char* kDummyLibName = "*dummy";

//This is actually defined within ROOT's v6_struct.cxx file but is not declared static
// I want to use it so that if the autoloading is already turned on, I can call the previously declared routine
extern CallbackPtr G__p_class_autoloading;

namespace art {

  static
    std::map<std::string,std::string>&
    cintToReflexSpecialCasesMap()
  {
    static std::map<std::string,std::string> s_map;
    return s_map;
  }

  static
    void
    addWrapperOfVectorOfBuiltin(std::map<std::string,std::string>& iMap, const char* iBuiltin)
  {
    static std::string sReflexPrefix("art::Wrapper<std::vector<");
    static std::string sReflexPostfix("> >");

   //Wrapper<vector<float,allocator<float> > >
    static std::string sCintPrefix("Wrapper<vector<");
    static std::string sCintMiddle(",allocator<");
    static std::string sCintPostfix("> > >");

    std::string type(iBuiltin);
    iMap.insert(make_pair(sCintPrefix+type+sCintMiddle+type+sCintPostfix,
      sReflexPrefix+type+sReflexPostfix));
  }

  static
    bool loadLibraryForClass(const char* classname)
  {
    FDEBUG(2) << "loadLibaryForClass" << "\n";
    if(0 == classname) return false;

    static const std::string cPrefix("LCGReflex/");
    std::string full_name(cPrefix + classname);
    FDEBUG(2) << "asking to find " << full_name << "\n";

    try {
    //give ROOT a name for the file we are loading
      CintCrashPreventionSentry sentry;
      if(artplugin::PluginCapabilities::get()->tryToLoad(full_name))
      {
        Reflex::Type t = Reflex::Type::ByName(classname);
        if (Reflex::Type() == t)
        {
            //would be nice to issue a warning here
          FDEBUG(1) << "loadLibraryForClass: got a dud!\n";
          return false;
        }
        if(!t.IsComplete())
        {
            // would be nice to issue a warning here.
            // Not sure the remainder of this comment is correct.
            // this message happens too often (too many false positives)
            // to be useful plus ROOT will complain about a missing dictionary
            // std::cerr <<"Warning: Reflex knows about type '"
            // <<classname<<"' but has no dictionary for it."<<std::endl;
          FDEBUG(1) << "loadLibraryForClass: for an incomplete type!\n";
          return false;
        }
      }
      else
      {
        //see if adding a std namespace helps
        std::string name = root::stdNamespaceAdder(classname);
        FDEBUG(2) << " see if std helps:  " << name << "\n";

        if (not artplugin::PluginCapabilities::get()->tryToLoad(cPrefix+name))
        {
            // Too many false positives on built-in types here.
          return false;
        }

        Reflex::Type t = Reflex::Type::ByName(name);
        if (Reflex::Type() == t)
        {
          t = Reflex::Type::ByName(classname);
          if (Reflex::Type() == t)
          {
                //would be nice to issue a warning here
            return false;
          }
        }
      }
    }
    catch(cet::exception& e)
    {
      //would be nice to issue a warning here
      return false;
    }

  //std::cout <<"loaded "<<classname<<std::endl;
    return true;
  }

//Based on code in ROOT's TCint.cxx file

  static int ALL_AutoLoadCallback(char *c, char *l)
  {
    FDEBUG(2) << "in ALL_AutoLoadCallback " << c << " " << l << "\n";
  // NOTE: if the library (i.e. 'l') is an empty string this
  // means we are dealing with a namespace
  // These checks appear to avoid a crash of ROOT during
  // shutdown of the application

    if(0==c || 0==l || l[0]==0) return 0;

    ULong_t varp = G__getgvp();
    G__setgvp(G__PVOID);
    int result = loadLibraryForClass(c) ? 1:0;
    G__setgvp(varp);

  //NOTE: the check for the library is done since we can have a failure
  // if a CMS library has an incomplete set of Reflex dictionaries where
  // the remaining dictionaries can be found by Cint.  If the library with
  // the Reflex dictionaries is loaded first, then the Cint library then any
  // requests for a Reflex::Type from the Reflex library will fail because for
  // some reason the loading of the Cint library causes Reflex to forget about
  // what types it already loaded from the Reflex library.  This problem was
  // seen for libDataFormatsMath and libMathCore.
  // I do not print an error message
  // since the dictionaries are actually loaded so things work fine.

    if(!result && 0 != strcmp(l,kDummyLibName) && gPrevious) {
      result = gPrevious(c,l);
    }
    return result;
  }

  static std::string
    classNameForRoot(const std::string& iCapName)
  {
  //need to remove any 'std::' since ROOT ignores it
    static const boost::regex ex("std::");
    const std::string to("");

    return regex_replace(iCapName, ex, to, boost::match_default | boost::format_sed);

    return iCapName;
  }

//Cint requires that we register the type and library containing the type
// before the autoloading will work
  namespace {
    struct CompareFirst {
      bool operator()(const std::pair<std::string,std::string>&iLHS,
      const std::pair<std::string,std::string>&iRHS) const{
        return iLHS.first > iRHS.first;
      }
    };
  }
  static
  void registerTypes() {
    FDEBUG(2) << "autoloader: registerTypes\n";
    artplugin::PluginCapabilities::get();
    artplugin::PluginManager*db =  artplugin::PluginManager::get();

    typedef artplugin::PluginManager::CategoryToInfos CatToInfos;

    CatToInfos::const_iterator itFound = db->categoryToInfos().find("Capability");

    if(itFound == db->categoryToInfos().end()) {
      return;
    }

  //in order to determine if a name is from a class or a namespace, we will order
  // all the classes in descending order so that embedded classes will be seen before
  // their containing classes, that way we can say the containing class is a namespace
  // before finding out it is actually a class
    typedef std::vector<std::pair<std::string,std::string> > ClassAndLibraries;
    ClassAndLibraries classes;
    classes.reserve(1000);
    std::string lastClass;

  //find where special cases come from
    std::map<std::string,std::string> specialsToLib;
    const std::map<std::string,std::string>& specials = cintToReflexSpecialCasesMap();
    for(std::map<std::string,std::string>::const_iterator itSpecial = specials.begin();
    itSpecial != specials.end();
    ++itSpecial) {
      specialsToLib[classNameForRoot(itSpecial->second)];
    }
    static const std::string cPrefix("LCGReflex/");
    for (artplugin::PluginManager::Infos::const_iterator itInfo = itFound->second.begin(),
      itInfoEnd = itFound->second.end();
    itInfo != itInfoEnd; ++itInfo)
    {
      FDEBUG(4) << "autoload: info name = " << itInfo->name_ << "\n";
      if (lastClass == itInfo->name_) {
        continue;
      }
      lastClass = itInfo->name_;
      if(cPrefix == lastClass.substr(0,cPrefix.size())) {
        std::string className = classNameForRoot(lastClass.c_str()+cPrefix.size());
        classes.push_back(std::pair<std::string,std::string>(className, itInfo->loadable_.native_file_string()));
        std::map<std::string,std::string>::iterator itFound = specialsToLib.find(className);
        if(itFound !=specialsToLib.end()){
          itFound->second = itInfo->loadable_.native_file_string();
        }
        FDEBUG(4) << "autoload: root name = " << className << "\n";
      }
    }
  //sort_all(classes, std::greater<std::string>());
  //sort_all(classes, CompareFirst());
  //the values are already sorted by less, so just need to reverse to get greater
    for(ClassAndLibraries::reverse_iterator itClass = classes.rbegin(), itClassEnd = classes.rend();
    itClass != itClassEnd;
    ++itClass) {

      const std::string& className = itClass->first;
      const std::string& libraryName = itClass->second;
    //need to register namespaces and figure out if we have an embedded class
      static const std::string toFind(":<");
      std::string::size_type pos=0;
      while(std::string::npos != (pos = className.find_first_of(toFind,pos))) {
        if (className[pos] == '<') {break;}
        if (className.size() <= pos+1 || className[pos+1] != ':') {break;}
      //should check to see if this is a class or not
        G__set_class_autoloading_table((char*)(className.substr(0,pos).c_str()),"");
      //std::cout <<"namespace "<<className.substr(0,pos).c_str()<<std::endl;
        pos += 2;
      }
      G__set_class_autoloading_table(const_cast<char*>(className.c_str()), const_cast<char*>(libraryName.c_str()));
    //std::cout <<"class "<<className.c_str()<<std::endl;
    }

  //now handle the special cases
    for(std::map<std::string,std::string>::const_iterator itSpecial = specials.begin();
    itSpecial != specials.end();
    ++itSpecial) {
    //std::cout <<"registering special "<<itSpecial->first<<" "<<itSpecial->second<<" "<<specialsToLib[classNameForRoot(itSpecial->second)]<<std::endl;
    //force loading of specials
      if(specialsToLib[classNameForRoot(itSpecial->second)].size()) {
      //std::cout <<"&&&&& found special case "<<itSpecial->first<<std::endl;
        std::string name=itSpecial->second;
        if(not artplugin::PluginCapabilities::get()->tryToLoad(cPrefix+name)) {
          std::cout <<"failed to load plugin"<<std::endl;
          continue;
        } else {
        //need to construct the Class ourselves
          Reflex::Type t = Reflex::Type::ByName(name);
          if(Reflex::Type() == t) {
            std::cout <<"reflex did not build "<<name<<std::endl;
            continue;
          }
          TClass* reflexNamedClass = TClass::GetClass(t.TypeInfo());
          if(0==reflexNamedClass){
            std::cout <<" failed to get TClass by typeid"<<std::endl;
            continue;
          }
        // MyClass* myNewlyNamedClass = new MyClass(*reflexNamedClass);
          TClass* myNewlyNamedClass = dynamic_cast<TClass*>(reflexNamedClass->Clone());
          myNewlyNamedClass->SetName(itSpecial->first.c_str());
          gROOT->AddClass(myNewlyNamedClass);
        }
      }
    }
  }

//
// constructors and destructor
//
  RootAutoLibraryLoader::RootAutoLibraryLoader() :
  classNameAttemptingToLoad_(0)
  {
    gROOT->AddClassGenerator(this);
    ROOT::Cintex::Cintex::Enable();

   //set the special cases
    std::map<std::string,std::string>& specials = cintToReflexSpecialCasesMap();
    if(specials.empty()) {
      addWrapperOfVectorOfBuiltin(specials,"char");
      addWrapperOfVectorOfBuiltin(specials,"unsigned char");
      addWrapperOfVectorOfBuiltin(specials,"signed char");
      addWrapperOfVectorOfBuiltin(specials,"short");
      addWrapperOfVectorOfBuiltin(specials,"unsigned short");
      addWrapperOfVectorOfBuiltin(specials,"int");
      addWrapperOfVectorOfBuiltin(specials,"unsigned int");
      addWrapperOfVectorOfBuiltin(specials,"long");
      addWrapperOfVectorOfBuiltin(specials,"unsigned long");

      addWrapperOfVectorOfBuiltin(specials,"float");
      addWrapperOfVectorOfBuiltin(specials,"double");
    }
   //std::cout <<"my loader"<<std::endl;
   //remember if the callback was already set so we can chain together our results
    gPrevious = G__p_class_autoloading;
    G__set_class_autoloading_callback(&ALL_AutoLoadCallback);
    registerTypes();
  }


//
// member functions
//

  TClass *
    RootAutoLibraryLoader::GetClass(const char* classname, Bool_t load)
  {
    if(classname == classNameAttemptingToLoad_)
    {
      std::cerr << "WARNING: Reflex failed to create CINT dictionary for "
        << classname << std::endl;
      return 0;
    }

    TClass* returnValue = 0;

    FDEBUG(2) << "looking for " << classname << " load " << (load? "T":"F")
      << std::endl;

    if (load)
    {
      FDEBUG(2) << " going to call loadLibraryForClass" << std::endl;

      if (loadLibraryForClass(classname))
      {
          //use this to check for infinite recursion attempt
        classNameAttemptingToLoad_ = classname;
          // This next call will create the TClass object for the class.
          // It will also attempt to load the dictionary for the class
          // if the second argument is kTRUE. This is the default, so it
          // need not be explicitly specified.
        returnValue = gROOT->GetClass(classname, kTRUE);
        classNameAttemptingToLoad_ = 0;
      }
    }
    return returnValue;
  }


  TClass *
    RootAutoLibraryLoader::GetClass(const type_info& typeinfo, Bool_t load)
  {
    FDEBUG(2) << "autolibloader: GetClass\n";
  //std::cout <<"looking for type "<<typeinfo.name()<<std::endl;
    TClass* returnValue = 0;
    if(load){
      return GetClass(typeinfo.name(), load);
    }
    return returnValue;
  }

  void
    RootAutoLibraryLoader::enable()
  {
   //static BareRootProductGetter s_getter;
   //static art::EDProductGetter::Operate s_op(&s_getter);
    static RootAutoLibraryLoader s_loader;
  }

  void
    RootAutoLibraryLoader::loadAll()
  {
  // std::cout <<"LoadAllDictionaries"<<std::endl;
    enable();

    artplugin::PluginManager*db =  artplugin::PluginManager::get();

    typedef artplugin::PluginManager::CategoryToInfos CatToInfos;

    CatToInfos::const_iterator itFound = db->categoryToInfos().find("Capability");

    if(itFound == db->categoryToInfos().end()) {
      return;
    }
    std::string lastClass;
    const std::string cPrefix("LCGReflex/");

  //give ROOT a name for the file we are loading
    CintCrashPreventionSentry sentry;

    for (artplugin::PluginManager::Infos::const_iterator itInfo = itFound->second.begin(),
      itInfoEnd = itFound->second.end();
    itInfo != itInfoEnd; ++itInfo)
    {
      if (lastClass == itInfo->name_) {
        continue;
      }

      lastClass = itInfo->name_;
      artplugin::PluginCapabilities::get()->load(lastClass);
    //NOTE: since we have the library already, we could be more efficient if we just load it ourselves
    }
  }

}  // namespace art

//ClassImp(RootAutoLibraryLoader)
