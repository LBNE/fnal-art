#ifndef art_Framework_Art_BasicOptionsHandler_h
#define art_Framework_Art_BasicOptionsHandler_h

// Handle the basic options, like config, help, process-name.

namespace art {
  class BasicOptionsHandler;
}

#include "art/Framework/Art/OptionsHandler.h"
#include "cetlib/filepath_maker.h"

#include <string>

class art::BasicOptionsHandler : public art::OptionsHandler {
public:
  BasicOptionsHandler(bpo::options_description & desc,
                      cet::filepath_maker & maker);
private:
  // Check selected options for consistency.
  int doCheckOptions(bpo::variables_map const & vm);
  // Act on selected options.
  int doProcessOptions(bpo::variables_map const & vm,
                       fhicl::intermediate_table & raw_config);

  // Data.
  bpo::options_description const & help_desc_;
  cet::filepath_maker & maker_;
};
#endif /* art_Framework_Art_BasicOptionsHandler_h */

// Local Variables:
// mode: c++
// End:
