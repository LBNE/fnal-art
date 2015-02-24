IF (CETBUILDTOOLS_VERSION)

# project name
project(art_Version)

configure_file ( ${CMAKE_CURRENT_SOURCE_DIR}/GetReleaseVersion.cc.in
  ${CMAKE_CURRENT_BINARY_DIR}/GetReleaseVersion.cc @ONLY )

art_make_library( LIBRARY_NAME art_Version
                  SOURCE ${CMAKE_CURRENT_BINARY_DIR}/GetReleaseVersion.cc
                 )

install_headers()
install_source()

ELSE()
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/GetReleaseVersion.cc.in
  ${CMAKE_CURRENT_BINARY_DIR}/GetReleaseVersion.cc
  @ONLY
  )

add_library(art_Version SHARED
  GetReleaseVersion.h
  ${CMAKE_CURRENT_BINARY_DIR}/GetReleaseVersion.cc
  )
set_target_properties(art_Version
  PROPERTIES
    VERSION ${art_VERSION}
    SOVERSION ${art_SOVERSION}
  )

#-----------------------------------------------------------------------
# Install lib and dev
#
install(TARGETS art_Version
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES GetReleaseVersion.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Version
  COMPONENT Development
  )
ENDIF()
