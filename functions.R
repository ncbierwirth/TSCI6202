sggf_listAES <- function(xx) with(as.list(xx$geom),list(required=required_aes,other=c(non_missing_aes,optional_aes)))

summarize_ggfunctions <- function(pattern='^geom_'
                                  ,payload=function(zz) zz$geom
                                  ,packagename='package:ggplot2'){
  ls(packagename,pat=pattern) %>%
    sapply(function(xx) try(do.call(xx,list())) %>% {
      yy <- .
      if(length(intersect(c('LayerInstance','Layer','ggproto','gg'),class(yy)))==4){
        payload(yy)
      } else NULL
    })
}