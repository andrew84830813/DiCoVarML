#' Additive- Log Ratio (ALR) Feature Selection using BORUTA / LASSO
#'
#' @importFrom magrittr %>%
#'
#' @param train_data a samples by log ratio matrix for feature discovery on training data
#' @param y_train training set class labels
#' @param test_data a samples by log ratio matrix to subset and return. Note key log-ratios are discovered using training set.
#' @param alr_denom which column to use as ALR denominator
#' @param featureSelectionMethod 1 - Boruta; 2- LASSO ; 3 - None
#' @param impute_factor impute factor multiplicative replacement of zeroes
#' @param num_borutaRuns number of runs of the Boruta algorithm
#' @param glmRepeats number of cv repeats
#' @param glmFolds number of cv folds
#'#'
#' @return A list containing:\tabular{ll}{
#'    \code{train_Data} \tab samples by features (derived from featureSelectionMethod) training data  \cr
#'    \tab \cr
#'    \code{test_data} \tab samples by features (derived from featureSelectionMethod) test data \cr
#'    \tab \cr
#'    }
#'
#' @export
#'
alrFeatureSelection =
  function(train_data,
           y_train,
           test_data,
           alr_denom = 1,
           featureSelectionMethod = 1,
           impute_factor = 1e-7,
           num_borutaRuns = 100,
           glmRepeats = 5,
           glmFolds = 5){

    Decision = NULL

    ## CLose data and impute zeroes
    trainData1 = selEnergyPermR::fastImputeZeroes(train_data,impFactor = impute_factor)
    testData1 = selEnergyPermR::fastImputeZeroes(test_data,impFactor = impute_factor)

    ## Get Log-ratios
    lrs.train = data.frame(compositions::alr(trainData1,ivar = alr_denom))
    lrs.test = data.frame(compositions::alr(testData1,ivar = alr_denom))

    switch (featureSelectionMethod,
            {
              ### Boruta
              b = Boruta::Boruta(x = lrs.train,y = y_train,
                                 doTrace = 2,maxRuns = num_borutaRuns,
                                 getImp = Boruta::getImpExtraGini)
              dec = data.frame(Ratio = names(b$finalDecision),Decision = b$finalDecision)
              keep = dec %>%
                dplyr::filter(Decision!="Rejected")
              kr =as.character(keep$Ratio)
              ## select final ratios
              if(length(kr)>2){
                trainData2 = subset(lrs.train,select = c(kr))
                testData2 = subset(lrs.test,select = c(kr))
              }else{
                trainData2 = lrs.train
                testData2 =  lrs.test
              }


            },
            {
              ## penalized regression
              train_control <- caret::trainControl(method="repeatedcv",
                                                   repeats = glmRepeats,
                                                   number=glmFolds,
                                                   seeds = NULL,
                                                   classProbs = TRUE,
                                                   savePredictions = F,
                                                   allowParallel = TRUE,
                                                   summaryFunction = caret::multiClassSummary
              )

              glm.mdl1 = caret::train(x = as.matrix(lrs.train) ,
                                      y =y_train,
                                      metric = "ROC",
                                      max.depth = 0,
                                      method = "glmnet",
                                      trControl = train_control
              )
              imp  = caret::varImp(glm.mdl1)
              imp  = data.frame(feature = rownames(imp$importance),imp = imp$importance,total = rowSums(imp$importance))
              keep = imp[imp$total>0,]
              keep = keep$feature
              if(length(keep)>2){
                trainData2 = subset(lrs.train,select = c(keep))
                testData2 = subset(lrs.test,select = c(keep))
              }else{
                trainData2 = lrs.train
                testData2 =  lrs.test
              }


            },
            {
              ## ALL ALR
              trainData2 = lrs.train
              testData2 = lrs.test
            }
    )

    return(list(train_data =trainData2,test_data = testData2))

  }

