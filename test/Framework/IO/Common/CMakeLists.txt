if (ALT_CMAKE) 
include(altCMakeLists.cmake)
else()
project(IORootCommonTest)

set( cpp_files TestEdmFastMerge.cpp )

link_libraries( IORootCommon
                DataFormatsProvenance
                FWCoreUtilities
		FWCoreServiceRegistry
		${ROOT_MATRIX} )

add_executable( TestEdmFastMerge TestEdmFastMerge.cpp )
add_test( TestEdmFastMerge ${EXECUTABLE_OUTPUT_PATH}/TestEdmFastMerge )
endif()
