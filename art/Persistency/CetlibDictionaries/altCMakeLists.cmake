art_add_dictionary(DICTIONARY_LIBRARIES FNALCore::FNALCore)

install(TARGETS art_Persistency_CetlibDictionaries_dict art_Persistency_CetlibDictionaries_map
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )

