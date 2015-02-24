IF (CETBUILDTOOLS_VERSION)

include(BuildPlugins)

art_make(
  art_Ntuple
  LIB_LIBRARIES
  art_Utilities
  ${SQLITE3}
  EXCLUDE sqlite_mfPlugin.cc
  )

simple_plugin( sqlite mfPlugin
               art_Ntuple
               ${SQLITE3}
               ${MF_MESSAGELOGGER}
               ${MF_UTILITIES}
               ${FHICLCPP}
               ${CETLIB}
               )

install_headers()
install_source()

ELSE()

# - Build art_Ntuple libray
# Define headers
set(art_Ntuple_HEADERS
  Ntuple.h
  sqlite_helpers.h
  Transaction.h
  )

# Describe library
add_library(art_Ntuple SHARED ${art_Ntuple_HEADERS} Transaction.cc)

# Describe library include interface
target_include_directories(art_Ntuple
  PUBLIC
   ${SQLite3_INCLUDE_DIRS}
   ${FNALCore_INCLUDE_DIRS}
   )

# Describe library link interface
target_link_libraries(art_Ntuple ${SQLite3_LIBRARIES})

# Set any additional properties
set_target_properties(art_Ntuple
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Ntuple
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Ntuple_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Ntuple
  COMPONENT Development
  )

ENDIF()
