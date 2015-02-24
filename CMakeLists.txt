# ======================================================================
#  art main build file
#
#  cd .../path/to/build/directory
#  source .../path/to/art/ups/setup_for_development
#  cmake [-DCMAKE_INSTALL_PREFIX=/install/path]
#        -DCMAKE_BUILD_TYPE=$CETPKG_TYPE
#        $CETPKG_SOURCE
#  make
#  make test
#  make install
#  make package (builds distribution tarfile)
# ======================================================================


# use cmake 2.8 or later
cmake_minimum_required (VERSION 2.8)

project(art)

# cetbuildtools contains our cmake modules
SET ( CETBUILDTOOLS_VERSION $ENV{CETBUILDTOOLS_VERSION} )
IF (CETBUILDTOOLS_VERSION)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/Modules 
                      $ENV{CETBUILDTOOLS_DIR}/Modules 
		      ${CMAKE_MODULE_PATH})

include(CetCMakeEnv)
cet_cmake_env()

cet_set_compiler_flags(DIAGS VIGILANT
  WERROR
  NO_UNDEFINED
  EXTRA_FLAGS -pedantic
  )
cet_have_qual(sse2 SSE2)
if ( SSE2 )
  cet_add_compiler_flags(CXX -msse2 -ftree-vectorizer-verbose=2)
endif()

cet_report_compiler_flags()

# these are minimum required versions, not the actual product versions
find_ups_product( cppunit v1_12_1a )
find_ups_product( gccxml v0_9_20140718a )
find_ups_product( clhep v2_2_0_3 )
find_ups_product (cetbuildtools v4_07_03)
find_ups_product( cetpkgsupport v1_08_03 )
find_ups_product( cetlib v1_08_00 )
find_ups_product( fhiclcpp v3_02_00 )
find_ups_product( messagefacility v1_14_00 )
find_ups_product( sqlite v3_08_05_00 )
find_ups_root( v5_34_20 )
find_ups_product( tbb v4_1 )
find_ups_boost(v1_53_0)


# define CLHEP
cet_find_library( CLHEP  NAMES CLHEP   PATHS ENV CLHEP_LIB_DIR NO_DEFAULT_PATH )

# define cppunit
cet_find_library( CPPUNIT NAMES cppunit   PATHS ENV CPPUNIT_LIB   NO_DEFAULT_PATH )

# macros for art_dictionary and simple_plugin
include(ArtDictionary)
include(BuildPlugins)

# tools (first)
add_subdirectory(tools)

# source
add_subdirectory (art)

# testing
add_subdirectory(test)

# ups - table and config files
add_subdirectory(ups)

# CMake modules
add_subdirectory(Modules)

# packaging utility
include(UseCPack)

ELSE()

# - Art top level build
# Project setup
# Require 2.8.12 to:
# - get new interface export features
# - target ALIAS
cmake_minimum_required(VERSION 2.8.12)

# - Policies - set all here as may influence project() call
# Always id Clang as Clang, defer use of AppleClang id
if(POLICY CMP0025)
  cmake_policy(SET CMP0025 OLD)
endif()

# Always use rpath on Mac, as it's supported in out min version, and
# CMake 3 and higher prefer it
if(POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif()

project(art)

#-----------------------------------------------------------------------
# API and ABI versioning
# NB - this only demonstrates that it *can* be done
# More info on this at:
# - http://public.kitware.com/Bug/view.php?id=4383
# - http://techbase.kde.org/Policies/Binary_Compatibility_Issues_With_C++
#
# The following numbers are *arbitrary* for now. Remember that
# VERSION and SOVERSION do not neccessarily evolve in sync
# - Hard code version plus splits (derive one from t'other later)
set(art_VERSION "1.11.3")
set(art_VERSION_MAJOR 1)
set(art_VERSION_MINOR 11)
set(art_VERSION_PATCH 3)

set(art_SOVERSION "1.0.0")

# - We can also use a postfix to distinguish the debug lib from
# others if different build modes are ABI incompatible (can be
# extended to other modes)
set(art_DEBUG_POSTFIX "d")

#-----------------------------------------------------------------------
# Standard and Custom CMake Modules
#
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_CURRENT_LIST_DIR}/Modules)

# - Standard Support
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)
include(CheckCXXCompilerFlag)

# - Local Customs
include(artInternalTools)
include(artTools)
include(ArtDictionary)

# - Build product locations
# The variables CMAKE_{RUNTIME,LIBRARY,ARCHIVE}_OUTPUT_DIRECTORY can
# be used to specify where executables, dynamic and static libraries
# are output. They initialize the {RUNTIME,LIBRARY,ARCHIVE}_OUTPUT_DIRECTORY
# properties of targets added via add_{executable,target}, so can
# targets can override if need be.
#
# - Assume for now that GNUInstallDirs provides relative (to
#   CMAKE_INSTALL_PREFIX) paths, and reflect this layout in the
#   output directories. This should be o.k. even on DLL platforms
#   as CMake should output these to the RUNTIME directory.
#
set(BASE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/BuildProducts")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${BASE_OUTPUT_DIRECTORY}/${CMAKE_INSTALL_BINDIR}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${BASE_OUTPUT_DIRECTORY}/${CMAKE_INSTALL_LIBDIR}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${BASE_OUTPUT_DIRECTORY}/${CMAKE_INSTALL_LIBDIR}")

# Implement SSE2 as option?
#cet_have_qual(sse2 SSE2)
#if ( SSE2 )
#  cet_add_compiler_flags(CXX -msse2 -ftree-vectorizer-verbose=2)
#endif()

# Use an imported target for checkClassVersion to give transparency
# between art build and client usage.
# This *is* a little messy, but eases the writing of the scripts for
# full portability between the art build and clients.
# We set it up *here* because we need to append the library output
# directory to checkClassVersion's search path.
add_executable(art::checkClassVersion IMPORTED)
set_target_properties(art::checkClassVersion PROPERTIES IMPORTED_LOCATION
  ${CMAKE_CURRENT_SOURCE_DIR}/tools/checkClassVersion
  )
checkclassversion_append_path(${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

#-----------------------------------------------------------------------
# Required Third Party Packages
# - Core library(ies), which will supply us with Boost
# For now use FNALCore, easy switch out to multi modules later if needed
find_package(FNALCore 0.1.0 REQUIRED)

# We need a minimum version of Boost, but rely on FNALCore to supply this
# to use. So check our found FNALCore provides a suitable version
set(art_MIN_BOOST_VERSION "1.53.0")

if(FNALCore_BOOST_VERSION VERSION_LESS art_MIN_BOOST_VERSION)
  message(FATAL_ERROR "Located version of FNALCore compiled against Boost ${FNALCore_BOOST_VERSION}\nart requires Boost >= ${art_MIN_BOOST_VERSION}")
endif()

# - Ensure we can refind Boost and extra components we need
find_package(Boost ${art_MIN_BOOST_VERSION}
  REQUIRED
    date_time
    unit_test_framework
    program_options
  )

# FNALCore provides an interface to the C++ standard, so use its flags
# Could also check for compiler/stdlib compatiblity.
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FNALCore_CXX_FLAGS}")

# - Needs review and implementation where required (though should
# be off-the-shelf FindX for most)
# Other issues - could ROOT supply some of these, e.g. sqlite3
# gccxml, tbb?
# Need to implement

# Is supplied by CMake, but no version checking, so need to check
# Also, this is only used "behind the scenes" via ROOT's genreflex script
# never directly, so strictly speaking it's ROOT's responsibility
# to handle this for us.
find_package(GCCXML 0.9.0 REQUIRED)

# CLHEP supplies a CMake project config...
find_package(CLHEP 2.2.0.3 REQUIRED)

# SQLite3 - NB FNALCore also depends on and exposes this...
find_package(SQLite3 3.8.5 REQUIRED)

# Cross check with what ROOT supply - ideally would like component
# based checks.
find_package(ROOT 5.34.20 REQUIRED
  Core
  Cint
  Cintex
  Hist
  Matrix
  Reflex
  RIO
  Thread
  Tree
  )
# - Must have Python support - it doesn't work as a COMPONENT
# argument to find_package because Root's component lookup only
# works for libraries.
if(NOT ROOT_python_FOUND)
  message(FATAL_ERROR "art requires ROOT with Python support")
endif()

# Need to implement
find_package(TBB 4.1.0 REQUIRED)

#-----------------------------------------------------------------------
# Set up paths for all subbuilds
#
include_directories(${PROJECT_SOURCE_DIR})
include_directories(${PROJECT_BINARY_DIR})

# tools (first)
add_subdirectory(tools)

# source
add_subdirectory(art)

# testing
option(art_ENABLE_TESTING "Built unit tests for art" OFF)
if(art_ENABLE_TESTING)
  # cppunit *only* needed for testing
  enable_testing()
  find_package(CppUnit 1.12.1 REQUIRED)
  add_subdirectory(test)
endif()

#-----------------------------------------------------------------------
# Documentation
#
option(art_BUILD_DOCS "Build documentation for Art" ON)
if(art_BUILD_DOCS)
  add_subdirectory(doc)
endif()

#-----------------------------------------------------------------------
# Install support files - usage from install tree only...
#
configure_package_config_file(
  Modules/artConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/artConfig.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/art-${art_VERSION}
  PATH_VARS
    CMAKE_INSTALL_INCLUDEDIR
    CMAKE_INSTALL_LIBDIR
    CMAKE_INSTALL_BINDIR
  )

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/artConfigVersion.cmake
  VERSION ${art_VERSION}
  COMPATIBILITY AnyNewerVersion
  )

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/artConfig.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/artConfigVersion.cmake
  Modules/ArtDictionary.cmake
  Modules/BuildDictionary.cmake
  Modules/CheckClassVersion.cmake
  Modules/artTools.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/art-${art_VERSION}
  COMPONENT Development
  )

install(EXPORT ArtLibraries
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/art-${art_VERSION}
  NAMESPACE art::
  COMPONENT Development
  )

#-----------------------------------------------------------------------
# Package for Source and Binary
#
include(ArtCPack)
ENDIF()
