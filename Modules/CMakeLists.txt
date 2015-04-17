if (ALT_CMAKE) 
include(portableCMakeLists.cmake)
else()
INSTALL(FILES
  ArtDictionary.cmake
  ArtMake.cmake
  BuildPlugins.cmake
  CheckClassVersion.cmake
  DESTINATION ${product}/${version}/Modules
  )
endif()
