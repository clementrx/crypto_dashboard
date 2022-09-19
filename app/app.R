library(shiny)

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

server <- function(input, output) {

  
  data_comp <- reactive({
      
    df_filter <- df %>% 
      filter(symbol %in% input$symb) %>% 
      filter(intervalle == input$select) %>% 
      filter(close_time >= input$daterange[1] & close_time <= input$daterange[2]) %>%
      select(close_time, close, symbol) %>% 
      pivot_wider(names_from = symbol,
                  values_from = close) 
    
    df_filter
    
  })
  
  output$synth <- renderDygraph({
    
    don=xts( x=data_comp()[,-1], order.by=data_comp()$close_time)
    dygraph(don) %>% 
      dyRangeSelector(height = 20)
  
    })
  
  
  data_spec <- reactive({
    df_filter_spec <- df %>% 
      filter(intervalle == input$select_spec) %>% 
      filter(symbol == input$select_crypto) %>% 
      filter(close_time >= input$daterange[1] & close_time <= input$daterange[2]) %>% 
      select(open_time, open, low, high, close ) 
    
    if(input$SMA10){
      df_filter_spec <- df_filter_spec %>% mutate(SMA10 = SMA(close, n=10))
    }
    if(input$SMA20){
      df_filter_spec <- df_filter_spec %>% mutate(SMA20 = SMA(close, n=20))
    }
    if(input$SMA50){
      df_filter_spec <- df_filter_spec %>% mutate(SMA50 = SMA(close, n=50))
    }
    if(input$SMA100){
      df_filter_spec <- df_filter_spec %>% mutate(SMA100 = SMA(close, n=100))
    }
    
    df_filter_spec
  })
  
  output$dygraph <- renderDygraph({
    dygraph(data_spec()) %>%
      dyCandlestick() %>% 
      dyRangeSelector(height = 20)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
