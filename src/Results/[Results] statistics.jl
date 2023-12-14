using HypothesisTests, Distributions, Statistics
import HypothesisTests.confint

###########################################
#  General Statistical functions on Collection
#      - count, length, sum, mean  (where count and length are synonyms)

value(c::Const)                = c.value

count(c::Const)                = c.n
count(agr::Aggregation)        = agr.n
count(storedResults::StoredResults) = fillindex(storedResults) - 1

length(agr::Aggregation)       = count(agr)
length(storedResults::StoredResults) = count(storedResults)

sum(c::Const)                  = value(c) * count(c)
sum(agr::Aggregation)          = agr.sum
sum(sv::StoredValues)          = sum( values(sv))

mean(c::Const)                 = value(c)
mean(agr::Aggregation)         = sum(agr) / count(agr)
mean(sv::StoredValues)         = mean( values(sv))

###########################################
#  More simple statistical measures
#       - does not apply to  Sum collections
#       - var, minimum, maximum. extrema

# helper function for the SimpleStats implementation of var 
sumsq(stats::NormalStats)     = stats.sumSq
biasedvar(stats::NormalStats) = sumsq(stats)/count(stats) - mean(stats)^2

var(c::Const) = 0
var(stats::NormalStats)      = biasedvar(stats) * stats.n / (stats.n - 1)
var(sv::StoredValues)        = var( values(sv))

function var(stats::BinomialStats)
    p = mean(stats)
    p * (1 - p) / count(stats)
end

std(c::Const) = 0
std(stats::SimpleStats)      = sqrt( var(stats))
std(sv::StoredValues)        = std( values(sv))

function confint(stats::BinomialStats; level = 0.95, tail = :both, method = :wilson)
    confint(BinomialTest(sum(stats), count(stats)); level, tail, method)
end

function confint(stats::NormalStats; level = 0.95, tail = :both)
    confint( OneSampleTTest(mean(stats), std(stats), count(stats)); level, tail)
end

function confint(stats::StoredValues; level = 0.95, tail = :both)
    confint(OneSampleTTest(values(stats)); level, tail)
end

minimum(c::Const)                = value(c)
minimum(stats::NormalStats)      = stats.min
minimum(sv::StoredValues)        = minimum( values(sv))

minimum(c::Const)                = value(c)
maximum(stats::NormalStats)      = stats.max
maximum(sv::StoredValues)        = maximum( values(sv))

minimum(c::Const)                = (value(c), value(c))
extrema(stats::NormalStats)      = (stats.min, stats.max)
extrema(sv::StoredValues)        = extrema( values(sv))



###########################################
#  Non-Parametric statistical measures
#       - only applies to StoredValues collections
#       - median, quantile

minimum(c::Const)               = value(c)
median(sv::StoredValues)        = median( values(sv))

quantile(sv::StoredValues, p)     = quantile( values(sv), p)
quantile(c::Const, p)             = value(c)
