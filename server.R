


# Define server logic required to draw a histogram
function(input, output, session) {
  
  perimetre <- eventReactive(input$actu, {
    data_ulule <- if (input$Choix_categorie != "Toutes les catégories") {
      data_ulule %>% filter(categorie == input$Choix_categorie)
    } else {
      data_ulule <- data_ulule
    }
    
    # Filtrage par pays
    data_ulule <- if (input$Pays != "Tous les pays") {
      data_ulule %>% filter(pays == input$Pays)
    } else {
      data_ulule <- data_ulule
    }
    
    data_ulule <- data_ulule %>%
      filter(lubridate::year(date_debut) >= input$Année[1],
             lubridate::year(date_debut) <= input$Année[2])
  })
  
  output$details_campagnes <- renderDT({
    head(perimetre(), n = 10)
  })
  
  output$download_table <- downloadHandler(
    filename = function() {
      paste("table_campagnes_", input$Pays, ".csv", sep = "")
    },
    
    content = function(file) {
      # Récupère les données filtrées par la fonction perimetre
      data_ulule_table <- perimetre()
      
      # Écriture du fichier CSV
      write.csv(data_ulule_table, file, row.names = FALSE)
    }
  )
  
  output$nb_campagne <- renderPlotly({
    (perimetre() %>% 
       count(trimestre) %>% 
       ggplot(aes(x = trimestre, y = n)) +
       geom_line(color = "#05567d") +
       geom_point(size = 2, color = "#05567d") + 
       labs(
         #title = "Évolutions trimestrielles du nombre de campagnes",
         title  = paste("Pays sélectionné : ", input$Pays),
         y = "Nombre de campagnes"
       ) +
       theme_bw()) %>% 
      ggplotly()
  })
  
  output$nb_campagne_reussie <- renderPlotly({
    (perimetre() %>% 
       filter(objectif_atteint == "TRUE") %>% 
       count(trimestre) %>% 
       ggplot(aes(x = trimestre, y = n)) +
       geom_line(color = "#05567d") +
       geom_point(size = 2, color = "#05567d") + 
       labs(
         #title = "Évolutions trimestrielles du nombre de campagnes réussies",
         y = "Nombre de campagnes réussies"
       ) +
       theme_bw()) %>% 
      ggplotly()
  })
  
  output$mont_finance <- renderPlotly({
    (perimetre() %>% 
       group_by(trimestre) %>% 
       summarise(
         montant_finance = sum(montant_recolte_euros)) %>%  
       
       ggplot(aes(x = trimestre, y = montant_finance)) +
       geom_line(color = "#05567d") +
       geom_point(size = 2, color = "#05567d") +
       scale_y_continuous(labels = label_number(big.mark = " "))+
       labs(
         #title = "Évolutions trimestrielles du montant financé",
         y = "Montant financé (€)"
       ) +
       theme_bw()) %>% 
      ggplotly()
  })
  
  output$ratio_campagne_financee <- renderPlotly({
    (perimetre() %>% 
       
       group_by(trimestre) %>% 
       summarise(
         ratio_campagne_finance = round(100 *sum(est_finance, na.rm = TRUE) / n(),2 ), " %" ) %>% 
       
       ggplot(aes(x = trimestre, y = ratio_campagne_finance)) +
       geom_line(color = "#05567d") +
       geom_point(size = 2, color = "#05567d") +
       labs(
         #title = "Évolutions trimestrielles du ratio des campagnes financés",
         y = "Ratio campagnes financés "
       ) +
       theme_bw()) %>% 
      ggplotly()
  })
  
}
