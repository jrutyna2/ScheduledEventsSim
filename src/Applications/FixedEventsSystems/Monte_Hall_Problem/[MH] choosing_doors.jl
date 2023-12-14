randomdoor() = rand(1:3)

function otherdoor(door)
    if door == 1
        rand((2,3))
    elseif door == 2
        rand((1,3))
    else
        rand((1,2))
    end
end

otherdoor(doorA, doorB) =  6 - doorA - doorB

choose(s::Switch, d::Doors)       =  otherdoor(revealed(d), chosen(d))
choose(s::Stay, d::Doors)         =  chosen(d)
choose(s::DoesntMatter, d::Doors) =  rand( (chosen(d), otherdoor( revealed(d), chosen(d))) )

function reveal(d::Doors)
    (prize(d) != chosen(d)) ? otherdoor(prize(d), chosen(d)) : otherdoor(chosen(d))
end

