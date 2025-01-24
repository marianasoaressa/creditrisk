# creditrisk

O pacote creditrisk fornece um conjunto de funções para pré-processamento de dados e modelagem utilizando árvore de decisão. Esse pacote pode ser utilziado para fazer previsão de uma variável binária denominada target, no contexto de risco de crédito em que estamos interessando em prever a inadimplência dos inadimplência. 

O pacote inclui o pré processamento de dados em que:

- Remove colunas com uma quantidade elevada de valores ausentes, (parâmetro na_threshold em que é possível fazer o ajuste da porcentagem de valores ausentes que será tolerado);
- Remove colunas duplicadas;
- Remove colunas com valores únicos;
- Identifica colunas com dependência linear e as remove;
- Identifica colunas com correlação alta e as remove para evitar multicolinearidade
- Faz tratamento dos valores ausentes que ainda restam no dataset com base no tipo de variável, se for uma variável explicativa categórica o valor ausente é preenchido com a moda, já se for uma variável explicativa númerica o preenchimento é feito utilizando a média.

Já na etapa de modelagem, é identificado quais colunas explicativas são categóricas e é feito o one-hot_encoder nessas colunas. Em seguida, treina um modelo de árvore de decisão utilizando o pacote (rpart) para prevera inadimplência com base nas variáveis explicativas. Isso é feito utilizando validação cruzada para encontrar o parâmetro de complexidade da árvore (cp) ótimo. O usuário tem controle dos parâmetros test_size = 0.2 e maxdepth = 30. O primeiro é responsável é a proporção do dataset que será utilizada no conjunto de teste do modelo e o segundo é a profundidade máxima da árvore de decisão.

O retorno do pacote é uma lista contendo o modelo de árvore de decisão treinado e suas métricas de desempenho (acurácia, sensibilidade, especificidade, precisão e matriz de confusão)

# Instalação

Para instalar o pacote, o usuário precisa instalar em sua máquina o pacote devtools para fazer a instalação diretamente do GitHub:

### Instale o devtools caso não tenha instalado
``` r
install.packages("devtools")
```

### Instale o pacote creditRisk diretamente do GitHub

``` r
devtools::install_github("marianasoaressa/creditrisk")
```

### Rodando o pacote
# Rodando o pacote
``` r
library(dplyr)
library(creditrisk)
dataset <- read.csv('seucaminho/base_modelo.csv')

run_modeling(dataset = dataset,
target = "y",
id_var = "id_var")
result_modeling <- run_modeling(dataset = dataset,
                                target = "y",
                                id_var = "id",
                                test_size = 0.2,
                                maxdepth = 30,
                                na_threshold = 0.5)
# Imprimir as metricas de acuracia do modelo treinado
print(result_modeling[["metrics"]])
```

- dataset: Um data frame contendo os dados de entrada. Este é o conjunto de dados que será utilizado para treinamento e teste do modelo.
- target: Uma string representando o nome da variável de interesse. Esta variável é a que o modelo tentará prever (por exemplo, "inadimplente" ou "adimplente").
- id_var: Uma string representando o nome da coluna identificadora, que será excluída durante o pré-processamento. Normalmente, essa coluna contém um identificador único para cada observação (por exemplo, um ID de cliente) e não será utilizada para a modelagem
- test_size: Um valor numérico entre 0 e 1 que indica a fração do conjunto de dados a ser utilizada para o teste do modelo. O valor padrão é 0.2, o que significa que 20% dos dados serão reservados para o teste e 80% para o treinamento.
- maxdepth: Um valor inteiro que define a profundidade máxima da árvore de decisão. A profundidade da árvore controla o número de divisões ou nós que a árvore pode ter. Quanto maior a profundidade, maior a complexidade do modelo. O valor padrão é 30.
- na_treshold: Um valor numérico entre 0 e 1 que define a porcentagem máxima de valores ausentes em uma coluna para que ela seja mantida no conjunto de dados. Se uma coluna tiver mais do que na_threshold de valores ausentes, ela será removida durante o pré-processamento. O valor padrão é 0.5, ou seja, colunas com mais de 50% de valores ausentes serão descartadas.
# Notas adicionais
Certifique-se de que os pacotes rpart, caret e logger estão instalados para o funcionamento adequado do pacote.
A variável target na função modeling deve ser uma variável de classificação binária representando o risco de crédito (por exemplo, "inadimplente" ou "adimplente").
