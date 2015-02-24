IF (CETBUILDTOOLS_VERSION)

# build art_Framework_Services libraries
add_subdirectory (FileServiceInterfaces)
add_subdirectory (Optional)
add_subdirectory (Registry)
add_subdirectory (System)
add_subdirectory (UserInteraction)

ELSE()

# build art_Framework_Services libraries
add_subdirectory(FileServiceInterfaces)
add_subdirectory(Optional)
add_subdirectory(Registry)
add_subdirectory(System)
add_subdirectory(UserInteraction)

ENDIF()
