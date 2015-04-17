# Build art_Framework_IO and sub libraries

# Define library
add_library(art_Framework_IO SHARED
  FileStatsCollector.h
  FileStatsCollector.cc
  PostCloseFileRenamer.h
  PostCloseFileRenamer.cc
  )

# Describe library link interface - all Public for now
target_link_libraries(art_Framework_IO
  art_Persistency_Provenance
  ${Boost_DATE_TIME_LIBRARY}
  ${Boost_FILESYSTEM_LIBRARY}
  ${Boost_SYSTEM_LIBRARY}
  ${Boost_REGEX_LIBRARY}
  )

# Set any additional properties
set_target_properties(art_Framework_IO
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_IO
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES FileStatsCollector.h PostCloseFileRenamer.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/IO
  COMPONENT Development
  )

# Build subcomponents
add_subdirectory(Catalog)
add_subdirectory(Root)
add_subdirectory(Sources)
add_subdirectory(ProductMix)

