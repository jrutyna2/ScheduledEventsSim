include("./deps/build.jl")

#-----------------------------
# Testing setup

struct E{N} <: Event end

#-----------------------------
# Testing FixedEL


e1 = E{1}()
e2 = E{2}()
e1 === e2
e1 === E{1}()

el1 = EventList(E{1}, E{2}, E{3})
el2 = EventList(e1,e2)

for ev in el1
    print(ev)
end

for ev in el2
    print(ev)
end

#-----------------------------
# Testing QueueEL

el = EventList(:append, E{1})
upcoming(el)

append!(el, E{2})
append!(el, E{3}())
add!(el, E{4})

upcoming(el)
nextevent!(el)
isempty(el)
length(el)

for ev in el
    print(ev)
end

#-----------------------------
# Testing SchedEL

el = EventList(:schedule, initialEvent = E{1}, endTime = 100.7)
upcoming(el)
post!(el, E{4}, 5.2)
upcomingtime(el)

for event in el
    print("[$(currenttime(el))] "); print("Event = "); print(event); println("")
end
