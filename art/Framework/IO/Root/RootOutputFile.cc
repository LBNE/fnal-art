// ======================================================================
//
// Class RootOutputFile
//
// ======================================================================

#include "art/Framework/IO/Root/RootOutputFile.h"

#include "art/Framework/Services/System/ConstProductRegistry.h"
#include "art/Framework/Core/EventPrincipal.h"
#include "art/Framework/Core/FileBlock.h"
#include "art/Framework/Core/RunPrincipal.h"
#include "art/Framework/Core/SubRunPrincipal.h"
#include "art/Framework/Services/Registry/ServiceHandle.h"
#include "art/Persistency/Common/BasicHandle.h"
#include "art/Persistency/Provenance/BranchChildren.h"
#include "art/Persistency/Provenance/BranchID.h"
#include "art/Persistency/Provenance/BranchIDList.h"
#include "art/Persistency/Provenance/BranchIDListRegistry.h"
#include "art/Persistency/Provenance/EventAuxiliary.h"
#include "art/Persistency/Provenance/EventID.h"
#include "art/Persistency/Provenance/FileFormatVersion.h"
#include "art/Persistency/Provenance/History.h"
#include "art/Persistency/Provenance/ParameterSetBlob.h"
#include "art/Persistency/Provenance/Parentage.h"
#include "art/Persistency/Provenance/ParentageRegistry.h"
#include "art/Persistency/Provenance/ProcessHistoryID.h"
#include "art/Persistency/Provenance/ProcessHistoryRegistry.h"
#include "art/Persistency/Provenance/ProductRegistry.h"
#include "art/Persistency/Provenance/ProductStatus.h"
#include "art/Persistency/Provenance/RunAuxiliary.h"
#include "art/Persistency/Provenance/SubRunAuxiliary.h"
#include "art/Utilities/Digest.h"
#include "art/Utilities/Exception.h"
#include "art/Framework/IO/Root/GetFileFormatVersion.h"
#include "art/Framework/IO/Root/GetFileFormatEra.h"
#include "cetlib/container_algorithms.h"
#include "fhiclcpp/ParameterSet.h"
#include "fhiclcpp/ParameterSetRegistry.h"
#include "fhiclcpp/ParameterSetID.h"
#include "Rtypes.h"
#include "TClass.h"
#include "TFile.h"
#include "TROOT.h"
#include "TTree.h"
#include <algorithm>
#include <iomanip>
#include <sstream>
#include <utility>


using namespace cet;
using namespace std;


namespace art {

  namespace {
    bool
    sorterForJobReportHash(BranchDescription const* lh, BranchDescription const* rh) {
      return
        lh->fullClassName() < rh->fullClassName() ? true :
        lh->fullClassName() > rh->fullClassName() ? false :
        lh->moduleLabel() < rh->moduleLabel() ? true :
        lh->moduleLabel() > rh->moduleLabel() ? false :
        lh->productInstanceName() < rh->productInstanceName() ? true :
        lh->productInstanceName() > rh->productInstanceName() ? false :
        lh->processName() < rh->processName() ? true :
        false;
    }
  }

  RootOutputFile::RootOutputFile(RootOutput *om, string const& fileName, string const& logicalFileName) :
      file_(fileName),
      logicalFile_(logicalFileName),
      om_(om),
      currentlyFastCloning_(),
      filePtr_(TFile::Open(file_.c_str(), "recreate", "", om_->compressionLevel())),
      fileIndex_(),
      eventEntryNumber_(0LL),
      subRunEntryNumber_(0LL),
      runEntryNumber_(0LL),
      metaDataTree_(0),
      parentageTree_(0),
      eventHistoryTree_(0),
      pEventAux_(0),
      pSubRunAux_(0),
      pRunAux_(0),
      eventEntryInfoVector_(),
      subRunEntryInfoVector_(),
      runEntryInfoVector_(),
      pEventEntryInfoVector_(&eventEntryInfoVector_),
      pSubRunEntryInfoVector_(&subRunEntryInfoVector_),
      pRunEntryInfoVector_(&runEntryInfoVector_),
      pHistory_(0),
      eventTree_(static_cast<EventPrincipal *>(0),
                 filePtr_, InEvent, pEventAux_, pEventEntryInfoVector_,
                 om_->basketSize(), om_->splitLevel(), om_->treeMaxVirtualSize()),
      subRunTree_(static_cast<SubRunPrincipal *>(0),
                filePtr_, InSubRun, pSubRunAux_, pSubRunEntryInfoVector_,
                om_->basketSize(), om_->splitLevel(), om_->treeMaxVirtualSize()),
      runTree_(static_cast<RunPrincipal *>(0),
               filePtr_, InRun, pRunAux_, pRunEntryInfoVector_,
               om_->basketSize(), om_->splitLevel(), om_->treeMaxVirtualSize()),
      treePointers_(),
      dataTypeReported_(false) {
    treePointers_[InEvent] = &eventTree_;
    treePointers_[InSubRun]  = &subRunTree_;
    treePointers_[InRun]   = &runTree_;

    for (int i = InEvent; i < NumBranchTypes; ++i) {
      BranchType branchType = static_cast<BranchType>(i);
      for (OutputItemList::const_iterator it = om_->selectedOutputItemList()[branchType].begin(),
          itEnd = om_->selectedOutputItemList()[branchType].end();
          it != itEnd; ++it) {
        treePointers_[branchType]->addBranch(*it->branchDescription_,
					     it->product_);
      }
    }
    // Don't split metadata tree or event description tree
    metaDataTree_         = RootOutputTree::makeTTree(filePtr_.get(), rootNames::metaDataTreeName(), 0);
    parentageTree_ = RootOutputTree::makeTTree(filePtr_.get(), rootNames::parentageTreeName(), 0);

    // Create the tree that will carry (event) History objects.
    eventHistoryTree_     = RootOutputTree::makeTTree(filePtr_.get(), rootNames::eventHistoryTreeName(), om_->splitLevel());
    if (!eventHistoryTree_)
      throw art::Exception(art::errors::FatalRootError)
        << "Failed to create the tree for History objects\n";

    if (! eventHistoryTree_->Branch(rootNames::eventHistoryBranchName().c_str(), &pHistory_, om_->basketSize(), 0))
      throw art::Exception(art::errors::FatalRootError)
        << "Failed to create a branch for Historys in the output file\n";

    // For the Job Report, get a vector of branch names in the "Events" tree.
    // Also create a hash of all the branch names in the "Events" tree
    // in a deterministic order, except use the full class name instead of the friendly class name.
    // To avoid extra string copies, we create a vector of pointers into the product registry,
    // and use a custom comparison operator for sorting.
    vector<string> branchNames;
    vector<BranchDescription const*> branches;
    branchNames.reserve(om_->selectedOutputItemList()[InEvent].size());
    branches.reserve(om->selectedOutputItemList()[InEvent].size());
    for (OutputItemList::const_iterator it = om_->selectedOutputItemList()[InEvent].begin(),
          itEnd = om_->selectedOutputItemList()[InEvent].end();
          it != itEnd; ++it) {
      branchNames.push_back(it->branchDescription_->branchName());
      branches.push_back(it->branchDescription_);
    }
    // Now sort the branches for the hash.
    sort_all(branches, sorterForJobReportHash);
    // Now, make a concatenated string.
    ostringstream oss;
    char const underscore = '_';
    for (vector<BranchDescription const*>::const_iterator it = branches.begin(), itEnd = branches.end(); it != itEnd; ++it) {
      BranchDescription const& bd = **it;
      oss <<  bd.fullClassName() << underscore
          << bd.moduleLabel() << underscore
          << bd.productInstanceName() << underscore
          << bd.processName() << underscore;
    }
    string stringrep = oss.str();
    art::Digest md5alg(stringrep);

    // Register the output file with the JobReport service
    // and get back the token for it.
    string moduleName = "RootOutput";
  }

  void RootOutputFile::beginInputFile(FileBlock const& fb, bool fastClone) {

    currentlyFastCloning_ = om_->fastCloning() && fb.fastClonable() && fastClone;
    if (currentlyFastCloning_) currentlyFastCloning_ = eventTree_.checkSplitLevelAndBasketSize(fb.tree());

    eventTree_.beginInputFile(currentlyFastCloning_);
    eventTree_.fastCloneTree(fb.tree());
  }

  void RootOutputFile::respondToCloseInputFile(FileBlock const&) {
    eventTree_.setEntries();
    subRunTree_.setEntries();
    runTree_.setEntries();
  }

  bool RootOutputFile::shouldWeCloseFile() const {
    unsigned int const oneK = 1024;
    Long64_t size = filePtr_->GetSize()/oneK;
    return(size >= om_->maxFileSize_);
  }

  void RootOutputFile::writeOne(EventPrincipal const& e) {
    // Auxiliary branch
    pEventAux_ = &e.aux();

    // Because getting the data may cause an exception to be thrown we want to do that
    // first before writing anything to the file about this event
    // NOTE: pEventAux_ must be set before calling fillBranches since it gets written out
    // in that routine.
    fillBranches(InEvent, e, pEventEntryInfoVector_);

    // History branch
    History historyForOutput(e.history());
    historyForOutput.addEventSelectionEntry(om_->selectorConfig());
    pHistory_ = &historyForOutput;
    int sz = eventHistoryTree_->Fill();
    if ( sz <= 0)
      throw art::Exception(art::errors::FatalRootError)
        << "Failed to fill the History tree for event: " << e.id()
        << "\nTTree::Fill() returned " << sz << " bytes written." << endl;

    // Add the dataType to the job report if it hasn't already been done
    if(!dataTypeReported_) {
      string dataType("MC");
      if(pEventAux_->isRealData())  dataType = "Data";
      dataTypeReported_ = true;
    }

    pHistory_ = & e.history();

    // Add event to index
    fileIndex_.addEntry(pEventAux_->id(), eventEntryNumber_);
    ++eventEntryNumber_;

    // Report event written
  }

  void RootOutputFile::writeSubRun(SubRunPrincipal const& sr) {
    // Auxiliary branch
    pSubRunAux_ = &sr.aux();
    // Add subRun to index.
    fileIndex_.addEntry(EventID::invalidEvent(pSubRunAux_->id()), subRunEntryNumber_);
    ++subRunEntryNumber_;
    fillBranches(InSubRun, sr, pSubRunEntryInfoVector_);
  }

  void RootOutputFile::writeRun(RunPrincipal const& r) {
    // Auxiliary branch
    pRunAux_ = &r.aux();
    // Add run to index.
    fileIndex_.addEntry(EventID::invalidEvent(pRunAux_->id()),runEntryNumber_);
    ++runEntryNumber_;
    fillBranches(InRun, r, pRunEntryInfoVector_);
  }

  void RootOutputFile::writeParentageRegistry() {
    ParentageID const* hash(0);
    Parentage const*   desc(0);

    if (!parentageTree_->Branch(rootNames::parentageIDBranchName().c_str(),
                                        &hash, om_->basketSize(), 0))
      throw art::Exception(art::errors::FatalRootError)
        << "Failed to create a branch for ParentageIDs in the output file";

    if (!parentageTree_->Branch(rootNames::parentageBranchName().c_str(),
                                        &desc, om_->basketSize(), 0))
      throw art::Exception(art::errors::FatalRootError)
        << "Failed to create a branch for Parentages in the output file";

    for (ParentageRegistry::const_iterator
           i = ParentageRegistry::begin(),
           e = ParentageRegistry::end();
         i != e;
         ++i) {
        hash = const_cast<ParentageID*>(&(i->first)); // cast needed because keys are const
        desc = &(i->second);
        parentageTree_->Fill();
      }
  }

  void RootOutputFile::writeFileFormatVersion() {
    FileFormatVersion fileFormatVersion(getFileFormatVersion(), getFileFormatEra());
    FileFormatVersion * pFileFmtVsn = &fileFormatVersion;
    TBranch* b = metaDataTree_->Branch(rootNames::fileFormatVersionBranchName().c_str(), &pFileFmtVsn, om_->basketSize(), 0);
    assert(b);
    b->Fill();
  }

  void RootOutputFile::writeFileIndex() {
    fileIndex_.sortBy_Run_SubRun_Event();
    FileIndex *findexPtr = &fileIndex_;
    TBranch* b = metaDataTree_->Branch(rootNames::fileIndexBranchName().c_str(), &findexPtr, om_->basketSize(), 0);
    assert(b);
    b->Fill();
  }

  void RootOutputFile::writeEventHistory() {
    RootOutputTree::writeTTree(eventHistoryTree_);
  }

  void RootOutputFile::writeProcessConfigurationRegistry() {
    // We don't do this yet; currently we're storing a slightly bloated ProcessHistoryRegistry.
  }

  void RootOutputFile::writeProcessHistoryRegistry() {
    typedef  ProcessHistoryRegistry::collection_type  collection_t;
    collection_t const & r = ProcessHistoryRegistry::get();
    collection_t * p = & const_cast<collection_t &>(r);
    TBranch* b = metaDataTree_->Branch(rootNames::processHistoryMapBranchName().c_str(), &p, om_->basketSize(), 0);
    assert(b);
    b->Fill();
  }

  void RootOutputFile::writeBranchIDListRegistry() {
    BranchIDListRegistry::collection_type *p = &BranchIDListRegistry::instance()->data();
    TBranch* b = metaDataTree_->Branch(rootNames::branchIDListBranchName().c_str(), &p, om_->basketSize(), 0);
    assert(b);
    b->Fill();
  }

  void RootOutputFile::writeParameterSetRegistry() {
     // TODO: update to separate tree per CMS code (2010/12/01),
    ParameterSetMap psetMap;
    fillPsetMap(psetMap);
    ParameterSetMap *pPsetMap = &psetMap;
    TBranch* b = metaDataTree_->Branch(rootNames::parameterSetMapBranchName().c_str(), &pPsetMap, om_->basketSize(), 0);
    assert(b);
    b->Fill();
  }

  void RootOutputFile::fillPsetMap( ParameterSetMap & psetMap ) {
    using fhicl::ParameterSetID;
    using fhicl::ParameterSetRegistry;
    typedef  ParameterSetRegistry::const_iterator  const_iterator;

    typedef  std::pair<ParameterSetID const, ParameterSetBlob>  pair_t;

    psetMap.clear();
    for( const_iterator it = ParameterSetRegistry::begin()
                      , e  = ParameterSetRegistry::end(); it != e; ++it )  {
      // TODO: Update to write out only those parameter sets we actually want.
      psetMap.insert( pair_t( it->first
                            , ParameterSetBlob(it->second.to_string())
                    )       );
    }
  }

  void RootOutputFile::writeProductDescriptionRegistry() {
    // Make a local copy of the ProductRegistry, removing any transient or pruned products.
    typedef ProductRegistry::ProductList ProductList;
    art::ServiceHandle<art::ConstProductRegistry> reg;
    ProductRegistry pReg(reg->productList());
    ProductList & pList  = const_cast<ProductList &>(pReg.productList());
    set<BranchID>::iterator end = branchesWithStoredHistory_.end();
    for (ProductList::iterator it = pList.begin(); it != pList.end(); ) {
      if (branchesWithStoredHistory_.find(it->second.branchID()) == end) {
        // avoid invalidating iterator on deletion
        ProductList::iterator itCopy = it;
        ++it;
        pList.erase(itCopy);

      } else {
        ++it;
      }
    }

    ProductRegistry * ppReg = &pReg;
    TBranch* b = metaDataTree_->Branch(rootNames::productDescriptionBranchName().c_str(), &ppReg, om_->basketSize(), 0);
    assert(b);
    b->Fill();
  }
  void RootOutputFile::writeProductDependencies() {
    BranchChildren& pDeps = const_cast<BranchChildren&>(om_->branchChildren());
    BranchChildren * ppDeps = &pDeps;
    TBranch* b = metaDataTree_->Branch(rootNames::productDependenciesBranchName().c_str(), &ppDeps, om_->basketSize(), 0);
    assert(b);
    b->Fill();
  }

  void RootOutputFile::finishEndFile() {
    metaDataTree_->SetEntries(-1);
    RootOutputTree::writeTTree(metaDataTree_);

    RootOutputTree::writeTTree(parentageTree_);

    // Create branch aliases for all the branches in the
    // events/subRuns/runs trees. The loop is over all types of data
    // products.
    for (int i = InEvent; i < NumBranchTypes; ++i) {
      BranchType branchType = static_cast<BranchType>(i);
      setBranchAliases(treePointers_[branchType]->tree(), om_->keptProducts()[branchType]);
      treePointers_[branchType]->writeTree();
    }

    // close the file -- mfp
    filePtr_->Close();
    filePtr_.reset();

    // report that file has been closed

  }

  void
  RootOutputFile::setBranchAliases(TTree *tree, Selections const& branches) const {
    if (tree && tree->GetNbranches() != 0) {
      for (Selections::const_iterator i = branches.begin(), iEnd = branches.end();
          i != iEnd; ++i) {
        BranchDescription const& pd = **i;
        string const& full = pd.branchName() + "obj";
        if (pd.branchAliases().empty()) {
          string const& alias =
              (pd.productInstanceName().empty() ? pd.moduleLabel() : pd.productInstanceName());
          tree->SetAlias(alias.c_str(), full.c_str());
        } else {
          set<string>::const_iterator it = pd.branchAliases().begin(), itEnd = pd.branchAliases().end();
          for (; it != itEnd; ++it) {
            tree->SetAlias((*it).c_str(), full.c_str());
          }
        }
      }
    }
  }

  void
  RootOutputFile::insertAncestors(ProductProvenance const& iGetParents,
                                  Principal const& principal,
                                  set<ProductProvenance>& oToFill) {
    if(om_->dropMetaData() == RootOutput::DropAll) return;
    if(om_->dropMetaDataForDroppedData()) return;
    BranchMapper const& iMapper = *principal.branchMapperPtr();
    vector<BranchID> const& parentIDs = iGetParents.parentage().parents();
    for(vector<BranchID>::const_iterator it=parentIDs.begin(), itEnd = parentIDs.end();
          it != itEnd; ++it) {
      branchesWithStoredHistory_.insert(*it);
      boost::shared_ptr<ProductProvenance> info = iMapper.branchToEntryInfo(*it);
      if(info) {
        if(om_->dropMetaData() == RootOutput::DropNone ||
                 principal.getProvenance(info->branchID()).product().produced()) {
          if(oToFill.insert(*info).second) {
            //haven't seen this one yet
            insertAncestors(*info, principal, oToFill);
          }
        }
      }
    }
  }

  void RootOutputFile::fillBranches(
                BranchType const& branchType,
                Principal const& principal,
                vector<ProductProvenance>* productProvenanceVecPtr) {

    vector<boost::shared_ptr<EDProduct> > dummies;

    bool const fastCloning = (branchType == InEvent) && currentlyFastCloning_;

    OutputItemList const& items = om_->selectedOutputItemList()[branchType];

    set<ProductProvenance> provenanceToKeep;

    // Loop over EDProduct branches, fill the provenance, and write the branch.
    for (OutputItemList::const_iterator i = items.begin(), iEnd = items.end(); i != iEnd; ++i) {

      BranchID const& id = i->branchDescription_->branchID();
      branchesWithStoredHistory_.insert(id);

      bool produced = i->branchDescription_->produced();
      bool keepProvenance = om_->dropMetaData() == RootOutput::DropNone ||
                           (om_->dropMetaData() == RootOutput::DropPrior && produced);
      bool getProd = (produced || !fastCloning ||
         treePointers_[branchType]->uncloned(i->branchDescription_->branchName()));

      EDProduct const* product = 0;
      OutputHandle const oh = principal.getForOutput(id, getProd);
      if (!oh.productProvenance()) {
        // No product with this ID is in the event.
        // Create and write the provenance.
        if (keepProvenance) {
          if (produced) {
            provenanceToKeep.insert(ProductProvenance(i->branchDescription_->branchID(),
                        productstatus::neverCreated()));
          } else {
            provenanceToKeep.insert(ProductProvenance(i->branchDescription_->branchID(),
                        productstatus::dropped()));
          }
        }
      } else {
        product = oh.wrapper();
        if (keepProvenance) {
          provenanceToKeep.insert(*oh.productProvenance());
          assert(principal.branchMapperPtr());
          insertAncestors(*oh.productProvenance(), principal, provenanceToKeep);
        }
      }
      if (getProd) {
        if (product == 0) {
          // No product with this ID is in the event.
          // Add a null product.
          TClass *cp = gROOT->GetClass(i->branchDescription_->wrappedName().c_str());
          boost::shared_ptr<EDProduct> dummy(static_cast<EDProduct *>(cp->New()));
          dummies.push_back(dummy);
          product = dummy.get();
        }
        i->product_ = product;
      }
    }

    productProvenanceVecPtr->assign(provenanceToKeep.begin(), provenanceToKeep.end());
    treePointers_[branchType]->fillTree();
    productProvenanceVecPtr->clear();
  }

}  // art