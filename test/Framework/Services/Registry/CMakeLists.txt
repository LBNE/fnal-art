if (ALT_CMAKE) 
include(altCMakeLists.cmake)
else()
include(CetTest)

link_libraries(
  -ldl
)

cet_test(GlobalSignal_t USE_BOOST_UNIT)
cet_test(LocalSignal_t USE_BOOST_UNIT)
endif()
