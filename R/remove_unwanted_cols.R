#' @title Remove Unwanted Columns
#' @description A function that removes unwanted columns from a dataset based on user-specified criteria, such as high missing values, unique values, duplicates, linear dependencies, or high correlations.
#' @param dataset A data frame containing the input data to be processed.
#' @param target A character string specifying the name of the target variable.
#' @param na_threshold A numeric value between 0 and 1 indicating the maximum proportion of missing values allowed in a column. Default: 0.5.
#' @param remove_col_NA A logical value indicating whether to remove columns with a proportion of missing values exceeding `na_threshold`. Default: FALSE.
#' @param remove_unique_cols A logical value indicating whether to remove columns with only unique values. Default: FALSE.
#' @param remove_duplicate_cols A logical value indicating whether to remove duplicate columns. Default: FALSE.
#' @param remove_ld_cols A logical value indicating whether to remove columns with linear dependencies. Default: FALSE.
#' @param remove_cor_cols A logical value indicating whether to remove columns with high correlations (correlation coefficient > 0.8). Default: FALSE.
#' @return A data frame with the unwanted columns removed,
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[dplyr]{select}}, \code{\link[dplyr]{reexports}}, \code{\link[dplyr]{bind_cols}}
#'  \code{\link[logger]{log_level}}
#'  \code{\link[caret]{findLinearCombos}}
#' @rdname remove_unwanted_cols
#' @export
#' @importFrom dplyr select any_of bind_cols
#' @importFrom logger log_info
#' @importFrom caret findLinearCombos findCorrelation
remove_unwanted_cols <- function(dataset,
                                 target,
                                 na_threshold = 0.5,
                                 remove_col_NA = FALSE,
                                 remove_unique_cols = FALSE,
                                 remove_duplicate_cols = FALSE,
                                 remove_ld_cols = FALSE,
                                 remove_cor_cols = FALSE){

  # Removendo a coluna target do dataset pois a remocao de colunas
  # indesejadas deve ser feita apenas nas variaveis explicativas
  dataset_filter <- dataset %>% dplyr::select(-dplyr::any_of(target))

  # Calculando a porcentagem de valores ausentes em cada coluna do dataset
  perc_na_cols <- colSums(is.na(dataset))/nrow(dataset)

  # Manter apenas as colunas que possuem ate na_threshold % de valores faltantes
  if (remove_col_NA) {
    logger::log_info(paste0("Removendo colunas com mais de ", na_threshold*100,
    "% de valores ausentes"))

    # Quantidade de colunas que serao removidas
    qtd_na_cols <- sum(with(dataset_filter, perc_na_cols >= na_threshold))

    dataset_filter <- dataset_filter[, with(dataset_filter,
                                            perc_na_cols < na_threshold)]

    logger::log_info(paste0(qtd_na_cols, " colunas foram removidas."))
  }

  # Identificar e remover colunas que possuem valores unicos
  if (remove_unique_cols) {
    logger::log_info(paste0("Removendo colunas com valores únicos"))

    unique_value <- apply(dataset_filter, MARGIN = 2,
                          function(x) length(unique(x[!is.na(x)])) <= 1) %>%
      which() %>%
      names()

    dataset_filter <- dataset_filter %>%
      dplyr::select(-dplyr::any_of(unique_value))

    logger::log_info(paste0(length(unique_value), " colunas foram removidas."))
  }

  # Identificar e remover colunas que sao duplicadas
  if (remove_duplicate_cols) {
    logger::log_info(paste0("Removendo colunas duplicadas"))

    # A primeira ocorrencia que sera mantida
    duplicate_cols <- duplicated(t(dataset_filter)) %>%
      which %>% names()

    dataset_filter <- dataset_filter %>%
      dplyr::select(-dplyr::any_of(duplicate_cols))

    logger::log_info(paste0(length(duplicate_cols), " colunas foram removidas."))

  }

  # Identificar e remover colunas que sao linearmente dependentes
  # Essa parte do pipe devera ser feita apos o prenchimento de valores
  # faltantes nas colunas que ficaram no dataset
  if (remove_ld_cols) {
    logger::log_info(paste0("Removendo colunas linearmente dependentes"))
    ld_cols <- caret::findLinearCombos(dataset_filter)

    # Se existe alguma variave com dependencia linear removemos
    if (!is.null(ld_cols[["remove"]])) {
      dataset_filter <- dataset_filter[ , -ld_cols[["remove"]]]
    }

    logger::log_info(paste0(length(ld_cols[["remove"]]),
                            " colunas foram removidas."))
  }

  # Identificar e remover colunas que sao altamente correlacionadas
  # Essa parte do pipe devera ser feita apos o prenchimento de valores
  # faltantes nas colunas que ficaram no dataset
  if (remove_cor_cols){
    logger::log_info(paste0("Removendo colunas altamente correlacionadas"))

    # Identificar colunas categoricas, pois elas nao entram no calculo
    # de correlacao
    categorical_vars <- detect_categorical_vars(dataset = dataset_filter)

    # Removendo as colunas categoricas do dataset que sera utilizado para
    # calcular a correlacao
    no_cat_dataset <- dataset_filter %>%
      dplyr::select(-dplyr::any_of(categorical_vars))

    # Calcular o coeficiente de correlacao de pearson
    cor_matrix <- cor(no_cat_dataset, use = "pairwise.complete.obs")

    # Encontrar as variaveis altamente correlacionadas com o limiar de 0.8
    # para identificar as correlações altas
    high_corr_cols <- caret::findCorrelation(cor_matrix, cutoff = 0.8)

    # Identificando o nome da coluna que sera removida
    name_high_corr <- colnames(no_cat_dataset)[high_corr_cols]

    # Se existe alguma variavel com alta correlacao, removemos ela do dataset
    if (length(name_high_corr) > 0) {
      dataset_filter <- dataset_filter[ , !(colnames(dataset_filter) %in%
                                              name_high_corr)]

      logger::log_info(paste0(length(name_high_corr),
                              " colunas foram removidas."))
    }
  }

  # Colocando a variavel target de volta no dataset
  dataset_final <- dplyr::bind_cols(dataset %>%
                                      dplyr::select(dplyr::any_of(target)),
                                    dataset_filter)

  return(dataset_final)
}


