if (ALT_CMAKE)
include(altCMakeLists.cmake)
else()
cet_test(PostCloseFileRenamer_t USE_BOOST_UNIT
  LIBRARIES
  art_Framework_IO
  ${Boost_FILESYSTEM_LIBRARY}
)
endif()
