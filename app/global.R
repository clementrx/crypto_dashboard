packages <- c("tidyverse",
              "binancer",
              "scales",
              "data.table",
              "dygraphs",
              "quantmod",
              "xts",
              'shiny')

install.packages(setdiff(packages, rownames(installed.packages())))

# telechargement des crypto
synth_df <- rbindlist(lapply(
  c('BTCEUR', 'ETHEUR', 'ADAEUR', 'DOTEUR', 'SOLEUR', 'XRPEUR', 'BNBEUR'),
  binance_klines,
  interval = '1d'))
# limit = 4*24))


klines <- binance_klines('BTCEUR', interval = '1d')
df2 = klines %>% 
  select(open_time, open, low, high, close ) 

df2 <- cbind(df2, SMA(df2[,"close"], n=10))
df2 <- cbind(df2, SMA(df2[,"close"], n=20))
df2 <- cbind(df2, SMA(df2[,"close"], n=50))
df2 <- cbind(df2, SMA(df2[,"close"], n=100))

colnames(df2)[6:9] <- c('SMA10','SMA20', 'SMA50', 'SMA100')


