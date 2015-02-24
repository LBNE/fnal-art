IF (CERBUILDTOOLS_VERSION)
foreach(ART_IPR_BASE_NAME FindOne FindMany)
  UNSET(ART_IPR_BY_PTR)
  SET(ART_IPR_CLASS_NAME ${ART_IPR_BASE_NAME})
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${ART_IPR_BASE_NAME}.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/${ART_IPR_CLASS_NAME}.h
    @ONLY FORCE)

  SET(ART_IPR_BY_PTR true)
  SET(ART_IPR_CLASS_NAME "${ART_IPR_BASE_NAME}P")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${ART_IPR_BASE_NAME}.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/${ART_IPR_CLASS_NAME}.h
    @ONLY)
endforeach()

art_make(
  SUBDIRS detail
  LIB_LIBRARIES
  art_Framework_Services_System_CurrentModule_service
  art_Framework_Services_System_TriggerNamesService_service
  art_Framework_Services_Optional_RandomNumberGenerator_service
  art_Framework_Principal
  art_Persistency_Common
  art_Persistency_Provenance
  art_Framework_Services_Registry
  art_Utilities
  art_Version
  MF_MessageLogger
  fhiclcpp
  cetlib
  ${CLHEP}
  ${TBB}
  )

install_headers(SUBDIRS detail)
install_source(SUBDIRS detail)

ELSE()
#-----------------------------------------------------------------------
# Build art_Framework_Core library

# - Define headers
set(art_Framework_Core_HEADERS)

# Generated headers
foreach(ART_IPR_BASE_NAME FindOne FindMany)
  UNSET(ART_IPR_BY_PTR)
  SET(ART_IPR_CLASS_NAME ${ART_IPR_BASE_NAME})
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${ART_IPR_BASE_NAME}.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/${ART_IPR_CLASS_NAME}.h
    @ONLY FORCE)
  list(APPEND art_Framework_Core_HEADERS
    ${CMAKE_CURRENT_BINARY_DIR}/${ART_IPR_CLASS_NAME}.h
    )

  SET(ART_IPR_BY_PTR true)
  SET(ART_IPR_CLASS_NAME "${ART_IPR_BASE_NAME}P")
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${ART_IPR_BASE_NAME}.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/${ART_IPR_CLASS_NAME}.h
    @ONLY)
  list(APPEND art_Framework_Core_HEADERS
    ${CMAKE_CURRENT_BINARY_DIR}/${ART_IPR_CLASS_NAME}.h
    )
endforeach()

# - Define headers
list(APPEND art_Framework_Core_HEADERS
  Breakpoints.h
  CachedProducts.h
  CPCSentry.h
  DecrepitRelicInputSourceImplementation.h
  EDAnalyzer.h
  EDFilter.h
  EDProducer.h
  EmptyEventTimestampPlugin.h
  EndPathExecutor.h
  EngineCreator.h
  EventObserver.h
  EventSelector.h
  FileBlock.h
  FileCatalogMetadataPlugin.h
  Frameworkfwd.h
  get_BranchDescription.h
  GroupSelector.h
  GroupSelectorRules.h
  IEventProcessor.h
  InputSourceDescription.h
  InputSourceFactory.h
  InputSource.h
  InputSourceMacros.h
  MFStatusUpdater.h
  ModuleMacros.h
  ModuleType.h
  OutputModuleDescription.h
  OutputModule.h
  OutputWorker.h
  Path.h
  PathManager.h
  PathsInfo.h
  PrincipalCache.h
  PrincipalMaker.h
  ProcessingTask.h
  ProducerBase.h
  ProductRegistryHelper.h
  PtrRemapper.h
  RootDictionaryManager.h
  Schedule.h
  TriggerNames.h
  TriggerReport.h
  TriggerResultInserter.h
  UnknownModuleException.h
  WorkerInPath.h
  WorkerMap.h
  WorkerT.h
  )

# - detail headers
set(art_Framework_Core_DETAIL_HEADERS
  detail/getAssnsHandle.h
  detail/IPRHelper.h
  detail/ModuleConfigInfo.h
  detail/ModuleFactory.h
  detail/ModuleInPathInfo.h
  detail/ModuleTypeDeducer.h
  detail/OutputModuleUtils.h
  detail/ScheduleTask.h
  )

# - Describe Library
add_library(art_Framework_Core SHARED
  ${art_Framework_Core_HEADERS}
  ${art_Framework_Core_DETAIL_HEADERS}
  Breakpoints.cc
  CachedProducts.cc
  DecrepitRelicInputSourceImplementation.cc
  detail/ModuleConfigInfo.cc
  detail/ModuleFactory.cc
  detail/OutputModuleUtils.cc
  detail/ScheduleTask.cc
  EDAnalyzer.cc
  EDFilter.cc
  EDProducer.cc
  EmptyEventTimestampPlugin.cc
  EndPathExecutor.cc
  EngineCreator.cc
  EventObserver.cc
  EventSelector.cc
  FileCatalogMetadataPlugin.cc
  get_BranchDescription.cc
  GroupSelector.cc
  GroupSelectorRules.cc
  IEventProcessor.cc
  InputSource.cc
  InputSourceFactory.cc
  MFStatusUpdater.cc
  OutputModule.cc
  OutputWorker.cc
  Path.cc
  PathManager.cc
  PathsInfo.cc
  PrincipalCache.cc
  ProducerBase.cc
  ProductRegistryHelper.cc
  RootDictionaryManager.cc
  Schedule.cc
  TriggerNames.cc
  TriggerResultInserter.cc
  WorkerInPath.cc
  )

# Describe library link interface - all Public for now
target_link_libraries(art_Framework_Core
  art_Framework_Services_System_CurrentModule_service
  art_Framework_Services_System_TriggerNamesService_service
  art_Framework_Services_Optional_RandomNumberGenerator_service
  art_Framework_Principal
  art_Persistency_Common
  art_Persistency_Provenance
  art_Framework_Services_Registry
  art_Utilities
  art_Version
  FNALCore::FNALCore
  ${CLHEP_LIBRARIES}
  ${TBB_LIBRARIES}
  )

target_include_directories(art_Framework_Core
  PUBLIC
   ${TBB_INCLUDE_DIRS}
  )

# Set any additional properties
set_target_properties(art_Framework_Core
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_Core
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Framework_Core_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Core
  COMPONENT Development
  )
install(FILES ${art_Framework_Core_DETAIL_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Core/detail
  COMPONENT Development
  )

ENDIF()
