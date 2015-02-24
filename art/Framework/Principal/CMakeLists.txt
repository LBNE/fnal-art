IF (CETBUILDTOOLS)

set(art_Framework_Principal_sources
  Actions.cc
  AssnsGroup.cc
  CurrentProcessingContext.cc
  DataViewImpl.cc
  DeferredProductGetter.cc
  Event.cc
  EventPrincipal.cc
  Group.cc
  GroupFactory.cc
  NoDelayedReader.cc
  Principal.cc
  Provenance.cc
  Run.cc
  RunPrincipal.cc
  Selector.cc
  SelectorBase.cc
  SubRun.cc
  SubRunPrincipal.cc
  Worker.cc
)

art_make_library( LIBRARY_NAME art_Framework_Principal
                  SOURCE ${art_Framework_Principal_sources}
                  LIBRARIES art_Persistency_Provenance
  art_Persistency_Common
  art_Framework_Services_Registry
  art_Utilities
  art_Version
  MF_MessageLogger
  fhiclcpp
  cetlib
  ${CLHEP}
)

install_headers(SUBDIRS detail)
install_source(SUBDIRS detail)


ELSE()

# - Build art_Framework_Principal lib
# Define headers
set(art_Framework_Principal_HEADERS
  ActionCodes.h
  Actions.h
  AssnsGroup.h
  CurrentProcessingContext.h
  DataViewImpl.h
  DeferredProductGetter.h
  Event.h
  EventPrincipal.h
  fwd.h
  GroupFactory.h
  Group.h
  Handle.h
  NoDelayedReader.h
  OccurrenceTraits.h
  OutputHandle.h
  Principal.h
  Provenance.h
  Run.h
  RunPrincipal.h
  RunStopwatch.h
  SelectorBase.h
  Selector.h
  SubRun.h
  SubRunPrincipal.h
  View.h
  Worker.h
  WorkerParams.h
  )

set(art_Framework_Principal_DETAIL_HEADERS
  detail/maybe_record_parents.h
  )

# Describe library
add_library(art_Framework_Principal SHARED
  ${art_Framework_Principal_HEADERS}
  ${art_Framework_Principal_DETAIL_HEADERS}
  Actions.cc
  AssnsGroup.cc
  CurrentProcessingContext.cc
  DataViewImpl.cc
  DeferredProductGetter.cc
  Event.cc
  EventPrincipal.cc
  Group.cc
  GroupFactory.cc
  NoDelayedReader.cc
  Principal.cc
  Provenance.cc
  Run.cc
  RunPrincipal.cc
  SelectorBase.cc
  Selector.cc
  SubRun.cc
  SubRunPrincipal.cc
  Worker.cc
  )

# Describe library include interface
target_include_directories(art_Framework_Principal
  PUBLIC
   ${CLHEP_INCLUDE_DIRS}
  )

# Describe library link interface - all Public for now
target_link_libraries(art_Framework_Principal
  art_Version
  art_Utilities
  art_Persistency_Common
  art_Framework_Services_Registry
  FNALCore::FNALCore
  ${CLHEP_LIBRARIES}
  )

# Set any additional properties
set_target_properties(art_Framework_Principal
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_Principal
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Framework_Principal_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Principal
  COMPONENT Development
  )
install(FILES ${art_Framework_Principal_DETAIL_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Principal/detail
  COMPONENT Development
  )

ENDIF()
