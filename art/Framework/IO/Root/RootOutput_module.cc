// ======================================================================
//
// RootOutput
//
// ======================================================================

#include "art/Framework/IO/Root/RootOutput.h"

#include "TBranchElement.h"
#include "TObjArray.h"
#include "TTree.h"
#include "art/Framework/Core/EventPrincipal.h"
#include "art/Framework/Core/FileBlock.h"
#include "art/Framework/Core/ModuleMacros.h"
#include "art/Framework/Core/RunPrincipal.h"
#include "art/Framework/Core/SubRunPrincipal.h"
#include "art/Framework/IO/Root/RootOutputFile.h"
#include "art/Persistency/Provenance/FileFormatVersion.h"
#include "art/Utilities/Exception.h"
#include "cetlib/container_algorithms.h"
#include "fhiclcpp/ParameterSet.h"
#include <iomanip>
#include <sstream>
#include <utility>

using art::RootOutput;
using fhicl::ParameterSet;
using std::string;

namespace art {

  RootOutput::RootOutput(ParameterSet const& ps)
  : OutputModule               ( ps )
  , selectedOutputItemList_    ( )
  , fileName_                  ( ps.get<string>("fileName") )
  , logicalFileName_           ( ps.get<string>("logicalFileName", string()) )
  , catalog_                   ( ps.get<string>("catalog", string()) )
  , maxFileSize_               ( ps.get<int>("maxSize", 0x7f000000) )
  , compressionLevel_          ( ps.get<int>("compressionLevel", 7) )
  , basketSize_                ( ps.get<int>("basketSize", 16384) )
  , splitLevel_                ( ps.get<int>("splitLevel", 99) )
  , treeMaxVirtualSize_        ( ps.get<int>("treeMaxVirtualSize", -1) )
  , fastCloning_               ( ps.get<bool>("fastCloning", true)
                                 && wantAllEvents() )
  , dropMetaData_              ( DropNone )  // tentative: see the c'tor body
  , dropMetaDataForDroppedData_( ps.get<bool>( "dropMetaDataForDroppedData"
                                             , false) )
  , moduleLabel_               ( ps.get<string>("module_label")  )
  , outputFileCount_           ( 0 )
  , inputFileCount_            ( 0 )
  , rootOutputFile_            ( )
  {
    string dropMetaData(ps.get<string>("dropMetaData", string()));
    if (dropMetaData.empty())                 dropMetaData_ = DropNone;
    else if (dropMetaData == string("NONE"))  dropMetaData_ = DropNone;
    else if (dropMetaData == string("PRIOR")) dropMetaData_ = DropPrior;
    else if (dropMetaData == string("ALL"))   dropMetaData_ = DropAll;
    else {
      throw art::Exception( errors::Configuration
                          , "Illegal dropMetaData parameter value: ")
          << dropMetaData << ".\n"
          << "Legal values are 'NONE', 'PRIOR', and 'ALL'.\n";
    }
  }  // c'tor

  RootOutput::OutputItem::Sorter::Sorter(TTree * tree) {
    // Fill a map mapping branch names to an index specifying the order in the tree.
    if (tree != 0) {
      TObjArray * branches = tree->GetListOfBranches();
      for (int i = 0; i < branches->GetEntries(); ++i) {
        TBranchElement * br = (TBranchElement *)branches->At(i);
        treeMap_.insert(std::make_pair(string(br->GetName()), i));
      }
    }
  }

  bool
  RootOutput::OutputItem::Sorter::operator()(OutputItem const& lh, OutputItem const& rh) const {
    // Provides a comparison for sorting branches according to the index values in treeMap_.
    // Branches not found are always put at the end (i.e. not found > found).
    if (treeMap_.empty()) return lh < rh;
    string const& lstring = lh.branchDescription_->branchName();
    string const& rstring = rh.branchDescription_->branchName();
    std::map<string, int>::const_iterator lit = treeMap_.find(lstring);
    std::map<string, int>::const_iterator rit = treeMap_.find(rstring);
    bool lfound = (lit != treeMap_.end());
    bool rfound = (rit != treeMap_.end());
    if (lfound && rfound) {
      return lit->second < rit->second;
    } else if (lfound) {
      return true;
    } else if (rfound) {
      return false;
    }
    return lh < rh;
  }

  void RootOutput::fillSelectedItemList(BranchType branchType, TTree * theTree) {

    Selections const& keptVector =    keptProducts()[branchType];
    OutputItemList&   outputItemList = selectedOutputItemList_[branchType];

    // Fill outputItemList with an entry for each branch.
    for (Selections::const_iterator it = keptVector.begin(), itEnd = keptVector.end(); it != itEnd; ++it) {
      BranchDescription const& prod = **it;
      outputItemList.push_back(OutputItem(&prod));
    }

    // Sort outputItemList to allow fast copying.
    // The branches in outputItemList must be in the same order as in the input tree, with all new branches at the end.
    cet::sort_all(outputItemList, OutputItem::Sorter(theTree));
  }

  void RootOutput::openFile(FileBlock const& fb) {
    if (!isFileOpen()) {
      if (fb.tree() == 0) {
        fastCloning_ = false;
      }
      doOpenFile();
      respondToOpenInputFile(fb);
    }
  }

  void RootOutput::respondToOpenInputFile(FileBlock const& fb) {
    for (int i = InEvent; i < NumBranchTypes; ++i) {
      BranchType branchType = static_cast<BranchType>(i);
      if (inputFileCount_ == 0) {
        TTree * theTree = (branchType == InEvent ? fb.tree() :
                          (branchType == InSubRun ? fb.subRunTree() :
                          fb.runTree()));
        fillSelectedItemList(branchType, theTree);
      }
    }
    ++inputFileCount_;
    if (isFileOpen()) {
      bool fastCloneThisOne = fb.tree() != 0 &&
                            (remainingEvents() < 0 || remainingEvents() >= fb.tree()->GetEntries());
      rootOutputFile_->beginInputFile(fb, fastCloneThisOne && fastCloning_);
    }
  }

  void RootOutput::respondToCloseInputFile(FileBlock const& fb) {
    if (rootOutputFile_) rootOutputFile_->respondToCloseInputFile(fb);
  }

  RootOutput::~RootOutput() {
  }

  void RootOutput::write(EventPrincipal const& e) {
      if (hasNewlyDroppedBranch()[InEvent]) e.addToProcessHistory();
      rootOutputFile_->writeOne(e);
  }

  void RootOutput::writeSubRun(SubRunPrincipal const& sr) {
      if (hasNewlyDroppedBranch()[InSubRun]) sr.addToProcessHistory();
      rootOutputFile_->writeSubRun(sr);
  }

  void RootOutput::writeRun(RunPrincipal const& r) {
      if (hasNewlyDroppedBranch()[InRun]) r.addToProcessHistory();
      rootOutputFile_->writeRun(r);
  }

  // At some later date, we may move functionality from finishEndFile() to here.
  void RootOutput::startEndFile() { }


  void RootOutput::writeFileFormatVersion() { rootOutputFile_->writeFileFormatVersion(); }
  void RootOutput::writeFileIndex() { rootOutputFile_->writeFileIndex(); }
  void RootOutput::writeEventHistory() { rootOutputFile_->writeEventHistory(); }
  void RootOutput::writeProcessConfigurationRegistry() { rootOutputFile_->writeProcessConfigurationRegistry(); }
  void RootOutput::writeProcessHistoryRegistry() { rootOutputFile_->writeProcessHistoryRegistry(); }
  void RootOutput::writeParameterSetRegistry() { rootOutputFile_->writeParameterSetRegistry(); }
  void RootOutput::writeProductDescriptionRegistry() { rootOutputFile_->writeProductDescriptionRegistry(); }
  void RootOutput::writeParentageRegistry() { rootOutputFile_->writeParentageRegistry(); }
  void RootOutput::writeBranchIDListRegistry() { rootOutputFile_->writeBranchIDListRegistry(); }
  void RootOutput::writeProductDependencies() { rootOutputFile_->writeProductDependencies(); }
  void RootOutput::finishEndFile() { rootOutputFile_->finishEndFile(); rootOutputFile_.reset(); }
  bool RootOutput::isFileOpen() const { return rootOutputFile_.get() != 0; }
  bool RootOutput::shouldWeCloseFile() const { return rootOutputFile_->shouldWeCloseFile(); }

  void RootOutput::doOpenFile() {
      if (inputFileCount_ == 0) {
        throw art::Exception(art::errors::LogicError)
          << "Attempt to open output file before input file. "
          << "Please report this to the core framework developers.\n";
      }
      string suffix(".root");
      string::size_type offset = fileName().rfind(suffix);
      bool ext = (offset == fileName().size() - suffix.size());
      if (!ext) suffix.clear();
      string fileBase(ext ? fileName().substr(0, offset) : fileName());
      std::ostringstream ofilename;
      std::ostringstream lfilename;
      ofilename << fileBase;
      lfilename << logicalFileName();
      if (outputFileCount_) {
        ofilename << std::setw(3) << std::setfill('0') << outputFileCount_;
        if (!logicalFileName().empty()) {
          lfilename << std::setw(3) << std::setfill('0') << outputFileCount_;
        }
      }
      ofilename << suffix;
      rootOutputFile_.reset(new RootOutputFile(this, ofilename.str(), lfilename.str()));
      ++outputFileCount_;
  }

}  // art

// ======================================================================

DEFINE_ART_MODULE(RootOutput);

// ======================================================================