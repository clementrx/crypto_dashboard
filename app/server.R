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