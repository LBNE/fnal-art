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
