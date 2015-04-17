cet_test(ntuple_t
  LIBRARIES art_Ntuple art_Utilities ${SQLite3_LIBRARIES}
  )

cet_test(sqlite_stringstream_t
  LIBRARIES art_Ntuple art_Utilities
  )

cet_test( messagefacility_destination_sqlite_t HANDBUILT
  TEST_EXEC FNALCore::ELdestinationTester
  TEST_ARGS sqlite_mfplugin_t.fcl
  DATAFILES
  sqlite_mfplugin_t.fcl
  )

