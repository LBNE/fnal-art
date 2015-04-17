
# - Build art_Persistency_RootDB lib
# Define headers
set(art_Persistency_RootDB_HEADERS
  MetaDataAccess.h
  SQLErrMsg.h
  SQLite3Wrapper.h
  tkeyvfs.h
  )

# Describe library
add_library(art_Persistency_RootDB SHARED
  ${art_Persistency_RootDB_HEADERS}
  MetaDataAccess.cc
  SQLErrMsg.cc
  SQLite3Wrapper.cc
  tkeyvfs.cc
  )

# Describe library include interface
target_include_directories(art_Persistency_RootDB
  PUBLIC
   ${ROOT_INCLUDE_DIRS}
   ${SQLite3_INCLUDE_DIRS}
   )

# Describe library link interface - all Public for now
target_link_libraries(art_Persistency_RootDB
  ${ROOT_Core_LIBRARY}
  ${ROOT_RIO_LIBRARY}
  art_Utilities
  ${SQLite3_LIBRARIES}
  )

# Set any additional properties
set_target_properties(art_Persistency_RootDB
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

install(TARGETS art_Persistency_RootDB
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Persistency_RootDB_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Persistency/RootDB
  COMPONENT Development
  )

