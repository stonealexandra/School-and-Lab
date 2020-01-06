#Problem 1

#a
data(ALL,package="ALL");library(ALL)
library(ArrayExpress);library(affy)
IsB <- factor(sub('\\d+', '', ALL$BT) ,
                  levels=c('T', 'B'), labels=c("FALSE","TRUE"))

#b
library(ALL);data(ALL)
ALLIsB <- ALL[,ALL$BT %in% c("T", "B")] 
prob.name.1 <-"39317_at" #select the gene
expr.data.1 <- exprs(ALLIsB)[prob.name.1, ] 
IsB <- (ALLIsB$BT=="B") #A boolean class indicator (in B)
data.lgr.1 <- data.frame(IsB, expr.data.1)
fit.lgr.1 <- glm(IsB~., family=binomial(link='logit'), data=data.lgr.1)
pred.prob.1 <- predict(fit.lgr.1, data=data.lgr.1$expr.data.1, type="response")
pred.B.1 <- factor(pred.prob.1> 0.5, levels=c(TRUE,FALSE), labels=c("B","not")) 
IsB<-factor(IsB, levels=c(TRUE,FALSE), labels=c("B","not")) 
table.1<-table(pred.B.1, IsB)
library(ROCR)
pred.1 <- prediction(pred.prob.1, IsB=="B") 
perf.1 <- performance(pred.1, "tpr", "fpr" ) #compute tpr and fpr for pred
plot(perf.1) 

prob.name.2 <-"39318_at" #select the gene
expr.data.2 <- exprs(ALLIsB)[prob.name.2, ]
IsB <- (ALLIsB$BT=="B") #A boolean class indicator (in B)
data.lgr.2 <- data.frame(IsB, expr.data.2) 
fit.lgr.2 <- glm(IsB~., family=binomial(link='logit'), data=data.lgr.2)
pred.prob.2 <- predict(fit.lgr.2, data=data.lgr.2$expr.data.2, type="response")
pred.B.2 <- factor(pred.prob.2> 0.5, levels=c(TRUE,FALSE), labels=c("B","not"))
IsB<-factor(IsB, levels=c(TRUE,FALSE), labels=c("B","not")) 
table(pred.B.2, IsB)
library(ROCR) ##Load library
pred.2 <- prediction(pred.prob.2, IsB=="B") 
perf.2 <- performance(pred.2, "tpr", "fpr" ) #compute tpr and fpr for pred
plot(perf.2) 

#c
performance(pred.1,"auc")
performance(pred.2,"auc")

#d
n<-dim(data.lgr.1)[1]
fnr.cv.raw<-rep(NA, n) 
for (i in 1:n) {
  data.tr.1<-data.lgr.1[-i,] #remove i-th observation from training
  data.test.1<-data.lgr.1[i,] #the i-th observation is kept for testing
  fit.lgr.1 <- glm(IsB~., family=binomial(link='logit'), data=data.tr.1) 
  pred.prob.1 <- predict(fit.lgr.1, newdata=data.test.1, type="response")
  #prediction probability
  pred.B.1<- (pred.prob.1> 0.5) #prediction class
  fnr.cv.raw[i]<- 1/sum(IsB =="B") 
}
fnr.cv<-mean(fnr.cv.raw)

n<-dim(data.lgr.2)[1]
fnr.cv.raw<-rep(NA, n) 
for (i in 1:n) {
  data.tr.2<-data.lgr.2[-i,] #remove i-th observation from training
  data.test.2<-data.lgr.2[i,] #the i-th observation is kept for testing
  fit.lgr.2 <- glm(IsB~., family=binomial(link='logit'), data=data.tr.2) 
  pred.prob.2 <- predict(fit.lgr.2, newdata=data.test.2, type="response")
  #prediction probability
  pred.B.2<- (pred.prob.2> 0.5) #prediction class
  fnr.cv.raw[i]<- 1/sum(IsB =="B") 
}
fnr.cv<-mean(fnr.cv.raw)

#e
fit.lgr.1
confint(fit.lgr.1, level=0.8) 
fit.lgr.2

#f
library(ALL);data(ALL)
ALLIsB <- ALL[,ALL$BT %in% c("T", "B")] 
prob.name.1 <-"39317_at" #select the gene
expr.data.1 <- exprs(ALLIsB)[prob.name.1, ] 
IsB <- (ALLIsB$BT=="B") #A boolean class indicator (in B)
data.lgr.1 <- data.frame(IsB, expr.data.1)
set.seed(131)
testID <- sample(1:10, 4, replace = FALSE) 
data.tr.1<-data.lgr.1[-testID, ] #training data, remove test cases with "-"
data.test.1<-data.lgr.1[testID, ] 
fit.lgr.1 <- glm(IsB~., family=binomial(link='logit'), data=data.tr.1)
pred.prob.1 <- predict(fit.lgr.1, data=data.tr.1, type="response")
pred.B.1 <- factor(pred.prob.1> 0.5)
mcr.tr.1<- sum(pred.B.1!=data.tr.1$IsB)/length(data.tr.1$IsB) 
pred.prob.1 <- predict(fit.lgr.1, data=data.tr.1, type="response")
pred.B.1 <- factor(pred.prob.1> 0.5)
mcr.test.1<- sum(pred.B.1!=data.tr.1$IsB)/length(data.tr.1$IsB)
data.frame(mcr.tr.1, mcr.test.1)

library(ALL);data(ALL)
ALLIsB <- ALL[,ALL$BT %in% c("T", "B")] 
prob.name.2 <-"39318_at" #select the gene
expr.data.2 <- exprs(ALLIsB)[prob.name.2, ] 
IsB <- (ALLIsB$BT=="B") #A boolean class indicator (in B)
data.lgr.2 <- data.frame(IsB, expr.data.2)
set.seed(131)
testID <- sample(1:10, 4, replace = FALSE) 
data.tr.2<-data.lgr.2[-testID, ] #training data, remove test cases with "-"
data.test.2<-data.lgr.2[testID, ] 
fit.lgr.2 <- glm(IsB~., family=binomial(link='logit'), data=data.tr.2)
pred.prob.2 <- predict(fit.lgr.2, data=data.tr.2, type="response")
pred.B.2 <- factor(pred.prob.2> 0.5)
mcr.tr.2<- sum(pred.B.2!=data.tr.2$IsB)/length(data.tr.2$IsB) 
pred.prob.2 <- predict(fit.lgr.2, data=data.tr.2, type="response")
pred.B.2 <- factor(pred.prob.2> 0.5)
mcr.test.2<- sum(pred.B.2!=data.tr.2$IsB)/length(data.tr.2$IsB)
data.frame(mcr.tr.2, mcr.test.2)

#g
pca.all<-prcomp(ALL, scale=TRUE) 
summary(pca.all)

#h
pca.all<-prcomp(ALL[,1:5], scale=TRUE)
summary(pca.all)
data.pca<-pca.all$x[,1:5]
summary(data.pca)
data.pca.numeric<-as.numeric(data.pca)
n<-length(data.pca.numeric)
pca.all.svm <- svm(IsB~data.pca.numeric, type = "C-classification", kernel =
                     "linear")


#i
pca.all<-prcomp(ALL[,1:5], scale=TRUE)
pca.all
library(e1071)

#j

#Problem 2
#a
#For 1 PC
pca.iris<-prcomp(iris[,1:4], scale=TRUE)
summary(pca.iris)
Species<-iris$Species #response variable with true classes
data.pca<-pca.iris$x[,1:1] #keep only the first principal components
n<-length(Species) #sample size n
iris2<-data.frame(Species, data.pca) #combine response variable with PCA data
fit<- rpart(Species ~ ., data = iris2, method = "class") #Fit tree iris2 data
pred.tr<-predict(fit, iris2, type = "class") #predict classes from the tree
mcr.tr <-mean(pred.tr!=Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  fit.tr <-rpart(Species ~ ., data = iris2[-i,], method = "class") #train the tree without i-th observation
  pred <-predict(fit.tr, iris2[i,], type = "class")#use tree to predict i-th observation class
  mcr.cv.raw[i]<- mean(pred!=Species[i]) #check misclassifion
}
mcr.cv<-mean(mcr.cv.raw) #average the mcr over all n rounds.
c(mcr.tr, mcr.cv)

iris2.lgr <-vglm(Species~., family=multinomial, data=iris2) #Logistic Regression
pred.prob <- predict(iris2.lgr, iris2[,-1], type="response") #get prediction probability for all cases in data set
pred.lgr <-apply(pred.prob, 1, which.max) #Assign to the class with largest prediction probability
pred.lgr<- factor(pred.lgr, levels=c("1","2","3"), labels=levels(iris2$Species)) #relabel 1,2,3 by species names
mcr.lgr <-mean(pred.lgr!=iris2$Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  fit.lgr <-vglm(Species~., family=multinomial, data=iris2[-i,]) #fit logistic regression without i-th observation
  pred.prob<- predict(fit.lgr, iris2[i,-1], type="response") #get prediction probability
  pred <-apply(pred.prob, 1, which.max) #Assign class
  pred <-factor(pred, levels=c("1","2","3"), labels=levels(iris2$Species)) #relabel 1,2,3 by species names
  mcr.cv.raw[i]<-mean(pred!=Species[i]) #check misclassification
}
mcr.cv.4<-mean(mcr.cv.raw) #average the mcr over all n rounds.
c(mcr.lgr, mcr.cv)

iris2.svm<- svm(data.pca, Species, type = "C-classification", kernel = "linear") #train SVM
svmpred<- predict(iris2.svm , data.pca) #get SVM prediction.
mcr.svm <-mean(svmpred!=Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  svmest <-svm(data.pca[-i,], Species[-i], type = "C-classification", kernel = "linear") #train SVM without i-th observation
  svmpred <-predict(svmest, t(data.pca[i,])) #predict i-th observation. Here transpose t() is used to make the vector back into a 1 by ncol matrix
  mcr.cv.raw[i] <-mean(svmpred!=Species[i]) #misclassification rate
}
mcr.cv<-mean(mcr.cv.raw)

#For 2 PC
pca.iris<-prcomp(iris[,1:4], scale=TRUE)
summary(pca.iris)
Species<-iris$Species #response variable with true classes
data.pca<-pca.iris$x[,1:2] #keep only the first two principal components
n<-length(Species) #sample size n
iris2<-data.frame(Species, data.pca) #combine response variable with PCA data
fit<- rpart(Species ~ ., data = iris2, method = "class") #Fit tree iris2 data
pred.tr<-predict(fit, iris2, type = "class") #predict classes from the tree
mcr.tr <-mean(pred.tr!=Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  fit.tr <-rpart(Species ~ ., data = iris2[-i,], method = "class") #train the tree without i-th observation
  pred <-predict(fit.tr, iris2[i,], type = "class")#use tree to predict i-th observation class
  mcr.cv.raw[i]<- mean(pred!=Species[i]) #check misclassifion
}
mcr.cv<-mean(mcr.cv.raw) #average the mcr over all n rounds.
c(mcr.tr, mcr.cv)

iris2.lgr <-vglm(Species~., family=multinomial, data=iris2) #Logistic Regression
pred.prob <- predict(iris2.lgr, iris2[,-1], type="response") #get prediction probability for all cases in data set
pred.lgr <-apply(pred.prob, 1, which.max) #Assign to the class with largest prediction probability
pred.lgr<- factor(pred.lgr, levels=c("1", "2", "3"), labels=levels(iris2$Species)) #relabel 1,2,3 by species names
mcr.lgr <-mean(pred.lgr!=iris2$Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  fit.lgr <-vglm(Species~., family=multinomial, data=iris2[-i,]) #fit logistic regression without i-th observation
  pred.prob<- predict(fit.lgr, iris2[i,-1], type="response") #get prediction probability
  pred <-apply(pred.prob, 1, which.max) #Assign class
  pred <-factor(pred, levels=c("1", "2", "3"), labels=levels(iris2$Species)) #relabel 1,2,3 by species names
  mcr.cv.raw[i]<-mean(pred!=Species[i]) #check misclassification
}
mcr.cv.2<-mean(mcr.cv.raw) #average the mcr over all n rounds.
c(mcr.lgr, mcr.cv.2)

iris2.svm<- svm(data.pca, Species, type = "C-classification", kernel = "linear") #train SVM
svmpred<- predict(iris2.svm , data.pca) #get SVM prediction.
mcr.svm <-mean(svmpred!=Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  svmest <-svm(data.pca[-i,], Species[-i], type = "C-classification", kernel = "linear") #train SVM without i-th observation
  svmpred <-predict(svmest, t(data.pca[i,])) #predict i-th observation. Here transpose t() is used to make the vector back into a 1 by ncol matrix
  mcr.cv.raw[i] <-mean(svmpred!=Species[i]) #misclassification rate
}
mcr.cv<-mean(mcr.cv.raw)

#For 3 PC
pca.iris<-prcomp(iris[,1:4], scale=TRUE)
summary(pca.iris)
Species<-iris$Species #response variable with true classes
data.pca<-pca.iris$x[,1:3] #keep only the first three principal components
n<-length(Species) #sample size n
iris2<-data.frame(Species, data.pca) #combine response variable with PCA data
fit<- rpart(Species ~ ., data = iris2, method = "class") #Fit tree iris2 data
pred.tr<-predict(fit, iris2, type = "class") #predict classes from the tree
mcr.tr <-mean(pred.tr!=Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  fit.tr <-rpart(Species ~ ., data = iris2[-i,], method = "class") #train the tree without i-th observation
  pred <-predict(fit.tr, iris2[i,], type = "class")#use tree to predict i-th observation class
  mcr.cv.raw[i]<- mean(pred!=Species[i]) #check misclassifion
}
mcr.cv<-mean(mcr.cv.raw) #average the mcr over all n rounds.
c(mcr.tr, mcr.cv)

iris2.lgr <-vglm(Species~., family=multinomial, data=iris2) #Logistic Regression
pred.prob <- predict(iris2.lgr, iris2[,-1], type="response") #get prediction probability for all cases in data set
pred.lgr <-apply(pred.prob, 1, which.max) #Assign to the class with largest prediction probability
pred.lgr<- factor(pred.lgr, levels=c("1","2","3"), labels=levels(iris2$Species)) #relabel 1,2,3 by species names
mcr.lgr <-mean(pred.lgr!=iris2$Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  fit.lgr <-vglm(Species~., family=multinomial, data=iris2[-i,]) #fit logistic regression without i-th observation
  pred.prob<- predict(fit.lgr, iris2[i,-1], type="response") #get prediction probability
  pred <-apply(pred.prob, 1, which.max) #Assign class
  pred <-factor(pred, levels=c("1","2","3"), labels=levels(iris2$Species)) #relabel 1,2,3 by species names
  mcr.cv.raw[i]<-mean(pred!=Species[i]) #check misclassification
}
mcr.cv.3<-mean(mcr.cv.raw) #average the mcr over all n rounds.
c(mcr.lgr, mcr.cv.3)

iris2.svm<- svm(data.pca, Species, type = "C-classification", kernel = "linear") #train SVM
svmpred<- predict(iris2.svm , data.pca) #get SVM prediction.
mcr.svm <-mean(svmpred!=Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  svmest <-svm(data.pca[-i,], Species[-i], type = "C-classification", kernel = "linear") #train SVM without i-th observation
  svmpred <-predict(svmest, t(data.pca[i,])) #predict i-th observation. Here transpose t() is used to make the vector back into a 1 by ncol matrix
  mcr.cv.raw[i] <-mean(svmpred!=Species[i]) #misclassification rate
}
mcr.cv<-mean(mcr.cv.raw) #average the mcr over all n rounds.

#For 4 PC
pca.iris<-prcomp(iris[,1:4], scale=TRUE)
summary(pca.iris)
Species<-iris$Species #response variable with true classes
data.pca<-pca.iris$x[,1:4] #keep only the first four principal components
n<-length(Species) #sample size n
iris2<-data.frame(Species, data.pca) #combine response variable with PCA data
fit<- rpart(Species ~ ., data = iris2, method = "class") #Fit tree iris2 data
pred.tr<-predict(fit, iris2, type = "class") #predict classes from the tree
mcr.tr <-mean(pred.tr!=Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  fit.tr <-rpart(Species ~ ., data = iris2[-i,], method = "class") #train the tree without i-th observation
  pred <-predict(fit.tr, iris2[i,], type = "class")#use tree to predict i-th observation class
  mcr.cv.raw[i]<- mean(pred!=Species[i]) #check misclassifion
}
mcr.cv<-mean(mcr.cv.raw) #average the mcr over all n rounds.
c(mcr.tr, mcr.cv)

iris2.lgr <-vglm(Species~., family=multinomial, data=iris2) #Logistic Regression
pred.prob <- predict(iris2.lgr, iris2[,-1], type="response") #get prediction probability for all cases in data set
pred.lgr <-apply(pred.prob, 1, which.max) #Assign to the class with largest prediction probability
pred.lgr<- factor(pred.lgr, levels=c("1","2","3"), labels=levels(iris2$Species)) #relabel 1,2,3 by species names
mcr.lgr <-mean(pred.lgr!=iris2$Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  fit.lgr <-vglm(Species~., family=multinomial, data=iris2[-i,]) #fit logistic regression without i-th observation
  pred.prob<- predict(fit.lgr, iris2[i,-1], type="response") #get prediction probability
  pred <-apply(pred.prob, 1, which.max) #Assign class
  pred <-factor(pred, levels=c("1","2","3"), labels=levels(iris2$Species)) #relabel 1,2,3 by species names
  mcr.cv.raw[i]<-mean(pred!=Species[i]) #check misclassification
}
mcr.cv.4<-mean(mcr.cv.raw) #average the mcr over all n rounds.
c(mcr.lgr, mcr.cv.4)
iris2.svm<- svm(data.pca, Species, type = "C-classification", kernel = "linear") #train SVM
svmpred<- predict(iris2.svm , data.pca) #get SVM prediction.
mcr.svm <-mean(svmpred!=Species) #misclassification rate
### leave-one-out cross validation
mcr.cv.raw<-rep(NA, n) #A vector to save mcr validation
for (i in 1:n) {
  svmest <-svm(data.pca[-i,], Species[-i], type = "C-classification", kernel = "linear") #train SVM without i-th observation
  svmpred <-predict(svmest, t(data.pca[i,])) #predict i-th observation. Here transpose t() is used to make the vector back into a 1 by ncol matrix
  mcr.cv.raw[i] <-mean(svmpred!=Species[i]) #misclassification rate
}
mcr.cv<-mean(mcr.cv.raw) #average the mcr over all n rounds.
