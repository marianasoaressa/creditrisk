#' @title Preprocess Dataset for Analysis
#' @description A function that performs several preprocessing steps on a
#' dataset, such as removing unwanted columns, handling missing values,
#' and addressing multicollinearity and making the data ready for analysis
#' or modeling.
#' @param dataset A data frame containing the input data to be preprocessed
#' @param target A character string indicating the name of the target variable #' in the dataset.
#' @param id_var A character string indicating the column to be treated as #' identifier. These columns are excluded during preprocessing.
#' @param na_threshold A numeric value between 0 and 1 indicating the maximum proportion of missing values allowed in a column. Default: 0.5.
#' @return A preprocessed data frame with cleaned and optimized features.
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[logger]{log_level}}
#' @rdname pre_process
#' @export
#' @importFrom logger log_error log_info
#' @importFrom dplyr select any_of
pre_process <- function(dataset,
                        target,
                        id_var,
                        na_threshold = 0.5){

  # Verificando se o target existe no dataset
  if (!(target %in% names(dataset))) {
    logger::log_error("A variável target não foi encontrada no dataset.")
  }

  # Verificando se id_var existe no dataset
  if (!(id_var %in% names(dataset))) {
    logger::log_error("A variável id_var não foi encontrada no dataset.")
  }

  logger::log_info(paste0("Iniciando o pré-processamento dos dados"))

  # Removendo id_var pois nao sera utilizado nas funcoes a seguir
  dataset <- dataset %>% dplyr::select(-dplyr::any_of(id_var))

  # Removendo colunas com uma quantidade elevada de valores ausentes,
  # colunas com valores unicos e colunas com valores duplicados
  treat_dataset <- remove_unwanted_cols(dataset = dataset,
                                       target = target,
                                       na_threshold = na_threshold,
                                       remove_col_NA = TRUE,
                                       remove_unique_cols = TRUE,
                                       remove_duplicate_cols = TRUE)

  # Preenchando os valores faltantes restantes, se a coluna for numerica
  # preenchemos com a media, se for categorica preenchemos com a moda
  treat_dataset <- na_input(dataset = treat_dataset,
                           target = target)

  # Removendo colunas com alta correlacacao e com dependencia linear
  # Isso precisa ser feito apos o preenchimento de dados faltantes
  treat_dataset <- remove_unwanted_cols(dataset = treat_dataset,
                                       target = target,
                                       remove_ld_cols = TRUE,
                                       remove_cor_cols = TRUE)

  logger::log_info("Pré-processamento concluído.")

  return(treat_dataset)
}

