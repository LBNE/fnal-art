#-----------------------------------------------------------------------
# ReflexTools_t
# Workaround here, to avoid proliferation of cmake file
#
cet_test(ReflexTools_t USE_BOOST_UNIT
  LIBRARIES
    art_Framework_Art
    art_Framework_Services_Registry
    art_Utilities
    art_Framework_Core
    ${Boost_FILESYSTEM_LIBRARY}
    ${Boost_PROGRAM_OPTIONS_LIBRARY}
    ${ROOT_Cintex_LIBRARY}
    ${ROOT_Tree_LIBRARY}
    ${ROOT_Hist_LIBRARY}
    ${ROOT_Matrix_LIBRARY}
    ${ROOT_Net_LIBRARY}
    ${ROOT_Mathcore_LIBRARY}
    ${ROOT_Thread_LIBRARY}
    ${ROOT_RIO_LIBRARY}
    ${ROOT_Core_LIBRARY}
    ${ROOT_Cint_LIBRARY}
    ${ROOT_Reflex_LIBRARY}
    ${CPPUNIT_LIBRARY}
    ${CMAKE_DL_LIBS}
  )
#-----------------------------------------------------------------------
# END REFLEXTOOLS_T

#-----------------------------------------------------------------------
# Support Boost.unit-fication
function(use_boost_unit _target)
  if(NOT TARGET ${_target})
    message(FATAL_ERROR "${_target} is not of target type")
  endif()
  set_target_properties(${_target}
    PROPERTIES
    COMPILE_DEFINITIONS BOOST_TEST_DYN_LINK
    COMPILE_FLAGS -Wno-overloaded-virtual
    )
  target_link_libraries(${_target} ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
endfunction()


#-----------------------------------------------------------------------
# Support libs/props
add_library(test_Integration SHARED ToySource.h ToySource.cc)
target_link_libraries(test_Integration
  art_Framework_IO_Sources
  art_Framework_Core
  FNALCore::FNALCore
  )

set_source_files_properties(MixFilterTestETS_module.cc
  PROPERTIES COMPILE_DEFINITIONS ART_TEST_EVENTS_TO_SKIP_CONST=0
)

set_source_files_properties(MixFilterTestETSc_module.cc
  PROPERTIES COMPILE_DEFINITIONS ART_TEST_EVENTS_TO_SKIP_CONST=1
)

set_source_files_properties(MixFilterTestNoStartEvent_module.cc
  PROPERTIES COMPILE_DEFINITIONS ART_TEST_NO_STARTEVENT
)

set_source_files_properties(MixFilterTestOldStartEvent_module.cc
  PROPERTIES COMPILE_DEFINITIONS ART_TEST_OLD_STARTEVENT
)

#-----------------------------------------------------------------------
# PLUGINS
#
art_add_module(AddIntsProducer_module      AddIntsProducer_module.cc)
art_add_module(AssnsAnalyzer_module        AssnsAnalyzer_module.cc)
use_boost_unit(AssnsAnalyzer_module)
art_add_module(AssnsProducer_module        AssnsProducer_module.cc)
art_add_module(BareStringAnalyzer_module   BareStringAnalyzer_module.cc)
art_add_module(BareStringProducer_module   BareStringProducer_module.cc)
art_add_module(CompressedIntProducer_module       CompressedIntProducer_module.cc)
art_add_module(CompressedIntTestAnalyzer_module   CompressedIntTestAnalyzer_module.cc)
art_add_module(DeferredIsReadyWithAssnsAnalyzer_module   DeferredIsReadyWithAssnsAnalyzer_module.cc)
art_add_module(DeferredIsReadyWithAssnsProducer_module  DeferredIsReadyWithAssnsProducer_module.cc)
art_add_module(DerivedPtrVectorProducer_module DerivedPtrVectorProducer_module.cc)
art_add_module(DoubleProducer_module DoubleProducer_module.cc)
art_add_module(DoubleTestAnalyzer_module  DoubleTestAnalyzer_module.cc)

art_add_module(DropTestAnalyzer_module DropTestAnalyzer_module.cc)
use_boost_unit(DropTestAnalyzer_module)

art_add_module(DropTestParentageFaker_module DropTestParentageFaker_module.cc)
art_add_module(FailingAnalyzer_module FailingAnalyzer_module.cc)
art_add_module(FailingProducer_module FailingProducer_module.cc)
art_add_source(FlushingGenerator_source FlushingGenerator_source.cc)
art_add_module(FlushingGeneratorTest_module FlushingGeneratorTest_module.cc)
art_add_module(FlushingGeneratorTestFilter_module FlushingGeneratorTestFilter_module.cc)
art_add_source(GeneratorTest_source GeneratorTest_source.cc)

art_add_service(InFlightConfiguration_service InFlightConfiguration_service.cc)
use_boost_unit(InFlightConfiguration_service)
target_link_libraries(InFlightConfiguration_service
  art_Framework_Services_Registry
  art_Framework_Services_UserInteraction
  art_Framework_Services_System_PathSelection_service
  )

art_add_module(IntProducer_module IntProducer_module.cc)
art_add_module(IntTestAnalyzer_module IntTestAnalyzer_module.cc)
art_add_module(IntVectorAnalyzer_module IntVectorAnalyzer_module.cc)
art_add_module(IntVectorProducer_module IntVectorProducer_module.cc)

art_add_module(MixAnalyzer_module MixAnalyzer_module.cc)
use_boost_unit(MixAnalyzer_module)

art_add_module(MixFilterTest_module MixFilterTest_module.cc)
use_boost_unit(MixFilterTest_module)
target_link_libraries(MixFilterTest_module art_Framework_IO_ProductMix)

art_add_module(MixFilterTestETS_module MixFilterTestETS_module.cc)
use_boost_unit(MixFilterTestETS_module)
target_link_libraries(MixFilterTestETS_module art_Framework_IO_ProductMix)

art_add_module(MixFilterTestETSc_module MixFilterTestETSc_module.cc)
use_boost_unit(MixFilterTestETSc_module)
target_link_libraries(MixFilterTestETSc_module art_Framework_IO_ProductMix)

art_add_module(MixFilterTestNoStartEvent_module MixFilterTestNoStartEvent_module.cc)
use_boost_unit(MixFilterTestNoStartEvent_module)
target_link_libraries(MixFilterTestNoStartEvent_module art_Framework_IO_ProductMix)

art_add_module(MixFilterTestOldStartEvent_module MixFilterTestOldStartEvent_module.cc)
use_boost_unit(MixFilterTestOldStartEvent_module)
target_link_libraries(MixFilterTestOldStartEvent_module art_Framework_IO_ProductMix)

art_add_module(MixProducer_module MixProducer_module.cc)
art_add_module(MockClusterListAnalyzer_module MockClusterListAnalyzer_module.cc)
art_add_module(MockClusterListProducer_module MockClusterListProducer_module.cc)
art_add_module(PausingAnalyzer_module PausingAnalyzer_module.cc)

art_add_module(ProductIDGetter_module ProductIDGetter_module.cc)
use_boost_unit(ProductIDGetter_module)

art_add_module(ProductIDGetterAnalyzer_module ProductIDGetterAnalyzer_module.cc)
use_boost_unit(ProductIDGetterAnalyzer_module)

art_add_module(PtrListAnalyzer_module PtrListAnalyzer_module.cc)
art_add_module(PtrVectorAnalyzer_module PtrVectorAnalyzer_module.cc)
art_add_module(PtrVectorProducer_module PtrVectorProducer_module.cc)
art_add_module(PtrVectorSimpleAnalyzer_module PtrVectorSimpleAnalyzer_module.cc)

art_add_module(PtrmvAnalyzer_module PtrmvAnalyzer_module.cc)
use_boost_unit(PtrmvAnalyzer_module)

art_add_module(PtrmvProducer_module PtrmvProducer_module.cc)

art_add_module(RandomNumberSaveTest_module RandomNumberSaveTest_module.cc)
use_boost_unit(RandomNumberSaveTest_module)

art_add_service(Reconfigurable_service Reconfigurable_service.cc)
art_add_module(Reconfiguring_module Reconfiguring_module.cc)

art_add_module(SAMMetadataTest_module SAMMetadataTest_module.cc)
target_link_libraries(SAMMetadataTest_module art_Framework_Services_System_FileCatalogMetadata_service)

art_add_service(ServiceUsing_service ServiceUsing_service.cc)
art_add_module(SimpleDerivedAnalyzer_module SimpleDerivedAnalyzer_module.cc)
art_add_module(SimpleDerivedProducer_module SimpleDerivedProducer_module.cc)
art_add_module(TH1DataProducer_module TH1DataProducer_module.cc)
target_link_libraries(TH1DataProducer_module test_TestObjects)

art_add_module(TestAnalyzerSelect_module TestAnalyzerSelect_module.cc)
art_add_module(TestBitsOutput_module TestBitsOutput_module.cc)
art_add_module(TestFilter_module TestFilter_module.cc)
art_add_module(TestOutput_module TestOutput_module.cc)
art_add_module(TestProvenanceDumper_module TestProvenanceDumper_module.cc)
use_boost_unit(TestProvenanceDumper_module)

art_add_module(TestResultAnalyzer_module TestResultAnalyzer_module.cc)
art_add_module(TestServiceUsingService_module TestServiceUsingService_module.cc)
use_boost_unit(TestServiceUsingService_module)

art_add_module(TestSimpleMemoryCheckProducer_module TestSimpleMemoryCheckProducer_module.cc)
art_add_module(TestTimeTrackerProducer_module TestTimeTrackerProducer_module.cc)
art_add_module(TestTimeTrackerFilter_module TestTimeTrackerFilter_module.cc)
art_add_module(TestTimeTrackerAnalyzer_module TestTimeTrackerAnalyzer_module.cc)
art_add_service(Throwing_service Throwing_service.cc)

art_add_source(ToyRawFileInput_source ToyRawFileInput_source.cc)
use_boost_unit(ToyRawFileInput_source)
target_link_libraries(ToyRawFileInput_source test_Integration)

art_add_source(ToyRawInput_source ToyRawInput_source.cc)
use_boost_unit(ToyRawInput_source)
target_link_libraries(ToyRawInput_source test_Integration)

art_add_module(ToyRawInputTester_module ToyRawInputTester_module.cc)
art_add_module(ToyRawProductAnalyzer_module ToyRawProductAnalyzer_module.cc)
art_add_module(U_S_module U_S_module.cc)
art_add_module(ValidHandleTester_module ValidHandleTester_module.cc)
art_add_service(Wanted_service Wanted_service.cc)

#-----------------------------------------------------------------------
# LOCAL DICTIONARY
art_add_dictionary()

#-----------------------------------------------------------------------
# ACTUAL TESTS
cet_test(EventSelectorFromFile_w HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all --config EventSelectorFromFile_w.fcl
  DATAFILES
  fcl/EventSelectorFromFile_w.fcl
)

cet_test(EventSelectorFromFile_r1 HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all --config EventSelectorFromFile_r1.fcl
  DATAFILES
  fcl/EventSelectorFromFile_r1.fcl
  TEST_PROPERTIES DEPENDS EventSelectorFromFile_w
)

cet_test(EventSelectorFromFile_r2 HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all --config EventSelectorFromFile_r2.fcl
  DATAFILES
  fcl/EventSelectorFromFile_r2.fcl
  TEST_PROPERTIES DEPENDS EventSelectorFromFile_w
)

cet_test(test_simple_01_t.sh HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/test_simple_01_t.sh
  DATAFILES
  fcl/test_simple_01.fcl
  fcl/test_simple_01r.fcl
  fcl/messageDefaults.fcl
  test_simple_01_verify.cxx
)

cet_test(test_view_01_t.sh HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/test_view_01_t.sh
  DATAFILES
  fcl/test_view_01a.fcl
  fcl/test_view_01b.fcl
  fcl/test_simple_01r.fcl
  fcl/messageDefaults.fcl
)

cet_test(test_ptrvector_01a_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --config test_ptrvector_01a.fcl --rethrow-all
  DATAFILES
  fcl/test_ptrvector_01a.fcl
  fcl/messageDefaults.fcl
)

cet_test(test_ptrvector_01b_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --config test_ptrvector_01b.fcl --rethrow-all
  DATAFILES
  fcl/test_ptrvector_01b.fcl
  fcl/messageDefaults.fcl
  TEST_PROPERTIES DEPENDS test_ptrvector_01a_t
)

cet_test(SimpleDerived_01_w HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c test_simplederived_01a.fcl
  DATAFILES
  fcl/test_simplederived_01a.fcl
)

cet_test(SimpleDerived_01_r HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c test_simplederived_01b.fcl
  DATAFILES
  fcl/test_simplederived_01b.fcl
  TEST_PROPERTIES DEPENDS SimpleDerived_01_w
)

cet_test(SimpleDerived_02_r HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c SimpleDerived_02.fcl
  DATAFILES
  fcl/SimpleDerived_02.fcl
  TEST_PROPERTIES DEPENDS SimpleDerived_01_w
)

cet_test(outputCommand_t.sh HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/outputCommand_t.sh
  DATAFILES
  fcl/outputCommand_w.fcl
  fcl/outputCommand_r.fcl
  fcl/messageDefaults.fcl
)

cet_test(ptr_list_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all --config ptr_list_01.fcl
  DATAFILES
  fcl/ptr_list_01.fcl
  fcl/messageDefaults.fcl
)

cet_test(test_failingProducer_t.sh HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/test_failingProducer_t.sh
  DATAFILES
  fcl/test_failingProducer_w.fcl
  fcl/test_failingProducer_r.fcl
  fcl/messageDefaults.fcl
)

cet_test(issue_0923_t.sh HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/issue_0923_t.sh
  DATAFILES
  fcl/issue_0923a.fcl
  fcl/issue_0923b.fcl
  fcl/messageDefaults.fcl
  issue_0923_ref.txt
)

cet_test(issue_0926_t.sh HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/issue_0926_t.sh
  DATAFILES
  fcl/issue_0926a.fcl
  fcl/issue_0926b.fcl
  fcl/issue_0926c.fcl
  fcl/messageDefaults.fcl
)

cet_test(issue_0940_t.sh HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/issue_0940_t.sh
  DATAFILES
  fcl/issue_0940.fcl
  fcl/messageDefaults.fcl
)

cet_test(reconfig_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c test_reconfig_01.fcl
  DATAFILES
  fcl/test_reconfig_01.fcl
  fcl/messageDefaults.fcl
)

cet_test(issue_0930_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c issue_0930.fcl
  DATAFILES
  fcl/issue_0930.fcl
  fcl/messageDefaults.fcl
  TEST_PROPERTIES
  PASS_REGULAR_EXPRESSION "LogicError BEGIN"
)

cet_test(FileDumperOutput_w HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c FileDumperOutputTest_w.fcl
  TEST_PROPERTIES
  PASS_REGULAR_EXPRESSION "Total products \\(present, not present\\): 3 \\(3, 0\\)\\."
  DATAFILES
  fcl/FileDumperOutputTest_w.fcl
)

cet_test(FileDumperOutput_r HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c FileDumperOutputTest_r.fcl
  DATAFILES
  fcl/FileDumperOutputTest_r.fcl
  TEST_PROPERTIES
  PASS_REGULAR_EXPRESSION "Total products \\(present, not present\\): 3 \\(2, 1\\)\\."
  DEPENDS FileDumperOutput_w
)

cet_test(ToyRawInput_t_01 HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c ToyRawInput_01.fcl
  DATAFILES
  fcl/ToyRawInput_01.fcl
)

foreach(num 02 03 04)
  cet_test(ToyRawInput_t_${num} HANDBUILT
    TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/test_must_abort
    TEST_ARGS art -c ToyRawInput_${num}.fcl
    DATAFILES
    fcl/ToyRawInput_${num}.fcl
    fcl/ToyRawInput_common.fcl
  )
endforeach()

cet_test_assertion("outR \\\\|\\\\| inR"
  ToyRawInput_t_02
  )
cet_test_assertion("outSR \\\\|\\\\| inSR"
  ToyRawInput_t_03
  ToyRawInput_t_04
  )

foreach(num 05 06 07 08 09 10 11 12)
  cet_test(ToyRawInput_t_${num} HANDBUILT
    TEST_EXEC art
    TEST_ARGS --rethrow-all -c ToyRawInput_${num}.fcl
    DATAFILES
    fcl/ToyRawInput_${num}.fcl
    fcl/ToyRawInput_common.fcl
  )
endforeach()

SET_TESTS_PROPERTIES(ToyRawInput_t_05 PROPERTIES
  PASS_REGULAR_EXPRESSION
  "readNext returned a 'new' SubRun that was the same as the previous SubRun"
)

SET_TESTS_PROPERTIES(ToyRawInput_t_06 PROPERTIES
  PASS_REGULAR_EXPRESSION
  "readNext returned a 'new' Run that was the same as the previous Run"
)

SET_TESTS_PROPERTIES(ToyRawInput_t_07 PROPERTIES
  PASS_REGULAR_EXPRESSION
  "readNext returned a new Run and Event without a SubRun"
)

SET_TESTS_PROPERTIES(ToyRawInput_t_08 PROPERTIES
  PASS_REGULAR_EXPRESSION
  "readNext returned true but created no new data"
)

SET_TESTS_PROPERTIES(ToyRawInput_t_09 PROPERTIES
  PASS_REGULAR_EXPRESSION
  "readNext returned false but created new data"
)

SET_TESTS_PROPERTIES(ToyRawInput_t_10 PROPERTIES
  PASS_REGULAR_EXPRESSION
  "readNext returned a new Run with a SubRun from the wrong Run"
)

cet_test(ToyRawInput_w HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c ToyRawInput_w.fcl
  DATAFILES
  fcl/ToyRawInput_w.fcl
  fcl/ToyRawInput_wr_f1.fcl
  fcl/ToyRawInput_common.fcl
)

cet_test(ToyRawInput_r1 HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c ToyRawInput_r1.fcl
  DATAFILES
  fcl/ToyRawInput_r1.fcl
  TEST_PROPERTIES DEPENDS ToyRawInput_w
)

cet_test(ToyRawInput_r2 HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c ToyRawInput_r2.fcl
  DATAFILES
  fcl/ToyRawInput_r2.fcl
  fcl/ToyRawInput_r1.fcl
  TEST_PROPERTIES DEPENDS ToyRawInput_w
)

cet_test(ToyRawInput_r3 HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c ToyRawInput_r3.fcl
  DATAFILES
  fcl/ToyRawInput_r3.fcl
  fcl/ToyRawInput_r1.fcl
  TEST_PROPERTIES DEPENDS ToyRawInput_w
)

cet_test(ToyRawFileInput_w HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c ToyRawFileInput_w.fcl
  DATAFILES
  fcl/ToyRawFileInput_data.fcl
  fcl/ToyRawFileInput_w.fcl
  fcl/ToyRawInput_w.fcl
  fcl/ToyRawInput_wr_f1.fcl
  fcl/ToyRawInput_common.fcl
)

cet_test(ToyRawFileInput_r1 HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c ToyRawFileInput_r1.fcl
  DATAFILES
  fcl/ToyRawFileInput_r1.fcl
  fcl/ToyRawInput_r1.fcl
  TEST_PROPERTIES DEPENDS ToyRawFileInput_w
)

cet_test(ToyRawFileInput_r2 HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c ToyRawFileInput_r2.fcl
  DATAFILES
  fcl/ToyRawFileInput_r2.fcl
  fcl/ToyRawInput_r2.fcl
  fcl/ToyRawInput_r1.fcl
  TEST_PROPERTIES DEPENDS ToyRawFileInput_w
)

cet_test(ToyRawFileInput_r3 HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c ToyRawFileInput_r3.fcl
  DATAFILES
  fcl/ToyRawFileInput_r3.fcl
  fcl/ToyRawInput_r3.fcl
  fcl/ToyRawInput_r1.fcl
  TEST_PROPERTIES DEPENDS ToyRawFileInput_w
)

cet_test(BareString_w HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c BareString_w.fcl
  DATAFILES
  fcl/BareString_w.fcl
)

cet_test(BareString_r HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c BareString_r.fcl
  DATAFILES
  fcl/BareString_r.fcl
  TEST_PROPERTIES DEPENDS BareString_w
)

cet_test(ValidHandleTester HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c ValidHandleTester.fcl
  DATAFILES
  fcl/ValidHandleTester.fcl
  TEST_PROPERTIES DEPENDS BareString_w
)

# Write the data file required for the other mixing tests.
cet_test(ProductMix_w HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c "ProductMix_w.fcl"
  DATAFILES
  fcl/ProductMix_w.fcl
)

# Mix the events from ProductMix_w, analyzing the results and
# writing an output file.
cet_test(ProductMix_r1 HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
)

# Mix the events from ProductMix_w, testing that things behave properly
# with primary event #2 having no secondaries to mix. No analysis is done
# nor output written.
cet_test(ProductMix_r1a HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1a.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  fcl/ProductMix_r1a.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
)

# Mix the events from ProductMix_w, testing that things behave properly
# with multiple secondary input files (actually, the same file specified
# twice).
cet_test(ProductMix_r1b HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1b.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  fcl/ProductMix_r1b.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
)

# Mix the events from ProductMix_w, testing that things behave properly
# with secondary input file wrapping and no eventsToSkip().
cet_test(ProductMix_r1c1 HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1c.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  fcl/ProductMix_r1c.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
  PASS_REGULAR_EXPRESSION "TrigReport Events total = 400 passed = 400 failed = 0.*MixingInputWrap      -w MixFilterTest[A-Za-z:]*                       1"
)

# Mix the events from ProductMix_w, testing that things behave properly
# with secondary input file wrapping, respondToXXX() functions and
# eventsToSkip().
cet_test(ProductMix_r1c2 HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1c2.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  fcl/ProductMix_r1c.fcl
  fcl/ProductMix_r1c2.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
)

# Mix the events from ProductMix_w, testing that things behave properly
# with secondary input file wrapping and eventsToSkip() const.
cet_test(ProductMix_r1c3 HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1c3.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  fcl/ProductMix_r1c.fcl
  fcl/ProductMix_r1c3.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
)

# Mix the events from ProductMix_w, testing that things behave properly
# with no startEvent function.
cet_test(ProductMix_r1d1 HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1d1.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  fcl/ProductMix_r1d1.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
)

# Mix the events from ProductMix_w, testing that things behave properly
# with an old-signature startEvent function.
cet_test(ProductMix_r1d2 HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1d2.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  fcl/ProductMix_r1d2.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
)

# Mix the events from ProductMix_w, testing that the secondary event
# selection is as specified. Order is:
#   SEQUENTIAL
#   RANDOM_REPLACE
#   RANDOM_LIM_REPLACE (require no dupes within a primary)
#   RANDOM_LIM_REPLACE (require dupes across a job).
#   RANDOM_NO_REPLACE
foreach(test 1 2 3 4 5)
  cet_test(ProductMix_r1e${test} HANDBUILT
    TEST_EXEC art_ut
    TEST_ARGS --rethrow-all -c "ProductMix_r1e${test}.fcl"
    DATAFILES
    fcl/ProductMix_r1.fcl
    fcl/ProductMix_r1e.fcl
    fcl/ProductMix_r1e${test}.fcl
    TEST_PROPERTIES DEPENDS ProductMix_w
    )
endforeach()

# Mix the events from ProductMix_w, obtaining the filenames from a
# detail-object-provided function rather than from fileNames_.
cet_test(ProductMix_r1f1 HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1f1.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  fcl/ProductMix_r1c.fcl
  fcl/ProductMix_r1f1.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
)

# Mix the events from ProductMix_w, testing that things behave properly
# with the compactMissingProducts option selected.
cet_test(ProductMix_r1g HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1g.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  fcl/ProductMix_r1g.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
)


SET_TESTS_PROPERTIES(
  ProductMix_r1c2
  ProductMix_r1c3
  PROPERTIES
  PASS_REGULAR_EXPRESSION "TrigReport Events total = 400 passed = 400 failed = 0.*MixingInputWrap      -w MixFilterTest[A-Za-z:]*                       2"
  )

# Mix the events from ProductMix_w, testing that we correctly detect an
# inappropriate attempt to dereference a Ptr.
cet_test(ProductMix_r1d HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r1d.fcl"
  DATAFILES
  fcl/ProductMix_r1.fcl
  fcl/ProductMix_r1d.fcl
  TEST_PROPERTIES DEPENDS ProductMix_w
)

# Read the output from ProductMix_r1a running the analysis to ensure that
# everything works as read from an output file written post-mixing.
cet_test(ProductMix_r2 HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductMix_r2.fcl"
  DATAFILES
  fcl/ProductMix_r2.fcl
  TEST_PROPERTIES DEPENDS ProductMix_r1
)

cet_test(Ptrmv_w HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "Ptrmv_w.fcl"
  DATAFILES
  fcl/Ptrmv_w.fcl
)

cet_test(Ptrmv_r HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "Ptrmv_r.fcl"
  DATAFILES
  fcl/Ptrmv_r.fcl
  TEST_PROPERTIES DEPENDS Ptrmv_w
)

cet_test(ProductIDGetter_t HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProductIDGetter_t.fcl"
  DATAFILES
  fcl/ProductIDGetter_t.fcl
  )

cet_test(Assns_w HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "Assns_w.fcl"
  DATAFILES
  fcl/Assns_w.fcl
)

foreach(num 1 2 3)
  cet_test(Assns_r${num} HANDBUILT
    TEST_EXEC art_ut
    TEST_ARGS --rethrow-all -c "Assns_r${num}.fcl"
    DATAFILES
    fcl/Assns_r_inc.fcl
    fcl/Assns_r${num}.fcl
    TEST_PROPERTIES DEPENDS Assns_w
    )
endforeach()

cet_test(DeferredIsReadyWithAssns_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all --config "DeferredIsReadyWithAssns_t.fcl"
  DATAFILES
  fcl/DeferredIsReadyWithAssns_t.fcl
  )

# Use the file from Ptrmv_w to test DropOnInput and outputCommand drops.
#
# 1. Drop Ptr, keep base MapVector.
# 2, Keep Ptr, drop base MapVector.
# 3. Drop both.
# 4. Keep both.
foreach(num RANGE 1 4)
  # Test drop on input.
  cet_test(DropOnInput_t_0${num} HANDBUILT
    TEST_EXEC art_ut
    TEST_ARGS --rethrow-all
    -c "DropOnInput_t_0${num}.fcl"
    -s "../Ptrmv_w.d/out.root"
    --output "out.root"
    DATAFILES
    fcl/DropOnInput_t_01.fcl
    fcl/DropOnInput_t_0${num}.fcl
    TEST_PROPERTIES DEPENDS Ptrmv_w
    )

  cet_test(DropOnInput_r_0${num} HANDBUILT
    TEST_EXEC art_ut
    TEST_ARGS --rethrow-all
    -c "DropOnInput_r_0${num}.fcl"
    -s "../DropOnInput_t_0${num}.d/out.root"
    DATAFILES
    fcl/DropOnInput_t_01.fcl
    fcl/DropOnInput_t_0${num}.fcl
    fcl/DropOnInput_r_0${num}.fcl
    TEST_PROPERTIES DEPENDS DropOnInput_t_0${num}
    )

  # Test drop on output with input file.
  cet_test(DropOnOutput_wA_0${num} HANDBUILT
    TEST_EXEC art_ut
    TEST_ARGS --rethrow-all -c "DropOnOutput_wA_0${num}.fcl"
    DATAFILES
    fcl/DropOnOutput_wA_01.fcl
    fcl/DropOnOutput_wA_0${num}.fcl
    TEST_PROPERTIES DEPENDS Ptrmv_w
    )

  cet_test(DropOnOutput_rA_0${num} HANDBUILT
    TEST_EXEC art_ut
    TEST_ARGS --rethrow-all
    -c "DropOnOutput_r_0${num}.fcl"
    -s "../DropOnOutput_wA_0${num}.d/out.root"
    DATAFILES
    fcl/DropOnOutput_r_01.fcl
    fcl/DropOnOutput_r_0${num}.fcl
    TEST_PROPERTIES DEPENDS DropOnOutput_wA_0${num}
    )

  # Test drop on output with in-job generated products.
  cet_test(DropOnOutput_wB_0${num} HANDBUILT
    TEST_EXEC art_ut
    TEST_ARGS --rethrow-all -c "DropOnOutput_wB_0${num}.fcl"
    DATAFILES
    fcl/Ptrmv_w.fcl
    fcl/DropOnOutput_wB_01.fcl
    fcl/DropOnOutput_wB_0${num}.fcl
    )

  cet_test(DropOnOutput_rB_0${num} HANDBUILT
    TEST_EXEC art_ut
    TEST_ARGS --rethrow-all
    -c "DropOnOutput_r_0${num}.fcl"
    -s "../DropOnOutput_wB_0${num}.d/out.root"
    DATAFILES
    fcl/DropOnOutput_r_01.fcl
    fcl/DropOnOutput_r_0${num}.fcl
    TEST_PROPERTIES DEPENDS DropOnOutput_wB_0${num}
    )
endforeach()

# Write a data file containing stored products and stored random number
# states for subsequent tests.
cet_test(RandomNumberTestEventSave_w HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "RandomNumberTestEventSave_w.fcl"
  DATAFILES
  fcl/RandomNumberTestEventSave_w.fcl
)

# Test the ability to restore random number states from data product.
cet_test(RandomNumberTestEventSave_r1 HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "RandomNumberTestEventSave_r.fcl"
  DATAFILES
  fcl/RandomNumberTestEventSave_r.fcl
  TEST_PROPERTIES DEPENDS RandomNumberTestEventSave_w
)

# Test that we get numbers out of sync. when we do *not* restore the
# state from data product
cet_test(RandomNumberTestEventSave_r2 HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "RandomNumberTestEventSave_r2.fcl"
  DATAFILES
  fcl/RandomNumberTestEventSave_r.fcl
  fcl/RandomNumberTestEventSave_r2.fcl
  TEST_PROPERTIES WILL_FAIL true
  DEPENDS RandomNumberTestEventSave_w
)

# Write the state file terminating normally after 9 events.
cet_test(RandomNumberTestFileSave_wA HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "RandomNumberTestFileSave_wA.fcl"
  DATAFILES
  fcl/RandomNumberTestEventSave_r.fcl
  fcl/RandomNumberTestFileSave_wA.fcl
  TEST_PROPERTIES DEPENDS RandomNumberTestEventSave_w
)

# Read the normal-termination state file to process the 10th event.
cet_test(RandomNumberTestFileSave_rA HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "RandomNumberTestFileSave_rA.fcl"
  DATAFILES
  fcl/RandomNumberTestEventSave_r.fcl
  fcl/RandomNumberTestFileSave_rA.fcl
  TEST_PROPERTIES DEPENDS RandomNumberTestFileSave_wA
)

# Write the state file terminating abnormally in event #10.
cet_test(RandomNumberTestFileSave_wB HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "RandomNumberTestFileSave_wB.fcl"
  DATAFILES
  fcl/RandomNumberTestEventSave_r.fcl
  fcl/RandomNumberTestFileSave_wB.fcl
  TEST_PROPERTIES WILL_FAIL true
  DEPENDS RandomNumberTestEventSave_w
)

# Read the abnormal-termination state file to process the 10th event.
cet_test(RandomNumberTestFileSave_rB HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "RandomNumberTestFileSave_rB.fcl"
  DATAFILES
  fcl/RandomNumberTestEventSave_r.fcl
  fcl/RandomNumberTestFileSave_rB.fcl
  TEST_PROPERTIES DEPENDS RandomNumberTestFileSave_wB
)

# Verify the ProvenanceChecker operation with a non-trivial event
# structure.
cet_test(ProvenanceChecker_t HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProvenanceChecker_t.fcl"
  DATAFILES
  fcl/Ptrmv_w.fcl
  fcl/ProvenanceChecker_t.fcl
)

# Test the ProvenanceDumper module template (write and check).
cet_test(ProvenanceDumper_w HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProvenanceDumper_w.fcl"
  DATAFILES
  fcl/FileDumperOutputTest_w.fcl
  fcl/ProvenanceDumper_w.fcl
)

# Test the ProvenanceDumper module template (read and check).
foreach(num 1 2 3 4)
  cet_test(ProvenanceDumper_r${num} HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS --rethrow-all -c "ProvenanceDumper_r${num}.fcl"
  DATAFILES
  fcl/FileDumperOutputTest_r.fcl
  fcl/ProvenanceDumper_r1.fcl
  fcl/ProvenanceDumper_r${num}.fcl # Should be ignored as dup. as appropriate.
  TEST_PROPERTIES DEPENDS ProvenanceDumper_w
  )
endforeach()

cet_test(PtrVectorFastClone_w HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS -c "PtrVectorFastClone_w.fcl"
  DATAFILES
  fcl/PtrVectorFastClone_w.fcl
  TEST_PROPERTIES DEPENDS Ptrmv_w
)

cet_test(AssnsFastClone_w HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS -c "AssnsFastClone_w.fcl"
  DATAFILES
  fcl/AssnsFastClone_w.fcl
  TEST_PROPERTIES DEPENDS Assns_w
)

cet_test(ServiceUsingService_01_t HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS -c "ServiceUsingService_01.fcl"
  DATAFILES
  fcl/ServiceUsingService_01.fcl
)

cet_test(ServiceUsingService_02_t HANDBUILT
  TEST_EXEC art_ut
  TEST_ARGS -c "ServiceUsingService_02.fcl"
  DATAFILES
  fcl/test_reconfig_01.fcl
  fcl/ServiceUsingService_02.fcl
)

cet_test(SimpleMemoryCheck_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS -c simpleMemoryCheck.fcl
  DATAFILES
  fcl/simpleMemoryCheck.fcl
  fcl/messageDefaults.fcl
  )

if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  cet_test(MemoryTracker_t HANDBUILT
    TEST_EXEC art
    TEST_ARGS -c memoryTracker.fcl
    DATAFILES
    fcl/memoryTracker.fcl
    fcl/messageDefaults.fcl
    REF "${CMAKE_CURRENT_SOURCE_DIR}/MemoryTracker_t-ref.txt"
    )
endif()

cet_test(TimingService_issue_2979_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS -c issue_2979.fcl
  DATAFILES
  fcl/issue_2979.fcl
)

cet_test(TimeTracker_issue_3598_t1 HANDBUILT
  TEST_EXEC art
  TEST_ARGS -c issue_3598_t1.fcl
  DATAFILES fcl/issue_3598_t1.fcl
  REF "${CMAKE_CURRENT_SOURCE_DIR}/TimeTracker_issue_3598_t1-ref.txt"
  )

cet_test(TimeTracker_issue_3598_t2 HANDBUILT TEST_EXEC art TEST_ARGS -c issue_3598_t2.fcl DATAFILES fcl/issue_3598_t2.fcl)

cet_test(TimeTracker_issue_3598_t3 HANDBUILT
  TEST_EXEC art
  TEST_ARGS -c issue_3598_t3.fcl
  DATAFILES fcl/issue_3598_t3.fcl
  REF "${CMAKE_CURRENT_SOURCE_DIR}/TimeTracker_issue_3598_t3-ref.txt"
  )

cet_test(SAM_metadata HANDBUILT
  TEST_EXEC art
  TEST_ARGS -c "SAMMetadata_w.fcl"
  --sam-application-family "Ethel"
  --sam-application-version "v0.00.01a"
  --sam-file-type "MC"
  --sam-run-type "MCChallenge"
  --sam-data-tier "The one with the thickest frosting"
  --sam-group "MyGang"
  DATAFILES
  fcl/SAMMetadata_w.fcl
)

set(date_regex "[0-9][0-9][0-9][0-9]-[01][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](,[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])?")

# Pipe the output of sam_metadata_dumper through the following perl
# command to get a suitable regex:
#
# perl -wne 'BEGIN { print "^"; }; chomp; s&([\[\]\.])&\\\\${1}&g; s&\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:,\d{9})?&\${date_regex}&g; s&"&\\"&g; print "$_\\n"; END { print "\$\n"; }'

cet_test(SAM_metadata_verify_hr HANDBUILT
  TEST_EXEC sam_metadata_dumper
  TEST_ARGS -H -s ../SAM_metadata.d/out.root
  TEST_PROPERTIES DEPENDS SAM_metadata
  PASS_REGULAR_EXPRESSION
  "^\nFile catalog metadata from file \\.\\./SAM_metadata\\.d/out\\.root:\n\n 1: applicationFamily   \"Ethel\"\n 2: applicationVersion  \"v0\\.00\\.01a\"\n 3: fileType            \"MC\"\n 4: run_type            \"MCChallenge\"\n 5: group               \"MyGang\"\n 6: process_name        \"SAMMetadataW\"\n 7: testMetadata        \"success!\"\n 8: dataTier            \"The one with the thickest frosting\"\n 9: streamName          \"o1\"\n10: file_format         \"artroot\"\n11: file_format_era     \"ART_2011a\"\n12: file_format_version 6\n13: start_time          \"${date_regex}\"\n14: end_time            \"${date_regex}\"\n15: runs                \\[ \\[ 1, 0, \"MCChallenge\" \\] \\]\n16: event_count         1\n17: first_event         \\[ 1, 0, 1 \\]\n18: last_event          \\[ 1, 0, 1 \\]\n-------------------------------\n$"
  )

cet_test(SAM_metadata_verify_JSON HANDBUILT
  TEST_EXEC sam_metadata_dumper
  TEST_ARGS -s ../SAM_metadata.d/out.root
  TEST_PROPERTIES DEPENDS SAM_metadata
  PASS_REGULAR_EXPRESSION
  "^{\n  \"\\.\\./SAM_metadata\\.d/out\\.root\": {\n    \"applicationFamily\": \"Ethel\",\n    \"applicationVersion\": \"v0\\.00\\.01a\",\n    \"file_type\": \"MC\",\n    \"run_type\": \"MCChallenge\",\n    \"group\": \"MyGang\",\n    \"process_name\": \"SAMMetadataW\",\n    \"testMetadata\": \"success!\",\n    \"data_tier\": \"The one with the thickest frosting\",\n    \"data_stream\": \"o1\",\n    \"file_format\": \"artroot\",\n    \"file_format_era\": \"ART_2011a\",\n    \"file_format_version\": 6,\n    \"start_time\": \"${date_regex}\",\n    \"end_time\": \"${date_regex}\",\n    \"runs\": \\[ \\[ 1, 0, \"MCChallenge\" \\] \\],\n    \"event_count\": 1,\n    \"first_event\": \\[ 1, 0, 1 \\],\n    \"last_event\": \\[ 1, 0, 1 \\]\n  }\n}\n$"
  )

cet_test(GeneratorSource_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS -c "GeneratorSource_t.fcl"
  DATAFILES
  fcl/GeneratorSource_t.fcl
  )

cet_test(FlushingGenerator_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS -c "FlushingGenerator_t.fcl"
  DATAFILES
  fcl/FlushingGenerator_t.fcl
  )

cet_test(BlockingPrescaler_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --config BlockingPrescaler_t.fcl --rethrow-all
  REF "${CMAKE_CURRENT_SOURCE_DIR}/BlockingPrescaler_t-ref.txt"
  DATAFILES
  fcl/BlockingPrescaler_t.fcl
  )

cet_test(test_compressed_simple_01_t.sh HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/test_compressed_simple_01_t.sh
  DATAFILES
  fcl/test_compressed_simple_01.fcl
  fcl/test_compressed_simple_01r.fcl
  fcl/messageDefaults.fcl
)

#-----------------------------------------------------------------------
# SIGNAL HANDLING
cet_test(signal_handling_01_t HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/signal_handling_t.sh
  TEST_ARGS -c signal_sigint.fcl SIGINT
  TEST_PROPERTIES
  PASS_REGULAR_EXPRESSION
  "Art caught and handled signal 2\\."
  DATAFILES
  fcl/signal_sigint.fcl
  )

cet_test(signal_handling_02_t HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/signal_handling_t.sh
  TEST_ARGS -c signal_sigint.fcl SIGQUIT
  TEST_PROPERTIES
  PASS_REGULAR_EXPRESSION
  "Art caught and handled signal 3\\."
  DATAFILES
  fcl/signal_sigint.fcl
  )

cet_test(signal_handling_03_t HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/signal_handling_t.sh
  TEST_ARGS -c signal_sigint.fcl SIGTERM
  TEST_PROPERTIES
  PASS_REGULAR_EXPRESSION
  "Art caught and handled signal 15\\."
  DATAFILES
  fcl/signal_sigint.fcl
  )

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin" )
  set(sigusr_two_signal 31)
else()
  set(sigusr_two_signal 12)
endif()

cet_test(signal_handling_04_t HANDBUILT
  TEST_EXEC ${CMAKE_CURRENT_SOURCE_DIR}/signal_handling_t.sh
  TEST_ARGS -c signal_sigint.fcl SIGUSR2
  TEST_PROPERTIES
  PASS_REGULAR_EXPRESSION
  "Art caught and handled signal ${sigusr_two_signal}\\."
  DATAFILES
  fcl/signal_sigint.fcl
  )

#-----------------------------------------------------------------------
# comment

foreach (num 1 2)
  cet_test(InFlightConfiguration_0${num}_t HANDBUILT
    TEST_EXEC art_ut
    TEST_ARGS --config InFlightConfiguration_0${num}.fcl
    DATAFILES
    fcl/InFlightConfiguration_0${num}.fcl
    )
endforeach()

cet_test(TH1Data_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS -c TH1Data_t.fcl
  DATAFILES
  fcl/TH1Data_t.fcl
  )

cet_test(PostCloseFileRename_Integration HANDBUILT
  TEST_EXEC art
  TEST_ARGS -c PostCloseFileRename_t.fcl
  DATAFILES
  fcl/PostCloseFileRename_t.fcl
)

cet_test(TestAnalyzerSelect HANDBUILT
  TEST_EXEC art
  TEST_ARGS -c "TestAnalyzerSelect.fcl"
  DATAFILES
  fcl/TestAnalyzerSelect.fcl
)

# Issue 5157
cet_test(UnusedModule_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c FilterIgnore_t.fcl
  DATAFILES
  fcl/FilterIgnore_t.fcl
  )

SET_TESTS_PROPERTIES(UnusedModule_t PROPERTIES
  FAIL_REGULAR_EXPRESSION
  "not assigned to any path"
  )

# Issue 5114
cet_test(MissingModuleType_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c MissingModuleType_t.fcl
  TEST_PROPERTIES
  PASS_REGULAR_EXPRESSION
  "ERROR: Configuration of module with label BadModuleConfig encountered the following error:\n"
  DATAFILES
  fcl/MissingModuleType_t.fcl
)

# Issue 5424
cet_test(rename-histfile_t_w HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c rename-histfile_t.fcl
  DATAFILES
  fcl/rename-histfile_t.fcl
)

cet_test(rename-histfile_t_check HANDBUILT
  TEST_EXEC ls
  TEST_ARGS -l ../rename-histfile_t_w.d/test_1_0_2_8.root
  TEST_PROPERTIES DEPENDS rename-histfile_t_w
)

#-----------------------------------------------------------------------
# Metadata
add_library(TestMetadata_plugin SHARED TestMetadata_plugin.cc)
target_link_libraries(TestMetadata_plugin art_Framework_Core FNALCore::FNALCore)
cet_test(TestMetadata_plugin_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c TestMetadata_Plugin_t.fcl
  DATAFILES
  fcl/TestMetadata_Plugin_t.fcl
)

cet_test(TestMetadata_verify_hr HANDBUILT
  TEST_EXEC sam_metadata_dumper
  TEST_ARGS -H -s ../TestMetadata_plugin_t.d/out.root
  TEST_PROPERTIES DEPENDS TestMetadata_plugin_t
  PASS_REGULAR_EXPRESSION
  "^\nFile catalog metadata from file \\.\\./TestMetadata_plugin_t\\.d/out\\.root:\n\n 1: fileType            \"unknown\"\n 2: process_name        \"DEVEL\"\n 3: file_format         \"artroot\"\n 4: file_format_era     \"ART_2011a\"\n 5: file_format_version 6\n 6: start_time          \"${date_regex}\"\n 7: end_time            \"${date_regex}\"\n 8: event_count         1\n 9: first_event         \\[ 1, 0, 1 \\]\n10: last_event          \\[ 1, 0, 1 \\]\n11: key1                \"value1\"\n12: key2                \"value2\"\n-------------------------------\n$"
  )

cet_test(TestMetadata_verify_JSON HANDBUILT
  TEST_EXEC sam_metadata_dumper
  TEST_ARGS -s ../TestMetadata_plugin_t.d/out.root
  TEST_PROPERTIES DEPENDS TestMetadata_plugin_t
  PASS_REGULAR_EXPRESSION
  "^{\n  \"\\.\\./TestMetadata_plugin_t\\.d/out\\.root\": {\n    \"file_type\": \"unknown\",\n    \"process_name\": \"DEVEL\",\n    \"file_format\": \"artroot\",\n    \"file_format_era\": \"ART_2011a\",\n    \"file_format_version\": 6,\n    \"start_time\": \"${date_regex}\",\n    \"end_time\": \"${date_regex}\",\n    \"event_count\": 1,\n    \"first_event\": \\[ 1, 0, 1 \\],\n    \"last_event\": \\[ 1, 0, 1 \\],\n    \"key1\": \"value1\",\n    \"key2\": \"value2\"\n  }\n}\n$"
  )

#-----------------------------------------------------------------------
# TIMESTAMPS
set_source_files_properties(TestEmptyEventTimestampNoRSRTS_plugin.cc
  PROPERTIES COMPILE_DEFINITIONS TEST_USE_LAST_EVENT_TIMESTAMP
)

add_library(TestEmptyEventTimestamp_plugin SHARED TestEmptyEventTimestamp_plugin.cc)
target_link_libraries(TestEmptyEventTimestamp_plugin art_Framework_Core FNALCore::FNALCore)

add_library(TestEmptyEventTimestampNoRSRTS_plugin SHARED TestEmptyEventTimestampNoRSRTS_plugin.cc)
target_link_libraries(TestEmptyEventTimestampNoRSRTS_plugin art_Framework_Core FNALCore::FNALCore)

cet_test(TestEmptyEventTimestamp_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c TestEmptyEventTimestamp_t.fcl
  DATAFILES
  fcl/TestEmptyEventTimestamp_t.fcl
  )

cet_test(TestEmptyEventTimestampNoRSRTS_t HANDBUILT
  TEST_EXEC art
  TEST_ARGS --rethrow-all -c TestEmptyEventTimestampNoRSRTS_t.fcl
  DATAFILES
  fcl/TestEmptyEventTimestamp_t.fcl
  fcl/TestEmptyEventTimestampNoRSRTS_t.fcl
  )

art_add_module(FindManySpeedTestProducer_module FindManySpeedTestProducer_module.cc)
art_add_module(FindManySpeedTestAnalyzer_module FindManySpeedTestAnalyzer_module.cc)

add_subdirectory(event-shape)
add_subdirectory(high-memory)

include(${CMAKE_CURRENT_SOURCE_DIR}/alt-legacy-tests.cmake)
