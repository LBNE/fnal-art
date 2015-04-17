
# - Build art_Framework_Services_FileServiceInterfaces lib
# Define headers
set(art_Framework_Services_FileServiceInterfaces_HEADERS
  CatalogInterface.h
  FileDeliveryStatus.h
  FileDisposition.h
  FileTransfer.h
  FileTransferStatus.h
  )

# Describe library
add_library(art_Framework_Services_FileServiceInterfaces SHARED
  ${art_Framework_Services_FileServiceInterfaces_HEADERS}
  FileDeliveryStatus.cc
  FileDisposition.cc
  FileTransferStatus.cc
  )

# Describe library link interface - all Public for now
target_link_libraries(art_Framework_Services_FileServiceInterfaces
  art_Framework_Services_Registry
  FNALCore::FNALCore
  )

# Set any additional properties
set_target_properties(art_Framework_Services_FileServiceInterfaces
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_Services_FileServiceInterfaces
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Framework_Services_FileServiceInterfaces_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/FileServiceInterfaces
  COMPONENT Development
  )

