ui <- navbarPage("Dashboard",
                 
                 tabPanel("Synthèse",
                          pageWithSidebar(
                            headerPanel('Filtre'),
                            sidebarPanel(width = 3,
                                         dateRangeInput("daterange",
                                                        "Période : " ,
                                                        start = last_y,
                                                        end   = today,
                                                        # min = NULL,
                                                        # max = NULL,
                                                        format = "yyyy-mm-dd", 
                                                        # startview = "month",
                                                        # weekstart = 0,
                                                        language = "fr", 
                                                        separator = " à "),
                                         
                                         selectInput("select", label = h3("Intervalle"), 
                                                     choices = list("15min" = "15min",
                                                                    "30min" = "30min",
                                                                    "1h" = "1h",
                                                                    "2h" = "2h",
                                                                    "1j" = '1j'), 
                                                     selected = c("1j"="1j")),
                                         
                                         checkboxGroupInput(inputId = "symb",
                                                            label = 'Crypto:',
                                                            choices = c("BTCEUR" = "BTCEUR",
                                                                        "ETHEUR" = "ETHEUR",
                                                                        "ADAEUR"="ADAEUR",
                                                                        "DOTEUR"="DOTEUR",
                                                                        "SOLEUR"="SOLEUR"),
                                                            selected = c("BTCEUR"="BTCEUR"),
                                                            inline=FALSE)
                            ),
                            
                            mainPanel(
                              column(9, dygraphOutput("synth", width = 900, height=600)
                                     
                              )
                            )
                          )),
                 
                 tabPanel("Cryptos filter",
                          pageWithSidebar(
                            headerPanel('Filtre'),
                            sidebarPanel(width = 3,
                                         dateRangeInput("daterange",
                                                        "Période : " ,
                                                        start = last_y,
                                                        end   = today,
                                                        # min = NULL,
                                                        # max = NULL,
                                                        format = "yyyy-mm-dd", 
                                                        # startview = "month",
                                                        # weekstart = 0,
                                                        language = "fr", 
                                                        separator = " à "),
                                         
                                         selectInput("select_spec", label = h3("Intervalle"), 
                                                     choices = list("15min" = "15min",
                                                                    "30min" = "30min",
                                                                    "1h" = "1h",
                                                                    "2h" = "2h",
                                                                    "1j" = '1j'), 
                                                     selected = c("1j"="1j")),
                                         
                                         selectInput("select_crypto", 
                                                     label = h3("Sélectionner la monnaie"), 
                                                     choices = c("BTCEUR" = "BTCEUR",
                                                                 "ETHEUR" = "ETHEUR",
                                                                 "ADAEUR"="ADAEUR",
                                                                 "DOTEUR"="DOTEUR",
                                                                 "SOLEUR"="SOLEUR"),
                                                     selected = c("BTCEUR"="BTCEUR")),
                                         
                                         checkboxInput("SMA10","MA10", value = TRUE),
                                         checkboxInput("SMA20","MA20", value = TRUE),
                                         checkboxInput("SMA50","MA50", value = TRUE),
                                         checkboxInput("SMA100","MA100", value = TRUE),
                            ),
                            
                            mainPanel(
                              column(9, dygraphOutput("dygraph", width = 900, height=600)
                                     
                              )
                            )
                          )),
                 tabPanel("Component 2",
                          
                          fluidRow(),
                          fluidRow(),
                          fluidRow()
                 ),
                 tabPanel("Component 3")
)