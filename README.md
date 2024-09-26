

# Simulación de Imputación de Datos en el Dataset Iris

## Objetivo

El objetivo de este proyecto es demostrar cómo manejar los **valores faltantes** en el conjunto de datos **Iris** utilizando varias técnicas de **imputación de datos** en R. En esta simulación, comparamos tres enfoques de imputación para evaluar su eficacia en la preservación de la calidad de los datos:

1. **Imputación por la media**.
2. **Imputación por regresión**.
3. **Imputación múltiple (MICE)**.

## Descripción del Dataset

El dataset Iris es un conjunto de datos ampliamente utilizado en la ciencia de datos, compuesto por 150 observaciones de tres especies de flores (*Iris setosa*, *Iris versicolor* y *Iris virginica*). Cada observación contiene cuatro variables de medición:

- Largo del sépalo (cm)
- Ancho del sépalo (cm)
- Largo del pétalo (cm)
- Ancho del pétalo (cm)
- Especie (factor categórico)

## Proceso de Simulación

1. **Introducción de Datos Faltantes**: Se introducen datos faltantes aleatoriamente en algunas de las columnas para simular un escenario real con valores ausentes.

2. **Aplicación de Técnicas de Imputación**:
   - **Imputación por la Media**: Los valores faltantes se reemplazan con la media de los valores observados para cada variable.
   - **Imputación por Regresión**: Utiliza un modelo de regresión lineal para predecir los valores faltantes en función de las otras variables.
   - **Imputación Múltiple (MICE)**: Se realizan varias imputaciones utilizando el método MICE (`mice` package en R) para tener en cuenta la incertidumbre en los valores faltantes.

3. **Análisis de los Resultados**: Se analizan los datasets resultantes de cada técnica y se comparan para evaluar su rendimiento y precisión en la imputación de valores faltantes.

## Resultados Relevantes

- **Imputación por la Media**: Es un método simple pero puede introducir sesgos, ya que no tiene en cuenta las correlaciones entre las variables.
  
- **Imputación por Regresión**: Aunque mejora sobre la imputación por la media, subestima la incertidumbre al tratar los valores faltantes de manera determinista.

- **Imputación Múltiple (MICE)**: Ofrece el mejor resultado, generando varias versiones del conjunto de datos con imputaciones distintas para reflejar la variabilidad y la incertidumbre de los datos faltantes, lo que resulta en análisis más precisos.

## Conclusión

La **imputación múltiple (MICE)** es el método más robusto para manejar valores faltantes en este caso. La variabilidad entre las iteraciones permite obtener inferencias más precisas y confiables, preservando la estructura de los datos.

## Requisitos

- R version 4.x
- Paquetes:
  - `dplyr`
  - `ggplot2`
  - `mice`
  - `gg_miss_var`

