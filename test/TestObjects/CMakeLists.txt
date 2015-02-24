IF (CETBUILDTOOLS)

art_make_library(SOURCE TH1Data.cc
  LIBRARIES ${ROOT_HIST} ${ROOT_CORE} NO_INSTALL
  )

art_dictionary(DICTIONARY_LIBRARIES
  test_TestObjects
  art_Persistency_Common_dict
  NO_INSTALL
  )

ELSE()

include_directories(${ROOT_INCLUDE_DIRS})
add_library(test_TestObjects SHARED TH1Data.cc)
target_link_libraries(test_TestObjects
  ${ROOT_Hist_LIBRARY}
  ${ROOT_Core_Library}
  )

art_add_dictionary(DICTIONARY_LIBRARIES
  test_TestObjects
  art_Persistency_Common_dict
  )
ENDIF()
