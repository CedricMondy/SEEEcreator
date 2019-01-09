generate_json <- function(indic, vIndic, exportPath) {
  vIndic2 <- gsub(vIndic, pattern = "v", replacement = "")
  content <- readLines(con = paste0(indic, "_JSON.json"))

  content[grepl("dossier", content)] <-
    gsub(content[grepl("dossier", content)],
         pattern = "\"\"",
         replacement = paste0("\"", indic, "\""))

  content[grepl("version", content)] <-
    gsub(content[grepl("version", content)],
         pattern = "\"\"",
         replacement = paste0("\"", vIndic2, "\""))

  content[grepl("script", content)] <-
    gsub(content[grepl("script", content)],
         pattern = "\"\"",
         replacement = paste0("\"", indic, "_", vIndic, "_calc.r", "\""))

  content[grepl("validation", content)] <-
    gsub(content[grepl("validation", content)],
         pattern = "\"\"",
         replacement = paste0("\"", indic, "_", vIndic, "_valid.r", "\""))

  content[grepl("format des fichiers d'entree et de sortie", content)] <-
    gsub(content[grepl("format des fichiers d'entree et de sortie", content)],
         pattern = "\"\"",
         replacement = paste0("\"", "Documentation/", indic, "_", vIndic,
                              "_Format_echange.pdf", "\""))

  content[grepl("acces algorithmes", content)] <-
    gsub(content[grepl("acces algorithmes", content)],
         pattern = "\"\"",
         replacement = paste0("\"", "Documentation/", indic, "_", vIndic,
                              "_Documentation_scripts.zip", "\""))

  content[grepl("jeu de donnees de reference", content)] <-
    gsub(content[grepl("jeu de donnees de reference", content)],
         pattern = "\"\"",
         replacement = paste0("\"", "Documentation/", indic, "_", vIndic,
                              "_Import_export.zip", "\""))

  writeLines(content, con = paste0(exportPath, "/", indic, "_", vIndic, ".json"))
  return(NULL)
}
