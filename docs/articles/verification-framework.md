# The HTA Verification Framework

``` r

library(testhta)
library(testthat)
```

## 1. Hierarchy of Testing in Health Economic Modelling

Testing can be performed at different levels of abstraction. Adapted
from the software engineering *Test Pyramid* framework (Cohn, 2009),
automated checks in health economic modelling are organized into three
structural tiers:

1.  **Level 1: Unit Testing (Lowest Level — Fast, High Isolation)**\
    Isolates the smallest testable parts of an application
    (“units”)—typically a single, self-contained helper function—and
    verifies that they function correctly (e.g., a function that
    converts a rate to a probability, applies a discount factor, or
    draws a parameter sample).
2.  **Level 2: Integration Testing (Middle Level — Subcomponent
    Interaction)**\
    Verifies that multiple components (input structures, transition
    matrices, simulation loops, and summary extractors) interact
    correctly to produce logically sound results. Because health
    economic models frequently lack a simple “test oracle” for complex
    multi-state traces, executing
    [`run_model()`](https://validate-hta.github.io/testhta/reference/run_model.md)
    under controlled boundary conditions to check summary outputs like
    QALYs, Life Expectancy (LE), and ICERs primarily operates at this
    integration level.
3.  **Level 3: System or End-to-End Testing (Highest Level — Full
    Pipeline)**\
    Executes the entire decision-analytic pipeline from raw data
    ingestion to final policy outputs (e.g., running a 10,000-iteration
    Probabilistic Sensitivity Analysis (PSA) pipeline to verify that it
    completes without memory leaks, handles missing data gracefully, and
    outputs a valid ICER and CEAC).

------------------------------------------------------------------------

## 2. Why Use `testthat` Instead of Ad-Hoc Console Checks?

The `testthat` package (Wickham, 2011) is the standard framework for
automated testing in R. To set up an R package or project to use
`testthat` (edition 3), run:

``` r

usethis::use_testthat(3)
```

This creates the `tests/testthat/` directory and `tests/testthat.R`
runner script. Automated checks in `testthat` are written as
**expectations** (functions starting with `expect_`, such as
[`expect_equal()`](https://testthat.r-lib.org/reference/equality-expectations.html),
[`expect_lt()`](https://testthat.r-lib.org/reference/comparison-expectations.html),
[`expect_gt()`](https://testthat.r-lib.org/reference/comparison-expectations.html),
[`expect_true()`](https://testthat.r-lib.org/reference/logical-expectations.html))
grouped inside `test_that("<description>", { ... })` blocks.

Unlike ad-hoc console checks using raw operators (`== 0` or `<`), which
return a generic `FALSE` or fail silently unless manually inspected each
time a script is run, `testthat` expectations act as automated
diagnostic tools. When an expectation fails, `testthat` immediately
flags the exact test requirement ID, file, line number, and numerical
discrepancy between actual and expected values.

------------------------------------------------------------------------

## 3. Health Economic Modelling Test Suite (`T01` – `T12`)

Table 1 below presents the standardized suite of 12 verification tests,
extreme-value checks, and logical assertions adapted from established
HTA quality-assurance frameworks:

- Internal consistency and extreme-value checks (McCabe & Dixon, 2000)
- Comprehensive “black-box” verification criteria (Tappenden & Chilcott,
  2014)
- Automated decision-analytic checking principles (Dasbach & Elbasha,
  2017)
- Technical verification standards reinforced by the CHEERS statement
  (Husereau et al., 2013)

| ID | Group | Test Condition | Expected Result |
|:---|:---|:---|:---|
| **T01** | Population | Treatment effect the same for all treatments, e.g., Set relative treatment effects (OR, HR, RR) $`= 1`$ | All treatments produce equal estimates of total LYGs and total QALYs |
| **T02** | Population | Set mortality rates (or corresponding transition probabilities) $`= 0`$ | $`\text{LE} = \text{time horizon}`$ (assuming a fixed, finite time horizon to avoid an infinite loop) |
| **T03** | Population | Set mortality rates (or corresponding transition probabilities) to produce a probability of $`1`$ | $`\text{LE} = 1\text{ cycle}`$ (or $`0.5`$ depending on within-cycle correction implementation) |
| **T04** | QALY | Set discount rate $`= 0`$ (assuming utility $`= 1`$ for all living health states) | Total QALYs equal LE |
| **T05** | QALY | Set all living health state utility parameters $`= 1`$ | QALY gains exactly equal LYGs |
| **T06** | QALY | Apply standard positive discount rate vs. $`0`$ rate | $`\text{Discounted QALYs} < \text{undiscounted QALYs } \forall \text{ treatments}`$ |
| **T07** | QALY | Set QALY discount rate $`= \infty`$ | QALY gains after time $`0`$ equal zero |
| **T08** | Cost | Set intervention costs $`= 0`$ | ICER is reduced$`^\dagger`$ |
| **T09** | Cost | Increase intervention costs | ICER is increased$`^\dagger`$ |
| **T10** | Cost | Set cost discount rate $`= 0`$ | Total costs equal the raw arithmetic sum of unadjusted state costs $`\forall`$ treatments (and discounted costs $`<`$ undiscounted costs) |
| **T11** | Cost | Set cost discount rate $`= \infty`$ | Costs after time $`0`$ equal zero |
| **T12** | Input | Sample parameters from probabilistic distributions | Range of sampled values does not violate distribution boundaries, `NaN`s, or critical numerical precision errors |

> $`^\dagger`$**Note on ICER Directionality (`T08` & `T09`)**: Assuming
> a controlled test environment where baseline Incremental Effects
> ($`\text{IE}`$) are known to be strictly positive ($`\text{IE} > 0`$).
> In `testthat`, this assumption can be guarded explicitly using
> `testthat::skip_if_not(inc_qalys > 0, ...)`. If evaluating a scenario
> with negative incremental health effects, the verification logic
> should isolate Incremental Costs ($`\text{IC}`$) instead.
>
> **Note on Within-Cycle Correction (`T03`)**: In models applying a
> standard half-cycle (or within-cycle) correction, setting mortality to
> $`100\%`$ in the first cycle will conceptually result in a life
> expectancy of $`0.5`$ cycles rather than $`1.0`$ cycle.

------------------------------------------------------------------------

## References

1.  **Cohn, M.** (2009). *Succeeding with Agile: Software Development
    Using Scrum*. Addison-Wesley Professional.
2.  **Wickham, H.** (2011). testthat: Get Started with Testing. *The R
    Journal*, 3, 5–10.
3.  **McCabe, C., & Dixon, S.** (2000). Testing the Validity of
    Cost-Effectiveness Models. *PharmacoEconomics*, 17(5), 501–513.
4.  **Tappenden, P., & Chilcott, J. B.** (2014). Avoiding and
    Identifying Errors and Other Threats to the Credibility of Health
    Economic Models. *PharmacoEconomics*, 32, 967–979.
5.  **Dasbach, E. J., & Elbasha, E. H.** (2017). Verification of
    Decision-Analytic Models for Health Economic Evaluations: An
    Overview. *PharmacoEconomics*, 35, 673–683.
6.  **Husereau, D., et al.** (2013). Consolidated Health Economic
    Evaluation Reporting Standards (CHEERS) Statement. *European Journal
    of Health Economics*, 14(3), 367–372.
