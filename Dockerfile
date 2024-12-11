FROM rocker/rstudio

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev\
    libssl-dev\
    libxml2-dev\
    && rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages(c('ggnewscale', 'tidyverse', 'corrplot', 'pROC', 'factoextra', 'foreach', 'ggplot2'), repos = 'https://cloud.r-project.org/', dependencies = TRUE, quiet = TRUE)"
CMD ["tail", "-f", "/dev/null"]
