% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Helper_Functions.R
\name{kfoldDataPartition}
\alias{kfoldDataPartition}
\title{Label Stratified Data Partitioning For K-Fold Cross-Validation}
\usage{
kfoldDataPartition(df, kfold, seed = 8272008, permuteLabel = F)
}
\arguments{
\item{df}{a data.frame with samples x features data.frame with the first column being the class labels}

\item{kfold}{number of data train-test splits}

\item{seed}{random seed; enables reproducibility of data partitions}

\item{permuteLabel}{should the labels be permuted before performing partitions. Useful when determining permutation significance of a classifier.}
}
\value{
a k-element list containing the train-test (xtrain_combinedFolds / xtest_kthFold) splits along with sample IDs (xtrain_IDs / xtest_IDs )
}
\description{
Easily creates k train-test splits and stores it partition in a list. Allows for easy retrieval of data partitions and sample identification.
}
\examples{
\dontrun{
## Sample Data Matrix with Binary Classes (A/B)
dat = data.frame(CLass =sample(x = c("A","B"),size = 50,replace = T) ,
   matrix(runif(50*50),nrow = 50))

## Perform 5-fold Data Paritioning of dat
foldData = kfoldDataPartition(df = dat,
   kfold = 5,
   permuteLabel = F,
   seed = 1)

 ## get first fold
  trainData = foldData[[1]]$xtrain_combinedFolds
  trainIDS = foldData[[1]]$xtrain_IDs
  testData = foldData[[1]]$xtest_kthFold
  testIDs = foldData[[1]]$xtest_IDs
}

}
