#' Calculate Plant Stress Response Index (PSRI)
#'
#' This function calculates the Plant Stress Response Index from time-series
#' germination data with optional radicle vigor integration.
#'
#' @param germination_counts Numeric vector of cumulative germination counts
#'   at each time point (length 3 for days 3, 5, 7)
#' @param time_points Numeric vector of time points in days (default: c(3, 5, 7))
#' @param total_seeds Integer, total number of seeds in the replicate
#' @param species Character string, species name for identification
#' @param radicle_summary Optional list containing radicle data
#' @param diseased_counts Optional numeric vector of diseased seed counts
#'
#' @return A list containing PSRI components and metrics
#' @export
#' @examples
#' result <- calculate_psri(
#'   germination_counts = c(5, 8, 10),
#'   time_points = c(3, 5, 7),
#'   total_seeds = 15,
#'   species = 'corn'
#' )
#' print(result$PSRI)
#'
#' @references
#' Walne, C.H., Gaudin, A., Henry, W.B., and Reddy, K.R. (2020). In vitro seed
#' germination response of corn hybrids to osmotic stress conditions.
#' Agrosystems, Geosciences & Environment, 3(1), e20087.
#' \doi{10.1002/agg2.20087}
calculate_psri <- function(germination_counts, time_points = c(3, 5, 7),
                          total_seeds, species, radicle_summary = NULL,
                          diseased_counts = NULL) {
  
  # Apply diseased count adjustments if available
  if (!is.null(diseased_counts) && length(diseased_counts) == length(germination_counts)) {
    adjusted_germination <- pmax(0, germination_counts - diseased_counts)
    total_diseased <- sum(diseased_counts, na.rm = TRUE)
  } else {
    adjusted_germination <- germination_counts
    total_diseased <- 0
  }
  
  # Calculate MSG: Maximum Stress-adjusted Germination
  final_germinated <- max(adjusted_germination, na.rm = TRUE)
  MSG <- final_germinated / total_seeds
  
  # Calculate MRG: Maximum Rate of Germination
  daily_rates <- c()
  for (i in 2:length(time_points)) {
    time_diff <- time_points[i] - time_points[i-1]
    germ_diff <- max(0, adjusted_germination[i] - adjusted_germination[i-1])
    if (time_diff > 0) {
      daily_rate <- germ_diff / time_diff / total_seeds
      daily_rates <- c(daily_rates, daily_rate)
    }
  }
  
  if (length(daily_rates) > 0) {
    MRG <- mean(daily_rates, na.rm = TRUE) * max(time_points)
  } else {
    MRG <- 0.1
  }
  
  # Calculate MTG: Mean Time to Germination
  target_germination <- final_germinated * 0.5
  t50 <- NA
  
  for (i in 1:(length(adjusted_germination)-1)) {
    if (adjusted_germination[i] <= target_germination &&
        adjusted_germination[i+1] >= target_germination) {
      if (adjusted_germination[i+1] > adjusted_germination[i]) {
        fraction <- (target_germination - adjusted_germination[i]) /
                   (adjusted_germination[i+1] - adjusted_germination[i])
        t50 <- time_points[i] + fraction * (time_points[i+1] - time_points[i])
      } else {
        t50 <- time_points[i]
      }
      break
    }
  }
  
  if (is.na(t50)) {
    if (final_germinated > 0) {
      weights <- diff(c(0, adjusted_germination))
      weighted_times <- weights * time_points
      t50 <- sum(weighted_times, na.rm = TRUE) / sum(weights, na.rm = TRUE)
    } else {
      t50 <- max(time_points)
    }
  }
  
  MTG <- t50 / max(time_points)
  
  # Calculate base PSRI
  PSRI_base <- (MSG * MRG * (1 - MTG))^(1/3)
  
  # Radicle vigor integration
  radicle_vigor_factor <- 1.0
  if (!is.null(radicle_summary) && radicle_summary$total_count > 0) {
    if (radicle_summary$total_count >= 15) {
      radicle_vigor_factor <- 1.10
    } else if (radicle_summary$total_count >= 8) {
      radicle_vigor_factor <- 1.05
    }
  }
  
  PSRI_final <- PSRI_base * radicle_vigor_factor
  
  return(list(
    MSG = MSG,
    MRG = MRG,
    MTG = MTG,
    PSRI = PSRI_final,
    PSRI_base = PSRI_base,
    t50 = t50,
    final_germinated = final_germinated,
    germination_rate = MSG,
    radicle_vigor_factor = radicle_vigor_factor,
    species = species
  ))
}
