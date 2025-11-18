# run markov model script


t_names <- c("without_drug", "with_drug")
n_treatments <- length(t_names)

s_names  <- c("Asymptomatic_disease", "Progressive_disease", "Dead")
n_states <- length(s_names)

n_cohort <- 1000
cycle <- 1

# unit costs
cAsymp <- 500
cDeath <- 1000
cDrug <- 1000
cProg <- 3000

# utilities
uAsymp <- 0.95
uProg <- 0.75

# transition probs
tpDcm <- 0.15
tpProg <- 0.01
tpDn <- 0.0379  # over 65 year old

effect <- 0.5   # drug

# cost of staying in state
state_c_matrix <-
  matrix(c(cAsymp, cProg, 0,
           cAsymp + cDrug, cProg, 0),
         byrow = TRUE,
         nrow = n_treatments,
         dimnames = list(t_names,
                         s_names))

# qaly when staying in state
state_q_matrix <-
  matrix(c(uAsymp, uProg, 0,
           uAsymp, uProg, 0),
         byrow = TRUE,
         nrow = n_treatments,
         dimnames = list(t_names,
                         s_names))

# cost of moving to a state
# same for both treatments
trans_c_matrix <-
  matrix(c(0, 0, 0,
           0, 0, cDeath,
           0, 0, 0),
         byrow = TRUE,
         nrow = n_states,
         dimnames = list(from = s_names,
                         to = s_names))

# transition probabilities
# time-homogeneous
p_matrix <- array(data = c(1 - tpProg - tpDn, 0, 0,
                           tpProg, 1 - tpDcm - tpDn, 0,
                           tpDn, tpDcm + tpDn, 1,
                           1 - tpProg*(1-effect) - tpDn, 0, 0,
                           tpProg*(1-effect), 1 - tpDcm - tpDn, 0,
                           tpDn, tpDcm + tpDn, 1),
                  dim = c(n_states, n_states, n_treatments),
                  dimnames = list(from = s_names,
                                  to = s_names,
                                  t_names))
start_pop <- c(1,0,0)

res <- ce_markov(start_pop,
                 p_matrix,
                 state_c_matrix,
                 trans_c_matrix,
                 state_q_matrix,
                 n_cycles = 15,
                 init_age = 55,
                 s_names,
                 t_names)

# plot ----

# Incremental costs and QALYs of with_drug vs to without_drug
c_incr <- res$total_costs["with_drug"] - res$total_costs["without_drug"]
q_incr <- res$total_QALYs["with_drug"] - res$total_QALYs["without_drug"]

# Incremental cost-effectiveness ratio
ICER <- c_incr/q_incr

wtp <- 20000

plot(x = q_incr/n_cohort, y = c_incr/n_cohort,
     xlim = c(0, 0.0006),
     ylim = c(0, 15),
     pch = 16, cex = 1.5,
     xlab = "QALY difference",
     ylab = paste0("Cost difference (", enc2utf8("\u00A3"), ")"),
     frame.plot = FALSE)
abline(a = 0, b = wtp) # willingness-to-pay threshold

# # save input data for unit testing
#
# test_data <- tibble::lst(start_pop,
#                          p_matrix,
#                          state_c_matrix,
#                          trans_c_matrix,
#                          state_q_matrix,
#                          n_cycles = 15,
#                          init_age = 55,
#                          s_names,
#                          t_names,
#                          discount_rate = 0.035)
# 
# save(test_data, file = "tests/testthat/testdata/test_data.rda")
