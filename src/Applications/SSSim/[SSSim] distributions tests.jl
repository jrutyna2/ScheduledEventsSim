include("../../../../deps/build.jl")
include("[SSSim_unif_unif] system.jl")
include("[SSSim_exp_unif] system.jl")
include("[SSSim_exp_exp] system.jl")
include("[SSSim_exp_erlang] system.jl")
include("[SSSim_exp_gamma] system.jl")
using Statistics
using DataFrames
using HypothesisTests
import Pkg
Pkg.add("CSV")
using CSV

# Function to run a simulation system multiple times and collect metrics
function run_system(simulation, n_runs, prints)
    #run the simulation
    results = simulation

    stat_IAT = results[:IAT]
    stat_WQ = results[:WQ]
    stat_WS = results[:WS]
    stat_NW = results[:NW]
    stat_N = results[:N]

    iat = stat_IAT/stat_N
    wq = stat_WQ/stat_N
    ws = stat_WS/stat_N
    pr_waiting = stat_NW / stat_N
    
    if (prints)
        println("\n\nIAT:\ns", stat_IAT)
        println("\nWQ:\n", stat_WQ)
        println("\nWS:\n", stat_WS)
        println("\nNW:\n", stat_NW)
        println("\nN:\n", stat_N)
        println("\niat\n", iat)
        println("\nwq:\n", wq)
        println("\nws\n", ws)
        println("\npr(waiting):\n", pr_waiting)
    end

    #return collected metrics
    return iat, wq, ws, pr_waiting
end

function calculate(measure1, measure2, n_runs) 
    z_score = 2.576  # z-score for 99% confidence

    data1 = measure1.values
    data2 = measure2.values

    # Calculations for the first measure
    avg1 = mean(data1)
    sd1 = std(data1)
    ci_half_width1 = z_score * sd1 / sqrt(n_runs)
    ci_lower1 = avg1 - ci_half_width1
    ci_upper1 = avg1 + ci_half_width1

    # Calculations for the second measure
    avg2 = mean(data2)
    sd2 = std(data2)
    ci_half_width2 = z_score * sd2 / sqrt(n_runs)
    ci_lower2 = avg2 - ci_half_width2
    ci_upper2 = avg2 + ci_half_width2

    # Performing a T-test on the WQ values
    ttest = pvalue(EqualVarianceTTest(data1, data2))

    # Return a dictionary (row of data)
    return Dict(
        "Avg1" => avg1, "SD1" => sd1, "CI1" => [ci_lower1, ci_upper1], 
        "Avg2" => avg2, "SD2" => sd2, "CI2" => [ci_lower2, ci_upper2], 
        "TTest" => ttest
    )
end

function add_to_dataframe(df, sim_comp, metric, result_dict)
    new_row = DataFrame(
        Simulation_Comparison = [sim_comp],
        Metric = [metric],
        Avg1 = [result_dict["Avg1"]],
        SD1 = [result_dict["SD1"]],
        CI1_Lower = [result_dict["CI1"][1]],
        CI1_Upper = [result_dict["CI1"][2]],
        Avg2 = [result_dict["Avg2"]],
        SD2 = [result_dict["SD2"]],
        CI2_Lower = [result_dict["CI2"][1]],
        CI2_Upper = [result_dict["CI2"][2]],
        TTest_pvalue = [result_dict["TTest"]]
    )
    append!(df, new_row)
end

function process_metric(df, sim_comp, metric, result1, result2, n_runs)
    result_dict = calculate(result1, result2, n_runs)
    add_to_dataframe(df, sim_comp, metric, result_dict)
end

# Running each system 100 times
n_runs = 100
prints = false
verb = false

unif_unif_results = run_system(SSSim_unif_unif(n_runs, verb), n_runs, prints)
exp_unif_results = run_system(SSSim_exp_unif(n_runs, verb), n_runs, prints)
exp_exp_results = run_system(SSSim_exp_exp(n_runs, verb), n_runs, prints)
exp_erlang_results = run_system(SSSim_exp_erlang(n_runs, verb), n_runs, prints)
exp_gamma_results = run_system(SSSim_exp_gamma(n_runs, verb), n_runs, prints)

sim_unif_unif = "SSSimunif,unif vs SSSimexp,unif"
sim_exp_unif = "SSSimexp,unif vs SSSimexp,exp"
sim_exp_erlang = "SSSimexp,unif vs SSSimexp,erlang"
sim_exp_gamma = "SSSimexp,unif vs SSSimexp,gamma"
sim_exp_exp = "SSSimexp,exp vs SSSimexp,erlang"
sim_erlang_gamma = "SSSimexp,erlang vs SSSimexp,gamma"

results_df = DataFrame(
    Simulation_Comparison = String[],
    Metric = String[],
    Avg1 = Float64[],
    SD1 = Float64[],
    CI1_Lower = Float64[],
    CI1_Upper = Float64[],
    Avg2 = Float64[],
    SD2 = Float64[],
    CI2_Lower = Float64[],
    CI2_Upper = Float64[],
    TTest_pvalue = Float64[]
)

# Define metrics
metrics = ["IAT", "WQ", "WS", "Pr_waiting"]

# Map metrics to tuple indices
metric_indices = Dict("IAT" => 1, "WQ" => 2, "WS" => 3, "Pr_waiting" => 4)

# Define simulation pairs for comparison
simulations = [
    (sim_unif_unif, unif_unif_results, exp_unif_results),
    (sim_exp_unif, exp_unif_results, exp_exp_results),
    (sim_exp_erlang, exp_unif_results, exp_erlang_results),
    (sim_exp_gamma, exp_unif_results, exp_gamma_results),
    (sim_exp_exp, exp_exp_results, exp_erlang_results),
    (sim_erlang_gamma, exp_erlang_results, exp_gamma_results)
]

# Loop through each simulation comparison
for (sim_comp, results1, results2) in simulations
    for metric in metrics
        index = metric_indices[metric]
        metric_data1 = results1[index]
        metric_data2 = results2[index]
        process_metric(results_df, sim_comp, metric, metric_data1, metric_data2, n_runs)
    end
end

println(results_df)

CSV.write("simulation_results.csv", results_df)