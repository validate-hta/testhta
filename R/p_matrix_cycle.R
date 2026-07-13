
#' @title Time-dependent probability matrix
#' 
#' @description Calculates time-dependent transition probabilities for a Markov model
#' 
#' @param p_matrix The base transition probability matrix
#' @param age The age of the individual
#' @param cycle The current cycle number
#' @param tpProg The probability of progression from asymptomatic to progressive disease
#' @param tpDcm The probability of death from progressive disease
#' @param effect The effectiveness of the drug
#' @param p_healthy_death Optional override for transition probability from healthy to dead
#' @param p_sick_death Optional override for transition probability from sick to dead
#' @param ... Extra arguments
#' @return The updated transition probability matrix
#' @export
p_matrix_cycle <- function(p_matrix, age, cycle,
                           tpProg = 0.01,
                           tpDcm = 0.15,
                           effect = 0.5,
                           p_healthy_death = NULL,
                           p_sick_death = NULL,
                           ...) {

  age_grp <- cut(age, breaks = c(34,44,54,64,74,84,Inf))
  tpDn <- tpDn_lookup()[age_grp]
  
  # Check if p_matrix was pre-configured with all 1 or all 0 for transitions from alive states to Dead
  alive_states <- c("Asymptomatic_disease", "Progressive_disease")
  if (all(p_matrix[alive_states, "Dead", ] == 1)) {
    p_healthy_death <- 1
    p_sick_death <- 1
  } else if (all(p_matrix[alive_states, "Dead", ] == 0)) {
    p_healthy_death <- 0
    p_sick_death <- 0
  }

  if (!is.null(p_healthy_death)) {
    tpDn <- p_healthy_death
  }
  
  tpProg_dead_without <- tpDcm + tpDn
  tpProg_dead_with <- tpDcm + tpDn
  if (!is.null(p_sick_death)) {
    tpProg_dead_without <- p_sick_death
    tpProg_dead_with <- p_sick_death
  }

  tpProg_cycle_without <- tpProg * cycle
  tpProg_cycle_with <- tpProg * (1 - effect) * cycle

  if (tpDn == 1) {
    tpProg_cycle_without <- 0
    tpProg_cycle_with <- 0
  }

  # Matrix containing transition probabilities for without_drug
  p_matrix["Asymptomatic_disease", "Progressive_disease", "without_drug"] <- tpProg_cycle_without
  p_matrix["Asymptomatic_disease", "Dead", "without_drug"] <- tpDn
  p_matrix["Asymptomatic_disease", "Asymptomatic_disease", "without_drug"] <- 1 - tpProg_cycle_without - tpDn
  p_matrix["Progressive_disease", "Dead", "without_drug"] <- tpProg_dead_without
  p_matrix["Progressive_disease", "Progressive_disease", "without_drug"] <- 1 - tpProg_dead_without
  p_matrix["Dead", "Dead", "without_drug"] <- 1
  
  # Matrix containing transition probabilities for with_drug
  p_matrix["Asymptomatic_disease", "Progressive_disease", "with_drug"] <- tpProg_cycle_with
  p_matrix["Asymptomatic_disease", "Dead", "with_drug"] <- tpDn
  p_matrix["Asymptomatic_disease", "Asymptomatic_disease", "with_drug"] <-
    1 - tpProg_cycle_with - tpDn
  p_matrix["Progressive_disease", "Dead", "with_drug"] <- tpProg_dead_with
  p_matrix["Progressive_disease", "Progressive_disease", "with_drug"] <- 1 - tpProg_dead_with
  p_matrix["Dead", "Dead", "with_drug"] <- 1
  
  return(p_matrix)
}

#' Look-up table for age-specific probabilities of death from non-disease causes
#' 
tpDn_lookup <- function() {
  c("(34,44]" = 0.0017,
    "(44,54]" = 0.0044,
    "(54,64]" = 0.0138,
    "(64,74]" = 0.0379,
    "(74,84]" = 0.0912,
    "(84,Inf]" = 0.1958)
}
