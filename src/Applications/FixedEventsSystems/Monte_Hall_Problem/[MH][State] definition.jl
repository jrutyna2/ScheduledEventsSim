mutable struct Doors <: State
    prize::Int
    chosen::Int
    revealed::Int
end

Doors()      = Doors(0, 0, 0)
Doors(prize) = Doors(prize, 0, 0)

prize(d::Doors)    = d.prize
chosen(d::Doors)   = d.chosen
revealed(d::Doors) = d.revealed
