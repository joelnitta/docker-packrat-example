#' # Installing packages to a Docker image with packrat
#'
#' ## How this works
#'
#' ### Setup
#'
#' Keep `Dockerfile` and `install_packages.R` in the root of the
#' project directory.
#'
#' ### First step: make packrat/packrat.lock file
#'
#' Launch rocker/tidyverse with tag set to same version we will use in
#' the Dockerfile and this directory mounted, and run this script.
#'
#' I'm using rocker/tidyverse because it comes with RStudio server, so we can
#' edit code in the container directly with RStudio. However, rocker/tidyverse
#' comes with tidyverse pre-installed, so if you want to track those packages
#' properly you would have to install them like
#' the other example packages below.
#'
#' ````
#' docker run -e PASSWORD=cleverpw -it -v /path/to/project/:/home/rstudio/project rocker/tidyverse:3.5.3 bash
#' ````
#'
#' Inside the docker container, install R packages.
#'
#' ```
#' cd home/rstudio/project
#' Rscript install_packages.R
#' ```
#'
#' This will install current versions of all packages below,
#' but the main reason is to write `packrat/packrat.lock`
#'
#' ### Second step: actually build the image
#'
#' Now we can use packrat.lock to restore (i.e., install) packages
#' during the next (real) docker build, using the `Dockerfile`.
#' Use DOCKER_BUILDKIT=1 to pass GitHub PAT as a secret so
#' we can install private packages.
#'
#' ```
#' docker build . -t tag
#' ```
#'
#' ### Third step: rinse, repeat
#'
#' Edit the packages below as needed to add new packages
#' or update old ones (by installing), and repeat Steps 1 and 2.

################################################################################

### Initialize packrat ###

# Use packrat options to add libraries and source code
# to .gitignore, and don't let packrat try to find
# packages to install itself.

install.packages("packrat", repos = "https://cran.rstudio.com/")

packrat::init(infer.dependencies = FALSE,
              options = list(
                vcs.ignore.lib = TRUE,
                vcs.ignore.src = TRUE
              ))

### Setup repositories ###

# Install packages that install packages.
install.packages("BiocManager", repos = "https://cran.rstudio.com/")
install.packages("remotes", repos = "https://cran.rstudio.com/")

# Specify repositories so they get included in
# packrat.lock file.
my_repos <- BiocManager::repositories()
my_repos["CRAN"] <- "https://cran.rstudio.com/"
options(repos = my_repos)

### Install packages ###

# All packages will be installed to
# the project-specific packrat library.

# Install CRAN packages
cran_packages <- c("glue")
install.packages(cran_packages)

# Install bioconductor packages
bioc_packages <- c("BiocVersion")
BiocManager::install(bioc_packages)

# Install github packages
github_packages <- c("joelnitta/minimal")
remotes::install_github(github_packages)

### Take snapshot ###

packrat::snapshot(
  snapshot.sources = FALSE,
  ignore.stale = TRUE,
  infer.dependencies = FALSE)
