#Problem 1
#a
data(golub, package="multtest")
data <- data.frame(golub[1042,])
gol.fac <- factor(golub.cl,levels=0:1, 
                  labels= c("ALL","AML"))
singhc<-hclust(dist(data, method="euclidian"), 
       method="single")
wardhc<-hclust(dist(data, method="euclidian"), 
               method="ward.D2")
plot(singhc, hang =-1,labels = gol.fac)
sing.groups <- cutree(singhc, k=2) 
table(gol.fac,sing.groups)

plot(wardhc, hang =-1,labels = gol.fac)
ward.groups <- cutree(wardhc, k=2)
table(gol.fac,ward.groups)

#Single works best

#b
cl <- kmeans(data, centers=2 )
cl
cl$cluster
table(gol.fac, cl$cluster)

#c Heirarchical

#d
initial<-cl$centers
n <- dim(data)[1]; nboot <-1000
boot.cl <- matrix(NA,nrow=nboot,ncol=2) 
for (i in 1:nboot){
  dat.star <- data[sample(1:n,replace=TRUE),] 
  cl2 <- kmeans(dat.star, centers=initial)
  boot.cl[i,] <- c(cl2$centers)  
}
apply(boot.cl,2,mean)  
quantile(boot.cl[,1],c(0.025,0.975))
quantile(boot.cl[,2],c(0.025,0.975))

#e
K<-(1:30); sse<-rep(NA,length(K)) 
for (k in K) {
  sse[k]<-kmeans(data, centers=k,nstart = 10)$tot.withinss
}
plot(K, sse, type='o', xaxt='n') 
axis(1, at = K, las=2) 

#plot suggests three or four clusters 

#Problem 2
#a
library(multtest); data(golub)
gol.fac <- factor(golub.cl,levels=0:1, labels= c("ALL","AML"))
onco.data<-golub[grep("oncogene",golub.gnames[,2]),]
antig.data<-golub[grep("antigen",golub.gnames[,2]),]
combo.cl<-c(rep(0,42),rep(1,75))
combo.fac<-factor(combo.cl,levels=0:1,labels=c("oncogene","antigen"))
combo.data<-data.frame(rbind(onco.data,antig.data))

#b
clusters.combo<-kmeans(combo.data, centers = 2)
clusters.combo
clusters.combo$cluster
clusters.combo$centers
tbl_kmean=table(combo.fac, clusters.combo$cluster)
library(cluster) 
kmed<-pam(combo.data, k=2)
tbl_kmed=table(combo.fac, kmed$cluster)

#c
chisq.test(tbl_kmean)
chisq.test(tbl_kmed)

#d
plot(hclust(dist(combo.data, method="euclidian"), method="single"),
     labels=combo.fac)
plot(hclust(dist(combo.data, method="euclidian"), method="complete"),
     labels=combo.fac)

#Problem 3
#a
library(ISLR) 
ncidata<-NCI60$data 
ncilabs<-NCI60$labs
K<-(1:30); sse<-rep(NA,length(K)) 
for (k in K) {
  sse[k]<-kmeans(ncidata[1:64,], centers=k,nstart = 10)$tot.withinss
}
plot(K, sse, type='o', xaxt='n') 
axis(1, at = K, las=2) 

#b
ncidata_rows<-ncidata[1:64,]
nci.pam<-pam(ncidata_rows, k=7)
plot(ncidata_rows, col = nci.pam$cluster)
table(NCI60$labs, nci.pam$cluster)
table.pam<-table(NCI60$labs,pam(as.dist(1-cor(t(ncidata_rows))), k=7)$cluster)