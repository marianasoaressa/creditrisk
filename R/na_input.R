#' @title Handle Missing Values in Dataset
#' @description A function that handles missing values in a dataset by filling them with appropriate values based on the data type. Numerical columns are filled with the mean, while categorical columns are filled with the mode.
#' @param dataset A data frame containing the input data to be processed.
#' @param target A character string indicating the name of the target variable in the dataset. This column will not be altered during this function.
#' @param n_unique An integer specifying the maximum number of unique values a column can have to be considered categorical, Default: 20
#' @return A data frame with missing values filled.
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[dplyr]{select}}, \code{\link[dplyr]{reexports}}, \code{\link[dplyr]{mutate}}, \code{\link[dplyr]{across}}
#'  \code{\link[logger]{log_level}}
#' @rdname na_input
#' @export
#' @importFrom dplyr select any_of mutate across where bind_cols
#' @importFrom logger log_info
na_input <- function(dataset,
                     target,
                     n_unique = 20){

  # Funcao para calcular a moda (essa funcao e muito pequena para ficar
  # de fora desse script)
  moda <- function(x) {
    names(sort(-table(x)))[1]
  }

  # Removendo a coluna target do dataset pois a remocao de colunas
  # indesejadas deve ser feita apenas nas variaveis explicativas
  dataset_filter <- dataset %>% dplyr::select(-dplyr::any_of(target))

  # Indentificar as colunas que sao categoricas, essas colunas terao
  # os valores NA prenchidos com a moda, ja as colunas numericas
  # serao preenchidas com a media
  categorical_vars <- detect_categorical_vars(dataset = dataset_filter,
                                              n_unique = n_unique)

  if (length(categorical_vars) > 0) {
    logger::log_info("Preenchendo valores faltantes de variaveis categóricas
                     com a moda.")
    # Preenchendo dados faltantes para colunas categoricas com a moda
    dataset_cat <- as.data.frame(lapply(names(dataset_filter), function(x) {
      if(x %in% categorical_vars){
        ifelse(is.na(dataset[,x]), moda(dataset[,x]), dataset[,x])
      } else {dataset[,x]}
    }))
  } else{
    dataset_cat <- dataset_filter
  }

  # Preenchendo dados faltantes para colunas numericas com a media
  logger::log_info("Preenchendo valores faltantes de variaveis numéricas
                     com a média")
  dataset_num <- as.data.frame(lapply(names(dataset_cat), function(x) {
    if (!(x %in% categorical_vars)) {
      ifelse(is.na(dataset_cat[,x]), mean(dataset_cat[,x], na.rm = TRUE),
             dataset_cat[,x])
    } else {dataset_cat[,x]}
  }))

  # Corrigindo os nomes das colunas
  names(dataset_num) <- names(dataset_filter)

  # Corrigindo tipagem dos dados
  dataset_num <- dataset_num %>%
    dplyr::mutate(dplyr::across(dplyr::where(is.character),
                                ~ as.integer(as.factor(.))))

  # Colocando a variavel target de volta no dataset
  dataset_num <- dplyr::bind_cols(dataset %>%
                                      dplyr::select(dplyr::any_of(target)),
                                  dataset_num)

  return(dataset_num)

}
