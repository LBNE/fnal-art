art_add_dictionary()

set(default_test_libraries
  art_Framework_Core
  art_Framework_Principal
  art_Utilities
  ${Boost_FILESYSTEM_LIBRARY}
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
  )

cet_test(eventprincipal_t USE_BOOST_UNIT
  LIBRARIES ${default_test_libraries}
  )
cet_test(Event_t USE_BOOST_UNIT
  LIBRARIES ${default_test_libraries}
  )
cet_test(GroupFactory_t
  USE_BOOST_UNIT
  LIBRARIES ${default_test_libraries}
  )

