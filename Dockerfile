FROM rocker/verse
RUN install2.r --error --skipinstalled\
  pacman here fs
WORKDIR /home/rstudio
