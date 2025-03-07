% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/modeling.R
\name{modeling}
\alias{modeling}
\title{Decision Tree Modeling}
\usage{
modeling(dataset, target, test_size = 0.2, maxdepth = 30)
}
\arguments{
\item{dataset}{A data frame containing the input data.}

\item{target}{A character string indicating the name of the target variable in the dataset.}

\item{test_size}{The fraction of the dataset to be used as the test set. Default: 0.2.}

\item{maxdepth}{The maximum depth of the decision tree. Default: 30.}
}
\value{
A list containing the trained model and performance metrics
}
\description{
A function thar performs classification modeling using a decision tree, with cross-validation to choose the best complexity parameter (cp) for the tree.
}
\details{
DETAILS
}
\examples{
\dontrun{
if(interactive()){
 #EXAMPLE1
 }
}
}
\seealso{
\code{\link[logger]{log_level}}
 \code{\link[dplyr]{select}}, \code{\link[dplyr]{reexports}}
 \code{\link[caret]{createDataPartition}}, \code{\link[caret]{train}}, \code{\link[caret]{trainControl}}, \code{\link[caret]{confusionMatrix}}
 \code{\link[rpart]{rpart}}
}
