#' Set up renv packages
#'
#' Set up a project library and install the specified (by default SEEE server)
#' package list
#'
#' @param package_list a data frame (or a named list) with two columns
#'   (elements): Package containing the name of the packages to install and
#'   Version containing the specific version to install (if no specific version
#'   required use "")
#'
#' @return
#' @export
#'
#' @examples
set_renv <- function(package_list = NULL) {

  if (is.null(package_list)) package_list <- SEEEcreator::package_server

  # There is some issues with installing the sources of these package version
  # installed on the SEEE server
  if (package_list$Version[package_list$Package == "ranger"] == "0.9.0" |
      package_list$Version[package_list$Package == "XML"] == "3.98-1.10") {
    package_list$Version[package_list$Package %in% c("XML", "ranger")] <- ""
  }

    to_install <- c(paste0(package_list$Package,
                          ifelse(package_list$Version == "", "", "@"),
                          package_list$Version),
                   "CedricMondy/SEEEcreator")

    cat("First installation can be long, be patient...\n    Packages to install:\n")
    print(to_install)

    renv::init(bare = TRUE,
               restart = FALSE)
    renv::install(packages = to_install,
            library = NULL,
            project = NULL)

}
