# -------------------------------------------- #
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






# ---- Chargement des données ---- #


data_ulule <- read_csv("Data/data_ulule_2025.csv")

glimpse(data_ulule)
