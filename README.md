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
install.packages("devtools")

### Instale o pacote creditRisk diretamente do GitHub
devtools::install_github("marianasoaressa/creditrisk")
