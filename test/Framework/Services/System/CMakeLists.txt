IF (CETBUILDTOOLS_VERSION)
cet_test(ScheduleContext_t
  LIBRARIES
  art_Framework_Services_System_ScheduleContext_service
  art_Framework_Services_Registry
  art_Utilities
  ${TBB}
  )
ELSE()
cet_test(ScheduleContext_t
  LIBRARIES
  art_Framework_Services_System_ScheduleContext_service
  art_Framework_Services_Registry
  art_Utilities
  ${TBB_LIBRARIES}
  )
ENDIF()
