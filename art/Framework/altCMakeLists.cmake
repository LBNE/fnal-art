#-----------------------------------------------------------------------
# Art - builds:
# - art_Framework_Art library
#   - links to (list internal only)
#     - art_Framework_IO_Root
#     - art_Framework_EventProcessor
#     - art_Framework_Core
#     - art_Framework_Services_Registry
#     - art_Persistency_Common
#     - art_Persistency_Provenance
#     - art_Utilities
# - Various art execs
#   - art ones link to art_Framework_Art
#   - `check_libs` links to art_Utilities
#
add_subdirectory(Art)

#-----------------------------------------------------------------------
# Core - builds
# - art_Framework_Core (probably, check what `art_make` does again...
#   looks like there are no plugins, so probably just lib and dict)
#   - links to (internal list only)
#     - art_Framework_Services_System_CurrentModule_service
#     - art_Framework_Services_System_TriggerNamesService_service
#     - art_Framework_Services_Optional_RandomNumberGenerator_service
#     - art_Framework_Principal
#     - art_Persistency_Common
#     - art_Persistency_Provenance
#     - art_Framework_Services_Registry
#     - art_Utilities
#     - art_Version
#
add_subdirectory(Core)

#-----------------------------------------------------------------------
# EventProcessor - builds
# - art_Framework_EventProcessor (probably)
#   - links to (internal list only)
#     - art_Framework_Services_System_CurrentModule_service
#     - art_Framework_Services_System_FileCatalogMetadata_service
#     - art_Framework_Services_System_FloatingPointControl_service
#     - art_Framework_Services_System_PathSelection_service
#     - art_Framework_Services_System_ScheduleContext_service
#     - art_Framework_Services_System_TriggerNamesService_service
#     - art_Framework_Core
#     - art_Utilities
#
add_subdirectory(EventProcessor)

#-----------------------------------------------------------------------
# IO - builds
# - art_Framework_IO (probably)
#   - links to (internal list only)
#     - art_Persistency_Provenance
# - (subdir) art_Framework_IO_Catalog
#   - links to
#     - art_Framework_Services_Optional_TrivialFileDelivery_service
#     - art_Framework_Services_Optional_TrivialFileTransfer_service
#     - art_Utilities
# - (subdir) art_Framework_IO_ProductMix
#   - links to
#     - art_Framework_IO_Root
#     - art_Framework_Services_System_CurrentModule_service
#     - art_Framework_Services_System_TriggerNamesService_service
#     - art_Framework_Services_Optional_RandomNumberGenerator_service
#     - art_Framework_Core
#     - art_Framework_Principal
#     - art_Framework_Services_Registry
#     - art_Persistency_Common
#     - art_Persistency_Provenance
#     - art_Utilities
# - (subdir) art_Framework_IO_Root
#   - links to
#     - art_Framework_Core
#     - art_Framework_IO
#     - art_Framework_IO_Catalog
#     - art_Framework_Principal
#     - art_Framework_Services_Registry
#     - art_Persistency_Common
#     - art_Persistency_Provenance
#     - art_Framework_IO_RootVersion
#   - alsobuilds
#     - art_Framework_IO_RootVersion (lib)
#     - RootInput (source plugin)
#     - RootOutput (output plugin)
#     - config_dumper (exe)
#       - links to
#         - art_Framework_IO_Root
#         - art_Utilities
#         - art_Framework_Core
#     - sam_metadata_dumper
#       - links to
#         - art_Framework_IO_Root
#         - art_Utilities
#         - art_Framework_Core
# - (subdir) art_Framework_IO_Sources
#   - links to
#     - art_Framework_Services_FileServiceInterfaces
#     - art_Framework_Services_Registry
#     - art_Framework_Principal
#     - art_Persistency_Common
#     - art_Persistency_Provenance
#     - art_Utilities
#
add_subdirectory(IO)

#-----------------------------------------------------------------------
# Modules - builds
# - BlockingPrescaler       (module plugin)
# - EmptyEvent              (source plugin)
# - FileDumperOutput        (module plugin)
# - Prescaler               (module plugin)
# - ProvenanceCheckerOutput (module plugin)
# - RandomNumberSaver       (module plugin)
#
add_subdirectory(Modules)

#-----------------------------------------------------------------------
# Principal - (BUILT)
# - art_Framework_Principal
#   - links to
#     - art_Persistency_Provenance
#     - art_Persistency_Common
#     - art_Framework_Services_Registry
#     - art_Utilities
#     - art_Version
#
add_subdirectory(Principal)

#-----------------------------------------------------------------------
# Services - builds
# - (subdir) art_Framework_Services_Registry (BUILT)
#   - links to
#     - art_Utilities
# - (subdir) art_Framework_Services_FileServiceInterfaces (BUILT)
#   - links to
#     - art_Framework_Services_Registry
# - (subdir) art_Framework_Services_Optional
#   - only links externally
#   - alsobuilds
#     - RandomNumberGenerator (service plugin)
#       - links to
#         - art_Framework_Principal
#         - art_Persistency_Common
#     - SimpleInteraction (service plugin)
#       - links to
#         - art_Framework_Services_UserInteraction
#     - SimpleMemoryCheck (service plugin)
#       - links to
#         - art_Persistency_Provenance
#     - TFileService (service plugin)
#       - links to
#         - art_Framework_Services_System_TriggerNamesService_service
#         - art_Framework_Services_Optional
#         - art_Framework_IO
#         - art_Framework_Principal
#     - Timing (service plugin)
#       - links to
#         - art_Persistency_Provenance
#     - Tracer (service plugin)
#       - links to
#         - art_Persistency_Provenance
#     - TrivialFileDelivery (service plugin)
#     - TrivialFileTransfer (service plugin)
# - (subdir) System (all service plugins)
#   - CurrentModule -> art_Persistency_Provenance (BUILT)
#   - FileCatalogMetadata (BUILT)
#   - FloatingPointControl (BUILT)
#   - PathSelection -> art_Framework_Core
#   - ScheduleContext -> art_Framework_Core
#   - TriggerNameService (BUILT)
# - (subdir) art_Framework_Services_UserInteraction
#   - links to
#     - art_Framework_Core
#     - art_Framework_Principal
#     - art_Persistency_Provenance
#     - art_Framework_Services_Registry
#
add_subdirectory(Services)
