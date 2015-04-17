if (ALT_CMAKE) 
include(altCMakeLists.cmake)
else()
art_dictionary(DICTIONARY_LIBRARIES ${CLHEP})

install_source()
endif()
