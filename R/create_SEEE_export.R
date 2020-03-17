#' Create a SEEE export
#'
#' Create the folder structure and files necessary to upload to the SEEE server
#' in order to implement a new indicator
#'
#' @param indic the name of the indicator
#'
#' @param additionalInput values of additional inputs (not files, e.g.
#'   TRUE/FALSE for additional output)
#'
#' @param test logical should the warnings be printed (useful when testing)
#'
#' @importFrom dplyr "%>%"
#' @importFrom utils zip
#' @importFrom rmarkdown render
#' @export
create_SEEE_export <- function(indic, additionalInput = NULL, test = FALSE) {

  warning("The R version on the SEEE server is not compatible with RData objects saved with recent versions of R. Please ensure that you use a compatible version of R (3.5.3 is advised)")

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
  exportPath <- paste0("Exports/", indic, " v", vIndic)

  if (dir.exists(exportPath)) {
    unlink(x         = exportPath,
           recursive = TRUE)
  }
  create_dir(path = paste0(exportPath, "/", indic, "/Documentation"))

  # Copy the server files
  fileList <- list.files(pattern = "_valid.r|_valid_fun.RData|_calc.r|_calc_fun.RData|_model")
  copy_files(files = fileList,
             to    = paste0(exportPath, "/", indic))

  # Create the archive with the user scripts
  zip(zipfile = paste0(exportPath, "/", indic, "/Documentation/",
                       indic, "_v", vIndic, "_Documentation_scripts.zip"),
      files = c(paste0(indic, "_CHANGELOG.txt"),
                paste0(indic, "_v", vIndic, "_valid_consult.r"),
                paste0(indic, "_v", vIndic, "_calc_consult.r"),
                paramFiles))

  # Generate the results corresponding to the input files
  generate_results(calc       = paste0(indic, "_v", vIndic, "_calc.r"),
                   inputFiles = inputFiles)

  # Create the archive with the import/export files
  zip(zipfile = paste0(exportPath, "/", indic, "/Documentation/",
                       indic, "_v", vIndic, "_Import_export.zip"),
      files = c(inputFiles,
                list.files(pattern = paste0(indic, "_v", vIndic, "_resultats")),
                list.files(pattern = paste0(indic, "_supplement"))))

  # Create the exchange file format pdf document
  generate_exchange(source = paste0(indic, "_Format_echange.Rmd"),
                    version = vIndic)

  render(input       = paste0(indic, "_Format_echange_temp.Rmd"),
         output_file = paste0(exportPath, "/", indic, "/Documentation/",
                              indic, "_v", vIndic, "_Format_echange.pdf"),
         output_options = list(latex_engine = "xelatex"),
         encoding = "UTF-8")

  # Create the JSON file
  generate_json(indic = indic, vIndic = vIndic, exportPath = exportPath)

  # Clean up the directory
  file.remove(list.files(pattern = "_valid|_calc|_resultats|Format_echange_temp|radarPlots"))
}
