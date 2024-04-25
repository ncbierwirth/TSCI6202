library(synthpop)
library(rio)
library(dplyr)
library(ggplot2)

hyperglycemia_bpd <- import("~/Desktop/Research/Hyperglycemia:BPD Paper/demo.df.csv")

hyperglycemia_bpd <- import("~/Desktop/numerlical_glucose_df.csv")[
  ,c("ga", "bw", "gender", "vent_days", "bpd_or_death", "average72hr", "top_third")]

data_syn <- syn(hyperglycemia_bpd)

summary(data_syn)

export(data_syn$syn,'synthetic_data_for_plotting.csv')

