IF (CETBUILDTOOLS_VERSION)

# project name
project(art_Framework_Modules)

simple_plugin(BlockingPrescaler       "module")
simple_plugin(EmptyEvent              "source")
simple_plugin(FileDumperOutput        "module")
simple_plugin(Prescaler               "module")
simple_plugin(ProvenanceCheckerOutput "module")
simple_plugin(RandomNumberSaver       "module")

art_dictionary(DICTIONARY_LIBRARIES art_Persistency_Common)

install_headers()
install_source()

ELSE()

# - Build art_Framework_Modules modules

# - BlockingPrescaler
add_library(art_Framework_Modules_BlockingPrescaler_module SHARED
  BlockingPrescaler_module.cc
  )
target_link_libraries(art_Framework_Modules_BlockingPrescaler_module
  art_Framework_Core
  art_Framework_Principal
  art_Persistency_Common
  art_Persistency_Provenance
  art_Utilities
  FNALCore::FNALCore
  )

# - EmptyEvent
add_library(art_Framework_Modules_EmptyEvent_source SHARED
  EmptyEvent_source.cc
  )
target_link_libraries(art_Framework_Modules_EmptyEvent_source
  art_Framework_Core
  art_Framework_Principal
  art_Persistency_Common
  art_Persistency_Provenance
  art_Utilities
  FNALCore::FNALCore
  )

# - FileDumperOutput
add_library(art_Framework_Modules_FileDumperOutput_module SHARED
  FileDumperOutput_module.cc
  )
target_link_libraries(art_Framework_Modules_FileDumperOutput_module
  art_Framework_Core
  art_Framework_Principal
  art_Persistency_Common
  art_Persistency_Provenance
  art_Utilities
  FNALCore::FNALCore
  )

# - Prescaler
add_library(art_Framework_Modules_Prescaler_module SHARED
  Prescaler_module.cc
  )
target_link_libraries(art_Framework_Modules_Prescaler_module
  art_Framework_Core
  art_Framework_Principal
  art_Persistency_Common
  art_Persistency_Provenance
  art_Utilities
  FNALCore::FNALCore
  )

# - ProvenanceCheckerOutput
add_library(art_Framework_Modules_ProvenanceCheckerOutput_module SHARED
  ProvenanceCheckerOutput_module.cc
  )
target_link_libraries(art_Framework_Modules_ProvenanceCheckerOutput_module
  art_Framework_Core
  art_Framework_Principal
  art_Persistency_Common
  art_Persistency_Provenance
  art_Utilities
  FNALCore::FNALCore
  )

# - RandomNumberSaver
add_library(art_Framework_Modules_RandomNumberSaver_module SHARED
  RandomNumberSaver_module.cc
  )
target_link_libraries(art_Framework_Modules_RandomNumberSaver_module
  art_Framework_Core
  art_Framework_Principal
  art_Persistency_Common
  art_Persistency_Provenance
  art_Utilities
  FNALCore::FNALCore
  )

# - Set properties
set_target_properties(
  art_Framework_Modules_BlockingPrescaler_module
  art_Framework_Modules_EmptyEvent_source
  art_Framework_Modules_FileDumperOutput_module
  art_Framework_Modules_Prescaler_module
  art_Framework_Modules_ProvenanceCheckerOutput_module
  art_Framework_Modules_RandomNumberSaver_module
  PROPERTIES
   VERSION ${art_VERSION}
   SOVERSION ${art_SOVERSION}
  )

# - Dictify
art_add_dictionary(DICTIONARY_LIBRARIES art_Persistency_Common)

# - Install targets, files
install(TARGETS
  art_Framework_Modules_BlockingPrescaler_module
  art_Framework_Modules_EmptyEvent_source
  art_Framework_Modules_FileDumperOutput_module
  art_Framework_Modules_Prescaler_module
  art_Framework_Modules_ProvenanceCheckerOutput_module
  art_Framework_Modules_RandomNumberSaver_module
  art_Framework_Modules_dict
  art_Framework_Modules_map
  EXPORT ArtLibraries
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT Runtime
  )
install(FILES MixFilter.h ProvenanceDumper.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/art/Framework/Modules
  COMPONENT Development
  )

ENDIF()
