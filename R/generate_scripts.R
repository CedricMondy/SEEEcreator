#' @importFrom dplyr "%>%"
generate_scripts <- function(source,
                             documents = c("server", "user", "data"),
                             version,
                             test = FALSE) {

  # Remove placeholders
  source_content <- readLines(con = source, skipNul = FALSE) %>%
    gsub(x = ., pattern = "##==<.*>==##", replacement = "")

  section_location <- which(grepl("#>", source_content))

  # Comment/uncomment the line controlling the printing of warnings

  optLoc <- which(grepl("options(warn", source_content, fixed = TRUE))

  if(test) {
    source_content[optLoc] <- paste0("#", source_content[optLoc])
  } else {
    source_content[optLoc] <- gsub(pattern = "#", replacement = "",
                                   x = source_content[optLoc])
  }

  # Automatic filling of header fields
  ## Date
  dateLoc <- which(grepl("# Date", source_content))
  source_content[dateLoc] <- gsub(pattern = ":",
                                  replacement = paste0(": ", Sys.Date()),
                                  x = source_content[dateLoc])
  ## Index version
  vLoc <- which(grepl("# Version", source_content))
  source_content[vLoc] <- gsub(pattern = ":",
                               replacement = paste0(": ", version),
                               x = source_content[vLoc])
  ## R version used
  RLoc <- which(grepl("# Interpreteur", source_content))
  source_content[RLoc] <- gsub(pattern = ":",
                               replacement = paste0(": ",
                                                    R.Version()$version.string),
                               x = source_content[RLoc])
  ## Packages needed
  depLoc   <- which(grepl("# Pre-requis", source_content))
  pkgs   <- source_content[which(grepl("dependencies <-",
                                       source_content))] %>%
    gsub(pattern     = "dependencies <- ",
         replacement = "")                               %>%
    (function(x) parse(text = x))                        %>%
    eval()
  source_content[depLoc] <- gsub(pattern     = ":",
                                 replacement = paste0(": Packages ",
                                                      paste(pkgs,
                                                            collapse = ", ")
                                                      ),
                                 x = source_content[depLoc])

  # Automatic filling of indicator and version
  indic <- gsub(x = source, pattern ="_Validation.r", replacement = "") %>%
    gsub(x = ., pattern = "_Calcul.r", replacement = "")

  indicLoc <- which(grepl("indic  <- ", source_content))
  source_content[indicLoc] <- gsub(pattern = "<-.+$",
                                   replacement = paste0("<- \"", indic, "\""),
                                   x = source_content[indicLoc])

  vLoc <- which(grepl("vIndic <-", source_content))
  source_content[vLoc] <- gsub(pattern     = "<-.+$",
                               replacement = paste0("<- \"v", version, "\""),
                               x = source_content[vLoc])


  # Separate the user, server and data sections
  element_location <- 1:length(source_content)

  element_section <- lapply(section_location,
                            function(i){
                              ifelse(element_location >= i, i, FALSE)
                              }) %>%
    do.call(what = cbind)        %>%
    apply(MARGIN = 1, max)
  element_section <- gsub(source_content[element_section],
                          pattern     = "#> ",
                          replacement = "")

  save_document <- function(d) {
    is_document_part <- grepl(d, element_section)

    document_content <- source_content[is_document_part &
                                         !grepl("#>", source_content)]
    fileLoc <- which(grepl("# Fichiers lies", document_content))
    dataFiles <- NULL

    if (d %in% "server") {
      ## Related files
      if (any(grepl("data", source_content[section_location]))) {
        dataFiles <- gsub(pattern = "Calcul.r|Calcul.R",
                          replacement = paste0("v", version, "_calc_fun.RData"),
                          x = source) %>%
          gsub(pattern = "Validation.r|Validation.R",
               replacement = paste0("v", version, "_valid_fun.RData")
          )
      }

      document_content[fileLoc] <- gsub(pattern = ":",
                                        replacement = paste0(": ",
                                                             paste(dataFiles,
                                                                   collapse = ", ")
                                                           ),
                                      x = document_content[fileLoc]
                                      )

      output <- gsub(x           = source,
                     pattern     = "Calcul",
                     replacement = paste0("v", version, "_calc"),
                     fixed       = TRUE) %>%
        gsub(x           = .,
             pattern     = "Validation",
             replacement = paste0("v", version, "_valid"),
             fixed       = TRUE)

      writeLines(text = document_content, con = output)
    }
    if (d %in% "user") {
      ## Related files
      dataFiles <- list.files(pattern = "_params_")

      document_content[fileLoc] <- gsub(pattern = ":",
                                      replacement = paste0(": ",
                                                           paste(dataFiles,
                                                                 collapse = ", ")
                                      ),
                                      x = document_content[fileLoc]
      )

      output <- gsub(x           = source,
                     pattern     = "Calcul",
                     replacement = paste0("v", version, "_calc_consult"),
                     fixed       = TRUE) %>%
        gsub(x           = .,
             pattern     = "Validation",
             replacement = paste0("v", version, "_valid_consult"),
             fixed       = TRUE)

      writeLines(text = document_content, con = output)
    }

    if (d %in% "data") {
      output <- gsub(x           = source,
                     pattern     = "Calcul.r",
                     replacement = paste0("v", version, "_calc_fun.RData"),
                     fixed       = TRUE) %>%
        gsub(x           = .,
             pattern     = "Validation.r",
             replacement = paste0("v", version, "_valid_fun.RData"),
             fixed       = TRUE)

      temp_output <- tempfile(fileext = ".R")

      writeLines(text = document_content, con = temp_output)

      rm(list = ls()[!ls() %in% c("output", "temp_output")])

      source(file = temp_output,local = TRUE, echo = FALSE)

      list1 <- ls()[!ls() %in% c("output", "temp_output")]

      save(list = list1, file = output)

    }
  }

  for (d in documents) {
    save_document(d)
  }
  rm()

  return(NULL)
}
