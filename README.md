## Installing R packages to a Docker image with packrat

This is a minimal example that installs a single package each from CRAN,
bioconductor, and github to a Docker image using packrat.

For more info, [see my blogpost.](https://www.joelnitta.com/post/docker-and-packrat/)

### Setup

Keep `Dockerfile` and `install_packages.R` in the root of the
project directory (you can clone this repo as an example project).

### First step: make packrat/packrat.lock file

Launch `rocker/rstudio` (or any other [rocker image](https://www.rocker-project.org/)
of your choice) with tag set to same version we will use in the `Dockerfile`,
and this directory mounted.

Note that the rocker images come with various packages pre-installed,
so if you want to track those packages properly you would have to install them
like the other example packages in `install_packages.R`.

````
docker run -it -e DISABLE_AUTH=true -v /path/to/project/:/home/rstudio/project rocker/rstudio:3.5.3 bash
````

Inside the docker container, run the script to install R packages
with `packrat`. Exit when done.

```
cd home/rstudio/project
Rscript install_packages.R
```

This will install current versions of all packages in `install_packages.R`,
but the main reason is to write `packrat/packrat.lock`.

### Second step: actually build the image

Now we can use `packrat.lock` to restore (i.e., install) packages when we
build the image.

```
docker build . -t mycontainer
```

We should now be able to run the container with the packages we installed.

```
docker run -it mycontainer R
```

Inside the container running R, check that the packages are installed:

```
library(minimal)
packageVersion("minimal")
```

### Third step: rinse, repeat

Edit the packages in `install_packages.R` as needed to add new packages
or update old ones, and repeat Steps 1 and 2.
