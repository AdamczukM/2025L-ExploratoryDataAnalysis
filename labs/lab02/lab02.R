###########################################
###     WSTĘP DO EKSPLORACJI DANYCH     ###
###           LABORATORIUM 2            ###
###########################################

library(dplyr) # https://dplyr.tidyverse.org/

# Dane
starwars
View(starwars)
starwars_new <- starwars[, c(1, 2, 3, 4, 5, 7, 8)]

# Informacje o zbiorze danych
str(starwars_new)

# Podgląd tabeli
View(starwars_new)

# Określamy typy zmiennych:
# name - jakościowa, nominalna
# height - ilościowa, ilorazowa
# mass - ilościowa, ilorazowa
# hair_color - jakościowa, nominalna
# skin_color - jakościowa, nominalna
# birth_year - ilościowa, przedziałowa
# sex - jakościowa, binarna

# 1) Wybór wierszy i kolumn w dplyr


# a) wybór kolumn ---> select()
select(starwars, name)
select(starwars, name, gender, mass)
select(starwars,gender,name,mass)

select(starwars,-name)
select(starwars, -name, -skin_color)
select(starwars, -c(name,skin_color))

wybierz <- c("name", "gender")
select(starwars, wybierz)
wybierz <- c(1,2,3,4)
select(starwars, wybierz)

?any_of
?all_of

wybierz <- c("name", "new_column")
select(starwars, any_of(wybierz))
select(starwars, all_of(wybierz))
# b) wybór wierszy ---> filter()
filter(starwars, eye_color == "blue")
filter(starwars, eye_color == "blue", hair_color == "blond")
filter(starwars, eye_color == "blue" & hair_color == "blond")
filter(starwars, eye_color =="blue" | hair_color == "blond")

# 2) pipes %>% (skrót Ctrl + Shift + m)
starwars_blue_eyes <- starwars %>% 
  filter(eye_color=="blue") %>% 
  select(name) %>% head()
starwars_blue_eyes

# Zadanie 1 ---------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wybierz te postacie, których gatunek to Droid, 
# a ich wysokość jest większa niż 100.

starwars %>%
  filter(species=="Droid" & height>100) %>% select(name, species, height)

# Zadanie 2 ---------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wybierz te postacie, które nie mają określonego koloru włosów.

starwars %>%
  select(name, hair_color) %>% 
  filter(is.na(hair_color))

# c) sortowanie wierszy ---> arrange()

starwars %>%
  filter(is.na(hair_color)) %>% 
  arrange(desc(height))


# Zadanie 3 ---------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wybierz postać o największej masie.
starwars %>% 
  select(name,mass) %>% 
  arrange(desc(mass)) %>% 
  head(1)

# d) transformacja zmiennych ---> mutate()
starwars %>%
  mutate(height_m = height/100) %>% View()

# e) transformacja zmiennych ---> transmute()
starwars %>%
  transmute(height_m = height/100) %>% View()


# Zadanie 4 ---------------------------------------------------------------
# Używając funkcji z pakietu dplyr() wylicz wskaźnik BMI (kg/m^2) i wskaż postać, która ma największy wskaźnik.
starwars %>% 
  mutate(height_m = height/100, bmi = mass / (height_m)^2) %>% 
  arrange(-bmi) %>% select(name, bmi) %>% head(1)

# f) kolejność kolumn ---> relocate()
starwars %>% 
  relocate(sex, .before = height)

starwars %>% 
  relocate(sex:homeworld, .before = height)

starwars %>% 
  relocate(where(is.numeric), .after = where(is.character))


# g) dyskretyzacja ---> ifelse(), case_when()
starwars %>% 
  mutate(height_category = ifelse(height>150, "tall", "short")) %>% 
  select(name,height, height_category)

starwars %>% 
  mutate(height_category = case_when(
    height > 150 ~ "tall",
    height > 100 ~ "short",
    TRUE ~ "super short"
    )
    ) %>% select(name,height,height_category)

# h) funkcje agregujące ---> summarise(), n(), mean, median, min, max, sum, sd, quantile

summary(starwars$height)

starwars %>% 
  summarise(mean_mass = mean(mass))

starwars %>% 
  summarise(mean_mass = mean(mass, na.rm = TRUE))

starwars %>% filter(hair_color == "blond") %>% 
  summarise(mean_mass = mean(mass, na.rm = TRUE))

starwars %>% filter(hair_color == "blond") %>% 
  summarise(n())

# i) grupowanie ---> group_by() + summarise()

starwars %>% 
  group_by(species) %>% 
  summarise(median_mass = median(mass, na.rm = TRUE))

starwars %>% 
  group_by(skin_color, eye_color) %>% 
  summarise(n = n())

# 3) Przekształcenie ramki danych w tidyr
library(tidyr) # https://tidyr.tidyverse.org

# j) pivot_longer()

?relig_income
relig_income

relig_income %>% 
  pivot_longer(!religion, names_to = "income", values_to = "count")

# k) pivot_wider()

?fish_encounters
fish_encounters

fish_encounters %>% 
  pivot_wider(names_from = station, values_from = seen, values_fill = 0)

# 4) Praca z faktorami (szczególnie w wizualizacji)
library(forcats) # https://forcats.tidyverse.org
library(ggplot2) # https://ggplot2.tidyverse.org


# l) kolejność poziomów ---> fct_infreq()


# m) scalanie poziomów ---> fct_lump()


# n) kolejność poziomów na podstawie innej zmiennej ---> fct_reorder()


