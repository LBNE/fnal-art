if (ALT_CMAKE) 
include(altCMakeLists.cmake)
else()

# create package configuration and version files

process_ups_files()

cet_cmake_config()
endif()
