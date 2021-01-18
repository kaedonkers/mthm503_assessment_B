# Code for question 1

## @knitr 1Init

library(colorspace)
library(ggplot2)


## @knitr 1Summary
# summary(obs)
knitr::kable(summary(obs), caption="Summary of observed cases in England")


## @knitr 1TimeSumData

time.sum <- obs %>%
    group_by(year) %>%
    summarise(sum=sum(observed))

## @knitr 1TimeSumPlot

ggplot(time.sum,
       aes(x=year, y=sum)) +
    geom_line(color='red') +
    geom_point() +
    labs(title="Annual cases of COPD in England",
         x = "Year",
         y = "Number of cases") +
    scale_x_continuous(breaks=seq(2000, 2010, by=2), 
                       labels=seq(2000, 2010, by=2),
                       limits=c(2001, 2010)) +
    scale_y_continuous(limits=c(0, 25000))

## @knitr 1EngMeanData


eng.mean <- obs %>%
    group_by(name) %>%
    summarise(mean=mean(observed))

eng <- merge(eng.geo, eng.mean, by='name')

## @knitr 1EngMeanMap

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


