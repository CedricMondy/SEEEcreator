generate_exchange <- function(source, version) {
  source_content <- readLines(con = source, skipNul = FALSE)

  indic <- gsub(x = source, pattern = "_Format_echange.Rmd", replacement = "")

  indicLoc  <- which(grepl(pattern = "indic  <-", x = source_content))
  vIndicLoc <- which(grepl(pattern = "vIndic <- ", x = source_content))

  source_content[indicLoc] <- gsub(x            = source_content[indicLoc],
                                   pattern      = "\"\"",
                                   replacement  = paste0("\"", indic, "\""))
  source_content[vIndicLoc] <- gsub(x           = source_content[vIndicLoc],
                                    pattern     = "\"\"",
                                    replacement = paste0("\"v", version, "\""))

  writeLines(text     = source_content,
             con      = gsub(x           = source,
                             pattern     = "Format_echange",
                             replacement = "Format_echange_temp"),
             useBytes = TRUE)
}
