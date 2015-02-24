IF (CETBUILDTOOLS_VERSION)

art_make(LIB_LIBRARIES
  MF_MessageLogger
  MF_Utilities
	fhiclcpp
	cetlib
	${Boost_FILESYSTEM_LIBRARY}
	${Boost_REGEX_LIBRARY}
	${Boost_SYSTEM_LIBRARY}
	${Boost_THREAD_LIBRARY}
	${ROOT_CINT}
	${ROOT_REFLEX}
	-lpthread
	-ldl
  )

install_headers(SUBDIRS detail)
install_source(SUBDIRS detail)

ELSE()

set(art_UTILITIES_HEADERS
  BasicPluginMacros.h
  CPUTimer.h
  CRC32Calculator.h
  DebugMacros.h
  Digest.h
  Exception.h
  ExceptionMessages.h
  FirstAbsoluteOrLookupWithDotPolicy.h
  FriendlyName.h
  GetPassID.h
  GetReleaseVersion.h
  HRRealTime.h
  InputTag.h
  JobMode.h
  MallocOpts.h
  OutputFileInfo.h
  RegexMatch.h
  RootHandlers.h
  ScheduleID.h
  TestHelper.h
  ThreadSafeIndexedRegistry.h
  TypeID.h
  UnixSignalHandlers.h
  Verbosity.h
  WrappedClassName.h
  ensurePointer.h
  ensureTable.h
  fwd.h
  md5.h
  parent_path.h
  pointersEqual.h
  quiet_unit_test.hpp
  unique_filename.h
  vectorTransform.h
  )

set(art_UTILITIES_DETAIL_HEADERS
  detail/math_private.h
  detail/metaprogramming.h
  )

set(art_UTILITIES_SOURCES
  CPUTimer.cc
  CRC32Calculator.cc
  DebugMacros.cc
  Digest.cc
  ensureTable.cc
  Exception.cc
  ExceptionMessages.cc
  FirstAbsoluteOrLookupWithDotPolicy.cc
  FriendlyName.cc
  InputTag.cc
  MallocOpts.cc
  md5.c
  parent_path.cc
  RegexMatch.cc
  RootHandlers.cc
  TestHelper.cc
  TypeID.cc
  unique_filename.cc
  UnixSignalHandlers.cc
  WrappedClassName.cc
  )


add_library(art_Utilities
  SHARED
  ${art_UTILITIES_HEADERS}
  ${art_UTILITIES_DETAIL_HEADERS}
  ${art_UTILITIES_SOURCES}
  )
set_target_properties(art_Utilities
  PROPERTIES
    VERSION ${art_VERSION}
    SOVERSION ${art_SOVERSION}
  )

# No usage requirements for Root dirs, so add them here,
# but due to Root's broken CMake config file, this won't
# work directly.
target_include_directories(art_Utilities
  PRIVATE ${ROOT_INCLUDE_DIRS}
  )

target_link_libraries(art_Utilities
  LINK_PUBLIC
   FNALCore::FNALCore
   ${Boost_FILESYSTEM_LIBRARY}
   ${Boost_SYSTEM_LIBRARY}
  LINK_PRIVATE
   ${ROOT_Reflex_LIBRARY}
  )

install(TARGETS art_Utilities
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_UTILITIES_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Utilities
  COMPONENT Development
  )
install(FILES ${art_UTILITIES_DETAIL_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Utilities/detail
  COMPONENT Development
  )

ENDIF()
