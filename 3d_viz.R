library(rgl)
library(dplyr)
open3d()

relocate(iris,"Petal.Width","Petal.Length") %>% plot3d(col="red")
#type="s" sphere instead of dot

fit <- lm(Sepal.Length~Petal.Width + Petal.Length, iris)

coef(fit)
coefs <- coef(fit)
planes3d(coefs["Petal.Width"],coefs["Petal.Length"],-1,coefs["(Intercept)"],alpha=0.2)

?ggplot2
