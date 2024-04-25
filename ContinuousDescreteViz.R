library(rio)
library(dplyr)
library(ggplot2)
library(ggsci)

input_data <- "synthetic_data_for_plotting.csv"

if (!file.exists(input_data)){system("R -f synthesize_data.R")}

d0 <- import(input_data)

ggplot(d0, aes(x=factor(bpd_or_death), y=bw)) + geom_violin() + geom_boxplot(width=0.1)

subset(d0, !is.na(bpd_or_death)) %>%
  ggplot(aes(x=factor(bpd_or_death), y=bw)) +
  geom_violin(fill = "green") +
  geom_jitter(width = 0.1, color = "red", fill = "yellow")

subset(d0, !is.na(bpd_or_death)) %>%
  ggplot(aes(x=factor(bpd_or_death), y=bw)) +
  geom_violin(fill = "green") +
  geom_boxplot(width = 0.1, color = "red", fill = "yellow")

subset(d0, !is.na(bpd_or_death)) %>%
  ggplot(aes(x=factor(bpd_or_death), y=bw)) +
  geom_violin(fill = "green") +
  geom_boxplot(width = 0.1, color = "red", fill = "yellow")+coord_flip()
