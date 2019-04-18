# Only run this after making packrat/packrat.lock by
# running install_packages.R

FROM rocker/rstudio:3.5.3

RUN apt-get update

COPY ./packrat/packrat.lock packrat/

RUN install2.r packrat

RUN Rscript -e 'packrat::restore()'

# Modify Rprofile.site so R loads packrat library by default
RUN echo '.libPaths("/packrat/lib/x86_64-pc-linux-gnu/3.5.3")' >> /usr/local/lib/R/etc/Rprofile.site
