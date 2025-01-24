#' @param categorical_vars A character vector specifying the names of the categorical variables to be one-hot encoded.
#' @param dataset A data frame containing the input data to be encoded.
#' @param dataset A data frame containing the input data to be preprocessed
#' @param dataset A data frame containing the input data to be processed.
#' @param dataset A data frame containing the input data.
#' @param id_var A character string indicating the column to be treated as #' identifier. These columns are excluded during preprocessing.
#' @param maxdepth The maximum depth of the decision tree. Default: 30.
#' @param n_unique An integer specifying the maximum number of unique values a column can have to be considered categorical, Default: 20
#' @param n_unique An integer specifying the maximum number of unique values a column can have to be considered categorical. Default: 20.
#' @param na_threshold A numeric value between 0 and 1 indicating the maximum proportion of missing values allowed in a column. Default: 0.5.
#' @param na_threshold PARAM_DESCRIPTION, Default: 0.5
#' @param na_thresholdA numeric value between 0 and 1 indicating the maximum proportion of missing values allowed in a column. Default: 0.5.
#' @param remove_col_NA A logical value indicating whether to remove columns with a proportion of missing values exceeding `na_threshold`. Default: FALSE.
#' @param remove_cor_cols A logical value indicating whether to remove columns with high correlations (correlation coefficient > 0.8). Default: FALSE.
#' @param remove_duplicate_cols A logical value indicating whether to remove duplicate columns. Default: FALSE.
#' @param remove_ld_cols A logical value indicating whether to remove columns with linear dependencies. Default: FALSE.
#' @param remove_unique_cols A logical value indicating whether to remove columns with only unique values. Default: FALSE.
#' @param target A character string indicating the name of the target variable #' in the dataset.
#' @param target A character string indicating the name of the target variable in the dataset.
#' @param target A character string indicating the name of the target variable in the dataset. This column will not be altered during this function.
#' @param target A character string specifying the name of the target variable.
#' @param test_size The fraction of the dataset to be used as the test set. Default: 0.2.
