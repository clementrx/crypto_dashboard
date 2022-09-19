
library(tidyverse)
library(binancer)


binance_coins_prices()

klines <- binance_klines('BTCEUR', interval = '1d')

ggplot(klines, aes(close_time, close)) + geom_line()

library(scales)
ggplot(klines, aes(open_time)) +
  geom_linerange(aes(ymin = open, ymax = close, color = close < open), size = 2) +
  geom_errorbar(aes(ymin = low, ymax = high), size = 0.25) +
  theme_bw() + theme('legend.position' = 'none') + xlab('') +
  ggtitle(paste('Last Updated:', Sys.time())) +
  scale_y_continuous(labels = dollar) +
  scale_color_manual(values = c('#1a9850', '#d73027'))

library(data.table)
klines <- rbindlist(lapply(
  c('ETHBTC', 'ARKBTC', 'NEOBTC', 'IOTABTC'),
  binance_klines,
  interval = '15m',
  limit = 4*24))
ggplot(klines, aes(open_time)) +
  geom_linerange(aes(ymin = open, ymax = close, color = close < open), size = 2) +
  geom_errorbar(aes(ymin = low, ymax = high), size = 0.25) +
  theme_bw() + theme('legend.position' = 'none') + xlab('') +
  ggtitle(paste('Last Updated:', Sys.time())) +
  scale_color_manual(values = c('#1a9850', '#d73027')) +
  facet_wrap(~symbol, scales = 'free', nrow = 2)


library(dygraphs)

klines <- binance_klines('BTCEUR', interval = '1d')

df = klines %>% select(close_time, close)

dygraph(df, main = "crypto") %>% 
  dyRangeSelector() %>% 
  dyOptions(fillGraph = TRUE, 
            drawPoints = TRUE,
            fillAlpha = 0.4)
library(xts)
library(quantmod)

df2 = klines %>% 
  select(open_time, open, low, high, close ) 

df2 <- cbind(df2, SMA(df2[,"close"], n=10))
df2 <- cbind(df2, SMA(df2[,"close"], n=20))
df2 <- cbind(df2, SMA(df2[,"close"], n=50))
df2 <- cbind(df2, SMA(df2[,"close"], n=100))

colnames(df2)[6:9] <- c('SMA10','SMA20', 'SMA50', 'SMA100')

dygraph(df2) %>%
  dyCandlestick()

synth_df <- rbindlist(lapply(
  c('BTCEUR', 'ETHEUR', 'ADAEUR', 'DOTEUR', 'SOLEUR', 'XRPEUR', 'BNBEUR'),
  binance_klines,
  interval = '15m',
  limit = 4*24))

synth_df = synth_df %>% 
  select(close_time, close, symbol) %>% 
  pivot_wider(names_from = symbol,
              values_from = close) 

don=xts( x=synth_df[,-1], order.by=synth_df$close_time)

dygraph(don) 


