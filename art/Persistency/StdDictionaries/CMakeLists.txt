if (ALT_CMAKE) 
include(altCMakeLists.cmake)
else()
# project name
project(art_Persistency_StdDictionaries)

art_dictionary()

install_source()
endif()
