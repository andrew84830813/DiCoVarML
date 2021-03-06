% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trainEnsemble.R
\name{trainML_Models}
\alias{trainML_Models}
\title{Caret Wrapper for Training Model Ensembles}
\usage{
trainML_Models(
  trainLRs,
  testLRs,
  ytrain,
  y_test,
  testIDs = NULL,
  models = c("ranger", "svmRadial", "gbm", "pls"),
  Index_ = NULL,
  numRepeats = 3,
  numFolds = 5,
  cvMethod = "repeatedcv",
  ntrees = 500,
  mtry_ = 1,
  num_comp = 2,
  ranger_imp = "none",
  mlpML_layers = NULL,
  bagModels = F,
  sampleSize,
  seed = 8272008
)
}
\arguments{
\item{trainLRs}{samples by features training data. *without labels*}

\item{testLRs}{samples by features test data. *without class labels*}

\item{ytrain}{training class labels}

\item{y_test}{test class labels}

\item{testIDs}{row meta-data for test samples}

\item{models}{model to be trained. Should be valid caret models names.}

\item{Index_}{NULL; User supplied vector of folds for cross validation partitions.}

\item{numRepeats}{Number of repeats for training cross-validation}

\item{numFolds}{Number of folds for model training}

\item{cvMethod}{cross-validation method; should be a valid caret CV method}

\item{ntrees}{number of trees for random forest models}

\item{mtry_}{mtry for random forest models}

\item{num_comp}{number of components for pls models}

\item{ranger_imp}{variable importance for random forest models}

\item{mlpML_layers}{hidden node structure for 3-layer mlpML model. Should be data.frame(layer1 = 'c()',layer2 = 'c()',layer3 = c())}

\item{bagModels}{should bagging be used to train the model ensemble}

\item{sampleSize}{sample size for bagging samples}

\item{seed}{random seed}
}
\value{
A list containing:\tabular{ll}{
   \code{performance} \tab training performance for each model  \cr
   \tab \cr
   \code{predictionMatrix} \tab prediction probs for test samples for each model  \cr
   \tab \cr
   \code{models} \tab caret model object for each model  \cr
   \tab \cr
}
}
\description{
Convenient wrapper for training multiple caret models and making predictions on test data.
}
\seealso{
\code{\link[caret]{trainControl}}
}
