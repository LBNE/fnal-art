IF (CETBUILDTOOLS_VERSION)

# project name
project(art_Persistency_Provenance)

set(art_Persistency_Provenance_sources
  BranchChildren.cc
  BranchDescription.cc
  BranchID.cc
  BranchIDListHelper.cc
  BranchKey.cc
  BranchMapper.cc
  BranchType.cc
  EventAuxiliary.cc
  EventID.cc
  FileFormatVersion.cc
  FileIndex.cc
  Hash.cc
  History.cc
  MasterProductRegistry.cc
  ModuleDescription.cc
  ParameterSetBlob.cc
  Parentage.cc
  ProcessConfiguration.cc
  ProcessHistory.cc
  ProductID.cc
  ProductMetaData.cc
  ProductProvenance.cc
  ReflexTools.cc
  RunAuxiliary.cc
  RunID.cc
  SubRunAuxiliary.cc
  SubRunID.cc
  TransientStreamer.cc
 )


set( art_Persistency_Provenance_libraries
  art_Persistency_RootDB
  art_Utilities
  ${Boost_THREAD_LIBRARY}
  ${ROOT_CINTEX}
  )

art_make_library( LIBRARY_NAME art_Persistency_Provenance
                  SOURCE ${art_Persistency_Provenance_sources}
                  LIBRARIES ${art_Persistency_Provenance_libraries}
		 )

art_dictionary(DICTIONARY_LIBRARIES art_Persistency_Provenance)

install_headers()
install_source()

ELSE()
# - Build art_Persistency_Provenance lib
# Define headers
set(art_Persistency_Provenance_HEADERS
  BranchChildren.h
  BranchDescription.h
  BranchID.h
  BranchIDList.h
  BranchIDListHelper.h
  BranchIDListRegistry.h
  BranchKey.h
  BranchListIndex.h
  BranchMapper.h
  BranchType.h
  EventAuxiliary.h
  EventID.h
  EventProcessHistoryID.h
  EventSelectionID.h
  FileFormatVersion.h
  FileIndex.h
  HashedTypes.h
  Hash.h
  History.h
  MasterProductRegistry.h
  ModuleDescription.h
  ModuleDescriptionID.h
  ParameterSetBlob.h
  ParameterSetMap.h
  Parentage.h
  ParentageID.h
  ParentageRegistry.h
  PassID.h
  ProcessConfiguration.h
  ProcessConfigurationID.h
  ProcessConfigurationRegistry.h
  ProcessHistory.h
  ProcessHistoryID.h
  ProcessHistoryRegistry.h
  ProductID.h
  ProductList.h
  ProductMetaData.h
  ProductProvenance.h
  ProductRegistry.h
  ProductStatus.h
  ProvenanceFwd.h
  ReflexTools.h
  ReleaseVersion.h
  RunAuxiliary.h
  RunID.h
  Selections.h
  SortInvalidFirst.h
  SubRunAuxiliary.h
  SubRunID.h
  Timestamp.h
  Transient.h
  TransientStreamer.h
  TypeLabel.h
  )

# Describe library
add_library(art_Persistency_Provenance SHARED
  ${art_Persistency_Provenance_HEADERS}
  BranchChildren.cc
  BranchDescription.cc
  BranchID.cc
  BranchIDListHelper.cc
  BranchKey.cc
  BranchMapper.cc
  BranchType.cc
  EventAuxiliary.cc
  EventID.cc
  FileFormatVersion.cc
  FileIndex.cc
  Hash.cc
  History.cc
  MasterProductRegistry.cc
  ModuleDescription.cc
  ParameterSetBlob.cc
  Parentage.cc
  ProcessConfiguration.cc
  ProcessHistory.cc
  ProductID.cc
  ProductMetaData.cc
  ProductProvenance.cc
  ReflexTools.cc
  RunAuxiliary.cc
  RunID.cc
  SubRunAuxiliary.cc
  SubRunID.cc
  TransientStreamer.cc
  )

# Describe library include interface
target_include_directories(art_Persistency_Provenance
  PUBLIC
   ${ROOT_INCLUDE_DIRS}
  PRIVATE
   ${BOOST_INCLUDE_DIRS}
   )

# Describe library link interface - all Public for now
target_link_libraries(art_Persistency_Provenance
  LINK_PUBLIC
   art_Persistency_RootDB
   art_Utilities
   ${ROOT_Cintex_LIBRARY}
  LINK_PRIVATE
   ${BOOST_THREAD_LIBRARY}
  )

# Set any additional properties
set_target_properties(art_Persistency_Provenance
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

# - Dictify
art_add_dictionary(DICTIONARY_LIBRARIES art_Persistency_Provenance)


install(TARGETS art_Persistency_Provenance art_Persistency_Provenance_dict art_Persistency_Provenance_map
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Persistency_Provenance_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Persistency/Provenance
  COMPONENT Development
  )


ENDIF()
