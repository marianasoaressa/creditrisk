#' @title Decision Tree Modeling
#' @description A function thar performs classification modeling using a decision tree, with cross-validation to choose the best complexity parameter (cp) for the tree.
#' @param dataset A data frame containing the input data.
#' @param target A character string indicating the name of the target variable in the dataset.
#' @param test_size The fraction of the dataset to be used as the test set. Default: 0.2.
#' @param maxdepth The maximum depth of the decision tree. Default: 30.
#' @return A list containing the trained model and performance metrics
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[logger]{log_level}}
#'  \code{\link[dplyr]{select}}, \code{\link[dplyr]{reexports}}
#'  \code{\link[caret]{createDataPartition}}, \code{\link[caret]{train}}, \code{\link[caret]{trainControl}}, \code{\link[caret]{confusionMatrix}}
#'  \code{\link[rpart]{rpart}}
#' @rdname modeling
#' @export
#' @importFrom logger log_info
#' @importFrom dplyr select any_of
#' @importFrom caret createDataPartition train trainControl confusionMatrix
#' @importFrom rpart rpart
modeling <- function(dataset,
                     target,
                     test_size = 0.2,
                     maxdepth = 30 ){

  logger::log_info("Iniciando a modelagem")

  # Removendo a coluna target do dataset que sera utilizado para detectar
  # as colunas categoricas
  dataset_filter <- dataset %>% dplyr::select(-dplyr::any_of(target))

  # Identificando as colunas categoricas que serao utilizadas para fazer
  # o one_hot_encoder
  categorical_vars <- detect_categorical_vars(dataset = dataset_filter)

  logger::log_info("One-hot-encoder das variáveis categóricas")
  # Fazendo o one_hot_encoder das variaveis categoricas
  one_hot_dataset <- one_hot_encoder(dataset = dataset,
                                     categorical_vars = categorical_vars)

  ##### Separando o dataset em treino e teste #####
  # semente
  set.seed(12345)

  # Indices do dataset que serao utilizados para separar o dataset
  # em treino e teste, quando usamos p = 1 garante uma divisao das classes
  # proporcional ao dataset original
  train_index <- caret::createDataPartition(one_hot_dataset[[target]],
                                            p = 1 - test_size,
                                            list = FALSE,
                                            times = 1)
  # Dataset de Treino
  train_data <- one_hot_dataset[train_index, ]

  # Dataset de Teste
  test_data <- one_hot_dataset[-train_index, ]

  # Garantindo que a variavel target esta no tipo factor, isso e necessario
  # para problemas de  classificacao
  train_data[[target]] <- as.factor(train_data[[target]])
  test_data[[target]] <- as.factor(test_data[[target]])

  logger::log_info("Treinando a Árvore de decisão")
  # Defininco a grade de parâmetros da arvore chamado cp, que e um parametro
  # que controla a complexidade da arvore
  grid <- expand.grid(cp = seq(0.001, 0.1, by = 0.005))

  # Treinamento do modelo com validação cruzada para escolha do melhor cp
  model_tree <- caret::train(
    as.formula(paste(target, "~ .")),
    data = train_data,
    method = "rpart",                   # Avore de decisao
    trControl = caret::trainControl(method = "cv", number = 5),   # Cross-validation
    tuneGrid = grid,                    # Tunnig do cp
    metric = "Accuracy")

    # Ajuste final do modelo que foi otimizado com o melhor cp
  final_model <- rpart::rpart(
    as.formula(paste(target, "~ .")),
    data = train_data,
    control = rpart::rpart.control(
      cp = model_tree[["bestTune"]][["cp"]],
      minsplit = 20,  # num minimo de observacoes que um no precisa ter para ser dividido
      maxdepth = maxdepth   # define a profundidade maxima da arvore
    )
  )
  # Previsoes no conjunto de teste para calcular as metricas de acuracia
  predictions <- predict(final_model, newdata = test_data, type = "class")

  # Calculando matrix de confusao e metricas de acuracia
  # o parametro positive e o que indica a classe positiva no dataset
  conf_matrix <- caret::confusionMatrix(data = predictions,
                                        reference = test_data[[target]],
                                        positive = "1")


  logger::log_info("Árvore treinada")

  return(list(model = final_model,
              metrics = list(accuracy = conf_matrix[["overall"]]["Accuracy"],
              sensitivity = conf_matrix[["byClass"]]["Sensitivity"],
              specificity = conf_matrix[["byClass"]]["Specificity"],
              precision = conf_matrix[["byClass"]]["Pos Pred Value"],
              confusion_matrix = conf_matrix[["table"]])))


}

