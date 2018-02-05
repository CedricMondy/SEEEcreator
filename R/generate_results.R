generate_results <- function(calc, inputFiles) {
  calc_content <- readLines(con = calc, skipNul = FALSE)

  argsLoc <- which(grepl("arguments.*<-.*commandArgs", calc_content))
  calc_content[argsLoc] <- paste0('arguments <- c("',
                                  paste(inputFiles, collapse = '", "'),
                                  '")')

  temp_output <- tempfile(fileext = ".R")

  writeLines(text = calc_content, con = temp_output)
  source(temp_output)

  return(NULL)
}
