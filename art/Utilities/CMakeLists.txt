art_make(LIB_LIBRARIES
  MF_MessageLogger
  MF_Utilities
  fhiclcpp
  cetlib
  ${Boost_FILESYSTEM_LIBRARY}
  ${Boost_REGEX_LIBRARY}
  ${Boost_SYSTEM_LIBRARY}
  ${Boost_THREAD_LIBRARY}
  ${ROOT_CINT}
  ${ROOT_REFLEX}
  -lpthread
  -ldl
  SUBDIRS detail
  )

install_headers(SUBDIRS detail)
install_source(SUBDIRS detail)
