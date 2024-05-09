library(rio)
library(dplyr)
library(ggplot2)
library(ggsci)
library(GGally)

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

ggpairs(iris, aes(col=Species))

psych_variables <- attr(psychademic, "psychology")
academic_variables <- attr(psychademic, "academic")
ggduo(
  psychademic,
  mapping = ggplot2::aes(color = sex),
  academic_variables, psych_variables)


independent_variables <- c("ga","bw","gender","average72hr")
dependent_variables <- c("vent_days","bpd_or_death")
mutate(d0,gender=factor(gender),bpd_or_death=ordered(bpd_or_death)) %>%ggduo(
  mapping = aes(color = gender),
  independent_variables, dependent_variables)

