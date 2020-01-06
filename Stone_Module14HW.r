#Problem 1
y<-as.numeric(t(read.table(file="DataPois.txt", header=TRUE)))
obs <- y
#a
#n=120
1/mean(obs)
#0.5505

#b
nlx <- function(x) sum(log(dpois(y, lambda=exp(x))))
nlik<- function(x) -nlx(x)
op<-optim(par=1, nlik)
#.5970703

#c
data<-y
nlx <- function(x) sum(log(dpois(y, lambda=exp(x))))
nlik<- function(x) -nlx(x)
lik<-function(lam) prod(dpois(data,lambda=lam)) 
n<-length(data)
nboot<-1000
boot.xbar <- rep(NA, nboot)
for (i in 1:nboot) {
  data.star <- data[sample(1:n,replace=TRUE)]
  boot.xbar[i]<-optim(par=1, lik)$par
}
quantile(boot.xbar,c(0.025,0.975))

#2.5%      97.5% 
# 1           1

#Problem 2
#a
library(ISLR) 
ncidata<-NCI60$data 
ncilabs<-NCI60$labs
dim(ncidata)
indx <- names(table(ncilabs))[table(ncilabs) < 3]
ncidata <- ncidata[!(ncilabs %in% indx),]
ncilabs <- ncilabs[!(ncilabs %in% indx)]
table(ncilabs)

#b
lab.matrix<-as.matrix(ncilabs)
nci.table<-as.data.frame(ncidata, header=TRUE)
first.gene<-nci.table[1:57,1:1]
gene.matrix<-as.matrix(first.gene)
merged<-cbind.data.frame(lab.matrix, gene.matrix)
merged$lab.matrix
merging<-merged[merged$lab.matrix %in% c("CNS","RENAL","BREAST", "NSCLC", 
    "OVARIAN", "LEUKEMIA", "MELANOMA", "COLON"),] 
pairwise.t.test(merged$gene.matrix, merging$lab.matrix, p.adjust.method = 'fdr')

#c
shapiro.test(residuals(lm(merged$gene.matrix ~ merging$lab.matrix))) 
plot(merged$gene.matrix~merging$lab.matrix)
#Since the p-value 0.4414 is large, we accept the null-hypothesis of
#normally distributed residuals
library(lmtest)
bptest(lm(merged$gene.matrix ~ merging$lab.matrix)) 
#the p-value 0.3498, the conclusion follows to accept the null
#hypothesis of equal variances (homoscedasticity)
summary(lm(merged$gene.matrix ~ merging$lab.matrix))
summary(lm(merged$gene.matrix ~ merging$lab.matrix-1))

#d
lab.matrix<-as.matrix(ncilabs)
nci.table<-as.data.frame(ncidata, header=TRUE)
first.gene<-nci.table[1:57,1:1]
gene.matrix<-as.matrix(first.gene)
merged<-cbind.data.frame(lab.matrix, gene.matrix)
merged$lab.matrix
merging<-merged[merged$lab.matrix %in% c("CNS","RENAL","BREAST", "NSCLC", 
             "OVARIAN", "LEUKEMIA", "MELANOMA", "COLON"),] 


emptable<-rep(NA,ncol(nci.table))
for (i in 2:ncol(nci.table))
{
  column<-names(nci.table[i])
  emptable<-summary(lm(nci.table[,i]~lab.matrix, p.adjust = 'fdr',
                       data=nci.table))
}

#Problem 3
#a
the.data<-as.data.frame(state.x77[,c('Population', 'Income', 'Illiteracy',
  'Life Exp', 'Murder', 'HS Grad', 'Frost', 'Area')]) 
names(the.data)<-c('Population', 'Income', 'Illiteracy',
                   'Life.Exp', 'Murder', 'HS Grad', 'Frost', 'Area')
pairs(the.data)

#b
lin.reg<-lm(Life.Exp~Income+Illiteracy+Frost, data=the.data)
summary(lin.reg)

#c
mse <- mean(residuals(lin.reg)^2)
n<-dim(the.data)[1]
mse.cv.raw<-rep(NA, n)
for (i in 1:n) { 
  data.tr<-the.data[-i,]
  data.test<-the.data[i,]
  fit.lgr <- glm(Life.Exp~., data=data.tr)
  pred.prob <- predict(fit.lgr, newdata=data.test, type="response")
  mse.cv.raw[i] <- residuals(lin.reg)^2
}
mean.mse<-mean(mse.cv.raw)
#0.5441243

#Problem 4
library("genefilter");library("ALL"); data(ALL)
#a
patientB <- factor(ALL$BT %in% c("B","B1","B2","B3","B4"))
sel1 <- genefilter(exprs(ALL[,patientB==TRUE]), filterfun(f1))
selected <- sel1
ALLs <- ALL[selected,]
allB <- ALLs[,which(ALL$BT %in% c("B","B1","B2","B3","B4"))]
allB$BT<-allB$BT[,drop=T] 

#b
f1 <- function(x) (sd(x)/abs(mean(x))>0.2)
sel1 <- genefilter(exprs(ALL[,patientB==TRUE]), filterfun(f1))
selected <- sel1
ALLs <- ALL[selected,]
sum(selected)
#184

#c test for normality
f2 <- function(x) (shapiro.test(x)$p.value > 0.05)
sel2 <- genefilter(exprs(ALL[,patientB==TRUE]), filterfun(f2))
selected <- sel1 & sel2
ALLsH <- ALL[selected,]

#d
f1 <- function(x) (sd(x)/abs(mean(x))>0.2)
sel1 <- genefilter(exprs(ALL[,patientB==TRUE]), filterfun(f1))
selected <- sel1
ALLs <- ALL[selected,]
ALLs <- ALLs[,which(ALL$BT %in% c("B","B1","B2","B3","B4"))]
ALLs$BT<-allB$BT[,drop=T]
data=data.frame(ALLs)
singhc<-hclust(dist(data, method="euclidian"), 
               method="single")
plot(singhc, hang =-1,labels = ALLs$BT )
sing.groups <- cutree(singhc, k=4)
singhc<-hclust(dist(data, method="euclidian"), 
               method="single")
plot(singhc, hang =-1,labels = ALLs$mol.biol )
sing.groups <- cutree(singhc, k=4)
BTable<-table(sing.groups, ALLs$BT)
MolBioTable<-table(sing.groups, ALLs$mol.biol)

#e
library(gplots)
MBT<-as.table(MolBioTable, header = TRUE)
row.names(MBT) <- c("1", "2", "3","4")
MBTMatrix<-data.matrix(MBT)
MBT_heatmap <- heatmap(MBTMatrix, Rowv=NA, Colv=NA, 
                       col = cm.colors(256), scale="row")
BTab<-as.table(BTable, header = TRUE)
row.names(BTab) <- c("1", "2", "3","4")
BTabMatrix<-data.matrix(BTab)
BTab_heatmap <- heatmap(BTabMatrix, Rowv=NA, Colv=NA, 
                        col = cm.colors(256), scale="row")

#f
library(hgu95av2.db)
library(limma)
allB <- ALL[,which(ALL$BT %in% c("B1","B2", "B3","B4"))][,drop=T]
levels(allB$BT)[levels(allB$BT)=="B3"] <- "B34"
levels(allB$BT)[levels(allB$BT)=="B4"] <- "B34"
allB$BT[,drop=T]
design.ma <- model.matrix(~0 + factor(allB$BT))
colnames(design.ma) <- c("B1","B2","B34")
cont.ma <- makeContrasts(B2-B1,B34-B1,B2-B34,levels=factor(allB$BT))
fit <- lmFit(allB, design.ma)
names(fit)
fit1 <- contrasts.fit(fit, cont.ma)
fit1 <- eBayes(fit1)
colnames(fit1)
tab<-topTable(fit1,coef=2,adjust="fdr")
tab

#g
library(rpart)
tabnames<-row.names(tab)
tab["probeName"]<- c("1389_at", "1914_at", "38555_at", "40268_at",
                     "39716_at", "40763_at", "37809_at", "31472_s_at", "1866_g_at", "40493_at ")
tabFactored<-factor(tab$probeName)
data.sub <- t(tab[c("1389_at", "1914_at", "38555_at", "40268_at",
  "39716_at", "40763_at", "37809_at", "31472_s_at", "1866_g_at", "40493_at "),])
combined<-cbind(tabFactored,data.sub)
ALL2<-data.frame(combined)
fit <- rpart(ALL2$tabFactored ~ ., data = ALL2, method = "class")
predict.tr<-predict(fit, type = "class")
plot(predict.tr, branch=0,margin=0.1)

library(e1071)
svm(ALL2$tabFactored ~ ., ALL2, type = "C-classification", kernel = "polynomial")


#h
#4  genes are selected
#1914_at 37809_at 38555_at 40763_


#Problem 5
#a
y<-as.numeric(t(read.table(file="DataPoisReg.txt", header=TRUE)))
mlik<-function(beta, y, x) -sum(y * (beta[1] + beta[2] * x) 
                          - exp(beta[1] + beta[2] * x))
optim(c(1, 0), mlik, y = y, x = x)$par
#(0.0541198003 -0.0007031573)

#b
my.dat<-read.table(file="DataPoisReg.txt", header=TRUE)
plot(my.dat)
coef(y2)
lm(formula = my.dat$y ~ my.dat$x)