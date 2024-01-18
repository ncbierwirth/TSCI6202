library(dplyr)

data.sets <- data(package = .packages(all.available = TRUE))$results%>%
  as.data.frame() %>%
  mutate(Item = gsub(" .*","",Item), code=paste(Package, Item, sep = "::"))

dataframesmry <- . %>%
  sapply(function(xx) tryCatch(data.frame(class.type = paste(class(xx), collapse = ","),
                                 unique = length(unique(xx))),
                               error = function(e) {}
                               ),
         simplify = FALSE) %>% bind_rows(.id = "Column")

parseeval <- . %>%  parse(text = .) %>% try(eval(.))

datainfo <- data.sets$code %>% sapply(parseeval, simplify = FALSE) %>% lapply(dataframesmry)
