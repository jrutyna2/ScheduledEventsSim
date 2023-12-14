include("../../../../deps/build.jl")

#-----------------------------------------------------------------------------------
# Running the Simulation one time

dw = DrunkardsWalkSim(walls = 10)

runsim(dw, verbose = true)
runsim(dw)

#-----------------------------------------------------------------------------------
# Running the Simulation multiple times with repeat
#    - measure ∈ (:steps, :leftwall, :rightwall, :all, :state) is user built
#          -  through the DW definition
#          - it is not part of the simulator proper
#    - measure = :all  
#          - is the default
#          - returns a struct called DWRecord

dw = DrunkardsWalkSim(walls = 10)                     # measure = :all is default
# dw = DrunkardsWalkSim(walls = 10; measure = :all)   # same as above

results = repeat(dw, 10000)                           # StoredObjects is the default result type
# results = repeat(dw, 10000, StoredObjects)          # same as above
# results = repeat(dw, 10000, StoredRecords)          # same as above

# calculate the average number of steps before you hit a wall
stepResults = results[:steps]
mean(stepResults)
confint(stepResults)

atLeftResults = results[:atleft]
mean(atLeftResults)                  
confint(atLeftResults)

atRightResults = results[:atright]
mean(atRightResults)                  
confint(atRightResults)

#-----------------------------------------------------------------------------------
# Running the Simulation multiple times with repeat
#    - this time, the state is returned instead of a applicaton specific record
#    - from the systems perspective, this is still a record (at least for now)

dw = DrunkardsWalkSim(walls = 10; measure = :state)          
results = repeat(dw, 10000)                 # StoredObjects is the default result type

stepResults = results[:steps]
mean(stepResults)
confint(stepResults)

# calculate the average loc when you hit a wall
#   - will approximate the probabilty of moving right/left if map results from [-1,1] to [0,1]
locResults = results[:loc]
mean(locResults)
confint(locResults)

#-----------------------------------------------------------------------------------
# Running the Simulation multiple times with repeat
#    - this time, the a single value is returned, 'steps', 
#    - so the statistics can be applied directly
#   - can use NormalStats since we are returning a single value

dw = DrunkardsWalkSim(walls = 10, measure = :steps)

results = repeat(dw, 1000, StoredValues)
mean(results)
confint(results)

# change the measure so the sim just returns whether or not you hit the left wall
dw = DrunkardsWalkSim(walls = 10, measure = :leftwall)

results = repeat(dw, 1000, BinomialStats)
mean(results)
confint(results)

