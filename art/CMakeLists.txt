IF (CETBUILDTOOLS_VERSION)

# project name
project(artCode)

include(ArtMake)

# cmake will automatically order the library builds according to declared dependencies
add_subdirectory (Version)
add_subdirectory (Utilities)
add_subdirectory (Framework)
add_subdirectory (Persistency)
add_subdirectory (Ntuple)

ELSE()

add_subdirectory(Version)
add_subdirectory(Utilities)
add_subdirectory(Framework)
add_subdirectory(Persistency)
add_subdirectory(Ntuple)

ENDIF()

