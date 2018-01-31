#' @importFrom dplyr "%>%"
generate_scripts <- function(source, documents = c("server", "user", "data"), version) {

  source_content <- readLines(con = source, skipNul = FALSE)

  element_location <- 1:length(source_content)

  section_location <- which(grepl("#>", source_content))

  element_section <- lapply(section_location,
                            function(i){
                              ifelse(element_location >= i, i, FALSE)
                              }) %>%
    do.call(what = cbind) %>%
    apply(MARGIN = 1, max)
  element_section <- gsub(source_content[element_section],
                          pattern     = "#> ",
                          replacement = "")

  save_document <- function(d) {
    is_document_part <- grepl(d, element_section)

    document_content <- source_content[is_document_part &
                                         !grepl("#>", source_content)]

    if (d %in% "server") {
      output <- gsub(x           = source,
                     pattern     = "Calcul",
                     replacement = paste0(version, "_calc"),
                     fixed       = TRUE) %>%
        gsub(x           = .,
             pattern     = "Validation",
             replacement = paste0(version, "_valid"),
             fixed       = TRUE)

      writeLines(text = document_content, con = output)
    }
    if (d %in% "user") {
      output <- gsub(x           = source,
                     pattern     = "Calcul",
                     replacement = paste0(version, "_calc_consult"),
                     fixed       = TRUE) %>%
        gsub(x           = .,
             pattern     = "Validation",
             replacement = paste0(version, "_valid_consult"),
             fixed       = TRUE)

      writeLines(text = document_content, con = output)
    }

    if (d %in% "data") {
      output <- gsub(x           = source,
                     pattern     = "Calcul.r",
                     replacement = paste0(version, "_calc_fun.RData"),
                     fixed       = TRUE) %>%
        gsub(x           = .,
             pattern     = "Validation.r",
             replacement = paste0(version, "_valid_fun.RData"),
             fixed       = TRUE)

      temp_output <- tempfile(fileext = ".R")

      writeLines(text = document_content, con = temp_output)

      rm(list = ls()[!ls() %in% c("output", "temp_output")])

      source(file = temp_output, echo = FALSE, local = TRUE)

      list1 <- ls()[!ls() %in% c("output", "temp_output")]

      save(list = list1, file = output)

    }
  }

  for (d in documents) {
    save_document(d)
  }
  rm()
}
