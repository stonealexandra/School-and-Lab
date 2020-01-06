#Problem 1
#a
data(ALL,package="ALL");library(ALL)
library(ArrayExpress);library(affy)
ALL.fac <- factor(sub('\\d+', '', ALL$BT) ,
                  levels=c('T', 'B'), labels=c(1,2)) 

#b
Y1 <- exprs(ALL[1,])
Y2 <- exprs(ALL[2,])
Y3 <- exprs(ALL[3,])
par(mfrow=c(1,3))    #3 plots in one row
hist(Y1,freq=F, nclass=12);lines(density(Y1), col='red')    #histogram+density
hist(Y2,freq=F, nclass=12);lines(density(Y2), col='red')
hist(Y3,freq=F, nclass=12);lines(density(Y3), col='red')

#c
first.five.in.columns <- t(exprs(ALL)[1:5,])
pairs(first.five.in.columns[,1:5], col=ALL.fac) 

#d
library(scatterplot3d)
at39317 <- exprs(ALL)["39317_at",] 
at32649 <- exprs(ALL)["32649_at",]
at481 <- exprs(ALL)["481_at",]
scatterplot3d(at39317, at32649, at481, color=as.numeric(ALL.fac))
summary(ALL.fac)

#e
at.clusters=kmeans(cbind(at39317,at32649,at481),centers=2,nstart=10)
two.clusters=table(at.clusters$cluster,ALL.fac)

at.clusters=kmeans(cbind(at39317,at32649,at481),centers=3,nstart=10)
three.clusters=table(at.clusters$cluster,ALL.fac)


#f
pr.ALL<-prcomp(ALL, scale=TRUE) 
summary(pr.ALL)

#g
biplot(pr.ALL, xlim=c(-0.05,0.03), ylim=c(-0.05,0.05), cex=0.5)
#red arrow lines are about the same size
#first principal component is summarizing the averages

#h
o <- order(pr.ALL$x[,2]) 
o1<-print(o[1:3],2) #first most negative/smallest
o2<-print(o[12623:12625],2) #last most positive/largest
PRALLDATA<-pr.ALL$x

#first/smallest
pr.ALL$x[9406,2] #39317_at      -6.096443
pr.ALL$x[2673,2] #32649_at      -5.838913
pr.ALL$x[4721,2] #34677_f_at    -5.215388

#last/largest
pr.ALL$x[11271,2] #41165_g_at   4.888194
pr.ALL$x[8095,2]  #38018_g_at   4.938823
pr.ALL$x[12047,2] #481_at       5.357233

#i
source("http://www.bioconductor.org/biocLite.R")
biocLite("hgu95av2.db")
library("hgu95av2.db") 
get("481_at", env = hgu95av2GENENAME) #largest
# "SNF related kinase"
get("481_at", env = hgu95av2CHRLOC)
#chromosome 3 
 
get("39317_at", env = hgu95av2GENENAME) #smallest
#"cytidine monophospho-N-acetylneuraminic 
#acid hydroxylase, pseudogene"
get("39317_at", env = hgu95av2CHRLOC)
#chromosome 6  

#Problem 2
#a
iris2 <- iris 
iris2$Species <- NULL
iris2
iris.scaled <- as.data.frame(scale(iris[,1:4]))
iris.scaled

#b
cor(iris2)
cor(iris.scaled)

#c
iris.rot<-t(iris.scaled)
iris.dis<-dist(iris.rot, method="euclidean")


#d
pcIris2 <- prcomp(iris2, scale=FALSE)
pcIrisScaled <- prcomp(iris.scaled, scale=FALSE)

#e
summary(pcIris2)
summary(pcIrisScaled)

#f
data <- pcIrisScaled$x; p <- 4; n <- 150 ; nboot<-1000 #define quantities
sdevs <- array(dim=c(nboot,p)) 
for (i in 1:nboot) {
  dat.star <- data[sample(1:n,replace=TRUE),] 
  sdevs[i,] <- prcomp(dat.star)$sdev 
}
print(names(quantile(sdevs[,1], c(0.05,0.95)))) 
for (j in 1:p) cat(j, as.numeric(quantile(sdevs[,j], 
  c(0.05,0.95))),"\n") 
