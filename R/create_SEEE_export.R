#' Create a SEEE export
#'
#' Create the folder and files necessary to upload to the SEEE server in order
#' to implement a new indicator
#'
#' @param indic the name of the indicator as it is in the names of the
#'   development files (ending with _valid.r and _calc.r)
#' @param paramFiles a character vector with the names of the tables and data
#'   that are not user-supplied but necessary for the indicator to be calculated
#'   (e.g. indicator value tables)
#' @param inputFiles a character vector with the names of the files used to
#'   provide exemples in the import_export documentation
#'
#' @importFrom dplyr "%>%"
#' @importFrom utils zip
#' @export
create_SEEE_export <- function(indic, paramFiles, inputFiles) {

  # Get the indicator version
  vIndic <- extract_version(indic)

  # Generate user and server files
  generate_scripts(source = paste0(indic, "_Validation.r"), version = vIndic)
  generate_scripts(source = paste0(indic, "_Calcul.r"),     version = vIndic)

  # Create the folder structure
  if (dir.exists(paste0("serverSEEE_", vIndic))) {
    unlink(x         = paste0("serverSEEE_", vIndic),
           recursive = TRUE)
  }
  create_dir(path = paste0("serverSEEE_", vIndic, "/",
                           indic, "/Documentation"))

  # Copy the JSON file
  copy_files(files = paste0(indic, "_", vIndic, ".json"),
             to    = paste0("serverSEEE_", vIndic))


  # Copy the server files
  copy_files(files = paste0(indic, "_", vIndic) %>%
               paste0(., c("_valid.r", "_valid_fun.RData",
                           "_calc.r", "_calc_fun.RData")),
             to    = paste0("serverSEEE_", vIndic, "/", indic))

  # Create the archive with the user scripts
  zip(zipfile = paste0("serverSEEE_", vIndic, "/", indic, "/Documentation/",
                       indic, "_", vIndic, "_Documentation_scripts.zip"),
      files = c(paste0(indic, "_", vIndic, "_valid_consult.r"),
                paste0(indic, "_", vIndic, "_calc_consult.r"),
                paramFiles))

  # Generate the results corresponding to the input files
  generate_results(calc       = paste0(indic, "_", vIndic, "_calc.r"),
                   inputFiles = inputFiles)

  # Create the archive with the import/export files
  zip(zipfile = paste0("serverSEEE_", vIndic, "/", indic, "/Documentation/",
                       indic, "_", vIndic, "_Import_export.zip"),
      files = c(inputFiles,
                paste0(indic, "_", vIndic, "_resultats.csv")))

  # Clean up the directory
  file.remove(paste0(indic, "_", vIndic) %>%
                paste0(., c("_valid.r", "_valid_fun.RData", "_valid_consult.r",
                            "_calc.r", "_calc_fun.RData", "_calc_consult.r",
                            "_resultats.csv")))
}
