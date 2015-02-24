IF (CETBUILDTOOLS_VERSION)

include(CetTest)

link_libraries(
  -ldl
)

cet_test(GlobalSignal_t USE_BOOST_UNIT)
cet_test(LocalSignal_t USE_BOOST_UNIT)

ELSE()

cet_test(GlobalSignal_t USE_BOOST_UNIT LIBRARIES FNALCore::FNALCore)
cet_test(LocalSignal_t USE_BOOST_UNIT LIBRARIES FNALCore::FNALCore)

ENDIF()
