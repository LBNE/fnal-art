FNAL Art Event Processing Framework
===================================
See the main [FNAL page](https://cdcvs.fnal.gov/redmine/projects/art) for
the authoratative upstream project.

This follow of the upstream project aims to make building Art easier
by removing the dependence on FNAL's custom build tools and configuration
management system. Whilst Art uses the [CMake](http://www.cmake.org)
build tool, the upstream FNAL CMake scripts make calls to the higher level
configuration management system, [ups](https://cdcvs.fnal.gov/redmine/projects/ups). This makes it impossible to build Art without this specific system,
reducing the portability and usefulness of Art. It also prevents use
of any other configuration management system for supplying (for example)
locations of dependencies. Removing the coupling of the buildtool to the
configuration management system does not prevent usage of the latter if
so required. It simply notices that the buildtool is at a lower level than
the configuration management tool, and thus should not call up into the
higher level system.

This specific `remove-ups` branch removes calls to the `ups` system and
wrappings of other FNAL specific tools in the CMake scripts for Art.
It also makes use of the [FNALCore](https://github.com/LBNE/FNALCore)
project to simplify the use of Art's FNAL supplied dependencies.

Installation
============
Requirements
------------
- CMake 2.8.12 or above
- C++11 compliant compiler (GCC 4.8 or better, Clang 3.3 or better)
  - NB: Full list of needed C++11 features not fully determined
  - Usage of FNALCore does not guarantee this
- [FNALCore](https://github.com/LBNE/FNALCore) library
  - Correct installation of this will also provide [Boost](http://www.boost.org)
  - art requires Boost 1.53 or better
- [GCCXML](http://gccxml.github.io/HTML/Index.html) 0.9.0 or higher
- [CLHEP](http://proj-clhep.web.cern.ch/proj-clhep/) 2.2.0.3 or higher
- [SQLite](http://www.sqlite.org/) 3.8.5 or higher
- [ROOT](http://root.cern.ch) 5.34.20 (or better 5 series)
- [Intel TBB](https://www.threadingbuildingblocks.org/) 4.1.0 or higher

**NB**: all C++ libraries must have been compiled against the *same*
C++ standard, specifically 0X or 11, and link to the *same* C++ Standard
Library.

How to Install
--------------
The build of Art provides a standard CMake system, so if you
have all the requirements installed and available directly in CMake's
search path(s), then you can simply do

```
$ mkdir build
$ cd build
$ cmake ..
$ make -j4
$ make install
```

**TODO**: add detail on how to find packages when not in standard locations.


Status
======
- Update sources to upstream art v1.11.3
- No dictionary libraries built yet
- Build of `art_Framework_Principal`
  - Discovered that this makes use of art/Persistency/Common/PtrVector.h
    which uses [ref-qualified](http://en.cppreference.com/w/cpp/language/member_functions) member functions. With GNU compilers, this is only
    supported with GCC 4.8 and higher.
- Build of `art_Framework_Services_Registry`
- Build of `art_Persistency_Common`
- Build of `art_Persistency_Provenance`
- Build of `art_Persistency_RootDB`
- Generate and install minimal CMake support files so that client projects
  can use Art via CMake's `find_package` command.
- Build of `art_Ntuple`
- Build of `art_Utilities`
- Build of `art_Version`
- FindXXX.cmake modules supplied for SQLite, TBB, and CPPUnit.
