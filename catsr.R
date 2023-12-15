library(tidyverse)
library(broom)
library(purrr)
library(modelr)

# Cargar el conjunto de datos
cats_data <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-01-31/cats_uk_reference.csv')

#pregunta 1: existe relación entre la edad de los gatos y la cantidad de presas ?
# Filtrar los datos relevantes y limpiar
cats_edad_presas <- cats_data %>%
  select(age_years, prey_p_month) %>%
  filter(!is.na(age_years))

# Modelo de regresión lineal
modelo <- lm(prey_p_month ~ age_years, data = cats_edad_presas)

# Crear un data frame para las predicciones
age_grid <- data.frame(age_years = seq(min(cats_edad_presas$age_years), max(cats_edad_presas$age_years), length.out = 50))
predictions <- augment(modelo, newdata = age_grid)

# Gráfico
ggplot(cats_edad_presas, aes(x = age_years, y = prey_p_month)) +
  geom_point(aes(color = age_years)) +
  geom_line(data = predictions, aes(y = .fitted), color = "blue") +
  labs(title = "Relación entre Edad y Cantidad de Presas",
       x = "Edad (Años)",
       y = "Presas por Mes")

#Se observa existe una relación inversa, por lo que a mayor edad un gato caza menos presas


#pregunta 2: existe alguna diferencia en la condición reproductiva según edad ?
# Preparación de los datos
cats_edad_reproductiva <- cats_data %>%
  select(age_years, animal_reproductive_condition) %>%
  filter(!is.na(age_years) & !is.na(animal_reproductive_condition))

# Gráfico de cajas por condición reproductiva
ggplot(cats_edad_reproductiva, aes(x = animal_reproductive_condition, y = age_years, fill = animal_reproductive_condition)) +
  geom_boxplot() +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Distribución de Edades por Condición Reproductiva",
       x = "Condición Reproductiva",
       y = "Edad (Años)") +
  theme_minimal()

#Hay gatos castrados que llegan a mayor edad, luego los gatos esterilizados y por ultimo se encuentran los gatos sin castrar ni esterilizar.