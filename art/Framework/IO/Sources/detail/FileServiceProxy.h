#ifndef art_Framework_IO_Sources_detail_FileServiceProxy_h
#define art_Framework_IO_Sources_detail_FileServiceProxy_h

#include "art/Framework/Services/FileServiceInterfaces/CatalogInterface.h"
#include "art/Framework/Services/FileServiceInterfaces/FileTransfer.h"
#include "art/Framework/Services/FileServiceInterfaces/FileDisposition.h"
#include "art/Framework/Services/FileServiceInterfaces/FileDeliveryStatus.h"
#include "art/Framework/Services/FileServiceInterfaces/FileTransferStatus.h"
#include "art/Framework/Services/Registry/ServiceHandle.h"

#include <string>
#include <vector>

namespace art {
  namespace detail {
    class FileServiceProxy;
  }
}

class art::detail::FileServiceProxy {
public:
  explicit FileServiceProxy(std::vector<std::string> && fileNames,
                            size_t attempts = 5,
                            double waitBetweenAttempts = 5.0);
  ~FileServiceProxy();

  std::string next();

private:
  std::string obtainURI_();
  std::string obtainFileFromURI_();

  ServiceHandle<CatalogInterface> ci_;
  ServiceHandle<FileTransfer> ft_;
  struct FileEntity {
    explicit FileEntity(size_t attempts)
    :
      uri(),
      pfn(),
      uriStatus(FileDeliveryStatus::PENDING),
      ftStatus(FileTransferStatus::PENDING),
      attemptsRemaining(attempts)
      {
      }
    std::string uri;
    std::string pfn;
    FileDeliveryStatus uriStatus;
    FileTransferStatus ftStatus;
    size_t attemptsRemaining;
  } currentItem_;
  size_t const attemptsPerPhase_;
  double const waitBetweenAttempts_;
};

#endif /* art_Framework_IO_Sources_detail_FileServiceProxy_h */

// Local Variables:
// mode: c++
// End:
