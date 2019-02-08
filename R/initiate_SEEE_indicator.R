#' Initiate a SEEE indicator
#'
#' This function allows to generate the template files necessary to develop a
#' SEEE indicator. Basic information about indicator name, type and authors are
#' added to the files.
#'
#' @param indic string. The name of the indicator as it it will be used in
#'   SEEE
#' @param type string. The type of indicator (e.g. Outil d'évaluation, Outil
#'   de diagnostic, beta-test)
#' @param author string. The names of the indicator authors
#'
#' @return nothing. Writes in the current directory the template files necessary
#'   to develop a SEEE indicator
#'
#' @export
#'
initiate_SEEE_indicator <- function(indic, type = "Outil d'évaluation", author = "", version = "1.0.0"){
  indic   <- enc2utf8(indic)
  type    <- enc2utf8(type)
  author  <- enc2utf8(author)
  version <- enc2utf8(version)

  # Génère le fichier json
  json    <- template_json
  json[2] <- gsub(x           = json[2],
                  pattern     = "\"\"",
                  replacement = paste0("\"", type, "\""),
                  fixed       = TRUE)
  json[3] <- gsub(x           = json[3],
                  pattern     = "\"\"",
                  replacement = paste0("\"", indic, "\""),
                  fixed       = TRUE)
  json[4] <- gsub(x           = json[4],
                  pattern     = "\"\"",
                  replacement = paste0("\"", version, "\""))

  # Génère le fichier de validation
  validation     <- template_validation
  validation[2]  <- gsub(x = validation[2], pattern = ":",
                         replacement = paste0(": ", indic))
  validation[3]  <- gsub(x = validation[3], pattern = ":",
                         replacement = paste0(": ", author))
  validation[11] <- paste(validation[11], format(Sys.Date(), "%Y"), author)

  # Génère le fichier de calcul
  calcul     <- template_calcul
  calcul[2]  <- gsub(x = calcul[2], pattern = ":",
                     replacement = paste0(": ", indic))
  calcul[3]  <- gsub(x = calcul[3], pattern = ":",
                     replacement = paste0(": ", author))
  calcul[11] <- paste(calcul[11], format(Sys.Date(), "%Y"), author)

  # Génère le fichier de format d'échange
  echange    <- template_echange

  # Génère le CHANGELOG
  changelog  <- template_changelog

  # Exporte les fichiers
  writeLines(text     = changelog,
             con      = paste0(indic, "_CHANGELOG.txt"),
             useBytes = TRUE)
  writeLines(text     = json,
             con      = paste0(indic, "_JSON.json"),
             useBytes = TRUE)
  writeLines(text     = validation,
             con      = paste0(indic, "_Validation.r"),
             useBytes = TRUE)
  writeLines(text     = calcul,
             con      = paste0(indic, "_Calcul.r"),
             useBytes = TRUE)
  writeLines(text     = echange,
             con      = paste0(indic, "_Format_echange.Rmd"),
             useBytes = TRUE)

  # Créer des dossier supplémentaires
  dir.create(path = "Documentation", showWarnings = FALSE)
  dir.create(path = "Tests",         showWarnings = FALSE)
  dir.create(path = "Exports",       showWarnings = FALSE)

}
