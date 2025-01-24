#' @title Detect Categorical Variables
#' @description A function that identifies columns in a dataset that can be considered categorical based on the number of unique values and their data type.
#' @param dataset A data frame containing the input data.
#' @param n_unique An integer specifying the maximum number of unique values a column can have to be considered categorical. Default: 20.
#' @return A character vector containing the names of the columns classified as categorical.
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname detect_categorical_vars
#' @export
detect_categorical_vars <- function(dataset,
                                    n_unique = 20) {
  # Contar quantidade de valores unicos presentes em cada coluna do dataset
  count_unique <- lapply(dataset, unique)

  # Se a variavel e do tipo inteiro ou logico e tiver menos que n_unique
  # valores unicos, sera considerada uma variavel categorica
  filters <- sapply(count_unique, function(value) {
    length(value) <= n_unique &&
      (is.integer(value) || is.logical(value))
  })

  categorical_cols <- names(dataset)[filters]

  return(categorical_cols)

}
