#ifndef art_Framework_IO_Catalog_InputFileCatalog_h
#define art_Framework_IO_Catalog_InputFileCatalog_h

// ======================================================================
//
// Class InputFileCatalog. Services to manage InputFile catalog
//
// ======================================================================

#include "art/Framework/IO/Catalog/FileCatalog.h"
#include "art/Framework/Services/Registry/ServiceHandle.h"
#include "art/Framework/Services/Interfaces/FileDeliveryStatus.h" 
#include "art/Framework/Services/Interfaces/FileTransferStatus.h" 
#include "fhiclcpp/ParameterSet.h"
#include <string>
#include <vector>

// ----------------------------------------------------------------------

namespace art {

  class TrivialFileDelivery;
  class TrivialFileTransfer;

  class InputFileCatalog : public FileCatalog {
  public:
    explicit InputFileCatalog(fhicl::ParameterSet const& pset,
                              std::string const& namesParameter = std::string("fileNames"),
                              bool canBeEmpty = false,
                              bool noThrow = false);
    virtual ~InputFileCatalog();
    std::vector<FileCatalogItem> const& fileCatalogItems() const {return fileCatalogItems_;}
    FileCatalogItem const& currentFile() const;
    size_t currentIndex() const;
    bool   getNextFile();
    bool   hasNextFile();
    void   rewind();
    void   rewindTo(size_t index);
    bool   isSearchable()       {return searchable_;}
    bool   empty() const        {return fileCatalogItems_.empty();}

    static const size_t indexEnd;

  private:
    void findFile(std::string & pfn, std::string const& lfn, bool noThrow);
    bool retrieveNextFileFromCacheOrService(FileCatalogItem & item);

    std::vector<std::string> fileSources_;
    std::vector<FileCatalogItem> fileCatalogItems_;
    FileCatalogItem nextItem_;
    size_t fileIdx_;
    size_t maxIdx_;
    bool searchable_;
    bool nextFileProbed_;
    bool hasNextFile_;

    ServiceHandle<TrivialFileDelivery> tfd_;
    ServiceHandle<TrivialFileTransfer> tft_;
  };  // InputFileCatalog

}  // art

// ======================================================================

#endif /* art_Framework_IO_Catalog_InputFileCatalog_h */

// Local Variables:
// mode: c++
// End:
