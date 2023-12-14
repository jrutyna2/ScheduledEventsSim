###########################################
#  Mean Comparisons - T-Test

abstract type TTest end
struct WelchT <: TTest end
struct StudentT <: TTest end

function ttest(r1, r2; equalVar::Bool = false, tails::Int = 2)
    testType = equalVar ? StudentT() : WelchT()
    if length(r1) == length(r2)
        ttest(testType, mean(r1), mean(r2), var(r1), var(r2), length(r1), tails)
    else
        ttest(testType, mean(r1), mean(r2), var(r1), var(r2), length(r1), length(r2), tails)
    end
end

function ttest(tt::TTest, x1, x2, v1, v2, n, tails)
    ttest_calc(x1, x2, pooledvar(tt, v1, v2, n), dof(tt, n, v1, v2), tails)
end

function ttest(tt::TTest, x1, x2, v1, v2, n1, n2, tails)
    ttest_calc(x1, x2, pooledvar(tt, v1, v2, n1, n2), dof(tt, n1, n2, v1, v2), tails)
end

function ttest_calc(x1, x2, pooledVar, dof, tails)
    tvalue = abs(x1 - x2) / √pooledVar
    cdf(TDist(dof), -tvalue) * tails
end

#---------------------------------------------------------
# Pooled Variance

pooledvar(t::TTest, v1, v2, n)        =  (v1 + v2)/n
pooledvar(t::WelchT, v1, v2, n1, n2)  =  v1/n1 + v2/n2

function pooledvar(t::StudentT, v1, v2, n1, n2)
    w1 = n1 - 1
    w2 = n2 - 1
    weighted_var = (w1 * v1 + w2 * v2) / (w1 + w2) 
    weighted_var * (n1 + n2) / n1 / n2
end

#---------------------------------------------------------
# Degrees of Freedom

function dof(t::StudentT, n::Int, v1::Float64 = 0.0, v2::Float64 = 0.0)
    2n - 2
end

function dof(t::StudentT, n1::Int, n2::Int, v1::Float64 = 0.0, v2::Float64 = 0.0)
    n1 + n2 - 2
end

function dof(t::WelchT, n, v1, v2)
    (n - 1) * (v1 + v2)^2 / (v1^2 + v2^2)
end

function dof(t::WelchT, n1, n2, v1, v2)
    v1 = v1/n1
    v2 = v2/n2
    (v1 + v2)^2 / (v1^2/(n1 - 1) + v2^2/(n2 - 1))
end

# Testing
ttest([1.0, 2.0, 3.0],[2.1, 3.2, 3.3])
ttest([1.0, 2.0, 3.0],[2.1, 3.2, 3.3], equalVar = true)
ttest([1.0, 2.0, 3.0],[2.1, 3.2, 3.3, 4.1, 1.8])
ttest([1.0, 2.0, 3.0],[2.1, 3.2, 3.3, 4.1, 1.8], equalVar = true)

###########################################
#  Variance Comparisons - F-Test

function ftest(r1, r2)
    v1 = var(r1)
    v2 = var(r2)
    dof1 = length(r1) - 1
    dof2 = length(r2) - 1
    vLarge = max(v1, v2)
    vSmall = min(v1,v2)
    dofLarge = (vLarge === v1 ? dof1 : dof2)
    dofSmall = (vSmall === v1 ? dof1 : dof2)
    F = vLarge/vSmall
    (1 - cdf(FDist(dofLarge, dofSmall), F)) * 2
end
