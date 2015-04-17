if(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  add_executable(ProcTester ProcTester.cc)
  target_link_libraries(ProcTester art_Framework_Services_Optional)
  cet_test(Proc_t HANDBUILT
    TEST_EXEC ProcTester
    )
endif()

add_executable(ConstrainedMultimapTester ConstrainedMultimapTester.cc)
target_link_libraries(ConstrainedMultimapTester art_Framework_Services_Optional)
cet_test(ConstrainedMultimap_t HANDBUILT
  TEST_EXEC ConstrainedMultimapTester
  )
