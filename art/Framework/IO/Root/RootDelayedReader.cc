#include "art/Framework/IO/Root/RootDelayedReader.h"

#include "art/Persistency/Common/RefCoreStreamer.h"
#include "art/Persistency/Provenance/BranchDescription.h"

#include "TBranch.h"
#include "TClass.h"
#include "TROOT.h"


namespace art {

  RootDelayedReader::RootDelayedReader(EntryNumber const& entry,
      boost::shared_ptr<BranchMap const> bMap,
      boost::shared_ptr<TFile const> filePtr,
      bool oldFormat) :
   entryNumber_(entry),
   branches_(bMap),
   filePtr_(filePtr),
   nextReader_(),
   oldFormat_(oldFormat) {}

  RootDelayedReader::~RootDelayedReader() {}

  std::auto_ptr<EDProduct>
  RootDelayedReader::getProduct_(BranchKey const& k, EDProductGetter const* ep) const {
    iterator iter = branchIter(k);
    if (!found(iter)) {
      assert(nextReader_);
      return nextReader_->getProduct(k, ep);
    }
    input::BranchInfo const& branchInfo = getBranchInfo(iter);
    TBranch *br = branchInfo.productBranch_;
    if (br == 0) {
      assert(nextReader_);
      return nextReader_->getProduct(k, ep);
    }
    setRefCoreStreamer(ep);
    TClass *cp = gROOT->GetClass(branchInfo.branchDescription_.wrappedCintName().c_str());
    std::auto_ptr<EDProduct> p(static_cast<EDProduct *>(cp->New()));
    EDProduct *pp = p.get();
    br->SetAddress(&pp);
    input::getEntry(br, entryNumber_);
    setRefCoreStreamer();
    return p;
  }

}  // art
