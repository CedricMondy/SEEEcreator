generate_results <- function(calc, inputFiles) {
  calc_content <- readLines(con = calc, skipNul = FALSE)

  argsLoc <- which(grepl("arguments *<- *commandArgs", calc_content))
  calc_content[argsLoc] <- paste0('arguments <- c("',
                                  paste(inputFiles, collapse = '", "'),
                                  '")')

  indicLoc <- which(grepl("indic *<- *", calc_content))
  indic <- gsub(x           = calc_content[[indicLoc]],
                pattern     = "indic *<- *\"|\"",
                replacement = "")

  vIndicLoc <- which(grepl("vIndic *<- *", calc_content))
  vIndic <- gsub(x           = calc_content[[vIndicLoc]],
                 pattern     = "vIndic *<- *\"|\"",
                 replacement = "")

  resultLoc     <- which(grepl("fichierResultat *<- *", calc_content))
  calc_content[[resultLoc]] <- paste0("fichierResultat <- \"", indic, "_", vIndic, "_resultats.csv\"")

  resultCompLoc <- which(grepl("fichierResultatComplementaire *<- *", calc_content))
  calc_content[[resultCompLoc]] <- paste0("fichierResultatComplementaire <- \"", indic, "_", vIndic, "_resultats_complementaires.csv\"")

  temp_output <- tempfile(fileext = ".R")

  writeLines(text = calc_content, con = temp_output)
  source(temp_output)

  return(NULL)
}
