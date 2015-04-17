if (ALT_CMAKE) 
include(altCMakeLists.cmake)
else()
art_dictionary()

install_source()
endif()
