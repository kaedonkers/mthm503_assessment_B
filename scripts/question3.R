# Code for question 3

## @knitr 3.init
library(ggplot2)

## @knitr 3.smr.time.plot

ggplot(smr.data,
       aes(x=year, y=smr.raw, color=name)) +
    geom_line(alpha=0.2) +
    labs(title="Raw SMRs for COPD in all English local authorities: 2001-2010",
         x="Year",
         y="SMR (raw)") +
    scale_x_continuous(breaks=seq(2000, 2010, by=2), 
                       labels=seq(2000, 2010, by=2),
                       limits=c(2001, 2010)) +
    theme(legend.position = "none")

## @knitr 3.top.smrs.2010

smr.data %>%
    filter(year==2010) %>%
    arrange(desc(smr.raw)) %>%
    slice(1:10) %>%
    knitr::kable(caption="Ten local authorities with the highest raw SMR values in 2010.")

## @knitr 3.obs.time.plot
ggplot(obs,
       aes(x=year, y=observed, color=name)) +
    geom_line(alpha=0.2) +
    labs(title="Annual admissions for COPD in all English local authorities: 2001-2010",
         x="Year",
         y="Number of cases") +
    scale_x_continuous(breaks=seq(2000, 2010, by=2), 
                       labels=seq(2000, 2010, by=2),
                       limits=c(2001, 2010)) +
    scale_y_continuous(trans="log10") +
    theme(legend.position = "none")

## @knitr 3.pairs.plot
library(GGally)

ggpairs(smr.data, 2:ncol(smr.data))
