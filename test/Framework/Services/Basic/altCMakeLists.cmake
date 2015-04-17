art_add_module(TestTFileServiceAnalyzer_module TestTFileServiceAnalyzer_module.cc)
target_link_libraries(TestTFileServiceAnalyzer_module
  art_Framework_Services_Optional_TFileService_service
  ${ROOT_Hist_LIBRARY}
  ${ROOT_Graf_LIBRARY}
  )

art_add_module(UnitTestClient_module UnitTestClient.h UnitTestClient_module.cc)

cet_test(UnitTestClient HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all --config test_fpc.fcl
  DATAFILES
  fcl/test_fpc.fcl
  )

