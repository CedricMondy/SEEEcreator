
  - [SEEEcreator](#seeecreator)
  - [Installation](#installation)
  - [Déroulement typique](#déroulement-typique)
      - [Initialisation](#initialisation)
          - [Préparation des packages](#préparation-des-packages)
          - [Initialisation de
            l’intégration](#initialisation-de-lintégration)
      - [Intégration](#intégration)
          - [Le fichier CHANGELOG](#le-fichier-changelog)
          - [Le fichier JSON](#le-fichier-json)
          - [Les scripts R Validation et
            Calcul](#les-scripts-r-validation-et-calcul)
          - [Le format d’échange](#le-format-déchange)
      - [Export](#export)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# SEEEcreator

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Last-changedate](https://img.shields.io/badge/last%20change-2020--08--06-yellowgreen.svg)](/commits/master)
[![packageversion](https://img.shields.io/badge/Package%20version-0.1.7-orange.svg?style=flat-square)](commits/master)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/SEEEcreator)](https://cran.r-project.org/package=SEEEcreator)
<!-- badges: end -->

Le but de SEEEcreator est de fournir une méthode aussi standardisée que
possible pour le développement et l’intégration d’indicateurs de suivi
de la qualité écologique (dans le contexte de la Directive Européenne
Cadre sur l’Eau) au sein du [Système d’Evaluation de l’Etat des Eaux
(SEEE)](http://seee.eaufrance.fr/). Le SEEE fournit les algorithmes de
référence et un service de calcul pour les indicateurs officiels
utilisés en France pour l’évaluation des masses d’eau dans le cadre de
la DCE. Le SEEE est un projet de l’Office Français pour la Biodiversité
([OFB](https://ofb.gouv.fr/)).

# Installation

SEEEcreator n’est pas disponible sur le CRAN, son installation se fait
donc via [GitHub](https://github.com/) :

``` r
# install.packages("remotes")
remotes::install_github("CedricMondy/SEEEcreator")
```

# Déroulement typique

## Initialisation

### Préparation des packages

La première étape est de créer un projet RStudio dans un nouveau
dossier.

> Il est recommandé de versionner le contenu de ce dossier en utilisant
> git pour lequel RStudio offre des fonctionnalités.

Une fois le projet ouvert, commencer par installer les packages avec des
versions compatibles à celles installées sur le serveur du SEEE. Pour
cela, nous utilisons la commande `SEEEcreator::set_renv()` qui va
installer les packages dans la version spécifié dans
`SEEEcreator::package_server` depuis un miroir historisé du CRAN
(<https://mran.microsoft.com/snapshot/2019-04-15>). Ces packages seront
installés dans une librairie propre au projet et seront donc
indépendants de l’installation générale de R.

    #>         Package   Version
    #> 1          ade4    1.7-11
    #> 2    assertthat       0.1
    #> 3     backports     1.1.2
    #> 4        BBmisc      1.11
    #> 5            BH  1.62.0-1
    #> 6         bindr     0.1.1
    #> 7      bindrcpp     0.2.2
    #> 8     checkmate     1.8.5
    #> 9           cli     1.0.0
    #> 10   colorspace     1.3-2
    #> 11       crayon     1.3.4
    #> 12   data.table  1.10.4-3
    #> 13          DBI       0.6
    #> 14    dichromat     2.0-0
    #> 15       digest    0.6.15
    #> 16        dplyr     0.7.4
    #> 17      ggplot2     2.2.1
    #> 18         glue     1.2.0
    #> 19       gtable     0.2.0
    #> 20     labeling       0.3
    #> 21     lazyeval     0.2.0
    #> 22     magrittr       1.5
    #> 23          mlr    2.12.1
    #> 24      munsell     0.4.3
    #> 25  parallelMap       1.3
    #> 26 ParamHelpers      1.10
    #> 27      permute     0.9-4
    #> 28       pillar     1.2.1
    #> 29    pkgconfig     2.0.1
    #> 30        plogr     0.2.0
    #> 31         plyr     1.8.4
    #> 32        purrr     0.2.4
    #> 33           R6     2.2.0
    #> 34       ranger     0.9.0
    #> 35 RColorBrewer     1.1-2
    #> 36         Rcpp   0.12.16
    #> 37    RcppEigen 0.3.3.4.0
    #> 38     reshape2     1.4.3
    #> 39        rlang     0.2.0
    #> 40       scales     0.5.0
    #> 41      sfsmisc     1.1-0
    #> 42           sp     1.2-4
    #> 43      stringi     1.1.3
    #> 44      stringr     1.2.0
    #> 45       tibble     1.4.2
    #> 46        tidyr     0.8.0
    #> 47   tidyselect     0.2.4
    #> 48         utf8     1.1.3
    #> 49        vegan     2.4-2
    #> 50  viridisLite     0.3.0
    #> 51          XML 3.98-1.10

La première fois que l’on utilise cette fonction `set_renv` peut être
longue puisque les packages doivent être téléchargés et installés. Les
fois suivantes (pour d’autres projets d’indicateurs), cette étape sera
plus rapide car les packages installés auront été mis en cache et seront
directement appelés depuis le cache. Voir la [vignette de
renv](https://cran.r-project.org/web/packages/renv/vignettes/renv.html)
pour plus de détails. Cette étape installe également SEEEcreator dans la
librairie du projet.

> De nouveaux packages peuvent être installés de manière classique dans
> cette librairie du projet mais il faut garder à l’esprit que si de
> nouveaux packages sont nécessaires pour qu’un indicateur puisse être
> calculé, il faudra également les installer sur le serveur du SEEE.

### Initialisation de l’intégration

L’étape suivante est réalisée avec la fonction `initiate_SEEE_indicator`
qui crée les dossiers et fichiers nécessaires pour l’intégration d’un
indicateur:

``` r
SEEEcreator::initiate_SEEE_indicator(indic   = "Indicateur",
                                     type    = "Outil d'évaluation",
                                     author  = "Auteur du script",
                                     version = "1.0.0")
```

Les paramètres à renseigner sont les suivants:

  - `indic`: le nom/acronyme de l’indicateur développé;
  - `type`: le type d’indicateur tel qu’il apparaît dans l’interface du
    SEEE (‘Outil d’évaluation’ qui est le choix par défaut, ‘Outil de
    diagnostic’ ou ‘beta-test’);
  - `author`: le nom du ou des auteurs des scripts SEEE;
  - `version`: le numéro de version de l’indicateur (par défaut 1.0.0).

Cette commande crée les éléments suivants dans le dossier du projet:

    #>                           levelName
    #> 1 Projet                           
    #> 2  ¦--Documentation                
    #> 3  ¦--Tests                        
    #> 4  ¦--Exports                      
    #> 5  ¦--Indicateur_CHANGELOG.txt     
    #> 6  ¦--Indicateur_JSON.json         
    #> 7  ¦--Indicateur_Validation.r      
    #> 8  ¦--Indicateur_Calcul.r          
    #> 9  °--Indicateur_Format_echange.Rmd

Tous les documents fournis par les concepteurs de l’indicateur intégré
(description de la méthode, outils pré-existants…) sont à placer dans le
dossier **Documentation**.

Le dossier **Tests** est là pour centraliser tous les tests que l’on
peut réaliser sur l’indicateur. Attention, il ne s’agit pas ici de tests
unitaires tels qu’utilisés pour le développement de packages mais plutôt
de tester des versions/implantations particulières de l’indicateur, pour
(i) s’assurer de la conformité des résultats obtenus avec les résultats
fournis par les concepteurs ou des outils pré-existants, (ii) tester des
fichiers d’entrée posant problème (rapporté via l’assistance par
exemple), (iii) faire une étude d’impact lors de changement de version…

Le dossier **Export** n’est pas à modifier manuellement, il sera peuplé
automatiquement lors de la création d’exports par SEEEcreator, un
dossier sera crée pour chaque nouvelle version de l’indicateur (version
à renseigner dans le fichier json). On peut toutefois y placer des
versions précédentes de l’indicateur qui n’auraient pas été développées
en utilisant SEEEcreator, on centralise ainsi l’historique de
l’indicateur.

Les fichiers crées à la racine du projet (CHANGELOG, JSON, Validation,
Calcul et Format\_echange) sont tous préfixés par le nom de l’indicateur
donné via l’argument `indic`. Ce sont des fichiers pré-remplis pour
commencer directement l’intégration d’un indicateur dans un format
exportable sur le serveur du SEEE. Des balises sont insérées dans chacun
de ces fichiers sour la forme de commentaires écrit sous le format
suivant:

`##==< COMMENTAIRE >==##`

Ces balises contiennent des indications sur la manière de
remplir/compléter les fichiers et seront automatiquement supprimées des
exports SEEE.

## Intégration

### Le fichier CHANGELOG

`Indicateur_CHANGELOG.txt`

    CHANGELOG Indicateur
    
    Version 1.0.0
        Version initiale
    
    ##==< POUR LES VERSIONS ULTERIEURES DECRIRE ICI LES PRINCIPALES MODIFICATIONS >==##

**Ce fichier permet de tracer les évolutions majeures de l’indicateur
entre les versions successivement mises à disposition via le SEEE.**

### Le fichier JSON

`Indicateur_JSON.json`

``` json
{
 "type"         : "Outil d'évaluation",
 "dossier"      : "Indicateur",
 "version"      : "1.0.0",
 "script"       : "",
 "validation"   : "",
 "langage"      : "R",
 "entree"       :   {
                    "fichier_entree" :  {
                                        "type"  : "file",
                                        "label" : "##==< METTRE LE TYPE DE DONNEES ICI >==##"
                                        }
                    },
 "sortie"       : {
                  "complementaire" : {
                            "type" : "checkbox",
                            "label" : "##==< SI RESULTATS COMPLEMENTAIRES METTRE LE TYPE ICI, SINON SUPPRIMER TOUTE LA PARTIE sortie >==##"
                          }
                  },
 "synchrone"    : "10000",
 "documentation":   {
                    "format des fichiers d'entree et de sortie" : "",
                    "acces algorithmes" : "",
                    "jeu de donnees de reference"   : ""
                    },
 "commentaire"  : "##==< METTRE UN COURT DESCRIPTIF DE L'INDICATEUR ET LES REFERENCES DE LA METHODE >==##"
}
```

**Ce fichier sert à configurer l’intégration et l’affichage de
l’indicateur dans l’interface du SEEE.**

Les éléments `type`, `dossier` et `version` sont pré-remplis par la
fonction `initiate_SEEE_indicator`. Le numéro de version de l’indicateur
sera à modifier manuellement dans ce fichier au moment de chaque mise à
jour publiée de l’indicateur.

Les éléments `script` et `validation` seront remplis automatiquement
lors de la création d’exports SEEE.

L’élément `entree` décrit le fichier d’entrée demandé par l’interface
SEEE. Pour un indicateur basé sur les diatomées, on pourra par exemple
donner comme `label`: ‘Listes floristiques’. Si plusieurs fichiers
d’entrée sont nécessaires pour le calcul de l’indicateur, il faut les
ajouter ici en dupliquant et renommant le sous-élément `fichier_entree`.

L’élément `sortie` n’est utile que si l’indicateur propose une sortie
complémentaire, si aucune sortie complémentaire n’est proposée, cet
élément doit être supprimé.

L’élément `synchrone` détermine le nombre de lignes du fichier d’entrée
à partir duquel les calculs passent du mode synchrone au mode
asynchrone avec envoi des résultats par mail. A modifier en fonction des
performances de l’indicateur (on essaiera de le choisir pour que la
durée maximale de calcul en mode synchrone soit de 1 minute).

L’élément `documentation` contient les liens vers les fichiers
téléchargeables depuis le SEEE. Ces fichiers et les liens sont générés
automatiquement au moment de la création d’un export SEEE:

  - format des fichiers d’entree et de sortie: format d’échange au
    format pdf;
  - acces algorithmes: archive zip contenant les scripts de validation
    et calcul en version utilisateur plus les fichiers de paramètres
    nécessaires;
  - jeu de donnees de reference: une archive zip contenant des données
    d’entrée et les résultats correspondant.

L’élément `commentaire` contient typiquement une courte description de
l’indicateur et les références.

### Les scripts R Validation et Calcul

    Indicateur_Validation.r
    Indicateur_Calcul.r

> **Les deux fichiers suivants (Validation et Calcul) contiennent des
> commentaires spéciaux commençant par les symboles `#>` suivis de
> `user`, `server` et/ou `data`. Ces balises ne doivent en aucun cas
> être modifiées ou supprimées.** En effet, ces deux scripts sont des
> documents de travail à partir desquels seront générés des scripts
> destinés à deux usages différents: un pour l’exécution côté serveur de
> calcul (`server`) et l’autre pour une exécution locale (`user`). Ces
> deux utilisations différentes impliquent une gestion différente des
> entrées/sorties, pour celà le script de travail de travail contient
> des sections différentes destinées à une utilisation ou l’autre.
> Lorsque le code est commun aux deux utilisations, la balise le précise
> également. Ces balises sont reconnues par la fonction
> `SEEE::create_SEEE_export()` qui les utilisent pour créer les deux
> scripts (user et server) contenant les bonnes sections de code.

#### Parties communes

Les entêtes de ces scripts (commentées par des \#) sont complétées
automatiquement par la fonction `create_SEEE_export`, il ne faut donc
pas modifier les éléments Date, Version, Interpreteur, Pre-requis,
Fichiers lies et Commentaires manuellement. De même, les objets `indic`
et `vIndic` seront spécifiées automatiquement au moment de la création
de l’export SEEE.

``` r
#> user, server
# Type d'algorithme : Indicateur
# Auteur(s)         : auteur 1, auteur 2
# Date              :
# Version           :
# Interpreteur      :
# Pre-requis        :
# Fichiers lies     :
# Commentaires      :

# Copyright 2020 Cedric MONDY, Delphine CORNEIL
# Ce programme est un logiciel libre; vous pouvez le redistribuer ou le modifier
# suivant les termes de la GNU General Public License telle que publiee par la
# Free Software Foundation; soit la version 3 de la licence, soit (a votre gre)
# toute version ulterieure.
# Ce programme est distribue dans l'espoir qu'il sera utile, mais SANS AUCUNE
# GARANTIE; sans meme la garantie tacite de QUALITE MARCHANDE ou d'ADEQUATION A
# UN BUT PARTICULIER. Consultez la GNU General Public License pour plus de
# details.
# Vous devez avoir recu une copie de la GNU General Public License en meme temps
# que ce programme; si ce n'est pas le cas, consultez
# <http://www.gnu.org/licenses>.

#> user, server, data
## VERSION ----
indic  <- ""
vIndic <- ""
```

##### CHARGEMENT DES PACKAGES

Cette section permet de définir et charger les packages requis par le
script. Si des packages sont nécessaires, c’est à cet endroit qu’ils
doivent être spécifiés en utilisant l’objet `dependencies`.

``` r
## CHARGEMENT DES PACKAGES ----
dependencies <- c("dplyr") ##==< SI BESOIN D'AUTRES PACKAGES, LES INCLURE ICI. ATTENTION A CE QU'ILS SOIENT BIEN INSTALLES SUR LE SERVEUR (VOIR SEEEcreator::package_server) >==##

loadDependencies <- function(dependencies) {
  suppressAll <- function(expr) {
    suppressPackageStartupMessages(suppressWarnings(expr))
  }

  lapply(dependencies,
         function(x)
         {
           suppressAll(library(x, character.only = TRUE))
         }
  )
  invisible()
}

loadDependencies(dependencies)
```

##### FICHIERS DE CONFIGURATION

Si des données non fournies dans les fichiers d’entrée sont nécessaires
au calcul de l’indicateur, elles doivent être importées ici.

> Les fichiers de configuration/paramètres (e.g. des tables de
> transcodage ou des valeurs de coefficients) doivent être nommés en
> suivant la convention suivante: `Indicateur_params_nomFichier.ext`.
> L’utilisation du nom de l’indicateur suivi de `_params_` permettra à
> la fonction `create_SEEE_export` de reconnaitre ces fichiers et de les
> inclure dans l’archive zip à télécharger.

``` r
## IMPORT DES FICHIERS DE CONFIGURATION ----

##==< IMPORTER ICI LES EVENTUELS FICHIERS DE CONFIGURATION (FICHIERS COMPRENANT _params DANS LEUR NOM) >==##

params <- read.csv2("Indicateur_params_typeParametre.csv")
```

##### DECLARATION DES FONCTIONS

C’est dans cette section que l’on définit les fonctions personnalisées
qui seront utilisées dans le script. Cette section est centrale dans le
script de Calcul.

``` r
## DECLARATION DES FONCTIONS ----

##==< AJOUTER ICI LES DEFINITIONS DES FONCTIONS PERMETTANT DE CALCULER L'INDICATEUR >==##

## Fonction permettant de faire les arrondis a l'inferieur si 0 a 4 et au superieur si 5 a 9
funArrondi <- function (x, digits = 0) {
  .local <- function(x, digits) {
    x <- x * (10^digits)
    ifelse(abs(x%%1 - 0.5) < .Machine$double.eps^0.5,
           ceiling(x)/(10^digits),
           round(x)/(10^digits))
  }

  if (is.data.frame(x))
    return(data.frame(lapply(x, .local, digits)))
  .local(x, digits)
}

## Fonction initialisant le fichier de sortie
funSortie <- function(data_entree, paramsOut, ...) {
  select(data_entree, ...) %>%
    distinct()             %>%
    (function(df) {
      df[rep(1:nrow(df), each = nrow(paramsOut)),] %>%
        as.tbl()
    })                     %>%
    mutate(CODE_PAR = rep(paramsOut$CODE_PAR,
                          n() / nrow(paramsOut)),
           LIB_PAR  = rep(paramsOut$LIB_PAR,
                          n() / nrow(paramsOut)))
}
```

> Pour le script de Validation, on ne devrait pas avoir à modifier cette
> section, toutes les fonctions de validation étant comprises dans le
> modèle de document. Si une nouvelle fonction de validation devait être
> ajoutée, il faudrait l’ajouter au script modèle dans SEEEcreator afin
> que les futurs indicateurs en bénéficient également.

##### INITIALISATION DU TRAITEMENT & IMPORT DES FICHIERS

Dans ces sections, on définit les fichiers d’entrée, soit par ordre des
arguments passés depuis le SEEE (`server`), soit par le nom des fichiers
(`user`).

> Les noms de fichier d’entrée doivent suivre la convention suivante
> pour être reconnus par la fonction `create_SEEE_export`:
> `Indicateur_entree_nomFichier.ext`.

Les fichiers sont ensuite importés, on peut spécifier à ce moment, dans
le script de Calcul, le type (caractère, numérique, date) des
différentes colonnes.

``` r
## INITIALISATION DU TRAITEMENT ----
# Ne pas afficher les messages d'avis
options(warn = -1)

# Recuperation du fichier d'entree
##==< SI PLUSIEURS FICHIERS D'ENTREE AJOUTER LES DANS LES DEUX PARTIES (server et user) >==##
#> server
arguments      <- commandArgs(trailingOnly = TRUE)
File           <- arguments[1]
complementaire <- as.logical(arguments[2]) ##==< SI PAS DE FICHIERS COMPLEMENTAIRES REMPLACER PAR FALSE >==##

#> user
File           <- "" ##==< REMPLACER PAR LE NOM DU FICHIER D'EXEMPLE INCLUT (AVEC _entree DANS SON NOM) >==##
complementaire <- FALSE ##==< SI FICHIER DE RESULTAT COMPLEMENTAIRE REMPLACER PAR TRUE >==##

#> server, user
# Initialisation de l'heure
heure_debut <- Sys.time()

##  IMPORT DES FICHIERS ----
#> server
# Chargement du fichier .RData associe
suppressWarnings(load(paste0(indic, "_", vIndic, "_calc_fun.RData")))

#> server, user
# Import du fichier d'entree
data_entree <- read.table(File, header = TRUE, sep = "\t",
                          stringsAsFactors = FALSE, quote = "\"",
                          ##==< MODIFIER ICI EN FONCTION DES DONNEES D'ENTREE >==##
                          colClasses = c(CODE_OPERATION = "character",
                                         CODE_STATION   = "character",
                                         CODE_TAXON     = "character"))
```

> L’import des fichiers d’entrée dans le script de Validation se fait un
> peu différement puisque:
> 
>   - on ne spécifie pas le type des colonnes puisque ces types seront
>     explicitement testés;
>   - on crée une colonne ID qui correspond au numéro de ligne dans le
>     fichier brut. Ce numéro de ligne sera retourné pour localiser des
>     erreurs éventuelles dans les fichiers d’entrée.

``` r
data_entree <- read.table(File, header = TRUE, sep = "\t", quote = "\"",
                          stringsAsFactors = FALSE) %>%
  mutate(ID = seq(n()) + 1)
```

#### Le script de validation

**Ce fichier est le script R qui est utilisé pour valider les données
d’entrée lors de l’utilisation de l’interface web du SEEE.**

##### VALIDATION DES DONNEES

C’est la principale section de ce script, les fonctions nécessaires
parmi celles définies dans la section DECLARATION DES FONCTIONS y sont
utilisées pour tester différentes caractéristiques des fichiers
d’entrée: noms des colonnes, informations obligatoires manquantes,
type des données…

Les fonctions de test sont définies de sorte à pouvoir être utilisées en
succession. Un objet `resultat` est à générer par fichier d’entrée (bien
penser à les nommer différemment). La validation finale est réalisée
avec la fonction `funValid` qui combine les résultats de différents
fichiers d’entrée.

``` r
## VALIDATION DES DONNEES ----
##==< MODIFIER/AJOUTER LES TESTS NECESSAIRES ICI >==##
resultat <- initResult() %>%
  funImport(
    Table  = data_entree,
    empty  = FALSE,
    result = .)          %>%
  funColonnes(
    Table  = data_entree,
    cols   = c("CODE_OPERATION","CODE_STATION",
               "DATE", "CODE_TAXON", "RESULTAT"),
    result = .)          %>%
  funOperations(
    Table = data_entree,
    result = .
  )

if (resultat$verif == "ok") {
  resultat <- resultat %>%
    funVide(
      Table    = select(data_entree,
                        ID, CODE_OPERATION, CODE_TAXON, RESULTAT),
      result   = .)    %>%
    funEspace(
      Table    = select(data_entree,
                        ID, CODE_TAXON, RESULTAT),
      result   = .)
}

##==< SI PLUSIEURS FICHIERS D'ENTREE INCLURE EGALEMENT LES TESTS CORRESPONDANT >==##
# Parametre de succes/echec de la validation
##==< SI PLUSIEURS FICHIERS D'ENTREE METTRE DANS LA LISTE LES RESULTATS DE TESTS CORRESPONDANT >==##
valid <- funValid(resultats = list(resultat))
```

##### SORTIE DU RAPPORT D’ERREUR

La dernière section du script permet d’améliorer la lisibilité des
messages d’erreur de validation (fonction `funSortie`) et de les
combiner dans le rapport d’erreur (fonction `funResult`).

Le nom de fichier `outputFile` est complété automatiquement, il ne faut
pas le modifier manuellement.

``` r
# SORTIE DU RAPPORT D'ERREUR ----
##==< SI PLUSIEURS FICHIERS D'ENTREE METTRE DANS LA LISTE LA FONCTION funSortie() POUR LES RESULTATS DE TESTS CORRESPONDANT >==##
sortie <- list(faunistiques     = funSortie(resultat))

#> user
outputFile <- paste0(indic, "_", vIndic, "_rapport_erreur.csv")
#> server
outputFile <- ""

#> user, server
funResult(indic       = indic,
          vIndic      = vIndic,
          heure_debut = heure_debut,
          valid       = valid,
          sortie      = sortie,
          file        = outputFile)
```

#### Le script de calcul

**Ce fichier est celui qui permet de réaliser le calcul de l’indicateur.
C’est dans ce script que la méthode développée par les concepteurs de
l’indicateur est transposée en code utilisable par le SEEE.**

##### INITIALISATION DU FICHIER DE SORTIE

Le fichier de sortie final est initialisé dans cette section en
spécifiant les codes et libellés Sandre de chacun des paramètres
retournés par l’indicateur.

> Tous les paramètres retournés par un indicateur doivent être
> enregistrés dans le référentiel Paramètres du Sandre afin de
> faciliter la bancarisation des résultats.

``` r
## INITIALISATION DU FICHIER DE SORTIE ----
paramsOut <- data.frame(CODE_PAR = c(), ##==< METTRE ICI LES CODES SANDRE DES PARAMETRES >==##
                        LIB_PAR  = c(), ##==< METTRE ICI LES LIBELLES COURTS DES PARAMETRES >==##
                        stringsAsFactors = FALSE)

data_sortie <- funSortie(data_entree = data_entree,
                         paramsOut   = paramsOut,
                         CODE_OPERATION, CODE_STATION, DATE) %>%
  mutate(CODE_OPERATION = as.character(CODE_OPERATION),
         CODE_STATION   = as.character(CODE_STATION),
         DATE           = as.character(DATE))
```

##### CALCUL DE L’INDICE

Cette section, avec la DECLARATION DES FONCTIONS, est la plus importante
du script de Calcul. C’est ici que l’on utilise les fonctions définies
plus hauts sur les données d’entrée afin de calculer les valeurs de
l’indicateur. Ce sont ces deux sections qui concentrent l’essentiel du
travail d’intégration.

``` r
## CALCUL DE L'INDICE ----
resultats <- ##==< APPELER ICI LES FONCTIONS PERMETTANT DE CALCULER L'INDICATEUR A PARTIR DES FICHIERS D'ENTREE ET DE PARAMETRE >==##
```

> Le tablau de résultats doit contenir à minima une colonne avec le
> CODE\_OPERATION, une avec le CODE\_PAR (code Sandre du paramètre) et
> une avec le RESULTAT.

##### RESULTATS COMPLEMENTAIRES

Si l’indicateur doit retourner une sortie de résultats complémentaire,
c’est dans cette section que l’on définit ces résultats.

``` r
## RESULTATS COMPLEMENTAIRES ----
if (complementaire) {
  data_complementaire <- NULL ##==< SI BESOIN DE SORTIE COMPLEMENTAIRE REMPLACER NULL PAR LE CODE PERMETTANT DE LES OBTENIR >==##
} else {
  data_complementaire <- NULL
}
```

##### SORTIE DES RESULTATS

Cette section permet de générer le fichier de sortie avec les résultats
de calcul. Si les objets `data_sortie` et `resultats` ont été générés
comme décrits plus haut, aucune modification de cette section ne devrait
être nécessaire.

``` r
## SORTIE DES RESULTATS ----

data_sortie <- left_join(x  = data_sortie,
                         y  = resultats,
                         by = c("CODE_OPERATION", "CODE_PAR"))


#> user
fichierResultat               <- paste0(indic, "_", vIndic, "_resultats.csv")
fichierResultatComplementaire <- paste0(indic, "_", vIndic,
                                        "_resultats_complementaires.csv")
#> server
fichierResultat               <- ""
fichierResultatComplementaire <- ""

#> user, server
funResult(indic               = indic,
          vIndic              = vIndic,
          heure_debut         = heure_debut,
          data_sortie         = data_sortie,
          data_complementaire = data_complementaire,
          complementaire      = complementaire,
          file                = fichierResultat,
          file_complementaire = fichierResultatComplementaire)
```

### Le format d’échange

`Indicateur_Format_echange.Rmd`

#### En-tête

**Ce fichier permet de générer automatiquement le pdf du format
d’échange de l’indicateur.** Il est au format
[RMarkdown](https://rmarkdown.rstudio.com/lesson-1.html) qui permet de
combiner facilement du texte mis en forme, du code et les résultats de
ce code.

Le début du fichier, à savoir le header YAML et le premier bloc de code
R, ne doivent pas être modifiés, les objets indic et vIndic seront
générés automatiquement pendant l’export SEEE.

``` yaml
---
output: pdf_document
classoption: landscape
---
```

``` r
library(knitr)
library(kableExtra)
library(dplyr, warn.conflicts = FALSE)

indic  <- ""
vIndic <- ""

options(knitr.table.format = "latex")
opts_chunk$set(echo = FALSE)
```

#### Fichiers d’entrée

Les seules choses à modifier dans le bloc de code intitulé ‘table1’ sont
le nom du fichier d’entrée et éventuellement de réduire/filtrer ce
fichier d’entrée pour que l’affichage des résultats s’affiche
correctement dans la partie ‘Sortie’ (une ou deux opérations de contrôle
sont suffisantes).

``` r
# I. Entrée 'r paste(indic, vIndic)'
##==< AJOUTER SI NESCESSAIRE DES TITRES DE NIVEAUX 2 POUR DIFFERENTS FICHIERS D'ENTREE >==##
Le fichier d'entrée nécessaire au calcul de l'indicateur 'r indic' par SEEE doit être au format texte séparé par des tabulations et construit comme cet exemple:
\hfill\break

'''{r table1}
table1 <- read.table(file   = "", ##==< AJOUTER LE FICHIER D'ENTREE >==##
                     sep    = "\t",
                     quote  = "\"",
                     header = TRUE)

kable(head(table1))                      %>%
  kable_styling(position      = "left")  %>%
  column_spec(1, border_left  = TRUE)    %>%
  column_spec(ncol(table1), border_right = TRUE)
'''
```

Dans l’objet `table2`, il faut adapter les intitulés et description des
champs du fichier d’entrée.

``` r
\hfill\break
Il doit, à minima, comporter ces 'r ncol(table1)' champs complétés comme suit:
\hfill\break

##==< MODIFIER LES NOMS DE CHAMPS ET DESCRIPTIFS EN FONCTION DES FICHIERS D'ENTREE >==##
'''{r table2}
table2 <- rbind(c("Nom de l'entête", "Descriptif du champ"),
                c("CODE_OPERATION ",
                  "Code de l'opération de contrôle désignée. Le champ est obligatoire et de type alphanumérique."),
                c("CODE_STATION",
                  "Code de la station associée à l'opération. Le champ est facultatif."),
                c("DATE",
                  "Date à laquelle l'opération a été effectuée. Le champ est facultatif."),
                c("CODE_TAXON",
                  "Code sandre du taxon identifié. Le champ est obligatoire et de type entier numérique positif."),
                c("RESULTAT",
                  "Effectif ou présence du taxon identifié. Le champ est obligatoire et de type entier numérique positif."))

kable(table2, align = NULL)                           %>%
  kable_styling(position = "left")                    %>%
  column_spec(1, width = "4cm",  border_left  = TRUE) %>%
  column_spec(ncol(table2), width = "16cm", border_right = TRUE)
'''

NB: L'ordre des colonnes n'a pas d'importance.
    Les champs facultatifs peuvent rester vides ou être complétés par un type de données quelconque.

**! Peu importe que le champ soit obligatoire ou facultatif, le nom des 'r ncol(table1)' entêtes doit être respecté.**

**! Ne pas introduire d'espace dans les cellules des champs obligatoires (hors code opération).**

\pagebreak
```

> Si l’indicateur nécessite plusieurs fichiers d’entrée, il faut
> démultiplier cette section en utilisant des sous-sections (e.g. I.1.
> Listes faunistiques; I.2. Données environnementales).

#### Fichiers de sortie

> Le modèle de fichier par défaut prévoit une sortie par défaut et une
> sortie complémentaire, si l’indicateur ne nécessite pas de sortie
> complémentaire, supprimer la partie en question.

Les premiers blocs de code ne nécessitent aucune modification, ils
permettent de calculer les résultats à partir du fichier d’entrée
importé plus tôt et d’afficher les résultats obtenus.

``` r
# II. Sortie 'r paste(indic, vIndic)'

##==< SI PAS DE SORTIE COMPLEMENTAIRE SUPPRIMER LA PARTIE CORRESPONDANTE ET LES TITRES DE NIVEAU 2 >==##
## II.1 Sortie par défaut

Le fichier de sortie par défaut du calcul de l'indicateur 'r indic' par SEEE est construit comme cet exemple:
\hfill\break

'''{r include=FALSE}
write.table(x = table1, file = "temp_data.txt", sep = "\t", row.names = FALSE)

SEEEcreator:::copy_files(from  = paste0(indic, " ", vIndic, "/", indic),
                         files = paste0(indic, "_", vIndic, "_") %>%
                           paste0(., c("calc.r", "calc_fun.RData")))

SEEEcreator:::generate_results(calc = paste0(indic, "_", vIndic, "_calc.r"),
                               inputFiles = c("temp_data.txt", TRUE))

label  <- readLines(paste0(indic, "_", vIndic, "_resultats.csv"))[[1]] %>%
  strsplit(split = ";")                                                %>%
  '[['(1)
results <- read.csv2(paste0(indic, "_", vIndic, "_resultats.csv"), skip = 1, header = FALSE)
table3 <- rbind(matrix(c(label,
                         rep("", (ncol(results) - length(label)))),
                       nrow = 1),
                results) %>%
  (function(mat) {
    colnames(mat) <- as.vector(t(mat[1,]))
    mat <- mat[-1,]
    rownames(mat) <- NULL
    mat
  })

file.remove("temp_data.txt")
'''

'''{r table3}
kable(table3)                     %>%
  kable_styling(position = "left") %>%
  column_spec(1, width = "3.25cm", border_left = TRUE) %>%
  column_spec(ncol(table3), width = "3.75cm", border_right = TRUE)
'''
```

> Il est important que le fichier d’entrée mis en exemple soit correct
> sinon la procédure d’export échouera.

Comme pour le fichier d’entrée, il faut ensuite modifier la `table4`
afin de décrire les champs du fichier de sortie:

``` r
\hfill\break
Il comporte les 'r ncol(table3)' champs suivants complétés comme suit:
\hfill\break

##==< A AJUSTER SI BESOIN >==##
'''{r table4}
table4 <- rbind(c("Nom de l'entête", "Descriptif du champ"),
                c("CODE_OPERATION", "Code de l'opération de contrôle renseigné. Ce champ est repris du fichier d'entrée."),
                c("CODE_STATION", "Code de la station associée à l'opération. Ce champ est repris du fichier d'entrée."),
                c("DATE", "Date à laquelle l'opération a été effectuée. Ce champ est repris du fichier d'entrée."),
                c("CODE_PAR", "Code sandre du paramètre de sortie."),
                c("LIB_PAR", "Libellé du paramètre de sortie."),
                c("RESULTAT", "Valeur du paramètre de sortie en EQR."),
                c("COMMENTAIRES", "Information sur les taxons non contributifs (liste taxonomique et proportion du prélèvement)."))

knitr::kable(table4)                                  %>%
  kable_styling(position = "left")                    %>%
  column_spec(1, width = "4cm",  border_left  = TRUE) %>%
  column_spec(ncol(table4), width = "16cm", border_right = TRUE)
'''
\hfill\break
```

Si un fichier de sortie complémentaire est produit, ses résultats sont
importés dans la `table5` puis affichés (le code des deux premiers blocs
de code ne nécessite pas de modification).

``` r
## II.2 Sortie optionnelle
'''{r}
label  <- readLines(paste0(indic, "_", vIndic, "_resultats_complementaires.csv"))[[1]] %>%
  strsplit(split = ";") %>%
  '[['(1)
results <- read.csv2(paste0(indic, "_", vIndic, "_resultats_complementaires.csv"), skip = 1, header = FALSE)
table5 <- rbind(matrix(c(label,
                         rep("", (ncol(results) - length(label)))),
                       nrow = 1),
                results) %>%
  (function(mat) {
    colnames(mat) <- as.vector(t(mat[1,]))
    mat <- mat[-1,]
    rownames(mat) <- NULL
    mat
  })

'''

Le fichier de sortie optionnel du calcul de l'indicateur 'r indic' par SEEE est construit de la manière suivante:

'''{r table5}
kable(table5)                     %>%
  kable_styling(position = "left") %>%
  column_spec(1, border_left = TRUE) %>%
  column_spec(ncol(table5), border_right = TRUE)

'''
```

Comme pour les autres fichiers, on donne ensuite le nom et une courte
description des colonnes de ce fichier de sortie complémentaire.

``` r
\hfill\break
Il comporte les 'r ncol(table5)' champs suivants complétés comme suit:
\hfill\break

'''{r table6}
table6 <- rbind(c("Nom de l'entête", "Descriptif du champ"))

knitr::kable(table6)                                  %>%
  kable_styling(position = "left")                    %>%
  column_spec(1, width = "4cm",  border_left  = TRUE) %>%
  column_spec(ncol(table4), width = "16cm", border_right = TRUE)
'''

\hfill\break

Pour chacune des sorties (par défaut et optionnelle), la première ligne du tableau de sortie comporte les informations suivantes: indicateur, version, date d'exécution du calcul, temps d'éxécution du calcul. Le tableau de résultats suit dessous.
```

## Export

Une fois que les fichiers de configuration (JSON), de validation, de
calcul et du format d’échange ont été complétés, on peut procéder à un
export SEEE, c’est à dire la création des fichiers que l’on copiera sur
le serveur pour rendre effective l’intégration de l’indicateur dans le
SEEE.

Cet export est réalisé grâce à la commande suivante:

``` r
SEEEcreator::create_SEEE_export(indic = "Indicateur", additionalInput = NULL, test = FALSE)
```

Seul le premier argument est nécessaire afin d’identifier les fichiers à
utiliser. L’argument `additionalInput` permet de simuler la case ‘Sortie
complémentaire’ de l’interface SEEE. L’argument `test` permet d’afficher
les messages d’avertissement, ce qui peut être utile pour débugger des
comportements anormaux.

Cette fonction génère les fichiers constituant l’export SEEE et les
places dans un dossier nommé avec le nom de l’indicateur et le numéro de
version dans le dossier **Exports**. Dans le détail, cette fonction
génère:

  - le fichier json de configuration;
  - les scripts `server` et les données correspondantes;
  - l’ensemble de la documentation:
      - scripts utilisateurs avec fichiers de paramètres
        (Documentation\_scripts.zip),
      - format d’échange au format pdf;
      - exemples de données d’entrée et résultats correspondants
        (Import\_export.zip)

**Le contenu du dossier `Indic version` peut directement être copié sur
le serveur SEEE pour mettre en ligne l’indicateur.**

Voici l’arborescence du projet d’un indicateur diatomée pour l’île de
Mayotte, seul le dossier renv contenant la librairie du package a été
exclu de cet affichage. On retrouve la structure classique d’une
indicateur développé avec SEEEcreator, un dossier **Documentation** avec
les documents de référence et autres éléments utiles à l’intégration, un
dossier **Exports** contenant les exports prêts à être déposés dans le
SEEE, le changelog, les fichiers de travail pour l’intégration
(changelog, json de configuration, scripts de validation et de calcul et
fichier Rmarkdown pour générer le format d’échange), les fichiers
d’entree et de paramètres de l’indicateur et un dossier **Tests**
contenant les fichiers nécessaires pour réaliser des tests (ici de
conformité à un outil pré-existant).

    1  IDM_sp                                                    
    2   ¦--01_Mayotte_IDMsp.Rproj                                
    3   ¦--Documentation                                         
    4   ¦   ¦--Guide IDM-V2.pdf                                  
    5   ¦   ¦--Outil_indice-especes.xlsx                         
    6   ¦   ¦--Rapport Onema Mayotte 2017.pdf                    
    7   ¦   °--Tapolczai_et_al_2017.pdf                          
    8   ¦--Exports                                               
    9   ¦   °--IDMsp v1.0.0                                      
    10  ¦       ¦--IDMsp                                         
    11  ¦       ¦   ¦--Documentation                             
    12  ¦       ¦   ¦   ¦--IDMsp_v1.0.0_Documentation_scripts.zip
    13  ¦       ¦   ¦   ¦--IDMsp_v1.0.0_Format_echange.pdf       
    14  ¦       ¦   ¦   °--IDMsp_v1.0.0_Import_export.zip        
    15  ¦       ¦   ¦--IDMsp_v1.0.0_calc.r                       
    16  ¦       ¦   ¦--IDMsp_v1.0.0_calc_fun.RData               
    17  ¦       ¦   ¦--IDMsp_v1.0.0_valid.r                      
    18  ¦       ¦   °--IDMsp_v1.0.0_valid_fun.RData              
    19  ¦       °--IDMsp_v1.0.0.json                             
    20  ¦--IDMsp_Calcul.r                                        
    21  ¦--IDMsp_CHANGELOG.txt                                   
    22  ¦--IDMsp_entree.txt                                      
    23  ¦--IDMsp_Format_echange.Rmd                              
    24  ¦--IDMsp_JSON.json                                       
    25  ¦--IDMsp_params.csv                                      
    26  ¦--IDMsp_Validation.r                                    
    27  °--Tests                                                 
    28      ¦--algos                                             
    29      ¦   °--IDMsp                                         
    30      ¦       °--1.0.0                                     
    31      ¦           ¦--IDMsp_CHANGELOG.txt                   
    32      ¦           ¦--IDMsp_params.csv                      
    33      ¦           ¦--IDMsp_v1.0.0_calc_consult.r           
    34      ¦           ¦--IDMsp_v1.0.0_resultats.csv            
    35      ¦           °--IDMsp_v1.0.0_valid_consult.r          
    36      °--ConformiteOutilExcel                              
    37          ¦--ConformiteResultats.R                         
    38          ¦--data                                          
    39          ¦   ¦--data_entree.csv                           
    40          ¦   °--IDMsp_entree.txt                          
    41          °--Outil_indice-especes.xlsx
