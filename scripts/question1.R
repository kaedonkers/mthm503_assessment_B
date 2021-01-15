# Code for question 1

## @knitr load_data

library(tidyverse)
library(here)
library(readr)
library(spdep)
library(sf)
library(CARBayes)
library(rgdal)
library(rgeos)
library(colorspace)
library(ggplot2)

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

## @knitr 1.summary
summary(obs)


## @knitr 1.time.sum.data

time.sum <- obs %>%
    group_by(year) %>%
    summarise(sum=sum(observed))

## @knitr 1.time.sum.plot

ggplot(time.sum,
       aes(x=year, y=sum)) +
    geom_line(color='red') +
    geom_point() +
    labs(title="Annual cases of COPD in England",
         x = "Year",
         y = "Number of cases") +
    scale_x_continuous(breaks=seq(2000, 2010, by=2), 
                       labels=seq(2000, 2010, by=2),
                       limits=c(2000, 2010)) +
    scale_y_continuous(limits=c(0, 25000))

## @knitr 1.eng.mean.data

eng.geo <- st_read(here::here('data/englandlocalauthority/englandlocalauthority.shp'))

eng.mean <- obs %>%
    group_by(name) %>%
    summarise(mean=mean(observed))

eng <- merge(eng.geo, eng.mean, by='name')

## @knitr 1.eng.mean.map

ggplot(eng, 
       aes(fill=mean)) +
    geom_sf() +
    geom_sf(colour = NA) +
    theme_bw() +
    labs(title='Number of cases of COPD in English \nlocal authorities: 2001-2010 average',
         x = 'Longitude',
         y = 'Latitude',
         fill = 'Cases (mean)') +
    scale_fill_continuous_sequential(palette='Reds')


