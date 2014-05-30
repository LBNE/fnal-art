#ifndef art_Framework_Core_PluginMacros_h
#define art_Framework_Core_PluginMacros_h
////////////////////////////////////////////////////////////////////////
// PluginMacros
//
// Define the macros DEFINE_BASIC_PLUGIN and a required component
// DEFINE_BASIC_PLUGIN_MAKER. These are intended for others to use for
// specific plugin types, like art::FileCatalogMetadataPlugin:
/*
#define DEFINE_FILECATALOGMETADATA_PLUGIN(klass) \
  DEFINE_BASIC_PLUGIN(klass,                     \
                      art::FileCatalogMetadata)
*/
//
// See also the definition of DEFINE_BASIC_PLUGINTYPE_FUNC in
// cetlib/PluginTypeDeducer.h.
//
//////////////////////////////////////////////////////////////////////////

#include "cetlib/PluginTypeDeducer.h"
#include "cetlib/make_unique.h"
#include "fhiclcpp/ParameterSet.h"

#include <memory>
#include <string>

#define DEFINE_BASIC_PLUGIN_MAKER(klass, base)    \
  extern "C" {                                    \
    std::unique_ptr<base>                         \
    makePlugin(fhicl::ParameterSet const & pset)  \
    {                                             \
      return cet::make_unique<klass>(pset);       \
    }                                             \
  }

#define DEFINE_BASIC_PLUGIN(klass, base)        \
  DEFINE_BASIC_PLUGIN_MAKER(klass, base)        \
  DEFINE_BASIC_PLUGINTYPE_FUNC(base)

#endif /* art_Framework_Core_PluginMacros_h */

// Local Variables:
// mode: c++
// End:
