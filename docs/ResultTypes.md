# Result Types
The default result type is `StoredValues`  

This result type is used if you want to store all values. This takes up the most memory, but allows all possible statistics, including non-parameteric statistics, to be computed.  

There are other results types which allow for different statistical functions to be applied. They potentially may  take up  less space in memory and consequently can speed up the running of a simulation.

To use another result type, just use the type name in the `repeat()` function as seen in the following examples:

**Example 1**: Used if it is known ahead of time that the resulting distribution is normally distibuted - the storage will be the sum of the values and the sum of the square values, from which the average and variance can be computed, instead of storing all of the values and then computing the average and variance.  

`results = repeat(sim, 1000, NormalStats)`  

**Example 2**: Used if it is known ahead of time that the resulting distribution is Binomially distibuted - the storage will be the sum of the values only, where the values will be 1 or 0 (or true / false, or success / fail, etc.), from which the average and variance can be computed
`results = repeat(sim, 1000, BinomialStats)`  



Here are the built-in result types along with the built-in statistical functions that can be used on them:  

- `Const`
    - `count`, `length`, `sum`
    - `mean`, `var`, `std`
    - `minimum`, `maximum`, `extrema`  
- `Sum`
    - `count`, `length`, `sum`, `mean`
- `NormalStats`
    - `count`, `length`, `sum`
    - `mean`, `var`, `std`
    - `minimum`, `maximum`, `extrema`  
    - `confint`, `ttest`, `ftest`
 - `BinomialStats`
    - `count`, `length`, `sum`
    - `mean`, `var`, `std`
    - `confint`, `ttest`, `ftest`
- `StoredValues`
    - `count`, `length`, `sum`
    - `mean`, `var`, `std`
    - `minimum`, `maximum`, `extrema`
    - `median`, `quantile`  
    - `confint`, `ttest`, `ftest`

Most of the functions are called with `results` as the only parameter. Here are the few exceptions, (with default values given for the associated keyword):  

`confint(results; level = 0.95, tail = :both)`  
`quantile(results, quantileValue)`  
`ttest(results1, results2; equalVar = false, tails = 2)`  
`ftest(results1, results2)`  

