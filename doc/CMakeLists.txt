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

#-----------------------------------------------------------------------
# Art Workbook - for now bring in as external project, could later
# be submodule.
# The "develop" branch is used because the last tag was last summer.
# No update command to avoid pulling in changes at every single build,
# which slightly contradicts the preceeding statement...
include(ExternalProject)
find_package(LATEX)

# Only build/install if we've got pdflatex
if(PDFLATEX_COMPILER)
  ExternalProject_Add(art-wb
    GIT_REPOSITORY "https://cdcvs.fnal.gov/projects/art-workbook-doc"
    GIT_TAG        "develop"
    UPDATE_COMMAND    ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ${PDFLATEX_COMPILER} "art-doc-draft"
          COMMAND     ${PDFLATEX_COMPILER} "art-doc-print"
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   ${CMAKE_COMMAND} -E copy art-doc-draft.pdf ${PROJECT_BINARY_DIR}
            COMMAND   ${CMAKE_COMMAND} -E copy art-doc-print.pdf ${PROJECT_BINARY_DIR}
    )

  install(FILES ${PROJECT_BINARY_DIR}/art-doc-draft.pdf
    ${PROJECT_BINARY_DIR}/art-doc-print.pdf
    DESTINATION ${CMAKE_INSTALL_DOCDIR}
    )
endif()


