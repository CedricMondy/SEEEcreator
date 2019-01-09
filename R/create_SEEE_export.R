#' Create a SEEE export
#'
#' Create the folder and files necessary to upload to the SEEE server in order
#' to implement a new indicator
#'
#' @param indic the name of the indicator as it is in the names of the
#'   development files (ending with _valid.r and _calc.r)
#'
#' @param additionalInput values of additional inputs (not files, e.g. TRUE/FALSE)
#'
#' @param test logical should the warnings be printed (useful when testing)
#'
#' @importFrom dplyr "%>%"
#' @importFrom utils zip
#' @importFrom rmarkdown render
#' @export
create_SEEE_export <- function(indic, additionalInput = NULL, test = FALSE) {

  # Get the indicator version
  vIndic <- extract_version(indic)

  # Get the parameter files
  paramFiles <- list.files(pattern = paste0(indic, "_params"))

  # Get the input files
  inputFiles <- c(list.files(pattern = paste0(indic, "_entree")), additionalInput)

  # Generate user and server files
  generate_scripts(source = paste0(indic, "_Validation.r"), version = vIndic, test = test)
  generate_scripts(source = paste0(indic, "_Calcul.r"),     version = vIndic, test = test)

  # Create the folder structure
  exportPath <- paste0("Exports/", indic, " ", vIndic)

  if (dir.exists(exportPath)) {
    unlink(x         = exportPath,
           recursive = TRUE)
  }
  create_dir(path = paste0(exportPath, "/",
                           indic, "/Documentation"))

  # Copy the server files
  fileList <- list.files(pattern = "_valid.r|_valid_fun.RData|_calc.r|_calc_fun.RData|_model")
  copy_files(files = fileList,
             to    = paste0(exportPath, "/", indic))

  # Create the archive with the user scripts
  zip(zipfile = paste0(exportPath, "/", indic, "/Documentation/",
                       indic, "_", vIndic, "_Documentation_scripts.zip"),
      files = c(paste0(indic, "_", vIndic, "_valid_consult.r"),
                paste0(indic, "_", vIndic, "_calc_consult.r"),
                paramFiles))

  # Generate the results corresponding to the input files
  generate_results(calc       = paste0(indic, "_", vIndic, "_calc.r"),
                   inputFiles = inputFiles)

  # Create the archive with the import/export files
  zip(zipfile = paste0(exportPath, "/", indic, "/Documentation/",
                       indic, "_", vIndic, "_Import_export.zip"),
      files = c(inputFiles,
                list.files(pattern = paste0(indic, "_", vIndic, "_resultats")),
                list.files(pattern = paste0(indic, "_supplement"))))

  # Create the exchange file format pdf document
  render(input       = paste0(indic, "_Format_echange.Rmd"),
         output_file = paste0(exportPath, "/", indic, "/Documentation/",
                              indic, "_", vIndic, "_Format_echange.pdf"),
         output_options = list(latex_engine = "xelatex"),
         encoding = "UTF-8")

  # Create the JSON file
  generate_json(indic = indic, vIndic = vIndic, exportPath = exportPath)

  # Clean up the directory
  file.remove(list.files(pattern = "_valid|_calc|_resultats"))
}
