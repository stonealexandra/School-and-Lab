#Problem 1

#a
library(ArrayExpress);library(affy)
getAE('E-MEXP-1551', path = 'C:/yeast',  type = "full")
yeast.raw <-  ReadAffy(celfile.path= 'C:/yeast' )

eset <- expresso(yeast.raw,
                                 normalize.method = "quantiles",
                                 bgcorrect.method = "mas",
                                 pmcorrect.method = "pmonly",
                                 summary.method = "medianpolish")

#b
apply(exprs(eset)[1:5,],1,mean)

#c
summary(eset)

#Problem 2

#a
annotation(yeast.raw)
source("https://bioconductor.org/biocLite.R")
biocLite("yeast2.db")

#b
library(yeast2.db)
library(annotate)
GO1769308<-get("1769308_at", env = yeast2GO)
getOntology(GO1769308, "MF")

#c
source("https://bioconductor.org/biocLite.R")
biocLite("GO.db")
library("GO.db")
GO1769308<-get("1769308_at", env = yeast2GO)
gonr <- getOntology(GO1769308, "MF") 
gP <- getGOParents(gonr) 
pa <- sapply(gP,function(x) x$Parents)      
gonrp <- unique(c(unlist(pa)))

#d
gC <- getGOChildren(gonr)
ch <- sapply(gC,function(x) x$Children) 
gonrc <- unique(c(unlist(ch))) 

#Problem 3

#a
library("ALL")
data("ALL")
ALLB23 <- ALL[,which(ALL$BT %in% c("B2","B3"))]
library(genefilter)
f1<- function(x) (wilcox.test(x, exact=F)$p.value < 0.001)
f2 <- function(x) (t.test(x ~ ALLB23$BT)$p.value < 0.001)
sel1 <- genefilter(exprs(ALLB23[,ALLB23$BT=="B2"]), filterfun(f1))
sel2 <- genefilter(exprs(ALLB23[,ALLB23$BT=="B3"]), filterfun(f1))
sel3 <- genefilter(exprs(ALLB23), filterfun(f2))
selected <-sel1 & sel2 & sel3
ALLs <- ALL[selected,] 

#b
library(limma)
x <- apply(cbind(sel1,sel2,sel3), 2, as.integer)
vc <- vennCounts(x, include="both")              
vennDiagram(vc) 

#c
sum(sel1 & sel2)
sum(sel1 & sel2 & sel3)

#d
annotation(ALL)
source("https://bioconductor.org/biocLite.R")
biocLite("hgu95av2.db")
library("hgu95av2.db")
library(annotate)
library("GO.db")
GOTerm2Tag <- function(term) {
  GTL <- eapply(GOTERM, function(x) {grep(term, x@Term, value=TRUE)}) 
  Gl <- sapply(GTL, length)         
  names(GTL[Gl>0])                
}
GOTerm2Tag("oncogene")

#e
tran <- hgu95av2GO2ALLPROBES$"GO:0090402" 
inboth <- tran %in% row.names(exprs(ALLs))       
ALLtran <- ALLs[tran[inboth],] 
dim(exprs(ALLtran))

#Problem 4

#a
library("limma")
data(ALL,package="ALL");library(ALL)
allB <-ALL[,ALL$BT%in%c("B1","B2","B3")] 
design.ma <- model.matrix(~ 0 + factor(allB$BT))
colnames(design.ma) <- c("B1","B2","B3")

#b
fit <- lmFit(allB, design.ma)
fit <- eBayes(fit)
print( topTable(fit, coef=3, number=5,adjust.method="fdr"), digits=4) 

#c
cont.ma <- makeContrasts(B1-B2, B2-B3, levels=factor(allB$BT))
cont.ma
fit1 <- contrasts.fit(fit, cont.ma)
fit1 <- eBayes(fit1) 
print( topTable(fit1, number=5, p.value=0.01, adjust.method="fdr"), digits=4) 
