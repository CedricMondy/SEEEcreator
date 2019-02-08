#' @importFrom dplyr "%>%"
extract_version <- function(indic) {
  source_content <- readLines(con = paste0(indic, "_JSON.json"), skipNul = FALSE)

  vLoc     <- which(grepl("version.+:.+\\d\\.\\d\\.\\d", source_content))
  vIndic   <- source_content[vLoc]                       %>%
    gsub(pattern = "version", replacement = "", fixed = TRUE)           %>%
    gsub(pattern = ":", replacement = "")               %>%
    gsub(pattern = "\"", replacement = "", fixed = TRUE) %>%
    gsub(pattern = " ", replacement = "") %>%
    gsub(pattern = "\t", replacement = "") %>%
    gsub(pattern = ",", replacement = "")

  return(vIndic)
}
