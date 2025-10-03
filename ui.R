


fluidPage(theme = shinytheme("cerulean"),
          
  tags$div(
    tags$img( src = "logo_ulule.png", height = "50px", width = "200px", style = "margin-right: 10px;"),
    style = "display: flex; align-items: center; margin-bottom: 10px;"
  ),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("Choix_categorie", "Categorie", 
                  choices = c("Toutes les catégories", unique(data_ulule$categorie)),
                  selected = "Toutes les catégories",
                  multiple = TRUE),
      selectInput("Pays", "Pays",
                  choices = c("Tous les pays", unique(data_ulule$pays)),
                  selected = "Tous les pays", selectize = TRUE),
      
      sliderInput("Année", "Année",
                  min = min(data_ulule$annee),
                  max = max(data_ulule$annee),
      value = c(min(data_ulule$annee),
                max(data_ulule$annee)),
    sep =""
  ),
  
      actionButton("actu", "Actualiser"),
      width = 3,
      style = "height: 900px; overflow-y: auto;"
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Accueil",
                 h1("Bienvenue sur notre application"),
                 p("Description accueil ...")
        ),
        
        tabPanel("Statistiques",
                 h2("Statistiques détaillées"),
                 p("Contenu statistiques ...")
        ),
        
        tabPanel("Détails campagnes",
                 h2("Principales caractéristiques de la campagne suivant le périmètre"),
                 p("Voici un extrait des principales caractéristiques des campagnes du périmètre choisi.
                     Il est possible de télécharger l'intégralités des données en cliquant sur 'Télécharger la table' en bas de la page"),
                 fluidRow(
                   column(width = 4,
                          DTOutput("details_campagnes"),
                          downloadButton("download_table", "Télécharger la table")
                   )
                 )
        ),
        
        tabPanel("Graphiques",
                 h2("Graphiques"),
                 p("Dans cet onglet, nous pouvons voir plusieurs indicateurs : les évolutions trimestrielles 
                     du nombre de campagnes, du nombre de campagnes réussies, du montant financé. 
                     Dans le dernier onglet, on peut suivre également l'évolution du ratio de campagnes financées"),
                 tabsetPanel(
                   tabPanel("Campagnes",
                            h3("Evolution trimestrielle du nombre de campagne"),
                            plotlyOutput("nb_campagne")
                   ),
                   tabPanel("Campagnes réussies",
                            h3("Evolution trimestrielle du nombre de campagnes réussies"),
                            plotlyOutput("nb_campagne_reussie")
                   ),
                   tabPanel("Montants financés",
                            h3("Evolution trimestrielle des montants financés des campagnes"),
                            plotlyOutput("mont_finance")
                   ),
                   tabPanel("Ratio campagnes financées",
                            h3("Evolution du ratio de campagnes financées"),
                            plotlyOutput("ratio_campagne_financee")
                   )
                 )
        )
      )
    )
  )
)