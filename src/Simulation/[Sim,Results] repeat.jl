import Base.repeat

function repeat(sim::Simulation, reps::Int, R::Type = NormalStats) 
    value = nextvalue(sim)
    results = Results(R, value, reps)
    repeat(sim, reps, results)
end

function repeat(sim::Simulation, reps::Int, results::Results)  
    for i = 2:reps
        add!(results, nextvalue(sim))
    end
        
    results
end
