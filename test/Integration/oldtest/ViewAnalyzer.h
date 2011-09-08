#ifndef test_Integration_oldtest_ViewAnalyzer_h
#define test_Integration_oldtest_ViewAnalyzer_h

#include <string>

#include "art/Framework/Core/Frameworkfwd.h"
#include "art/Framework/Core/EDAnalyzer.h"

namespace arttest
{

  class ViewAnalyzer : public art::EDAnalyzer
  {
  public:
    explicit ViewAnalyzer(fhicl::ParameterSet const& /* no parameters*/);
    virtual ~ViewAnalyzer();
    virtual void analyze(art::Event const& e,
			 art::EventSetup const& /* unused */ );

    template <class P, class V>
    void testProduct(art::Event const& e,
		     std::string const& moduleLabel) const;

    void testDSVProduct(art::Event const& e,
			std::string const& moduleLabel) const;

    void testProductWithBaseClass(art::Event const& e,
 			          std::string const& moduleLabel) const;

    void testRefVector(art::Event const& e,
		       std::string const& moduleLabel) const;

    void testRefToBaseVector(art::Event const& e,
			     std::string const& moduleLabel) const;
  };

}

#endif /* test_Integration_oldtest_ViewAnalyzer_h */

// Local Variables:
// mode: c++
// End: