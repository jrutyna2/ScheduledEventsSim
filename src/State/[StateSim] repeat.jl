function firstvalue(sim::StateSim, verbosity)
    value = runsim(sim, verbosity)
    while value === missing
        value = runsim(sim, verbosity)
    end
    value
end

repeat(sim::StateSim, reps::Int; verbose = false) = repeat(sim, reps, Nothing; verbose)

function repeat(sim::StateSim, reps::Int, ResultType::Type = Nothing; verbose = false)
    fv = firstvalue(sim, verbosity(verbose))
    ResultType === Nothing && (ResultType = typeof(fv) <: Number ? StoredValues : StoredRecords)
    results = (typeof(fv) <: Number)  ?  Results(ResultType, fv, reps) : Results(StoredRecords, fv, reps)  
    repeat(sim, reps, results, verbosity(verbose))
end

function repeat(sim::StateSim, reps::Int, results::Results, v::Verbosity)  
    for i = 2:reps
        add!(results, runsim(sim, v))
    end
    results
end
