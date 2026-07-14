# Writing Basic Bounding Tests

``` r

library(testhta)
library(testthat)
```

In health economic model verification, **basic bounding tests** check
whether a model behaves correctly under extreme or “boundary” conditions
where the mathematical output is known *a priori*.

Unlike relational tests (which compare two different runs using
[`compare_model_runs()`](https://n8thangreen.github.io/testhta/reference/compare_model_runs.md)),
basic bounding tests assert model outputs against a single, static
expected value (e.g. checking that costs are exactly 0 when unit costs
are 0, or that QALYs are 0 under 100% discounting).

`testhta` provides three key assertion functions to write these tests
without needing custom comparison wrappers: -
`check_model_qalys(expected_qalys, data, ...)` -
`check_model_costs(expected_costs, data, ...)` -
`check_model_le(expected_le, data, ...)`

This vignette demonstrates how to implement these basic bounding tests
using the package’s built-in cohort Markov model as a case study.

------------------------------------------------------------------------

## 1. QALY Bounding Tests

QALY calculations are sensitive to utility weights and discount rates.
Under extreme conditions, QALY outcomes can be predicted exactly.

### T01: Extreme Discounting (100%)

If the discount rate is extremely high (e.g. $`1.0`$, representing a
$`100\%`$ discount rate), all future value is discounted to zero
immediately. In `testhta`, a discount rate of 1 or greater sets all
cycle values to 0. We expect total QALYs to equal 0.

``` r

data(test_data)

check_model_qalys(
  expected_qalys = 0,
  data = test_data,
  discount_rate = 1,
  label = "T01: QALYs are 0 when discount rate is 100%"
)
```

### T08: Infinite Discounting

Similarly, if we simulate an infinite discount rate
(e.g. `discount_rate = 1000`), QALY gains must tend to zero.

``` r

check_model_qalys(
  expected_qalys = 0,
  data = test_data,
  discount_rate = 1000,
  label = "T08: QALYs tend to 0 under infinite discounting"
)
```

### T04: Zero Utilities

If all health state utilities are set to 0, no QALYs can be accumulated,
regardless of survival or discounting. We can test this by setting the
utility values to 0:

``` r

check_model_qalys(
  expected_qalys = 0,
  data = test_data,
  u_healthy = 0,
  u_sick = 0,
  label = "T04: QALYs are 0 when all utility inputs are 0"
)
```

------------------------------------------------------------------------

## 2. Cost Bounding Tests

Similar to QALYs, cost calculations must equal zero under specific
extreme parameters.

### T06: Zero Unit Costs

If all health state occupancy costs, transition costs, and intervention
costs are set to 0, the model must output a total cost of 0.

``` r

check_model_costs(
  expected_costs = 0,
  data = test_data,
  c_healthy = 0,
  c_sick = 0,
  c_intervention = 0,
  c_death = 0,
  label = "T06: Costs are 0 when all cost parameters are 0"
)
```

### T12: Infinite Cost Discounting

With an infinite cost discount rate, all costs incurred after time 0 are
discounted to zero. Because `testhta` treats discount rates $`\ge 1`$ as
zeroing out all cycles, we assert:

``` r

check_model_costs(
  expected_costs = 0,
  data = test_data,
  discount_rate = 1000,
  label = "T12: Costs tend to 0 under infinite discounting"
)
```

------------------------------------------------------------------------

## 3. Population & Life Expectancy (LE) Bounding Tests

Survival transitions govern the population trace. We can verify survival
calculations by setting transition probabilities to death to extreme
bounds.

### T05: Absolute Mortality (100% Death Rate)

If the probability of transitioning to the “Dead” state is set to 1 for
all alive states, the cohort will die immediately in the first cycle.
Since the cohort only lives for cycle 1, the life expectancy must equal
exactly 1.

``` r

check_model_le(
  expected_le = 1,
  data = test_data,
  p_healthy_death = 1,
  p_sick_death = 1,
  label = "T05: Life expectancy is 1 when death rate is 100%"
)
```

### T10 (Modified): Zero Mortality (No-Death Bounding)

If the probability of death is set to 0, no member of the cohort can
die. Thus, the entire cohort must survive for the full time horizon
(`n_cycles`). If we set the time horizon to 50 cycles, the life
expectancy must be exactly 50.

``` r

check_model_le(
  expected_le = 50,
  data = test_data,
  p_healthy_death = 0,
  p_sick_death = 0,
  n_cycles = 50,
  label = "T10: Life expectancy equals time horizon when death rate is 0%"
)
```

------------------------------------------------------------------------

## Summary of Bounding Tests

By utilizing static bounding tests, you can guarantee that the
mathematical limits of your model are preserved. These tests form the
bedrock of your verification suite, ensuring that simple arithmetic
mistakes or indexing shifts do not pass undetected.
