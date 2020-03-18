detach_packages = function() {
  suppressWarnings(
    suppressMessages({
    invisible(lapply(names(sessionInfo()$loadedOnly), require, character.only = TRUE))
    invisible(lapply(paste0('package:', names(sessionInfo()$otherPkgs)), detach, character.only=TRUE, unload=TRUE, force=TRUE))
    })
  )
}
