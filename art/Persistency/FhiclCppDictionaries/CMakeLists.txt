if (ALT_CMAKE) 
include(altCMakeLists.cmake)
else()
# project name
project(art_Persistency_FhiclCppDictionaries)

art_dictionary(DICTIONARY_LIBRARIES fhiclcpp)

install_source()
endif()
