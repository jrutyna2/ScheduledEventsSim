include("../../../../deps/build.jl")
include("../TwoCentersSystem/[TwoCentersSystem] system.jl")
include("[ThreeCentersSystem] system.jl")
include("[Results] external_measures.jl")
using DataFrames
using Distributions
using CSV

TimeType(simTRC::TRCSystem) = Float64                 # Define the type of time used in the simulation
endtime(simTRC::TRCSystem) = simTRC.endTime           # Define the simulation end time
interarrivaltime(simTRC::TRCSystem) = rand(Exponential(1 / simTRC.lambda_a))     # Define iat based on exponential distribution
servicetime(simTRC::TRCSystem, i) = rand(Erlang(simTRC.k[i], simTRC.lambda_s[i]))# Define st for each center based on Erlang distribution

TimeType(simTC::TCSystem) = Int                 # Define the type of time used in the simulation
endtime(simTC::TCSystem) = 100                  # Define the simulation end time
interarrivaltime(simTC::TCSystem) =  rand(1:8)
distributions(simTC::TCSystem)    =  [3:12, 4:8]
servicetime(simTC::TCSystem, i)   =  rand(distributions(simTC)[i])

n_sims = 200
#Question 8 Implementation
lambda_a_exp = 1 / 4.5          #mean interarrival time 4.5
lambda_s_sterlang = 4.5 / 8.25  #rate parameter for STerlang
k_values_sterlang = [2, 2, 2]   #k values for STerlang
#Define setups and pchoices
setups = [[1, 2, 2], [1, 3, 1], [1, 4, 0]]
pchoices = [1, 2/3, 1/2, 1/3, 0]

function configure_simulation(setup, pchoice)
    # Define fixed parameters
    lambda_a_exp = 1 / 4.5          # Mean interarrival time
    lambda_s_sterlang = 4.5 / 8.25  # Rate parameter for STerlang
    k_values_sterlang = [2, 2, 2]   # k values for STerlang
    end_time = 100                  # End time for the simulation

    # Unpack setup values for servers at each center
    c1, c2, c3 = setup

    # Create and return the TRCSystem instance
    TRCSystem(
        lambda_a = lambda_a_exp,
        lambda_s = [lambda_s_sterlang, lambda_s_sterlang, lambda_s_sterlang],
        k = k_values_sterlang,
        end_time = 100,
        c1 = c1,
        c2 = c2,
        c3 = c3,
        pchoice = pchoice
    )
end

function run_simulation(sim_instance, n_sims)
    # Run the simulation with verbose output turned off
    runsim(sim_instance, verbose = false)
    
    # Repeat the simulation n_sims times and collect the results
    results = repeat(sim_instance, n_sims)

    return results
end

function print_results(df::DataFrame)
    #Print DataFrame
    show(df, allrows=true)
end

#calculate the total number of simulations
total_sims = 1+ length(setups) * length(pchoices)

#initialize a DataFrame with pre-allocated size and specific columns for each metric
results_df = DataFrame(
    Setup = Array{Array{Int,1}, 1}(undef, total_sims),
    PChoice = Array{Union{Float64, String}, 1}(undef, total_sims),
    SystemWQ = Array{Float64, 1}(undef, total_sims),
    ServiceCenterWQ = Array{Array{Float64, 1}, 1}(undef, total_sims),
    SystemPW = Array{Float64, 1}(undef, total_sims),
    ServiceCenterPW = Array{Array{Float64, 1}, 1}(undef, total_sims)
)

#index for filling DataFrame
idx = 1

#initialize TwoCentersSystem
simTC = TCSystem(c1 = 1, c2 = 4)
runsim(simTC, verbose = false)
resultsTC = repeat(simTC, n_sims);

#calculate metrics
metricsTC = calculate_metrics(resultsTC, 2, n_sims)
(SystemWQ, ServiceCenterWQ, SystemPW, ServiceCenterPW) = calculate_metrics(resultsTC, 2, n_sims)
#add TwoCentersSystem results to DataFrame
results_df[idx, :] = ([1, 4], "N/A", SystemWQ, ServiceCenterWQ, SystemPW, ServiceCenterPW)  # "N/A" for pchoice
idx += 1
for setup in setups
    for pchoice in pchoices
        # Configure the simulation
        simTRC = configure_simulation(setup, pchoice)  # Define this function

        # Run the simulation and collect metrics
        simulation_results = run_simulation(simTRC, n_sims)  # Define this function

        # Calculate metrics
        (SystemWQ, ServiceCenterWQ, SystemPW, ServiceCenterPW) = calculate_metrics(simulation_results, 3, n_sims)

        # Add ThreeCentersSystem results to DataFrame
        results_df[idx, :] = (setup, pchoice, SystemWQ, ServiceCenterWQ, SystemPW, ServiceCenterPW)
        idx += 1
    end
end

#print DataFrame
print_results(results_df)

for col in [:SystemWQ, :ServiceCenterWQ, :SystemPW, :ServiceCenterPW]
    col_data = [x for x in results_df[!, col] if x != "N/A"]  # Filter out "N/A" values
    avg = mean(collect(Iterators.flatten(col_data)))
    std_dev = std(collect(Iterators.flatten(col_data)))
    ci = calculate_ci(collect(Iterators.flatten(col_data)))

    println("\nMetrics for $col:")
    println("  Average: $avg")
    println("  Standard Deviation: $std_dev")
    println("  99% Confidence Interval: $ci")
    println("\n")
end

CSV.write("full_results.csv", results_df)
println("Results saved to full_results.csv")