# --------------------------------- #
# -- Projet : Rshiny avec les données Ulule -- #


# ---- Packages ---- #


library(readr)
library(tidyverse)
library(dplyr)
library(ggplot2) 
library(forcats) # facteurs
library(lubridate) # pour gérer la date
library(shiny)
library(shinythemes)
library(plotly) # graphique intéractif
library(scales) # pour formater l'échelle du graphique
library(DT) # Data table
library(countrycode) # conversion code pays en noms complets
library(shinydashboard)





# ---- Chargement des données ---- #


data_ulule <- read_csv("Data/data_ulule_2025.csv")

glimpse(data_ulule)


# ---- Pré-traitement --- #

# Dans un premier temps, nous allons traduire les noms des variables

data_ulule <- data_ulule %>%
  rename(
    date_fin = date_end,
    date_debut = date_start,
    nb_jours = nb_days,
    pays = country,
    emplacement = location,
    categorie = category,
    statut = status,
    termine = finished,
    est_annule = is_cancelled,
    montant_recolte = amount_raised,
    objectif = goal,
    pourcentage = percent,
    devise = currency,
    objectif_atteint = goal_raised,
    langue = lang,
    nombre_commentaires = comment_counts,
    nombre_nouvelles = news_count
  )


# Maintenant nous allons mettre les deux dates dans le même format et enlever l'heure de date_fin.
# On convertit également date_debut.
# Pour cela on utilise la fonction as.Date() 

data_ulule <- data_ulule %>% 
  mutate(date_fin = as.Date(date_fin, "YYYY-MM-DD"),
         date_debut = as.Date(date_debut, "YYYY-MM-DD"))

glimpse(data_ulule)


# --------------------- 
# On retire les campagnes annulées ou antérieures à 2020

data_ulule <- data_ulule %>% 
  filter(est_annule != "TRUE" & year(date_debut) >= 2020)



# --------------------
# Convertir les montants en euros

table(data_ulule$devise)


# On crée un tableau pour faire nos conversions. Les taux de change sont à dates du 23/09/2025

taux_conversion <- c(
  "EUR" = 1,
  "USD" = 0.85,   # 1 USD ≈ 0.85 EUR
  "CAD" = 0.61,   # 1 CAD ≈ 0.61 EUR
  "AUD" = 0.56,   # 1 AUD ≈ 0.56 EUR
  "BRL" = 0.16,   # 1 BRL ≈ 0.16 EUR
  "CHF" = 1.07,   # 1 CHF ≈ 1.07 EUR
  "GBP" = 1.14,   # 1 GBP ≈ 1.14 EUR
  "DKK" = 0.13,   # 1 DKK ≈ 0.13 EUR
  "NOK" = 0.09,   # 1 NOK ≈ 0.09 EUR
  "SEK" = 0.09   # 1 SEK ≈ 0.09 EUR
)


data_ulule <- data_ulule %>% 
  mutate(montant_recolte_euros = round(montant_recolte*taux_conversion[devise]),
         objectif_euros = round(objectif*taux_conversion[devise]),
         devise = "EUR") %>% 
  select(-montant_recolte, -objectif)



# ----------------------
# Création d'une colonne trimestre basé sur la date de début de campagne

data_ulule <- data_ulule %>% 
  mutate(
    trimestre = floor_date(date_debut, unit = "quarter"))

table(data_ulule$trimestre)




# ---------------------
# Création d'une nouvelle colonne pays pour mettre le nom complet du pays


data_ulule$pays <- countrycode(data_ulule$pays,
                                   origin = "iso2c",   # codes ISO à 2 lettres
                                   destination = "country.name.fr") # noms complets des pays


table(data_ulule$pays)



# ----------------------
# Création d'une colonne est_finance pour savoir si une campagne a été financée

data_ulule <- data_ulule %>% 
  mutate(est_finance = if_else(montant_recolte_euros > 0, TRUE, FALSE))



data_ulule$annee <- year(data_ulule$date_debut)

