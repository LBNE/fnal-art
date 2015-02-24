IF (CETBUILDTOOLS_VERSION)
# Confgure file to handle differences for Mac.
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/check_libs.cc.in
  ${CMAKE_CURRENT_BINARY_DIR}/check_libs.cc @ONLY
  )

####################################
# Configure for desired default exception handling.
SET(ART_MAIN_FUNC artapp)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/artapp.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/${ART_MAIN_FUNC}.h @ONLY
  )

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/artapp.cc.in
  ${CMAKE_CURRENT_BINARY_DIR}/${ART_MAIN_FUNC}.cc @ONLY
  )

SET(ART_MAIN_FUNC mu2eapp)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/artapp.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/${ART_MAIN_FUNC}.h @ONLY
  )

SET(ART_RETHROW_DEFAULT TRUE)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/artapp.cc.in
  ${CMAKE_CURRENT_BINARY_DIR}/${ART_MAIN_FUNC}.cc @ONLY
  )
####################################

set(art_Framework_Art_sources
  BasicOptionsHandler.cc
  BasicPostProcessor.cc
  BasicSourceOptionsHandler.cc
  BasicOutputOptionsHandler.cc
  DebugOptionsHandler.cc
  FileCatalogOptionsHandler.cc
  InitRootHandlers.cc
  OptionsHandler.cc
  ${CMAKE_CURRENT_BINARY_DIR}/artapp.cc
  ${CMAKE_CURRENT_BINARY_DIR}/mu2eapp.cc
  find_config.cc
  run_art.cc
  )

art_make_library( LIBRARY_NAME art_Framework_Art
                  SOURCE ${art_Framework_Art_sources} 
                  LIBRARIES ${Boost_PROGRAM_OPTIONS_LIBRARY}
  art_Framework_IO_Root
  art_Framework_EventProcessor
  art_Framework_Core
  art_Framework_Services_Registry
  art_Persistency_Common
  art_Persistency_Provenance
  art_Utilities
  ${ROOT_HIST}
  ${ROOT_MATRIX}
  )

set (ART_EXEC_ROOT_LIBS
  ${ROOT_CINTEX}
  ${ROOT_PHYSICS}
  ${ROOTSYS}/lib/libGraf.so
  ${ROOT_TREE}
  ${ROOT_HIST}
  ${ROOT_MATRIX}
  ${ROOT_NET}
  ${ROOT_MATHCORE}
  ${ROOT_RIO}
  ${ROOT_THREAD}
  ${ROOT_CORE}
  ${ROOT_CINT}
  ${ROOT_REFLEX}
)

# Build an art exec.
macro(art_exec TARGET_STEM IN_STEM MAIN_FUNC)
  cet_parse_args(AE "LIBRARIES" "" ${ARGN})
  set(ART_MAIN_FUNC ${MAIN_FUNC})
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${IN_STEM}.cc.in
    ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_STEM}.cc @ONLY
    )
  art_make_exec(NAME ${TARGET_STEM}
    SOURCE ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_STEM}.cc
    ${AE_DEFAULT_ARGS}
    LIBRARIES
    ${AE_LIBRARIES}
    art_Framework_Art
    # ROOT libraries added for use convenience ONLY -- they will go away
    # eventually.
    ${ART_EXEC_ROOT_LIBS}
    MF_MessageLogger
    )
endmacro()

# Standard execs
art_exec(art art artapp)
art_exec(gm2 art artapp)
art_exec(lar art artapp)
art_exec(mu2e art mu2eapp)
art_exec(nova art artapp)

# Execs with Boost unit testing enabled for modules.
art_exec(art_ut art_ut artapp LIBRARIES ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
art_exec(gm2_ut art_ut artapp LIBRARIES ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
art_exec(lar_ut art_ut artapp LIBRARIES ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
art_exec(mu2e_ut art_ut mu2eapp LIBRARIES ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
art_exec(nova_ut art_ut artapp LIBRARIES ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})

art_make_exec(NAME check_libs
  SOURCE ${CMAKE_CURRENT_BINARY_DIR}/check_libs.cc
  LIBRARIES
  art_Utilities
  cetlib
  )

install_headers()
install_source()

ELSE()

# - Build art_Framework_Art and main applications

# - check_libs app
configure_file(check_libs.cc.in
  ${CMAKE_CURRENT_BINARY_DIR}/check_libs.cc @ONLY
  )
add_executable(check_libs ${CMAKE_CURRENT_BINARY_DIR}/check_libs.cc)
target_link_libraries(check_libs
  art_Utilities
  FNALCore::FNALCore
  )

# - art_Framework_Art library
# Configure for desired default exception handling.
set(ART_MAIN_FUNC artapp)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/artapp.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/${ART_MAIN_FUNC}.h @ONLY
  )

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/artapp.cc.in
  ${CMAKE_CURRENT_BINARY_DIR}/${ART_MAIN_FUNC}.cc @ONLY
  )

set(ART_MAIN_FUNC mu2eapp)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/artapp.h.in
  ${CMAKE_CURRENT_BINARY_DIR}/${ART_MAIN_FUNC}.h @ONLY
  )

set(ART_RETHROW_DEFAULT TRUE)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/artapp.cc.in
  ${CMAKE_CURRENT_BINARY_DIR}/${ART_MAIN_FUNC}.cc @ONLY
  )

set(art_Framework_Art_HEADERS
  BasicOptionsHandler.h
  BasicOutputOptionsHandler.h
  BasicPostProcessor.h
  BasicSourceOptionsHandler.h
  DebugOptionsHandler.h
  FileCatalogOptionsHandler.h
  find_config.h
  InitRootHandlers.h
  OptionsHandler.h
  OptionsHandlers.h
  run_art.h
  ${CMAKE_CURRENT_BINARY_DIR}/artapp.h
  ${CMAKE_CURRENT_BINARY_DIR}/mu2eapp.h
  )

add_library(art_Framework_Art SHARED
  ${art_Framework_Art_HEADERS}
  BasicOptionsHandler.cc
  BasicPostProcessor.cc
  BasicSourceOptionsHandler.cc
  BasicOutputOptionsHandler.cc
  DebugOptionsHandler.cc
  FileCatalogOptionsHandler.cc
  InitRootHandlers.cc
  OptionsHandler.cc
  ${CMAKE_CURRENT_BINARY_DIR}/artapp.cc
  ${CMAKE_CURRENT_BINARY_DIR}/mu2eapp.cc
  find_config.cc
  run_art.cc
  )

# Describe library link interface - all Public for now
target_link_libraries(art_Framework_Art
  ${Boost_PROGRAM_OPTIONS_LIBRARY}
  art_Framework_IO_Root
  art_Framework_EventProcessor
  art_Framework_Core
  art_Framework_Services_Registry
  art_Persistency_Common
  art_Persistency_Provenance
  art_Utilities
  ${ROOT_Hist_LIBRARY}
  ${ROOT_Matrix_LIBRARY}
  )

# Set any additional properties
set_target_properties(art_Framework_Art
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

# - art program / Boost.Unit version
set(ART_MAIN_FUNC artapp)
configure_file(art.cc.in art.cc @ONLY)
configure_file(art_ut.cc.in art_ut.cc @ONLY)

add_executable(art ${CMAKE_CURRENT_BINARY_DIR}/art.cc)
target_link_libraries(art
  art_Framework_Art
  FNALCore::FNALCore
  )
add_executable(art_ut ${CMAKE_CURRENT_BINARY_DIR}/art_ut.cc)
target_link_libraries(art_ut
  art_Framework_Art
  FNALCore::FNALCore
  ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}
  )

# - art with default exception handling / Boost.Unit variant
set(ART_MAIN_FUNC mu2eapp)
configure_file(art.cc.in mu2e.cc @ONLY)
configure_file(art_ut.cc.in mu2e_ut.cc @ONLY)

add_executable(mu2e ${CMAKE_CURRENT_BINARY_DIR}/mu2e.cc)
target_link_libraries(mu2e
  art_Framework_Art
  FNALCore::FNALCore
  )
add_executable(mu2e_ut ${CMAKE_CURRENT_BINARY_DIR}/mu2e_ut.cc)
target_link_libraries(mu2e_ut
  art_Framework_Art
  FNALCore::FNALCore
  ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}
  )

# - Install the targets
install(TARGETS
  check_libs
  art_Framework_Art
  art
  art_ut
  mu2e
  mu2e_ut
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )

install(FILES ${art_Framework_Art_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Art
  COMPONENT Development
  )

ENDIF()
