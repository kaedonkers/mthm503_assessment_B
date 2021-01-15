# Load data

## @knitr load_data

library(tidyverse)
library(here)
library(readr)
library(spdep)
library(sf)
library(CARBayes)
library(rgdal)
library(rgeos)
library(RColorBrewer)
library(colorspace)
library(ggplot2)

obs <- read_csv(here::here("data/copdobserved.csv"))
expd <- read_csv(here::here("data/copdexpected.csv"))
# summary(expd)


## @knitr 1.summary
summary(obs)


## @knitr 1.eng.time.sum

time.sum <- obs %>%
    gather("year.str", "cases", -Name) %>%
    mutate(year=as.integer(str_replace(year.str, "Y", ""))) %>%
    select(-year.str) %>%
    group_by(year) %>%
    summarise(sum=sum(cases))


ggplot(time.sum,
       aes(x=year, y=sum)) +
    geom_line() +
    geom_point() +
    labs(title="Time series: COPD in England",
         x = "Year",
         y = "Total number of cases") +
    scale_x_continuous(breaks=c(2000, 2002, 2004, 2006, 2008, 2010), 
                       labels=c(2000, 2002, 2004, 2006, 2008, 2010),
                       limits=c(2000, 2010)) +
    scale_y_continuous(limits=c(0, 25000))

## @knitr 1.eng.mean.map

eng.geo <- st_read(here::here('data/englandlocalauthority/englandlocalauthority.shp'))

eng.mean <- obs %>%
    gather("year.str", "cases", -Name) %>%
    group_by(Name) %>%
    summarise(mean=mean(cases))

eng <- merge(eng.geo, eng.mean, by.x="name", by.y="Name")

ggplot(eng, 
       aes(fill=mean)) +
    geom_sf() +
    geom_sf(colour = NA) +
    theme_bw() +
    labs(title='Number of cases of COPD in English \nlocal authorities: 2001-2010 average',
         x = 'Longitude',
         y = 'Latitude',
         fill = 'Mean') +
    scale_fill_gradientn(colours = brewer.pal(9, 'RdPu'))

## @knitr merge_data

library(ggplot2)

copd.data = merge(obs, expd, by='Name')

