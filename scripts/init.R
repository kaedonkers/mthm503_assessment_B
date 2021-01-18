# Initialisation script

## @knitr 0LoadData

library(tidyverse)
library(here)
library(sf)

obs <- read_csv(here::here("data/copdobserved.csv")) %>%
    gather("year.str", "observed", -Name) %>%
    mutate(year=as.integer(str_replace(year.str, "Y", ""))) %>%
    rename("name"="Name") %>%
    select(-year.str)

expd <- read_csv(here::here("data/copdexpected.csv")) %>%
    gather("year.str", "expected", -Name) %>%
    mutate(year=as.integer(str_replace(year.str, "E", ""))) %>%
    rename("name"="Name") %>%
    select(-year.str)

eng.geo <- st_read(here::here('data/englandlocalauthority/englandlocalauthority.shp'))
