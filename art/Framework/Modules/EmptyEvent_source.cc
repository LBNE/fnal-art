namespace art {
  class EmptyEvent;
}

#include "art/Framework/Core/DecrepitRelicInputSourceImplementation.h"
#include "art/Framework/Principal/EventPrincipal.h"
#include "art/Framework/Core/EmptyEventTimestampPlugin.h"
#include "art/Framework/Core/Frameworkfwd.h"
#include "art/Framework/Core/InputSourceDescription.h"
#include "art/Framework/Core/InputSourceMacros.h"
#include "art/Framework/Principal/Run.h"
#include "art/Framework/Principal/RunPrincipal.h"
#include "art/Framework/Principal/SubRun.h"
#include "art/Framework/Principal/SubRunPrincipal.h"
#include "art/Persistency/Provenance/EventAuxiliary.h"
#include "art/Persistency/Provenance/EventID.h"
#include "art/Persistency/Provenance/RunAuxiliary.h"
#include "art/Persistency/Provenance/RunID.h"
#include "art/Persistency/Provenance/SubRunAuxiliary.h"
#include "art/Persistency/Provenance/SubRunID.h"
#include "art/Persistency/Provenance/Timestamp.h"
#include "cetlib/BasicPluginFactory.h"
#include "cpp0x/cstdint"
#include "cpp0x/memory"
#include "fhiclcpp/ParameterSet.h"

class art::EmptyEvent : public art::DecrepitRelicInputSourceImplementation {
public:
   explicit EmptyEvent(fhicl::ParameterSet const& pset,
                       InputSourceDescription & desc);

   unsigned int numberEventsInRun() const { return numberEventsInRun_; }
   unsigned int numberEventsInSubRun() const { return numberEventsInSubRun_; }
   unsigned int eventCreationDelay() const { return eventCreationDelay_; }
   unsigned int numberEventsInThisRun() const { return numberEventsInThisRun_; }
   unsigned int numberEventsInThisSubRun() const { return numberEventsInThisSubRun_; }

private:
   art::input::ItemType getNextItemType() override;
   void setRunAndEventInfo();
   std::unique_ptr<EventPrincipal> readEvent_() override;
   std::shared_ptr<SubRunPrincipal> readSubRun_() override;
   std::shared_ptr<RunPrincipal> readRun_() override;
   std::vector<std::shared_ptr<SubRunPrincipal>> readSubRunFromSecondaryFiles_() override;
   std::vector<std::shared_ptr<RunPrincipal>> readRunFromSecondaryFiles_() override;
   void skip(int offset) override;
   void rewind_() override;

  void beginJob() override;
  void endJob() override;

   void reallyReadEvent();

  std::unique_ptr<EmptyEventTimestampPlugin>
  makePlugin_(fhicl::ParameterSet const & pset);

   unsigned int numberEventsInRun_;
   unsigned int numberEventsInSubRun_;
   unsigned int eventCreationDelay_;  /* microseconds */

   unsigned int numberEventsInThisRun_;
   unsigned int numberEventsInThisSubRun_;
   EventID eventID_;
   EventID origEventID_;
   bool newRun_;
   bool newSubRun_;
   bool subRunSet_;
   bool eventSet_;
   bool skipEventIncrement_;
   bool resetEventOnSubRun_;
   std::unique_ptr<EventPrincipal> ep_;
   EventAuxiliary::ExperimentType eType_;

  cet::BasicPluginFactory pluginFactory_;
  std::unique_ptr<EmptyEventTimestampPlugin> plugin_;
};  // EmptyEvent

using namespace art;
using std::uint32_t;

//used for defaults

art::EmptyEvent::EmptyEvent
(fhicl::ParameterSet const& pset, InputSourceDescription & desc) :
   DecrepitRelicInputSourceImplementation( pset, desc ),
   numberEventsInRun_       ( pset.get<uint32_t>("numberEventsInRun", remainingEvents()) ),
   numberEventsInSubRun_    ( pset.get<uint32_t>("numberEventsInSubRun", remainingEvents()) ),
   eventCreationDelay_      ( pset.get<uint32_t>("eventCreationDelay", 0u) ),
   numberEventsInThisRun_   ( 0 ),
   numberEventsInThisSubRun_( 0 ),
   eventID_                 ( ),
   origEventID_             ( ), // In body.
   newRun_                  ( true ),
   newSubRun_               ( true ),
   subRunSet_               ( false ),
   eventSet_                ( false ),
   skipEventIncrement_      ( true ),
   resetEventOnSubRun_      ( pset.get<bool>("resetEventOnSubRun", true) ),
   ep_                      ( ),
   eType_                   ( EventAuxiliary::Any),
   pluginFactory_           ( ),
   plugin_                  (makePlugin_(pset.get<fhicl::ParameterSet>("timestampPlugin", { })))
{

   RunNumber_t firstRun;
   bool haveFirstRun = pset.get_if_present("firstRun", firstRun);
   SubRunNumber_t firstSubRun;
   bool haveFirstSubRun = pset.get_if_present("firstSubRun", firstSubRun);
   EventNumber_t firstEvent;
   bool haveFirstEvent = pset.get_if_present("firstEvent", firstEvent);
   RunID firstRunID = haveFirstRun?RunID(firstRun):RunID::firstRun();
   SubRunID firstSubRunID = haveFirstSubRun?SubRunID(firstRunID.run(), firstSubRun):
      SubRunID::firstSubRun(firstRunID);
   origEventID_ = haveFirstEvent?EventID(firstSubRunID.run(),
                                         firstSubRunID.subRun(),
                                         firstEvent):
      EventID::firstEvent(firstSubRunID);
   eventID_ = origEventID_;
}

std::shared_ptr<RunPrincipal>
art::EmptyEvent::readRun_() {
  auto ts = plugin_ ?
            plugin_->doBeginRunTimestamp(eventID_.runID()) :
            Timestamp::invalidTimestamp();
  RunAuxiliary runAux(eventID_.runID(), ts, Timestamp::invalidTimestamp());
  newRun_ = false;
  auto rp_ptr =
    std::make_shared<RunPrincipal>(runAux, processConfiguration());
  if (plugin_) {
    Run r(*rp_ptr, moduleDescription());
    plugin_->doBeginRun(r);
  }
  return rp_ptr;
}

std::vector<std::shared_ptr<RunPrincipal>>
EmptyEvent::readRunFromSecondaryFiles_()
{
  std::vector<std::shared_ptr<RunPrincipal>> ret;
  return ret;
}

std::shared_ptr<SubRunPrincipal>
EmptyEvent::readSubRun_() {
   if (processingMode() == Runs) return std::shared_ptr<SubRunPrincipal>();
   auto ts = plugin_ ?
             plugin_->doBeginSubRunTimestamp(eventID_.subRunID()) :
             Timestamp::invalidTimestamp();
   SubRunAuxiliary subRunAux(eventID_.subRunID(),
                             ts,
                             Timestamp::invalidTimestamp());
   auto srp_ptr =
     std::make_shared<SubRunPrincipal>(subRunAux,
                                       processConfiguration());
   if (plugin_) {
     SubRun sr(*srp_ptr, moduleDescription());
     plugin_->doBeginSubRun(sr);
   }
   newSubRun_ = false;
   return srp_ptr;
}

std::vector<std::shared_ptr<SubRunPrincipal>>
EmptyEvent::readSubRunFromSecondaryFiles_()
{
  std::vector<std::shared_ptr<SubRunPrincipal>> ret;
  return ret;
}

std::unique_ptr<EventPrincipal>
  EmptyEvent::readEvent_() {
   assert(ep_.get() != 0 || processingMode() != RunsSubRunsAndEvents);
   return std::move(ep_);
}

void
art::EmptyEvent::
beginJob()
{
  if (plugin_) {
    plugin_->doBeginJob();
  }
}

void
art::EmptyEvent::
endJob()
{
  if (plugin_) {
    plugin_->doEndJob();
  }
}

void art::EmptyEvent::reallyReadEvent() {
  if (processingMode() != RunsSubRunsAndEvents) return;
  auto timestamp = plugin_ ?
                   plugin_->doEventTimestamp(eventID_) :
                   Timestamp::invalidTimestamp();
  EventAuxiliary eventAux(eventID_,
                          timestamp,
                          eType_);
  ep_.reset(new EventPrincipal(eventAux, processConfiguration()));
}

std::unique_ptr<art::EmptyEventTimestampPlugin>
art::EmptyEvent::
makePlugin_(fhicl::ParameterSet const & pset)
{
  std::unique_ptr<art::EmptyEventTimestampPlugin> result;
  try {
    if (!pset.is_empty()) {
      auto const libspec = pset.get<std::string>("plugin_type");
      auto const pluginType = pluginFactory_.pluginType(libspec);
      if (pluginType == cet::PluginTypeDeducer<EmptyEventTimestampPlugin>::value) {
        result = pluginFactory_.makePlugin<std::unique_ptr<EmptyEventTimestampPlugin>,
          fhicl::ParameterSet const &>(libspec, pset);
    } else {
        throw Exception(errors::Configuration, "EmptyEvent: ")
          << "unrecognized plugin type "
          << pluginType
          << "for plugin "
          << libspec
          << ".\n";
      }
  }
} catch (cet::exception & e) {
    throw Exception(errors::Configuration, "EmptyEvent: ", e)
      << "Exception caught while processing plugin spec.\n";
  }
  return result;
}

void art::EmptyEvent::skip(int offset)
{
  for (; offset < 0; ++offset) {
     eventID_ = eventID_.previous();
  }
  for (; offset > 0; --offset) {
     eventID_ = eventID_.next();
  }
}

void art::EmptyEvent::rewind_() {
  if (plugin_) {
    plugin_->doRewind();
  }
  setTimestamp(Timestamp::invalidTimestamp());
  eventID_ = origEventID_;
  skipEventIncrement_ = true;
  numberEventsInThisRun_ = 0;
  numberEventsInThisSubRun_ = 0;
  newRun_ = newSubRun_ = true;
  resetSubRunPrincipal();
  resetRunPrincipal();
}

art::input::ItemType
art::EmptyEvent::getNextItemType() {
   if (newRun_) {
      if (!eventID_.runID().isValid() ) {
         ep_.reset();
         return input::IsStop;
      }
      return input::IsRun;
   }
   if (newSubRun_) {
      return input::IsSubRun;
   }
   if(ep_.get() != 0) return input::IsEvent;
   EventID oldEventID = eventID_;
   if (!eventSet_) {
      subRunSet_ = false;
      setRunAndEventInfo();
      eventSet_ = true;
   }
   if (!eventID_.runID().isValid()) {
      ep_.reset();
      return input::IsStop;
   }
   if (oldEventID.runID() != eventID_.runID()) {
      //  New Run
      // reset these since this event is in the new run
      numberEventsInThisRun_ = 0;
      numberEventsInThisSubRun_ = 0;
      newRun_ = newSubRun_ = true;
      resetSubRunPrincipal();
      resetRunPrincipal();
      return input::IsRun;
   }
   // Same Run
   if (oldEventID.subRunID() != eventID_.subRunID()) {
      // New Subrun
      numberEventsInThisSubRun_ = 0;
      newSubRun_ = true;
      resetSubRunPrincipal();
      if (processingMode() != Runs) {
         return input::IsSubRun;
      }
   }
   ++numberEventsInThisRun_;
   ++numberEventsInThisSubRun_;
   reallyReadEvent();
   if (ep_.get() == 0) {
      return input::IsStop;
   }
   eventSet_ = false;
   return input::IsEvent;
}

void
art::EmptyEvent::setRunAndEventInfo() {
   // NOTE: numberEventsInRun < 0 means go forever in this run
   if (numberEventsInRun_ < 1 || numberEventsInThisRun_ < numberEventsInRun_) {
      // same run
      if (!(numberEventsInSubRun_ < 1 || numberEventsInThisSubRun_ < numberEventsInSubRun_)) {
         // new subrun
         if (resetEventOnSubRun_) {
            eventID_ = eventID_.nextSubRun(origEventID_.event());
         } else {
            eventID_ = eventID_.nextSubRun(eventID_.next().event());
         }
      } else if (skipEventIncrement_) { // For first event, rewind etc.
         skipEventIncrement_ = false;
      } else {
         eventID_ = eventID_.next();
      }
   } else {
      // new run
      eventID_ = EventID(eventID_.nextRun().run(), origEventID_.subRun(), origEventID_.event());
   }
   if (eventCreationDelay_ > 0) {usleep(eventCreationDelay_);}
}

DEFINE_ART_INPUT_SOURCE(EmptyEvent)

