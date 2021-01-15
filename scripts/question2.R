# Code for question2

## @knitr 2.init

# library(CARBayes)
# library(rgdal)
# library(rgeos)
# library(spdep)
library(ggplot2)
library(colorspace)


## @knitr 2.raw.smrs

smr.data <- merge(obs, expd, by=c("name", "year"))

smr.data$smr.raw <- smr.data$observed / smr.data$expected



## @knitr 2.smoothed.smrs

# # Creates the neighbourhood
# W.nb <- poly2nb(eng.geo, row.names = rownames(eng.geo))
# # Creates a matrix for following function call
# W.mat <- nb2mat(W.nb, style="B")


# ERROR: Crashes R when model run
# # Running smoothing model
# model <- S.CARleroux(formula = observed ~ offset(log(expected)), # Model Formula
#                      data = smr.data, # Dataset name
#                      family = "poisson",     # Choosing Poisson Regression
#                      W = W.mat,              # Neighbourhood matrix
#                      burnin = 200,         # Number of burn in samples (throw away)
#                      n.sample = 1000,      # Number of MCMC samples
#                      thin = 10,
#                      rho = 1)



## @knitr 2.map.smrs

# smr.mean <- smr.data %>%
#     filter(year==2010) %>%
#     merge(eng.geo, by=c("name")) %>%
#     st_as_sf()

smr.mean <- smr.data %>%
    group_by(name) %>%
    summarise(mean.smr=mean(smr.raw)) %>%
    merge(eng.geo, by=c("name")) %>%
    st_as_sf()


ggplot(smr.mean, 
       aes(fill=mean.smr)) +
    geom_sf() +
    geom_sf(colour = NA) +
    theme_bw() +
    labs(title='Average raw SMRs for COPD in English \nlocal authorities: 2001-2010',
         x = 'Longitude',
         y = 'Latitude',
         fill = 'SMR (raw)') +
    scale_fill_continuous_sequential(palette='Purples')


## @knitr 2.top.smrs

smr.data %>%
    group_by(name) %>%
    summarise(mean.smr=mean(smr.raw)) %>%
    arrange(desc(mean.smr)) %>%
    slice(1:10)

# smr.data %>%
#     group_by(name) %>%
#     summarise(mean.smr=mean(smr.raw)) %>%
#     arrange(name) %>%
#     View()
# 
# smr.data %>%
#     filter(name=="Cornwall UA") %>%
#     summarise(mean=mean(smr.raw))
