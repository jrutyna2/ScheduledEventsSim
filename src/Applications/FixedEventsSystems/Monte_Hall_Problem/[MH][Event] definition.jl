####################################################
# Monte Hall Simulation Events interface

struct PlacePrize  <: Event end
struct FirstChoice <: Event end
struct Reveal      <: Event end
struct FinalChoice <: Event end

eventlist(sim::MonteHall) = EventList(PlacePrize, FirstChoice, Reveal, FinalChoice)
