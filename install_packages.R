# Install packages to a docker image with packrat

### Initialize packrat ###

# rocker/tidyverse comes with packrat, so we don't need to install it.
# Uncomment the next line if using an image that doesn't already have packrat.
# install.packages("packrat", repos = "https://cran.rstudio.com/")

# Don't let packrat try to find packages to install itself.
packrat::init(
  infer.dependencies = FALSE,
  enter = TRUE,
  restart = FALSE)

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

# Here we are just installing one package per repository
# as an example. If you want to install others, just add
# them to the vectors.

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
