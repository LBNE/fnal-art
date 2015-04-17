
# - Build art_Framework_Services_Registry lib
# Define headers
set(art_Framework_Services_Registry_HEADERS
  ActivityRegistry.h
  BranchActionType.h
  GlobalSignal.h
  LocalSignal.h
  ServiceHandle.h
  ServiceMacros.h
  ServiceRegistry.h
  ServiceScope.h
  ServicesManager.h
  ServiceToken.h
  )

set(art_Framework_Services_Registry_DETAIL_HEADERS
  detail/helper_macros.h
  detail/makeWatchFunc.h
  detail/ServiceCacheEntry.h
  detail/ServiceCache.h
  detail/ServiceHelper.h
  detail/ServiceStack.h
  detail/ServiceWrapperBase.h
  detail/ServiceWrapper.h
  detail/SignalResponseType.h
  )

# Describe library
add_library(art_Framework_Services_Registry SHARED
  ${art_Framework_Services_Registry_HEADERS}
  ${art_Framework_Services_Registry_DETAIL_HEADERS}
  ServiceRegistry.cc
  ServicesManager.cc
  detail/ServiceCacheEntry.cc
  )

# Describe library link interface - all Public for now
target_link_libraries(art_Framework_Services_Registry
  art_Utilities
  )

# Set any additional properties
set_target_properties(art_Framework_Services_Registry
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Framework_Services_Registry
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Framework_Services_Registry_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/Registry
  COMPONENT Development
  )
install(FILES ${art_Framework_Services_Registry_DETAIL_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Services/Registry/detail
  COMPONENT Development
  )

