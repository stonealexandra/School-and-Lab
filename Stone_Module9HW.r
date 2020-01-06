#Problem 1
#a
data(golub,package="multtest") 
grep("GRO2 GRO2",golub.gnames[,2])
grep("GRO3 GRO3",golub.gnames[,2])
x <- golub[2714,]
y <- golub[2715,]
cor(x,y)

#b
cor.test(x,y,
         alternative = c("two.sided", "less", "greater"),
         method = c("pearson", "kendall", "spearman"),
         exact = NULL, conf.level = 0.90, continuity = FALSE)

#c
nboot <- 2000 
boot.cor<-matrix(0,nrow=nboot,ncol=1) 
data<- cbind(x,y)
for (i in 1:nboot){
  dat.star<-data[sample(1:nrow(data), replace=TRUE), ]
  boot.cor[i,]<- cor(dat.star[,1], dat.star[,2]) 
}
mean(boot.cor)
quantile(boot.cor[,1], c(0.050,0.950))


#Problem 2
#a
grep("Zyxin",golub.gnames[,2]) 
zyxin <- golub[2124,]
cor.zyxin <- apply(golub,1,function(x) cor.test(x,zyxin)$estimate)
sum(cor.zyxin < -0.05)

#b
o <- order(cor.zyxin)
golub.gnames[o[1:5],2]

#c
p.fdr<-p.adjust(p=cor.zyxin, method="fdr") 
sum(p.fdr< -0.05)

#Problem 3
#a
data(golub,package="multtest") 
GRO2_GRO2 <- golub[2714,]
GRO3_GRO3 <- golub[2715,]
reg.fit<-lm(GRO3_GRO3 ~ GRO2_GRO2) #GRO3_GRO3 on GRO2_GRO2
#Regression GRO3_GRO3 = b0+ b1*GRO2_GRO2
reg.fit
#e b0= -0.8426  b1= 0.3582
#estimated equation is GRO3_GRO3 = -0.8426 + .03582*GRO2_GRO2
summary(reg.fit)

#b
confint(reg.fit, level=0.9) 

#c
predict(lm(GRO3_GRO3~GRO2_GRO2), newdata=data.frame(GRO2_GRO2=0),interval="prediction", level=0.8)

#d
qqnorm(resid(reg.fit))

#Problem 4
#a
lsl = lm(stack.loss~ Air.Flow + Water.Temp + Acid.Conc., data=stackloss)
summary(lsl)
#stack.loss=???39.92 + .72 Air.Flow + 1.30 Water.Temp ??? .15 Acid.Conc.

#b
#Air.Flow and Water.Temp statistically significant
#r squared = .9136

#c
stackloss.lm = lm(stack.loss ~ Air.Flow + Water.Temp + Acid.Conc.,
                data=stackloss) 
newdata = data.frame(Air.Flow=60, Water.Temp=20, Acid.Conc.=90) 
predict(stackloss.lm, newdata, interval="confidence", level=.90)
predict(stackloss.lm, newdata, interval="prediction", level=.90) 