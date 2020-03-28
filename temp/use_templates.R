template_changelog  <- readLines("temp/template_changelog")
template_json       <- readLines("temp/template_json")
template_validation <- readLines("temp/template_validation")
template_calcul     <- readLines("temp/template_calcul")
template_echange    <- readLines("temp/template_echange")

usethis::use_data(template_changelog, template_json,
                  template_validation, template_calcul,
                  template_echange,
                  internal = TRUE, overwrite = TRUE)
