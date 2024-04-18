library(dplyr)
library(shiny)
library(rio)
library(ggplot2)

if(file.exists("functions.R")) source("functions.R")

AESsummary<-summarize_ggfunctions(payload = sggf_listAES)

# `geom_ribbon()` requires the following missing aesthetics: ymin and ymax or xmin and xmax
# `geom_curve()` requires the following missing aesthetics: xend and yend
# `geom_label()` requires the following missing aesthetics: label

# Aesthetic mappings that at least one geom_* function requires
ggCoreAes <-
  sapply(AESsummary, function(xx) xx$required) %>% unlist() %>%
  strsplit(split ="|", fixed=TRUE) %>% unlist() %>% table() %>%
  sort(dec=TRUE) %>% names()

  # c('x','xmax','xmin','y','ymax','ymin','angle','intercept','label',
  #              'lower','middle','radius','slope','upper','xend','xintercept',
  #              'xlower','xmiddle','xupper','yend','yintercept')

# Aesthetic mappings that at least one geom_* function can use
ggOtherAes <-
  sapply(AESsummary, function(xx) xx$other) %>% unlist() %>%
  strsplit(split ="|", fixed=TRUE) %>% unlist() %>% table() %>%
  sort(dec=TRUE) %>% names() %>% setdiff(ggCoreAes) %>% c("alpha","group","z")

  # c('colour','fill','linetype','linewidth','shape','size','alpha');

ggAllAES <- c(ggCoreAes, ggOtherAes)

ggYAes <- grep("^y",ggAllAES,value = TRUE) %>% setdiff("y")
ggXAes <- grep("^x",ggAllAES,value = TRUE) %>% setdiff("x")

#ggPopularAes<-intersect(ggAllAES,c('colour','fill','linetype','linewidth','shape','size','alpha','group'))

ggUncommonAes<-setdiff(ggAllAES,c(ggOtherAes,ggXAes,ggYAes,"x","y"))

ggNumericAes <- intersect(c(ggYAes,ggYAes,'radius','slope','intercept','angle'),ggAllAES);

AesIDs<-paste0(ggAllAES,"_var")

AesLabels<-sprintf("Select %s variable",ggAllAES)

exclude.formats <- c("list", "haven_labelled",
                         "haven_labelled_spss,haven_labelled",
                         "sfc_MULTIPOLYGON,sfc", "matrix,array",
                         "nativeRaster","wk_wkb,wk_vctr",
                         "wk_wkb,wk_vctr,geovctr")

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

if(file.exists("metadata.csv")) {MetaData <- import("metadata.csv")} else {
  MetaData <- mapply(function(CurrentItem,CurrentPackage){
    currentenv <- new.env()
    data(list = CurrentItem, package = CurrentPackage, envir = currentenv)
    currentdf <- try(as.data.frame(currentenv[[CurrentItem]]))
    if(is(currentdf, "try-error")) return()
    out <- dataframesmry(currentdf) %>%
      mutate(Item=CurrentItem, Package=CurrentPackage, Rows=nrow(currentdf))
    if(nrow(out)==0) return()
    out <- subset(out, !class.type %in% exclude.formats)
    if(nrow(out)>0) out
    },
    data.sets$Item, data.sets$Package, SIMPLIFY = FALSE) %>% bind_rows() %>%
    group_by(Item,Package) %>%
    mutate(Label = sprintf("%s, %s, [%d , %d]",Item,Package,Rows,n()))
  export(MetaData, "metadata.csv")
}

input <- list(InputDataset="starwars, dplyr, [87 , 11]")

#sprintf('as.data.frame(%s::%s) %>% ggplot(aes(x=height, y=mass)) + geom_point()',
#        selected.dataset$Package[1],selected.dataset$Item[1])%>%
#  parse(text = .) %>% eval()


