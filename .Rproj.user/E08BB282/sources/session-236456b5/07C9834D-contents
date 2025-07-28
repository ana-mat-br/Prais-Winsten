# Análise de Tendência Temporal com Prais-Winsten

Este projeto realiza a análise de tendência temporal de uma série de dados de acidentes, utilizando regressão Prais-Winsten para correção de autocorrelação (séries temporais). O passo a passo inclui leitura de dados, transformação logarítmica, ajuste do modelo, cálculo da taxa de variação anual, intervalo de confiança e classificação da tendência.

## Requisitos

- R (versão recomendada: ≥ 4.0)
- Pacotes R:
  - `readxl` (para leitura de arquivos Excel)
  - `prais` (para regressão Prais-Winsten)

## Instalação dos Pacotes

Se necessário, instale os pacotes via CRAN:

```r
install.packages("readxl")
install.packages("prais")
```

## Como Usar

1. **Prepare seu arquivo de dados**  
   Crie um arquivo Excel chamado `exemplo.xlsx` (ou altere o nome no script) com pelo menos as colunas:
   - `ano`: ano da observação
   - `acidentes`: quantidade de acidentes (ou outra variável de interesse)

2. **Execute o script**  
   O script R faz:
   - Leitura dos dados;
   - Aplicação do logaritmo natural na variável de interesse;
   - Ajuste do modelo Prais-Winsten;
   - Cálculo da taxa de variação anual e intervalo de confiança;
   - Classificação da tendência em *Crescente*, *Decrescente* ou *Estável* conforme significância estatística.

3. **Saídas principais**  
   O script irá exibir:
   - Coeficientes do modelo;
   - Taxa de variação percentual anual;
   - Intervalo de confiança de 95% para a taxa;
   - p-valor do coeficiente;
   - Situação da tendência.

## Exemplo de Uso

```r
# Carregar pacotes
library(readxl)
library(prais)

# Ler dados
dados <- read_excel("exemplo.xlsx")

# Transformar e modelar
log_variavel <- log(dados$acidentes)
modelo1 <- prais_winsten(log_variavel ~ ano, data = dados, index = "ano")
summary(modelo1)

# Cálculo da taxa anual
beta <- coef(modelo1)[2]
taxa_percentual <- (exp(beta) - 1) * 100
round(taxa_percentual, 2)

# IC 95%
erro_padrao <- summary(modelo1)$coefficients[2, 2]
ic_inferior <- beta - 1.96 * erro_padrao
ic_superior <- beta + 1.96 * erro_padrao
ic_percentual <- (exp(c(ic_inferior, ic_superior)) - 1) * 100
round(ic_percentual, 2)

# Significância e classificação
p_valor <- summary(modelo1)$coefficients["ano", "Pr(>|t|)"]
round(p_valor, 3)

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
```

## Interpretação dos Resultados

- **Taxa de variação anual**: Crescimento ou queda média anual da série (%).
- **Intervalo de confiança**: Faixa em que a taxa verdadeira provavelmente se encontra (95%).
- **p-valor**: Indica se a tendência é estatisticamente significativa.
- **Situação**:
  - *Crescente*: tendência de aumento estatisticamente significativa.
  - *Decrescente*: tendência de queda estatisticamente significativa.
  - *Estável*: sem tendência significativa.

---

**Autor:** [Ana Paula Fernandes]  
**Licença:** MIT
