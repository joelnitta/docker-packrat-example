FROM rocker/tidyverse:3.5.3

RUN apt-get update

# Install R packages with packrat
# (From R, run packrat::init() the first to set up packrat,
# and install_packages.R any time packages should be updated)

COPY ./packrat/packrat.lock packrat/

RUN Rscript -e 'packrat::restore()'

# .Rprofile doesn't get parsed by Rstudio, so modify Rprofile.site instead
# This is needed so R uses packrat libraries by default
RUN echo '.libPaths("/packrat/lib/x86_64-pc-linux-gnu/3.5.3")' >> /usr/local/lib/R/etc/Rprofile.site
