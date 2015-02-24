IF (CETBUILDTOOLS_VERSION)

# project name
project(art_Persistency_FhiclCppDictionaries)

art_dictionary(DICTIONARY_LIBRARIES fhiclcpp)

install_source()

ELSE()

art_add_dictionary(DICTIONARY_LIBRARIES FNALCore::FNALCore)
install(TARGETS art_Persistency_FhiclCppDictionaries_map
  art_Persistency_FhiclCppDictionaries_dict
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )

ENDIF()
