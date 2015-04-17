link_libraries (art_Framework_IO_RootVersion)
cet_test(GetFileFormatVersion SOURCES test_GetFileFormatVersion.cpp)

foreach (mode M S P)
  cet_test(config_dumper_${mode}_t HANDBUILT
    TEST_EXEC config_dumper
    TEST_ARGS -${mode} ../../../../Integration/Assns_w.d/out.root
    REF "${CMAKE_CURRENT_SOURCE_DIR}/config_dumper_${mode}_t-ref.txt"
    TEST_PROPERTIES
    DEPENDS Assns_w
    REQUIRED_FILES ../../../../Integration/Assns_w.d/out.root
    )
endforeach()

