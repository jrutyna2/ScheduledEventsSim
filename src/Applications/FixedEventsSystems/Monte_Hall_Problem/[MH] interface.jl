startstate(sim::MonteHall) = Doors()

state!(event::PlacePrize,  sim::MonteHall, state)  =  ( state.prize = randomdoor() )
state!(event::FirstChoice, sim::MonteHall, state)  =  ( state.chosen = randomdoor() )
state!(event::Reveal,      sim::MonteHall, state)  =  ( state.revealed = reveal(state) )
state!(event::FinalChoice, sim::MonteHall, state)  =  ( state.chosen = choose(strategy(sim), state) )

measure(sim::MonteHall, state) = won(state) ? 1 : 0
won(d::Doors) = (chosen(d) == prize(d))

verbose(::☼Event☼, sim::MonteHall, event) =  println(string(typeof(event)))
verbose(::☼PreEvent☼, sim::MonteHall)     =  println("Initialize")

function verbose(::☼State☼, sim::MonteHall, d::Doors)
    println("  prize  = ", prize(d) > 0 ? prize(d) : "<<not set>>")
    println("  chosen = ", chosen(d) > 0 ? chosen(d) : "<<not set>>")
    println("  reveal = ", revealed(d) > 0 ? revealed(d) : "<<not set>>")
end
