# - Build documentation as required

#-----------------------------------------------------------------------
# Doxygen
find_package(Doxygen 1.8 REQUIRED)

# - Configure
# We create and install a tags file so that clients can cross link to
# or documents.
# TODO: provide path to tag file as a component in the cmake project
# config file.
set(Art_DOXYGEN_TAGFILE "Art.doxytags")
configure_file(Art.doxyfile.in Art.doxyfile @ONLY)

add_custom_command(OUTPUT html/index.html
  COMMAND ${DOXYGEN_EXECUTABLE} Art.doxyfile
  MAIN_DEPENDENCY Art.doxyfile
  #DEPENDS <target list>
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Doxygenating Art"
  )
add_custom_target(doc ALL DEPENDS html/index.html)

# - HTML docs
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html
  DESTINATION ${CMAKE_INSTALL_DOCDIR}/doxygen
  COMPONENT Documentation
  )

# - Doxygen tag file
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${Art_DOXYGEN_TAGFILE}
  DESTINATION ${CMAKE_INSTALL_DOCDIR}/doxygen
  COMPONENT Documentation
  )

