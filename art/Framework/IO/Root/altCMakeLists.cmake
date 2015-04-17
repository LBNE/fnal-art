# - Build art_Framework_IO_Root{Version} plus modules/apps

# - art_Framework_IO_RootVersion
add_library(art_Framework_IO_RootVersion SHARED
  GetFileFormatEra.h
  GetFileFormatVersion.h
  GetFileFormatEra.cc
  GetFileFormatVersion.cc
  )

# Set any additional properties
set_target_properties(art_Framework_IO_RootVersion
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_IO_RootVersion
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES GetFileFormatEra.h GetFileFormatVersion.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/IO/Root
  COMPONENT Development
  )

# - art_Framework_IO_Root
set(art_Framework_IO_Root_HEADERS
  BranchMapperWithReader.h
  DuplicateChecker.h
  FastCloningInfoProvider.h
  Inputfwd.h
  RefCoreStreamer.h
  RootBranchInfo.h
  RootBranchInfoList.h
  RootDelayedReader.h
  RootInputFile.h
  RootInputFileSequence.h
  rootNames.h
  RootOutputFile.h
  RootOutputTree.h
  RootTree.h
  setMetaDataBranchAddress.h
  )

add_library(art_Framework_IO_Root SHARED
  ${art_Framework_IO_Root_HEADERS}
  DuplicateChecker.cc
  FastCloningInfoProvider.cc
  RefCoreStreamer.cc
  RootBranchInfo.cc
  RootBranchInfoList.cc
  RootDelayedReader.cc
  RootInputFile.cc
  RootInputFileSequence.cc
  rootNames.cc
  RootOutputFile.cc
  RootOutputTree.cc
  RootTree.cc
  )

# Describe library link interface - all Public for now
target_link_libraries(art_Framework_IO_Root
  art_Framework_Core
  art_Framework_IO
  art_Framework_IO_Catalog
  art_Framework_Principal
  art_Framework_Services_Registry
  art_Persistency_Common
  art_Persistency_Provenance
  art_Framework_IO_RootVersion
  ${ROOT_Tree_LIBRARY}
  ${ROOT_Net_LIBRARY}
  ${ROOT_MatchCore_LIBRARY}
  )

# Set any additional properties
set_target_properties(art_Framework_IO_Root
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_IO_Root
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Framework_IO_Root_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/IO/Root
  COMPONENT Development
  )

# - art_Framework_IO_RootInput_source
add_library(art_Framework_IO_RootInput_source SHARED
  RootInput.h
  RootInput_source.cc
  )
target_link_libraries(art_Framework_IO_RootInput_source
  art_Framework_IO_Root
  art_Framework_IO_Catalog
  )
# Set any additional properties
set_target_properties(art_Framework_IO_RootInput_source
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_IO_RootInput_source
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES RootInput.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/IO/Root
  COMPONENT Development
  )


# art_Framework_IO_RootOutput_module
add_library(art_Framework_IO_RootOutput_module SHARED
  RootOutput.h
  RootOutput_module.cc
  )
target_link_libraries(art_Framework_IO_RootOutput_module
  art_Framework_IO_Root
  )
# Set any additional properties
set_target_properties(art_Framework_IO_RootOutput_module
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_IO_RootOutput_module
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES RootOutput.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/IO/Root
  COMPONENT Development
  )


# config_dumper
add_executable(config_dumper config_dumper.cc)
target_link_libraries(config_dumper
  art_Framework_IO_Root
  art_Utilities
  art_Framework_Core
  ${Boost_PROGRAM_OPTIONS_LIBRARY}
  ${ROOT_Tree_LIBRARY}
  ${ROOT_RIO_LIBRARY}
  )
install(TARGETS config_dumper
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )

# sam_metadata_dumper
add_executable(sam_metadata_dumper sam_metadata_dumper.cc)
target_link_libraries(sam_metadata_dumper
  art_Framework_IO_Root
  art_Utilities
  art_Framework_Core
  ${Boost_PROGRAM_OPTIONS_LIBRARY}
  ${ROOT_RIO_LIBRARY}
  )
install(TARGETS sam_metadata_dumper
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )



