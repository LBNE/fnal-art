IF (CETBUILDTOOLS_VERSION)

art_dictionary()

install_source()

ELSE()

art_add_dictionary()

install(TARGETS art_Persistency_WrappedStdDictionaries_dict art_Persistency_WrappedStdDictionaries_map
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
ENDIF()
