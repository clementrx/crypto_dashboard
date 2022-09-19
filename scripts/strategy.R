# moving average

df_strat = df %>% 
  filter(intervalle == '15min',
         symbol == 'BTCEUR') %>% 
  select(close_time, close) %>% 
  mutate(
    # pnl = replace_na(close/lag(close) -1, 0),
    
    SMA20 = SMA(close, n=10),
    SMA50 = SMA(close, n=30),
    
    # SMA20_pos = ifelse(
    #   lag(close) < lag(SMA20) & close > SMA20,
    #   1,
    #   ifelse(lag(close) > lag(SMA20) & close < SMA20,
    #          -1,
    #          0)),
    # SMA50_pos = ifelse(
    #   lag(close) < lag(SMA50) & close > SMA50,
    #   1,
    #   ifelse(lag(close) > lag(SMA50) & close < SMA50,
    #          -1,
    #          0)),
    
    SMA_dec = replace_na(ifelse(
      lag(SMA20) < lag(SMA50) & SMA20 > SMA50,
      'Achat',
      ifelse(lag(SMA20) > lag(SMA50) & SMA20 < SMA50,
             'Vente',
             ''))),
    
    SMA_position = if_else(SMA20 > SMA50, 'hold', "wait") %>% lag() %>% replace_na('')
    
    ) 

bs_df = df_strat %>% 
  filter(SMA_dec != '') %>% 
  mutate(n = row_number()) %>% 
  filter((n > 1 & SMA_dec == 'Vente') | (n >= 1 & SMA_dec == 'Achat') ) %>% 
  select(-n) %>% 
  mutate(evolution = replace_na(close/lag(close) -1, 0)) #%>% 
  # filter(SMA_dec == 'Vente')


daily_xts = xts(bs_df$evolution, order.by = bs_df$close_time)


library(PerformanceAnalytics)

maxDrawdown(daily_xts)
# table.AnnualizedReturns(daily_xts)
charts.PerformanceSummary(daily_xts)

# Load required R packages
library(highcharter)

df_hch = xts(df_strat$close, order.by = df_strat$close_time)

df_strat %>%
  pivot_longer(!c(close_time, SMA_dec, SMA_position), names_to = "var", values_to = "close") %>% 
  ggplot(aes(x = close_time, y = close, color = var))+
  geom_line(size = 1) +
  geom_point(data = bs_df, 
             mapping = aes(x = close_time, y = close, 
                           shape = factor(SMA_dec),
                           color = factor(SMA_dec))) +
  scale_color_manual(values = c("close" = "blue",
                                "SMA20" = "orange",
                                "SMA50" = 'purple',
                                "Achat" = "green",
                                "Vente" = "red")) + 
  theme(legend.position="none")




