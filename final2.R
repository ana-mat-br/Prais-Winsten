
library(prais)
library(readxl)


# parte 1
dados <- read_excel("exemplos.xlsx")
colnames(dados)

log_variavel <- log(dados$MG)
modelo1 <- prais_winsten(log_variavel ~ ano, data = dados, index = "ano")
summary(modelo1)

beta <- coef(modelo1)[2]
taxa_percentual <- (exp(beta) - 1) * 100
round(taxa_percentual,2)
erro_padrao <- summary(modelo1)$coefficients[2, 2]
ic_inferior <- beta - 1.96 * erro_padrao
ic_superior <- beta + 1.96 * erro_padrao
ic_percentual <- (exp(c(ic_inferior, ic_superior)) - 1) * 100
round(ic_percentual,2)

p_valor <- summary(modelo1)$coefficients["ano", "Pr(>|t|)"]
round(p_valor,3)
if (p_valor < 0.05) {
  if (taxa_percentual > 0) {
    situacao <- "Crescente"
  } else {
    situacao <- "Decrescente"
  }
} else {
  situacao <- "Estável"
}
situacao
