function calculate_system_wq(results, num_centers, num_sims)
    total_wq = 0.0
    total_nw = 0

    for i in 1:num_sims
        # Loop through each service center and collect non-zero wait times
        for c in 1:num_centers
            wq = results[:WQ, c]  # Array to store total wait time for service center i
            nw = results[:NW, c] 
            total_nw += nw[i]     # sum total number that waited for each center in each sim
            total_wq += wq[i]     # sum total time waited for each center in each sim
        end
    end
    if total_nw > 0
        return (total_wq / total_nw) / num_sims  # total system queue wait time 
    end

    return 0.0
end

function calculate_queue_wait_time_per_center(results, center_number)
    return mean(results[:WQ, center_number])
end

function calculate_probability_of_wait_in_queue(results, num_centers)
    #since a customer can be waiting for multiple queues at once just use the 
    #center with most NW for system pr_waiting
    max_pr = 0.0

    for i in 1:num_centers
        pr = calculate_probability_of_wait_per_center(results, i)
        max_pr = max(max_pr, pr)
    end

    return max_pr
end

function calculate_probability_of_wait_per_center(results, center_number)
    if mean(results[:N]) == 0.0
        return 0.0
    end
    return mean(results[:NW, center_number] / results[:N])  #number that waited for center / total arrivals
end

function calculate_metrics(simulation_results, num_centers, n_sims)
    # Calculating system-wide average queue wait time
    wq = calculate_system_wq(simulation_results, num_centers, n_sims)

    # Calculating queue wait time for each service center
    wq_per_center = [calculate_queue_wait_time_per_center(simulation_results, i) for i in 1:num_centers]

    # Calculating the probability of a customer experiencing a wait in a queue
    pw = calculate_probability_of_wait_in_queue(simulation_results, num_centers)

    # Calculating the probability of a customer experiencing a wait in a queue for each service center
    pw_per_center = [calculate_probability_of_wait_per_center(simulation_results, i) for i in 1:num_centers]

    # Return collection of metrics
    (wq, wq_per_center, pw, pw_per_center)
end

#99% confidence interval
function calculate_ci(data, confidence_level=0.99)
    z_score = quantile(Normal(), 1 - (1 - confidence_level) / 2)  # for 99% CL
    margin_of_error = z_score * std(data) / sqrt(length(data))
    lower_bound = mean(data) - margin_of_error
    upper_bound = mean(data) + margin_of_error
    return (lower_bound, upper_bound)
end
