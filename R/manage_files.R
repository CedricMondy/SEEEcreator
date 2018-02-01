create_dir <- function(path) {
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)

  return(NULL)
}

copy_files <- function(files, from = NULL, to = NULL) {
  if (is.null(from)) {
    from2 <- files
  } else {
    from2 <- paste0(from, "/", files)
  }

  if (is.null(to)) {
    to2 <- files
  } else {
    to2 <- paste0(to, "/", files)
  }

  file.copy(from = from2, to = to2)

  return(NULL)
}
