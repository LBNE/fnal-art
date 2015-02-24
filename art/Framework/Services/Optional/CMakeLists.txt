IF (CETBUILDSERVICE_VERSION)

set( art_Framework_Services_Optional_sources
  TFileDirectory.cc
  detail/TH1AddDirectorySentry.cc
)

if ( ${CMAKE_SYSTEM_NAME} MATCHES "Linux" ) 
  list( APPEND 
    art_Framework_Services_Optional_sources 
    MemoryTrackerLinux.cc
    SimpleMemoryCheckLinux.cc
    detail/LinuxProcMgr.cc
    )
endif()

art_make_library( SOURCE ${art_Framework_Services_Optional_sources}
  LIBRARIES cetlib
  ${ROOT_HIST}
  ${ROOT_MATRIX}
  ${ROOT_MATHCORE}
  ${ROOT_CORE}
  ${ROOT_CINT}
  ${Boost_FILESYSTEM_LIBRARY}
  ${Boost_REGEX_LIBRARY}
  ${Boost_SYSTEM_LIBRARY}
  art_Framework_Services_Registry
  art_Persistency_Provenance
  art_Utilities
  art_Ntuple
)

simple_plugin(RandomNumberGenerator "service"
  art_Framework_Principal
  art_Persistency_Common
  MF_MessageLogger
  MF_Utilities
  cetlib
  ${CLHEP}
  )

simple_plugin(SimpleInteraction "service" art_Framework_Services_UserInteraction)

simple_plugin(SimpleMemoryCheck "service"
  art_Persistency_Provenance
  art_Framework_Services_Optional
  )

simple_plugin(MemoryAdjuster "service"
  art_Framework_Services_Optional
  )

simple_plugin(MemoryTracker "service"
  art_Framework_Services_Optional
  art_Ntuple
  art_Persistency_Provenance
  )

simple_plugin(TFileService "service"
  art_Framework_Services_System_TriggerNamesService_service
  art_Framework_Services_Optional
  art_Framework_IO
  art_Framework_Principal
  ${ROOT_RIO}
  ${ROOT_THREAD})

simple_plugin(Timing "service" art_Persistency_Provenance)

if (NOT APPLE)
  set(RT -lrt)
endif()

simple_plugin(TimeTracker "service"
  art_Ntuple
  art_Persistency_Provenance
  ${TBB}
  ${RT}
  )

simple_plugin(Tracer "service" art_Persistency_Provenance)

simple_plugin(TrivialFileDelivery "service")

simple_plugin(TrivialFileTransfer "service")

install_headers(SUBDIRS detail)
install_source(SUBDIRS detail)

ELSE()

# - Build art_Framework_Services_Optional lib and plugins

# - art_Framework_Services_Optional
add_library(art_Framework_Services_Optional SHARED
  TFileDirectory.h
  TFileDirectory.cc
  detail/TH1AddDirectorySentry.h
  detail/TH1AddDirectorySentry.cc
  )

target_link_libraries(art_Framework_Services_Optional
  FNALCore::FNALCore
  ${ROOT_Core_LIBRARY}
  ${ROOT_Hist_LIBRARY}
  )
target_include_directories(art_Framework_Services_Optional
  PUBLIC
   ${ROOT_INCLUDE_DIRS}
  )
set_target_properties(art_Framework_Services_Optional
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )
install(TARGETS art_Framework_Services_Optional
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES TFileDirectory.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/Optional
  COMPONENT Development
  )
install(FILES detail/TH1AddDirectorySentry.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/Optional/detail
  COMPONENT Development
  )

# - RandomNumberGeneratorService
add_library(art_Framework_Services_Optional_RandomNumberGenerator_service
  SHARED
  RandomNumberGenerator.h
  RandomNumberGenerator_service.cc
  )
target_link_libraries(art_Framework_Services_Optional_RandomNumberGenerator_service
  FNALCore::FNALCore
  ${CLHEP_LIBRARIES}
  art_Framework_Principal
  )
set_target_properties(art_Framework_Services_Optional_RandomNumberGenerator_service
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )
install(TARGETS art_Framework_Services_Optional_RandomNumberGenerator_service
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES RandomNumberGenerator.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/Optional
  COMPONENT Development
  )

# - SimpleInteraction_service
add_library(art_Framework_Services_Optional_SimpleInteraction_service
  SHARED
  SimpleInteraction.h
  SimpleInteraction_service.cc
  )
target_link_libraries(art_Framework_Services_Optional_SimpleInteraction_service
  art_Framework_Services_UserInteraction
  )
set_target_properties(art_Framework_Services_Optional_SimpleInteraction_service
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )
install(TARGETS art_Framework_Services_Optional_SimpleInteraction_service
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES SimpleInteraction.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/Optional
  COMPONENT Development
  )

# - SimpleMemoryCheck_service
add_library(art_Framework_Services_Optional_SimpleMemoryCheck_service
  SHARED
  SimpleMemoryCheck_service.cc
  )
target_link_libraries(art_Framework_Services_Optional_SimpleMemoryCheck_service
  art_Persistency_Provenance
  )
set_target_properties(art_Framework_Services_Optional_SimpleMemoryCheck_service
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )
install(TARGETS art_Framework_Services_Optional_SimpleMemoryCheck_service
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )

add_library(art_Framework_Services_Optional_TFileService_service
  SHARED
  TFileService.h
  TFileService_service.cc
  )
target_link_libraries(art_Framework_Services_Optional_TFileService_service
  art_Framework_Services_System_TriggerNamesService_service
  art_Framework_Services_Optional
  art_Framework_IO
  art_Framework_Principal
  ${ROOT_RIO_LIBRARY}
  ${ROOT_Thread_LIBRARY}
  )
set_target_properties(art_Framework_Services_Optional_TFileService_service
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )
install(TARGETS art_Framework_Services_Optional_TFileService_service
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES TFileService.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/Optional
  COMPONENT Development
  )



# - Timing_service
add_library(art_Framework_Services_Optional_Timing_service
  SHARED
  Timing_service.cc
  )
target_link_libraries(art_Framework_Services_Optional_Timing_service
  art_Persistency_Provenance
  )
target_include_directories(art_Framework_Services_Optional_Timing_service
  PRIVATE
   ${TBB_INCLUDE_DIRS}
  )

set_target_properties(art_Framework_Services_Optional_Timing_service
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )
install(TARGETS art_Framework_Services_Optional_Timing_service
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )

# - Tracer_service
add_library(art_Framework_Services_Optional_Tracer_service
  SHARED
  Tracer_service.cc
  )
target_link_libraries(art_Framework_Services_Optional_Tracer_service
  art_Persistency_Provenance
  )
set_target_properties(art_Framework_Services_Optional_Tracer_service
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )
install(TARGETS art_Framework_Services_Optional_Tracer_service
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )

# - TrivialFileDelivery_service
add_library(art_Framework_Services_Optional_TrivialFileDelivery_service
  SHARED
  TrivialFileDelivery.h
  TrivialFileDelivery_service.cc
  )
target_link_libraries(art_Framework_Services_Optional_TrivialFileDelivery_service
  art_Framework_Services_Registry
  )
set_target_properties(art_Framework_Services_Optional_TrivialFileDelivery_service
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )
install(TARGETS art_Framework_Services_Optional_TrivialFileDelivery_service
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES TrivialFileDelivery.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/Optional
  COMPONENT Development
  )

# - TrivialFileTransfer_service
add_library(art_Framework_Services_Optional_TrivialFileTransfer_service
  SHARED
  TrivialFileTransfer.h
  TrivialFileTransfer_service.cc
  )
target_link_libraries(art_Framework_Services_Optional_TrivialFileTransfer_service
  art_Framework_Services_Registry
  )
set_target_properties(art_Framework_Services_Optional_TrivialFileTransfer_service
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )
install(TARGETS art_Framework_Services_Optional_TrivialFileTransfer_service
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES TrivialFileTransfer.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/Optional
  COMPONENT Development
  )

ENDIF()

