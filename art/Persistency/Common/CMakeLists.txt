IF (CETBUILDTOOLS_VERSION)

# project name
project(art_Persistency_Common)

set(art_Persistency_Common_sources
  CacheStreamers.cc
  DelayedReader.cc
  EDProduct.cc
  GroupQueryResult.cc
  PtrVectorBase.cc
  RNGsnapshot.cc
  RefCore.cc
  detail/maybeCastObj.cc
  detail/setPtrVectorBaseStreamer.cc
  traits.cc
)

set( art_Persistency_Common_libraries 
	art_Persistency_Provenance
	art_Utilities
	${ROOT_CORE}
	${Boost_THREAD_LIBRARY}
	)

art_make_library( LIBRARY_NAME art_Persistency_Common
                  SOURCE ${art_Persistency_Common_sources}
		  LIBRARIES ${art_Persistency_Common_libraries}
		 )

art_dictionary(DICTIONARY_LIBRARIES art_Persistency_Common)

install_headers(SUBDIRS detail)
install_source(SUBDIRS detail)

ELSE()

# - Build art_Persistency_Common lib
# Define headers
set(art_Persistency_Common_HEADERS
  Assns.h
  BoolCache.h
  CacheStreamers.h
  CollectionUtilities.h
  ConstPtrCache.h
  debugging_allocator.h
  DelayedReader.h
  EDProductGetter.h
  EDProduct.h
  fwd.h
  getElementAddresses.h
  GetProduct.h
  GroupQueryResult.h
  HLTenums.h
  HLTGlobalStatus.h
  HLTPathStatus.h
  PostReadFixupTrait.h
  Ptr.h
  PtrVectorBase.h
  PtrVector.h
  RefCore.h
  RNGsnapshot.h
  setPtr.h
  traits.h
  TriggerResults.h
  Wrapper.h
  )

set(art_Persistency_Common_DETAIL_HEADERS
  detail/maybeCastObj.h
  detail/setPtrVectorBaseStreamer.h
  )

# Describe library
add_library(art_Persistency_Common SHARED
  ${art_Persistency_Common_HEADERS}
  ${art_Persistency_Common_DETAIL_HEADERS}
  CacheStreamers.cc
  DelayedReader.cc
  EDProduct.cc
  GroupQueryResult.cc
  PtrVectorBase.cc
  RefCore.cc
  RNGsnapshot.cc
  traits.cc
  detail/maybeCastObj.cc
  detail/setPtrVectorBaseStreamer.cc
  )

# Describe library include interface
#target_include_directories(art_Persistency_Common
#  PUBLIC
#   ${ROOT_INCLUDE_DIRS}
#   ${BOOST_INCLUDE_DIRS}
#   )

# Describe library link interface
target_link_libraries(art_Persistency_Common
  PUBLIC
  FNALCore::FNALCore
  art_Utilities
  art_Persistency_Provenance
  ${ROOT_Core_LIBRARY}
  )

# Set any additional properties
set_target_properties(art_Persistency_Common
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

# - Dictify
art_add_dictionary(DICTIONARY_LIBRARIES art_Persistency_Common)

install(TARGETS art_Persistency_Common art_Persistency_Common_dict art_Persistency_Common_map
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES ${art_Persistency_Common_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Persistency/Common
  COMPONENT Development
  )
install(FILES ${art_Persistency_Common_DETAIL_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Persistency/Common/detail
  COMPONENT Development
  )

ENDIF()
