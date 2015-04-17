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
