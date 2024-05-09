library(kinship2)
library(dplyr)
library(randomNames)
library(plotrix)
library(colourpicker)

data("sample.ped")
ecomaps<-mutate(sample.ped,
                varx=sample(0:1,n(),rep=TRUE),
                age=sample(0:99,n(),rep=TRUE),
                name=randomNames(n(),which.names = "first",gender=sex-1,
                                 sample.with.replacement = FALSE) %>% paste0("\n",.,"\n",age),
                fathername=sapply(father,function(xx) {coalesce(name[match(xx,id)],"0")}),
                mothername=sapply(mother,function(xx) {coalesce(name[match(xx,id)],"0")}),
                overplot = case_match(sex,
                                      1 ~ sample(c('none','square'),n(),prob=c(0.5,0.5),rep=T),
                                      2 ~ sample(c('none','circle'),n(),prob=c(0.5,0.5),rep=T),
                                      T ~ 'none'
                )
)

ecomaps.ped<-with(ecomaps,pedigree(id=id, dadid=father, momid=mother,sex=sex,
                                   affected=cbind(affected, avail,varx),
                                   famid=ped))

ecomaps.ped$id<-ecomaps$name
oldpar<-par()
par(srt=180,crt=180)
ecomaps.plotdata<-plot(ecomaps.ped[2])

with(ecomaps.plotdata,mapply(draw.circle,x[which(subset(ecomaps,ped==2)$overplot=='circle')],
                             y[which(subset(ecomaps,ped==2)$overplot=='circle')]+boxh/2,
                             MoreArgs=list(lwd=2,border="red",radius = boxw/2)))

with(ecomaps.plotdata,rect(xleft=x[which(subset(ecomaps,ped==2)$overplot=='square')]-boxw/2,
                           ybottom=y[which(subset(ecomaps,ped==2)$overplot=='square')],
                           xright=x[which(subset(ecomaps,ped==2)$overplot=='square')]+boxw/2,
                           ytop=y[which(subset(ecomaps,ped==2)$overplot=='square')]+boxh,
                           border='blue', lwd=2))

text(2.7, 1, "Pedigree")

with(ecomaps.plotdata, text(x=x[8], y=y[8] + boxh/2,'diseased',col='purple'))

# rect, boxh, boxw