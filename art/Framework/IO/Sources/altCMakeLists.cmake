
# - Build art_Framework_IO_Sources library

set(art_Framework_IO_Sources_HEADERS
  put_product_in_principal.h
  Source.h
  SourceHelper.h
  SourceTraits.h
  )

set(art_Framework_IO_Sources_DETAIL_HEADERS
  detail/FileNamesHandler.h
  detail/FileServiceProxy.h
  )

# Define library
add_library(art_Framework_IO_Sources SHARED
  ${art_Framework_IO_Sources_HEADERS}
  ${art_Framework_IO_Sources_DETAIL_HEADERS}
  SourceHelper.cc
  detail/FileServiceProxy.cc
  )

# Describe library link interface - all Public for now
target_link_libraries(art_Framework_IO_Sources
  art_Framework_Services_FileServiceInterfaces
  art_Framework_Services_Registry
  art_Framework_Principal
  art_Persistency_Common
  art_Persistency_Provenance
  art_Utilities
  )

# Set any additional properties
set_target_properties(art_Framework_IO_Sources
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_IO_Sources
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Framework_IO_Sources_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/IO/Sources
  COMPONENT Development
  )
install(FILES ${art_Framework_IO_Sources_DETAIL_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/IO/Sources/detail
  COMPONENT Development
  )


