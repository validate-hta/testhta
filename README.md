# testhta

> **Custom unit tests and validity checks for Health Technology Assessment (HTA) models in R.**

`testhta` provides a framework for applying software engineering best practices—specifically unit testing—to health economic modeling. By leveraging the [`testthat`]([https://testthat.r-lib.org/](https://testthat.r-lib.org/)) package, `testhta` helps modelers verify that their cost-effectiveness models behave as expected under specific conditions.

Ensuring model quality does not require you to be an expert programmer; it requires verifying that the model passes a defined set of logical and mathematical tests. This approach improves transparency, reproducibility, and confidence in HTA decision-making.

## Installation

You can install the development version of `testhta` from GitHub:

```r
# install.packages("devtools")
devtools::install_github("n8thangreen/testhta")
```

## Quick Start: A Basic Example

Below is a basic example of how to implement a validity check.

In this scenario, we test the **economic logic of discounting**. We expect that total QALYs calculated with a positive discount rate (e.g., 3.5%) should be strictly *lower* than QALYs calculated with no discounting (0%), provided the model runs for more than one cycle.

First, set up the model with the baseline input parameters using a simple wrapper function.

```r
library(testhta)
library(testthat)

# (See scripts/run_markov_model.R for the underlying model logic)
run_my_model <- function(discount_rate) {
  # This calls the core Markov function included in the package
  ce_markov(
    start_pop = c(1000, 0, 0),
    p_matrix = array(c(0.8, 0.1, 0.1, 0.7, 0.2, 0.1, 0, 0, 1, 
                       0.8, 0.1, 0.1, 0.7, 0.2, 0.1, 0, 0, 1), 
                     dim = c(3, 3, 2)), # Simplified transition matrix
    state_c_matrix = matrix(c(500, 3000, 0, 1500, 3000, 0), nrow = 2, byrow = TRUE),
    trans_c_matrix = matrix(0, nrow = 3, ncol = 3),
    state_q_matrix = matrix(c(0.95, 0.75, 0, 0.95, 0.75, 0), nrow = 2, byrow = TRUE),
    n_cycles = 15,
    discount_rate = discount_rate
  )
}
```

Next we perform some unit tests to verify discounting logic.

```r
test_that("Discounted QALYs are lower than undiscounted QALYs", {
  
  # Run model with standard discounting (3.5%)
  results_discounted <- run_my_model(discount_rate = 0.035)
  
  # Run model with NO discounting (0%)
  results_undiscounted <- run_my_model(discount_rate = 0.0)
  
  # Extract the total QALYs (using the package getter or direct list access)
  qaly_discounted <- get_qalys(results_discounted)
  qaly_undiscounted <- get_qalys(results_undiscounted)
  
  # Expectation: Discounted value must be less than Undiscounted value
  expect_lt(qaly_discounted["without_drug"], qaly_undiscounted["without_drug"])
  expect_lt(qaly_discounted["with_drug"], qaly_undiscounted["with_drug"])
})
```

## Testing Strategy

This package implements the validation framework discussed in our [HTA in R Manifesto](https://github.com/StatisticsHealthEconomics/HTAinRmanifesto) and Tappenden et al (2014). The tests focus on black-box verification of model outputs rather than internal code inspection.

Common test cases included in this framework:

* **QALY Estimation:**
    * Set discount rate to 0 $\rightarrow$ QALYs should equal Life Expectancy (if utility = 1).
    * Set discount rate to $\infty$ $\rightarrow$ Future QALYs tend toward zero.
    * Set all utilities to 0 $\rightarrow$ Total QALYs should be 0.
* **Cost Estimation:**
    * Set intervention costs to 0 $\rightarrow$ Incremental Cost-Effectiveness Ratio (ICER) decreases.
    * Discounted costs should be $<$ Undiscounted costs.
* **Clinical Trajectory:**
    * Sum of probabilities in any state at any timepoint must equal 1.0.
    * Relative risks/Hazard ratios set to 1.0 $\rightarrow$ Outcomes should be identical between arms.
* **PSA & Statistical:**
    * Sampled parameter values must fall within defined distribution ranges (e.g., probabilities between 0 and 1).

For a full list of defined test cases, see the [Test Case Definition List](raw%20data/test_case_example.csv).

## References

The methodology for these tests is based on the following literature:

1.  **Dasbach, E.J., Elbasha, E.H.** (2017). Verification of Decision-Analytic Models for Health Economic Evaluations: An Overview. *PharmacoEconomics* 35, 673–683. [10.1007/s40273-017-0508-2](https://doi.org/10.1007/s40273-017-0508-2)
2.  **Alarid-Escudero, F., et al.** (2019). A Need for Change! A Coding Framework for Improving Transparency in Decision Modeling. *PharmacoEconomics*, 37(11), 1329–1339. [10.1007/s40273-019-00837-x](https://doi.org/10.1007/s40273-019-00837-x)
3.  **McCabe, C., & Dixon, S.** (2000). Testing the validity of cost-effectiveness models. *PharmacoEconomics*, 17(5), 501–513. [10.2165/00019053-200017050-00007](https://doi.org/10.2165/00019053-200017050-00007)
4.  **Husereau, D., et al.** (2013). Consolidated Health Economic Evaluation Reporting Standards (CHEERS) statement. *European Journal of Health Economics*, 14(3), 367–372. [10.1007/s10198-013-0471-6](https://doi.org/10.1007/s10198-013-0471-6)
5.  **Tappenden, P., Chilcott, J.B.** (2014). Avoiding and Identifying Errors and Other Threats to the Credibility of Health Economic Models. *PharmacoEconomics* 32, 967–979. [10.1007/s40273-014-0186-2](https://doi.org/10.1007/s40273-014-0186-2)
