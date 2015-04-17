# - Build art_Framework_EventProcessor

set(art_Framework_EventProcessor_HEADERS
  EPStates.h
  EventProcessor.h
  EvProcInitHelper.h
  ServiceDirector.h
  )

set(art_Framework_EventProcessor_DETAIL_HEADERS
  detail/writeSummary.h
  )

# Define library
add_library(art_Framework_EventProcessor SHARED
  ${art_Framework_EventProcessor_HEADERS}
  ${art_Framework_EventProcessor_DETAIL_HEADERS}
  EPStates.cc
  EventProcessor.cc
  EvProcInitHelper.cc
  ServiceDirector.cc
  detail/writeSummary.cc
  )

# Describe library link interface - all Public for now
target_link_libraries(art_Framework_EventProcessor
  art_Framework_Services_System_CurrentModule_service
  art_Framework_Services_System_FileCatalogMetadata_service
  art_Framework_Services_System_FloatingPointControl_service
  art_Framework_Services_System_PathSelection_service
  art_Framework_Services_System_ScheduleContext_service
  art_Framework_Services_System_TriggerNamesService_service
  art_Framework_Core
  art_Utilities
  FNALCore::FNALCore
  ${TBB_LIBRARIES}
  )

target_include_directories(art_Framework_EventProcessor
  PUBLIC
   ${TBB_INCLUDE_DIRS}
  )

# Set any additional properties
set_target_properties(art_Framework_EventProcessor
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_EventProcessor
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Framework_EventProcessor_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/EventProcessor
  COMPONENT Development
  )
install(FILES ${art_Framework_EventProcessor_DETAIL_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/EventProcessor
  COMPONENT Development
  )


