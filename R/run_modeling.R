#' @title Wrapper function to run the package
#' @description A function that performs pre_process and modeling
#' @param dataset A data frame containing the input data.
#' @param target A character string indicating the name of the target variable in the dataset.
#' @param id_var A character string indicating the column to be treated as #' identifier. These columns are excluded during preprocessing.
#' @param test_size The fraction of the dataset to be used as the test set. Default: 0.2.
#' @param maxdepth The maximum depth of the decision tree. Default: 30.
#' @param na_thresholdA numeric value between 0 and 1 indicating the maximum proportion of missing values allowed in a column. Default: 0.5.
#' @param na_threshold PARAM_DESCRIPTION, Default: 0.5
#' @return Run pre_process and modeling and return a list containing the trained model and performance metrics
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname run_modeling
#' @export
run_modeling <- function(dataset,
                         target,
                         id_var,
                         test_size = 0.2,
                         maxdepth = 30,
                         na_threshold = 0.5){

  # Rodando o pre processamento dos dados
  dataset_pre_process <- pre_process(dataset = dataset,
                                     target = target,
                                     id_var = id_var,
                                     na_threshold =  na_threshold)

  # Rodando a modelagem
  result_modeling <- modeling(dataset = dataset_pre_process,
                              target = target,
                              test_size = test_size,
                              maxdepth = maxdepth)

  return(result_modeling)
}
