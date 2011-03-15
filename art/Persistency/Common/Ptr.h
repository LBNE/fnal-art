#ifndef art_Persistency_Common_Ptr_h
#define art_Persistency_Common_Ptr_h

// ======================================================================
//
// Ptr: Persistent 'pointer' to an item in a collection where the
//      collection is in the art::Event
//
// ======================================================================
#include <cstddef> // for std::size_t
#include <list>
#include <vector>

#include "art/Persistency/Common/EDProduct.h"
#include "art/Persistency/Common/EDProductGetter.h"
#include "art/Persistency/Common/GetProduct.h"
#include "art/Persistency/Common/Handle.h"
#include "art/Persistency/Common/OrphanHandle.h"
#include "art/Persistency/Common/RefCore.h"
#include "art/Persistency/Common/traits.h"
#include "art/Utilities/Exception.h"
#include "boost/type_traits/is_base_of.hpp"
#include "boost/utility/enable_if.hpp"

namespace art
{
  template <typename T>
  class Ptr
  {
    friend class PtrVectorBase;
  public:

    typedef std::size_t   key_type;
    typedef T             value_type;

    // Create a Ptr<T> to a specific element within a collection of type
    // C. The collection is identified by 'handle', and the element in
    // the collection is identified by the index 'idx'.
    template <typename C>
    Ptr(Handle<C> const& handle, key_type idx, bool setNow=true);

    // An OrphanHandle is a handle to a collection that has been put
    // into an Event during the running of the same module.  This
    // constructor creates a Ptr<T> to a specific element within such a
    // collection of type C. The collection is identified by 'handle',
    // and the element in the collection is identified by index 'idx'.
    template <typename C>
    Ptr(OrphanHandle<C> const& handle, key_type idx, bool setNow=true);

    /*
                                WARNING

      Do not use the following constructor. It shall be removed from
      upcoming releases of the art framework. The purpose of the class
      template Ptr<T> is to provide a peristent pointer to an object of
      type T, in a collection in an Event. This constructor attempts to
      create an object that subverts that purpose, and which is
      therefore inherently broken.

      The remaining documentation for this function is legacy only.
     */
    // Constructor for ref to object that is not in an event.  An
    // exception will be thrown if an attempt is made to persistify any
    // object containing this Ptr.  Also, in the future work will be
    // done to throw an exception if an attempt is made to put any
    // object containing this Ptr into an event(or run or subRun).
     template <typename C>
     Ptr(C const* product, key_type itemKey, bool setNow=true);

    // Constructor from test handle.
    // An exception will be thrown if an attempt is made to persistify
    // any object containing this Ptr.
//     template <typename C>
//     Ptr(TestHandle<C> const& handle, key_type itemKey, bool setNow=true):
//       core_(handle.id(), getItem_(handle.product(), itemKey), 0, true), key_(itemKey)
//     { }

    // Constructor for those users who do not have a product handle,
    // but have a pointer to a product getter (such as the EventPrincipal).
    // prodGetter will ususally be a pointer to the event principal.
    Ptr(ProductID const& productID, key_type itemKey, EDProductGetter const* prodGetter) :
      core_(productID, 0, mustBeNonZero(prodGetter, "Ptr", productID), false), key_(itemKey)
    { }

    // Constructor for use in the various X::fillView(...) functions
    // or for extracting a persistent Ptr from a PtrVector.
    // It is an error (not diagnosable at compile- or run-time) to call
    // this constructor with a pointer to a T unless the pointed-to T
    // object is already in a collection of type C stored in the
    // Event. The given ProductID must be the id of the collection
    // in the Event.
    Ptr(ProductID const& productID, T const* item, key_type item_key) :
      core_(productID, item, 0, false),
      key_(item_key)
    { }

    // Constructor that creates an invalid ("null") Ptr that is
    // associated with a given product (denoted by that product's ProductID).
    explicit Ptr(ProductID const& id) :
      core_(id, 0, 0, false),
      key_(key_traits<key_type>::value)
    { }

    Ptr():
      core_(),
      key_(key_traits<key_type>::value)
    { }

    Ptr(Ptr<T> const& iOther):
      core_(iOther.core_),
      key_(iOther.key_)
    { }

    template<typename U>
    Ptr(Ptr<U> const& iOther, typename boost::enable_if_c<boost::is_base_of<T, U>::value>::type * = 0):
      core_(iOther.id(),
            (iOther.hasCache()? static_cast<T const*>(iOther.get()): static_cast<T const*>(0)),
            iOther.productGetter(),
            iOther.isTransient()),
      key_(iOther.key())
    { }

    template<typename U>
    explicit
    Ptr(Ptr<U> const& iOther, typename boost::enable_if_c<boost::is_base_of<U, T>::value>::type * = 0):
      core_(iOther.id(),
            dynamic_cast<T const*>(iOther.get()),
            0,
            iOther.isTransient()),
      key_(iOther.key())
    { }

    // Destructor
    ~Ptr() { }

    // Dereference operator
    T const&
    operator*() const;

    // Member dereference operator
    T const*
    operator->() const;

    // Returns C++ pointer to the item
    T const* get() const
    {
      return isNull() ? 0 : this->operator->();
    }

    // Checks for null
    bool isNull() const { return !isNonnull(); }

    // Checks for non-null
    bool isNonnull() const { return key_traits<key_type>::value != key_; }
    // Checks for null
    bool operator!() const { return isNull(); }

    // Checks if collection is in memory or available
    // in the event. No type checking is done.
    bool isAvailable() const { return core_.isAvailable(); }

    // Checks if this Ptr is transient (i.e. not persistable).
    bool isTransient() const { return core_.isTransient(); }

    // Accessor for product ID.
    ProductID id() const { return core_.id(); }

    // Accessor for product getter.
    EDProductGetter const* productGetter() const { return core_.productGetter(); }

    key_type key() const { return key_; }

    bool hasCache() const { return 0!=core_.productPtr(); }

    RefCore const& refCore() const { return core_; }
    // ---------- member functions ---------------------------

  private:
    // Constructor for extracting a transient Ptr from a PtrVector.
    Ptr(T const* item, key_type item_key) :
      core_(ProductID(), item, 0, true),
      key_(item_key) {
    }

    template<typename C>
    T const* getItem_(C const* product, key_type iKey);

    void getData_() const {
      if(!hasCache() && 0 != productGetter()) {
        void const* ad = 0;
        const EDProduct* prod = productGetter()->getIt(core_.id());
        if(prod==0) {
          throw art::Exception(errors::ProductNotFound)
            << "A request to resolve an art::Ptr to a product containing items of type: "
            << typeid(T).name()
            << " with ProductID "<<core_.id()
            << "\ncan not be satisfied because the product cannot be found."
            << "\nProbably the branch containing the product is not stored in the input file.\n";
        }
        prod->setPtr(typeid(T),
                     key_,
                     ad);
        core_.setProductPtr(ad);
      }
    }
    // ---------- member data --------------------------------
    RefCore core_;
    key_type key_;
  };  // Ptr<>

  //------------------------------------------------------------
  // Implementation details below.
  //------------------------------------------------------------

  template <typename T>
  template <typename C>
  inline
  Ptr<T>::Ptr(Handle<C> const& handle,
              typename Ptr<T>::key_type idx,
              bool setNow) :
    core_(handle.id(), getItem_(handle.product(), idx), 0, false),
    key_(idx)
  { }

  template <typename T>
  template <typename C>
  inline
  Ptr<T>::Ptr(OrphanHandle<C> const& handle,
              key_type idx,
              bool setNow) :
    core_(handle.id(), getItem_(handle.product(), idx), 0, false),
    key_(idx)
    { }

  template <typename T>
  template <typename C>
  inline
  Ptr<T>::Ptr(C const* product,
              key_type idx,
              bool setNow) :
    core_(ProductID(), product != 0 ? getItem_(product,idx) : 0, 0, true),
    key_(product != 0 ? idx : key_traits<key_type>::value)
  { }

  template<typename T>
  template<typename C>
  T const* Ptr<T>::getItem_(C const* product, key_type iKey)
  {
    assert (product != 0);
    typename C::const_iterator it = product->begin();
    advance(it,iKey);
    T const* address = detail::GetProduct<C>::address(it);
    return address;
  }

  // Dereference operator
  template <typename T>
  inline
  T const&
  Ptr<T>::operator*() const {
    getData_();
    return *reinterpret_cast<T const*>(core_.productPtr());
  }

  // Member dereference operator
  template <typename T>
  inline
  T const*
  Ptr<T>::operator->() const {
    getData_();
    return reinterpret_cast<T const*>(core_.productPtr());
  }

  template <typename T>
  inline
  bool
  operator==(Ptr<T> const& lhs, Ptr<T> const& rhs) {
    return lhs.refCore() == rhs.refCore() && lhs.key() == rhs.key();
  }

  template <typename T>
  inline
  bool
  operator!=(Ptr<T> const& lhs, Ptr<T> const& rhs) {
    return !(lhs == rhs);
  }

  template <typename T>
  inline
  bool
  operator<(Ptr<T> const& lhs, Ptr<T> const& rhs) {
    // The ordering of integer keys guarantees that the ordering of Ptrs within
    // a collection will be identical to the ordering of the referenced objects in the collection.
    return (lhs.refCore() == rhs.refCore() ? lhs.key() < rhs.key() : lhs.refCore() < rhs.refCore());
  }

  template <class T, class C>
  inline
  void
  fill_ptr_vector(std::vector<Ptr<T> >& ptrs, Handle<C> const& h)
  {
    for (size_t i = 0, sz = h->size(); i != sz; ++i)
      ptrs.push_back(Ptr<T>(h, i));
  }

  template <class T, class C>
  inline
  void
  fill_ptr_list(std::list<Ptr<T> >& ptrs, Handle<C> const& h)
  {
    for (size_t i = 0, sz = h->size(); i != sz; ++i)
      ptrs.push_back(Ptr<T>(h, i));
  }

}  // art

#endif /* art_Persistency_Common_Ptr_h */

// Local Variables:
// mode: c++
// End:
