#' @importFrom dplyr "%>%"
extract_version <- function(indic) {
  source_content <- readLines(con = paste0(indic, "_Calcul.r"), skipNul = FALSE)

  vLoc     <- which(grepl("vIndic <-", source_content))
  vIndic   <- source_content[vLoc]                       %>%
    gsub(pattern = "vIndic", replacement = "")           %>%
    gsub(pattern = "<-", replacement = "")               %>%
    gsub(pattern = "\"", replacement = "", fixed = TRUE) %>%
    gsub(pattern = " ", replacement = "")

  return(vIndic)
}
