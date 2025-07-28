# ------------------------------
# Pacotes usados
# ------------------------------

# Caso ainda não estejam instalados, descomente as linhas abaixo:
# install.packages("readxl")  # para ler arquivos Excel
# install.packages("prais")   # para rodar regressão Prais-Winsten (séries temporais)

# Carregar os pacotes
library(prais)
library(readxl)

# ------------------------------
# Leitura dos dados
# ------------------------------

# Lê os dados de um arquivo Excel chamado "exemplo.xlsx"
dados <- read_excel("exemplo.xlsx")

# Exibe os nomes das colunas do dataset (para verificação)
colnames(dados)

# ------------------------------
# Transformações e modelo
# ------------------------------

# Aplica logaritmo natural à variável de interesse (acidentes), usada para estimar a taxa de crescimento percentual
log_variavel <- log(dados$acidentes)

# Estima uma regressão Prais-Winsten com correção para autocorrelação de primeira ordem
# A variável dependente é log_variavel e a explicativa é o ano
modelo1 <- prais_winsten(log_variavel ~ ano, data = dados, index = "ano")

# Exibe o resumo do modelo (coeficientes, erro padrão, R², etc.)
summary(modelo1)

# ------------------------------
# Cálculo da taxa de variação anual
# ------------------------------

# Extrai o coeficiente de "ano" (beta), que representa o crescimento médio anual em log
beta <- coef(modelo1)[2]

# Converte o coeficiente logarítmico em uma taxa percentual de crescimento
taxa_percentual <- (exp(beta) - 1) * 100

# Arredonda a taxa para 2 casas decimais
round(taxa_percentual, 2)

# ------------------------------
# Intervalo de confiança (95%)
# ------------------------------

# Erro padrão do coeficiente "ano"
erro_padrao <- summary(modelo1)$coefficients[2, 2]

# Limites inferior e superior do intervalo de confiança (em escala log)
ic_inferior <- beta - 1.96 * erro_padrao
ic_superior <- beta + 1.96 * erro_padrao

# Converte os limites para escala percentual
ic_percentual <- (exp(c(ic_inferior, ic_superior)) - 1) * 100

# Arredonda o intervalo de confiança para 2 casas decimais
round(ic_percentual, 2)

# ------------------------------
# Verifica significância estatística
# ------------------------------

# Extrai o p-valor do coeficiente "ano"
p_valor <- summary(modelo1)$coefficients["ano", "Pr(>|t|)"]

# Arredonda o p-valor
round(p_valor, 3)

# Classifica a tendência da série:
# - Crescente se o p < 0.05 e beta > 0
# - Decrescente se o p < 0.05 e beta < 0
# - Estável se o p >= 0.05
if (p_valor < 0.05) {
  if (taxa_percentual > 0) {
    situacao <- "Crescente"
  } else {
    situacao <- "Decrescente"
  }
} else {
  situacao <- "Estável"
}

# Exibe a situação da tendência
situacao
