#Problem 1
#a
library(ALL);data(ALL)
ALLB12345 <- ALL[,ALL$BT %in% c("B", "B1","B2","B3", "B4", "B5")] 
y <- exprs(ALLB12345)["109_at",] 
anova(lm(y ~ ALLB12345$BT)) 
#look at p value...does express differently

#b
summary(lm(y ~ ALLB12345$BT -1))

#c
summary(lm(y ~ ALLB12345$BT)) 

#d
pairwise.t.test(y,ALLB12345$BT,p.adjust.method='fdr')

#e
shapiro.test(residuals(lm(y ~ ALLB12345$BT)))
bptest(lm(y ~ ALLB12345$BT), studentize = FALSE)

#Problem 2
ALLB <- ALL[,ALL$BT%in%c("B", "B1","B2","B3", "B4")] 
y<- apply(exprs(ALLB), 1, function(x) kruskal.test(x ~ ALLB$BT)$p.value)

#a
p.fdr<-p.adjust(p=y, method="fdr") 
sum(p.fdr<0.05)

#b
sort(p.fdr)[1:5]

#Problem 3
#a
library("ALL"); data(ALL)
ALLBm <- ALL[,which(ALL$BT%in%c("B1","B2","B3","B4") & ALL$sex%in%c("F","M"))] 
y<-exprs(ALLBm)["38555_at",] 
Bcell<-ALLBm$BT 
gend<-ALLBm$sex 
anova(lm(y~ Bcell*gend)) 
summary(lm(y~ Bcell+gend))

#b
shapiro.test(residuals(lm(y ~ ALLBm$BT)))
bptest(lm(y ~ ALLBm$BT), studentize = FALSE)
#since normality is violated, KruskalTest needed
kruskal.test(y ~ ALLBm$BT)

#Problem 4

#a
data(ALL,package="ALL");library(ALL)
ALLB123 <-ALL[,ALL$BT%in%c("B1","B2","B3")] 
data<- exprs(ALLB123)["1242_at",] 
group<-ALLB123$BT[,drop=T] 

perm.test<- function(data, group){
n=length(data)
group.means= by(data, group, mean)
n.group=length(group.means)
T.obs<-(1/(n.group-1))*sum((group.means-mean(group.means))^2)  
n.perm=2000 
for(i in 1:n.perm) {
  data.perm = sample(data, n, replace=F)
  group.means= by(data.perm, group, mean)
  n.group=length(group.means)
  T.perm[i]=(1/(n.group-1))*sum((group.means-mean(group.means))^2)
}
mean(T.perm>=T.obs) 
}

perm.test(data, group)





                 

