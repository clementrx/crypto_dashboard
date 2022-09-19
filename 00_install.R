
packages <- c("tidyverse",
              "binancer",
              "scales",
              "data.table",
              "dygraphs",
              "quantmod",
              "xts",
              'shiny')

install.packages(setdiff(packages, rownames(installed.packages())))