# 1st-GitData
# Análisis de Factores Determinantes en la Estadía Hospitalaria Prolongada (GRD 2024)
Este proyecto analiza los factores clínicos y sociodemográficos que influyen en la probabilidad de una estadía hospitalaria prolongada, utilizando una base de datos de egresos hospitalarios (GRD) del año 2024.

## Descripción
Como parte de un reporte para el Magíster en Salud Pública este estudio busca identificar qué variables predicen significativamente una mayor ocupación de camas, permitiendo optimizar la gestión hospitalaria. Se utilizaron técnicas de estadística descriptiva, pruebas de hipótesis no paramétricas y modelos de regresión multivariable.

## Pregunta de Investigación
¿Cuáles son los principales factores clínicos (gran causa diagnóstica) y sociodemográficos (edad, sexo, previsión) que influyen en la probabilidad de presentar una estadía hospitalaria prolongada?.

## 🛠️ Tecnologías y Metodología
* **Lenguaje:** R
* **Librerías** `tidyverse`, `ggplot2`, `MASS` (para Binomial Negativa).
* **Análisis Univariado/Bivariado:**
    * Pruebas de Spearman (Edad vs Estadía).
    * Prueba de Wilcoxon (Sexo/Previsión vs Estadía).
    * Kruskal-Wallis (Categoría Diagnóstica vs Estadía).
* **Modelo Multivariable:** Regresión Binomial Negativa, seleccionada debido a la sobredispersión de los datos (Varianza > Media).

## 📊 Principales Resultados
* El modelo final identificó variaciones significativas en los días de estadía (IRR - Incidence Rate Ratios):
* **Edad:** Por cada año de vida, la estadía aumenta levemente (IRR 1.009).
* **Sexo:** Las mujeres presentan una tasa de estadía 28.3% menor en comparación con hombres.
* **Diagnósticos Críticos:**
    * Recién nacidos y neonatos: Tasa de estadía 287% mayor a la referencia.
    * Trastornos mentales y abuso de sustancias presentaron tasas significativamente mayores.
* **Sistema de Salud:** Pacientes con ISAPRE que aun así fueron atendidos en el servicio público, mostraron una tasa de estadía 31% menor que FONASA.

## 📄 Estructura del Repositorio
* `/codigo`: Contiene el script `Estadística_dias_estadía.R` con la limpieza y modelado.
* `/docs`: Contiene el informe completo en PDF con el detalle académico.
---
*Autor: Carlos Aedo - Profesional de Salud & Data Scientist en formación.*
