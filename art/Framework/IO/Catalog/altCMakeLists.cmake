# Build art_Framework_IO_Catalog library

add_library(art_Framework_IO_Catalog SHARED
  FileCatalog.h
  InputFileCatalog.h
  FileCatalog.cc
  InputFileCatalog.cc
  )

# Describe library link interface - all Public for now
target_link_libraries(art_Framework_IO_Catalog
   art_Framework_Services_Optional_TrivialFileDelivery_service
   art_Framework_Services_Optional_TrivialFileTransfer_service
   art_Utilities
   ${Boost_FILESYSTEM_LIBRARY}
   )

 # Set any additional properties
set_target_properties(art_Framework_IO_Catalog
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_IO_Catalog
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES FileCatalog.h InputFileCatalog.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/IO/Catalog
  COMPONENT Development
  )

