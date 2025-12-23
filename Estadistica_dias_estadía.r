GRD2024 <- read.csv("GRD2024.2.0.csv")
# Convertir a factores las variables categóricas (R puede leerlas como texto)
GRD2024.2 <- GRD2024 %>%
  mutate(
    sexo = as.factor(sexo),
    prevision = as.factor(prevision),
    tipoalta = as.factor(tipoalta),
    CategoriaDgMayor = as.factor(CategoriaDgMayor)
  )

# --- 2. Análisis Descriptivo (R) ---

# Resumen de la variable dependiente (ya lo vimos, pero para confirmar)
summary(GRD2024.2$dias_estadia)

# Histograma de dias_estadia (con ggplot2)
ggplot(GRD2024.2, aes(x = dias_estadia)) +
  geom_histogram(binwidth = 1, fill = "blue", alpha = 0.7) +
  ggtitle("Distribución de Días de Estadía") +
  xlab("Días de Estadía") +
  ylab("Frecuencia") +
  xlim(0, 100) # Limitar a 60 días para ver el detalle de la cola

# Boxplots para ver relaciones categóricas
# (Nota: 'CategoriaDgMayor' tiene demasiados niveles para un buen gráfico)
ggplot(GRD2024.2, aes(x = sexo, y = dias_estadia, fill = sexo)) +
  geom_boxplot() +
  scale_y_continuous(limits = c(0, 20)) + # Limitar para visualización
  ggtitle("Días de Estadía por Sexo")

ggplot(GRD2024.2, aes(x = tipoalta, y = dias_estadia, fill = tipoalta)) +
  geom_boxplot() +
  scale_y_continuous(limits = c(0, 25)) +
  ggtitle("Días de Estadía por Tipo de Alta")


summarise(promedio = mean(dias_estadia))
# --- 3. Análisis Bivariado (Pruebas de Hipótesis) ---

# 1. Correlación Edad vs. Días Estadía
# Usamos Spearman porque los datos no son normales
cor_test_edad <- cor.test(
  df_clean$dias_estadia,
  df_clean$edad_aprox,
  method = "spearman"
)
print(cor_test_edad)

# 2. Pruebas U de Mann-Whitney (2 grupos)
# Sexo (excluyendo "DESCONOCIDO" para una comparación limpia de 2 grupos)
GRD2024.2sexo_2 <- GRD2024.2 %>% filter(sexo %in% c("HOMBRE", "MUJER"))
wilcox_test_sexo <- wilcox.test(dias_estadia ~ sexo, data = df_sexo_2)
print(wilcox_test_sexo)

# Previsión
wilcox_test_prevision <- wilcox.test(dias_estadia ~ prevision, data = df_clean)
print(wilcox_test_prevision)

# Tipo Alta
wilcox_test_alta <- wilcox.test(dias_estadia ~ tipoalta, data = df_clean)
print(wilcox_test_alta)

# 3. Prueba de Kruskal-Wallis (>2 grupos)
# CategoriaDgMayor
kruskal_test_dg <- kruskal.test(
  dias_estadia ~ CategoriaDgMayor,
  data = df_clean
)
print(kruskal_test_dg)


# --- 4. Análisis Multivariable (Regresión Binomial Negativa) ---

GRD2024.2 <- GRD2024 %>% sample_n(1085813)

cat(
  "Iniciando el modelo de Regresión Binomial Negativa... esto puede tardar.\n"
)

# Para evitar problemas de referencia, re-codificamos la variable con más datos como base
GRD2024.2$CategoriaDgMayor <- relevel(
  GRD2024.2$CategoriaDgMayor,
  ref = "Enfermedades del sistema musculo esqueletico y tejido conectivo"
)

modelo_nb <- glm.nb(
  dias_estadia ~ edad_aprox + sexo + prevision + tipoalta + CategoriaDgMayor,
  data = GRD2024.2
)

cat("Modelo completado.\n")

# Ver el resumen del modelo
summary(modelo_nb)

coeficientes <- summary(modelo_nb)$coefficients

tabla_resultados1 <- as.data.frame(coeficientes) %>%
  mutate(
    Variable = rownames(coeficientes),
    IRR = exp(Estimate),
    `p-value` = `Pr(>|z|)`
  ) %>%
  dplyr::select(Variable, IRR, `p-value`) %>%
  filter(`p-value` < 0.05)

# Imprimir la tabla de resultados significativos
print("Resultados Significativos (IRR):")
print(kable(tabla_resultados1, digits = 3))

# Ejemplo de interpretación de un IRR:
# Si el IRR para `edad_aprox` es 1.01, significa que por cada año más de edad,
# la tasa de días de estadía aumenta un 1% (1.01 - 1 = 0.01),
# manteniendo constantes todos los demás factores.
# Si el IRR para `tipoaltaFALLECIDO` es 1.8, significa que los pacientes
# que fallecen tienen una tasa de estadía 80% mayor que los que salen vivos.

write.csv(tabla_resultados1, "tabladepurada.csv", row.names = FALSE)


df_frecuencias <- GRD2024.2 %>%
  count(CategoriaDgMayor, name = "Frecuencia") %>%
  arrange(-Frecuencia)

ggplot(df_frecuencias, aes(x = CategoriaDgMayor, y = Frecuencia)) +
  geom_line(group = 1, color = "Black", linetype = "dashed") +
  geom_point(color = "black", size = 2) +
  labs(
    title = "Frecuencia de Diagnósticos (Gráfico de Líneas - No Recomendado)",
    x = "Categoría de Diagnóstico Mayor",
    y = "Número de Pacientes (Frecuencia)"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

ggplot(GRD2024.2, aes(x = fct_infreq(CategoriaDgMayor))) +
  geom_bar(fill = "steelblue") +
  labs(
    title = "Frecuencia de Pacientes por Categoría de Diagnóstico",
    x = "Categoría de Diagnóstico Mayor",
    y = "Número de egresos"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

