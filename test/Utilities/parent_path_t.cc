#define BOOST_TEST_MODULE ( parent_path_t )
#include "boost/test/auto_unit_test.hpp"

#include "art/Utilities/parent_path.h"

BOOST_AUTO_TEST_SUITE(parent_path_t)

BOOST_AUTO_TEST_CASE(parent_path)
{
  BOOST_CHECK_EQUAL(art::parent_path("bar"), ".");
  BOOST_CHECK_EQUAL(art::parent_path("/bar"), "/");
  BOOST_CHECK_EQUAL(art::parent_path("foo/bar"), "foo");
}

BOOST_AUTO_TEST_SUITE_END()
