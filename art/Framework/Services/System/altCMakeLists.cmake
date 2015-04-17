
# - Build art_Framework_Services_System plugins
# All service plugins, so require linking to art_Framework_Services_Registry
set(art_Framework_Services_System_HEADERS)
set(art_Framework_Services_System_DETAIL_HEADERS)
set(art_Framework_Services_System_TARGETS)

# - CurrentModule
add_library(art_Framework_Services_System_CurrentModule_service
  SHARED
  CurrentModule.h
  CurrentModule_service.cc
  )
list(APPEND art_Framework_Services_System_HEADERS CurrentModule.h)
list(APPEND art_Framework_Services_System_TARGETS art_Framework_Services_System_CurrentModule_service)
target_link_libraries(art_Framework_Services_System_CurrentModule_service
  art_Framework_Services_Registry
  art_Persistency_Provenance
  )

# - FileCatalogMetadata
add_library(art_Framework_Services_System_FileCatalogMetadata_service
  SHARED
  FileCatalogMetadata.h
  FileCatalogMetadata_service.cc
  )
list(APPEND art_Framework_Services_System_HEADERS FileCatalogMetadata.h)
list(APPEND art_Framework_Services_System_TARGETS art_Framework_Services_System_FileCatalogMetadata_service)
target_link_libraries(art_Framework_Services_System_FileCatalogMetadata_service
  art_Framework_Services_Registry
  )

# - FloatingPointControl
add_library(art_Framework_Services_System_FloatingPointControl_service
  SHARED
  FloatingPointControl.h
  FloatingPointControl_service.cc
  )
list(APPEND art_Framework_Services_System_HEADERS FloatingPointControl.h)
list(APPEND art_Framework_Services_System_TARGETS art_Framework_Services_System_FloatingPointControl_service)
target_link_libraries(art_Framework_Services_System_FloatingPointControl_service
  art_Framework_Services_Registry
  )

# - PathSelection
add_library(art_Framework_Services_System_PathSelection_service
  SHARED
  PathSelection.h
  PathSelection_service.cc
  )
list(APPEND art_Framework_Services_System_HEADERS PathSelection.h)
list(APPEND art_Framework_Services_System_TARGETS art_Framework_Services_System_PathSelection_service)
target_link_libraries(art_Framework_Services_System_PathSelection_service
  art_Framework_Services_Registry
  art_Framework_Core
  )

# - ScheduleContext
add_library(art_Framework_Services_System_ScheduleContext_service
  SHARED
  ScheduleContext.h
  detail/ScheduleContextSetter.h
  ScheduleContext_service.cc
  )
list(APPEND art_Framework_Services_System_HEADERS ScheduleContext.h)
list(APPEND art_Framework_Services_System_DETAIL_HEADERS
  detail/ScheduleContextSetter.h)
list(APPEND art_Framework_Services_System_TARGETS
  art_Framework_Services_System_ScheduleContext_service
  )
target_link_libraries(art_Framework_Services_System_ScheduleContext_service
  art_Framework_Services_Registry
  art_Framework_Core
  ${TBB_LIBRARIES}
  )
target_include_directories(art_Framework_Services_System_ScheduleContext_service
  PRIVATE
   ${TBB_INCLUDE_DIRS}
  )

# - TriggerNamesService
add_library(art_Framework_Services_System_TriggerNamesService_service
  SHARED
  TriggerNamesService.h
  TriggerNamesService_service.cc
  )
list(APPEND art_Framework_Services_System_HEADERS TriggerNamesService.h)
list(APPEND art_Framework_Services_System_TARGETS art_Framework_Services_System_TriggerNamesService_service)
target_link_libraries(art_Framework_Services_System_TriggerNamesService_service
  art_Framework_Services_Registry
  )


# Set any additional properties
set_target_properties(${art_Framework_Services_System_TARGETS}
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS ${art_Framework_Services_System_TARGETS}
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Framework_Services_System_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/System
  COMPONENT Development
  )
install(FILES ${art_Framework_Services_System_DETAIL_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/System/detail
  COMPONENT Development
  )

