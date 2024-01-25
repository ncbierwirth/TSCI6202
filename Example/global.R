library(dplyr)
library(shiny)

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

xx <- data.sets[1:30,]

MetaData <- mapply(function(CurrentItem,CurrentPackage){
  currentenv <- new.env()
  data(list = CurrentItem, package = CurrentPackage, envir = currentenv)
  currentdf <- try(as.data.frame(currentenv[[CurrentItem]]))
  if(is(currentdf, "try-error")) return()
  out <- dataframesmry(currentdf) %>%
    mutate(Item=CurrentItem, Package=CurrentPackage, Rows=nrow(currentdf))
  if(nrow(out)>0) out
  },
  data.sets$Item, data.sets$Package, SIMPLIFY = FALSE) %>% bind_rows() %>%
  group_by(Item,Package) %>%
  mutate(Label = sprintf("%s, %s, [%d , %d]",Item,Package,Rows,n()))

