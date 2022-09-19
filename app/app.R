library(shiny)

ui <- navbarPage("Dashboard",
                 
                 tabPanel("Synthèse",
                          pageWithSidebar(
                            headerPanel('Filtre'),
                            sidebarPanel(width = 3,
                                         dateRangeInput("daterange",
                                                        "Période : " ,
                                                        start = "2022-01-01",
                                                        end   = "2022-09-22",
                                                        # min = NULL,
                                                        # max = NULL,
                                                        format = "yyyy-mm-dd", 
                                                        # startview = "month",
                                                        # weekstart = 0,
                                                        language = "fr", 
                                                        separator = " à "),
                                         
                                         checkboxGroupInput(inputId = "symb",
                                                            label = 'Crypto:',
                                                            choices = c("BTCEUR" = "BTCEUR",
                                                                        "ETHEUR" = "ETHEUR",
                                                                        "ADAEUR"="ADAEUR",
                                                                        "DOTEUR"="DOTEUR",
                                                                        "SOLEUR"="SOLEUR"),
                                                            selected = c("BTCEUR"="BTCEUR"),
                                                            inline=TRUE)
                            ),
                            
                            mainPanel(
                              column(9, dygraphOutput("synth", width = 900, height=600),
                                     p("test",
                                       style = "font-size:25px")
                                     
                              )
                            )
                          )),
                 
                 tabPanel("Cryptos filter",
                          pageWithSidebar(
                            headerPanel('Filtre'),
                            sidebarPanel(width = 3,
                                         dateRangeInput("daterange",
                                                        "Période : " ,
                                                        start = "2022-01-01",
                                                        end   = "2022-09-22",
                                                        # min = NULL,
                                                        # max = NULL,
                                                        format = "yyyy-mm-dd", 
                                                        # startview = "month",
                                                        # weekstart = 0,
                                                        language = "fr", 
                                                        separator = " à ")
                            ),
                            
                            mainPanel(
                              column(9, dygraphOutput("dygraph", width = 900, height=600),
                                     p("test",
                                       style = "font-size:25px")
                                     
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

server <- function(input, output) {

  
  data_synth <- reactive({
      
    df_filter <- synth_df %>% 
      filter(close_time >= input$daterange[1] & close_time <= input$daterange[2]) %>%
      filter(symbol %in% input$symb) %>% 
      select(close_time, close, symbol) %>% 
      pivot_wider(names_from = symbol,
                  values_from = close) 
    
    df_filter
    
  })
  
  output$synth <- renderDygraph({
    
    don=xts( x=data_synth()[,-1], order.by=data_synth()$close_time)
    dygraph(don) 
  
    })
  
  
  data <- reactive({
    df_filter <- df2 %>% 
      filter(open_time >= input$daterange[1] & open_time <= input$daterange[2])
    
    df_filter
  })
  
  output$dygraph <- renderDygraph({
    dygraph(data()) %>%
      dyCandlestick()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
