#' @title One-Hot Encoding for Categorical Variables
#' @description A function that performs one-hot encoding on specified categorical variables in a dataset, creating dummy variables for each unique level of the categorical variables.
#' @param dataset A data frame containing the input data to be encoded.
#' @param categorical_vars A character vector specifying the names of the categorical variables to be one-hot encoded.
#' @return A data frame containing the original dataset (excluding the original categorical variables) combined with the newly created dummy variables for each level of the specified categorical variables.
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[caret]{dummyVars}}
#' @rdname one_hot_encoder
#' @export
#' @importFrom logger log_error
one_hot_encoder <- function(dataset,
                             categorical_vars){

  # Verificar se as variáveis categóricas estão presentes no dataset
  if (!all(categorical_vars %in% names(dataset))) {
    logger::log_error("Uma ou mais variáveis categóricas não foram encontradas
                      no dataset.")
  }

  # Os valores das variaveis categoricas precisam ser do tipo factor
  dataset[categorical_vars] <- lapply(dataset[categorical_vars], as.factor)

  # Modificando os nomes das colunas categóricas para adicionar o "_" no final
  # de cada nome, para que na hora de fazer o model_matrix o reusultado final
  # dos nomes fique no formato nomecategorica_valor
  colnames(dataset)[colnames(dataset) %in% categorical_vars] <- paste0(categorical_vars,
                                                               "_")
  categorical_vars <- paste0(categorical_vars, "_")

  # Criando a fórmula para aplicar o one-hot encoding
  one_hot_formula <- as.formula(paste("~", paste(categorical_vars,
                                                 collapse = " + ")))

  # Criar as variáveis dummies
  # O [, -1] remove o intercepto da formula
  one_hot_dataset <- as.data.frame(model.matrix(one_hot_formula,
                                                data = dataset)[, -1])

  one_hot_dataset <- lapply(one_hot_dataset, as.factor)

  # Combinando o dataset original (sem as colunas categoricas) com as novas
  # colunas das vars categoricas
  dataset_encoded <- cbind(dataset[setdiff(names(dataset), categorical_vars)],
                           one_hot_dataset)



  return(dataset_encoded)

}
