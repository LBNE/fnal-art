IF (CETBUILDTOOLS_VERSION)

# project name
project(Persistency)

# build Persistency libraries
add_subdirectory (CLHEPDictionaries)
add_subdirectory (Common)
add_subdirectory (Provenance)
add_subdirectory (RootDB)
add_subdirectory (StdDictionaries)
add_subdirectory (WrappedStdDictionaries)
add_subdirectory (CetlibDictionaries)
add_subdirectory (FhiclCppDictionaries)

ELSE()

# build Persistency libraries
#add_subdirectory (CLHEPDictionaries)
add_subdirectory(Common)
add_subdirectory(Provenance)
add_subdirectory(RootDB)
add_subdirectory(StdDictionaries)
add_subdirectory(WrappedStdDictionaries)
add_subdirectory(CetlibDictionaries)
add_subdirectory(FhiclCppDictionaries)

ENDIF()
