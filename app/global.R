packages <- c("tidyverse",
              "binancer",
              "scales",
              "data.table",
              "dygraphs",
              "quantmod",
              "xts",
              'shiny')

install.packages(setdiff(packages, rownames(installed.packages())))

library(tidyverse)
library(binancer)
library(scales)
library(data.table)
library(dygraphs)
library(quantmod)
library(xts)
library(shiny)

today = Sys.Date()
last_7d = today-7
last_15d = today-15
last_30d = today-30
last_y = today-365
# last_3y = today-(365*3)

# telechargement des crypto
df_7d_15min <- rbindlist(lapply(
  c('BTCEUR', 'ETHEUR', 'ADAEUR', 'DOTEUR', 'SOLEUR', 'XRPEUR', 'BNBEUR'),
  binance_klines,
  interval = '15m',
  limit = 4*24*7,
  start_time = last_7d,
  end_time = today)) %>% 
  mutate(intervalle = '15min')

df_7d_30min <- rbindlist(lapply(
  c('BTCEUR', 'ETHEUR', 'ADAEUR', 'DOTEUR', 'SOLEUR', 'XRPEUR', 'BNBEUR'),
  binance_klines,
  interval = '30m',
  limit = 3*24*7,
  start_time = last_7d,
  end_time = today)) %>% 
  mutate(intervalle = '30min')

df_7d_1h <- rbindlist(lapply(
  c('BTCEUR', 'ETHEUR', 'ADAEUR', 'DOTEUR', 'SOLEUR', 'XRPEUR', 'BNBEUR'),
  binance_klines,
  interval = '1h',
  limit = 24*7,
  start_time = last_7d,
  end_time = today)) %>% 
  mutate(intervalle = '1h')

df_15d_2h <- rbindlist(lapply(
  c('BTCEUR', 'ETHEUR', 'ADAEUR', 'DOTEUR', 'SOLEUR', 'XRPEUR', 'BNBEUR'),
  binance_klines,
  interval = '2h',
  limit = 12*15,
  start_time = last_15d,
  end_time = today)) %>% 
  mutate(intervalle = '2h')

df_1d <- rbindlist(lapply(
  c('BTCEUR', 'ETHEUR', 'ADAEUR', 'DOTEUR', 'SOLEUR', 'XRPEUR', 'BNBEUR'),
  binance_klines,
  interval = '1d',
  limit = 365,
  start_time = last_y,
  end_time = today)) %>% 
  mutate(intervalle = '1j')

df = rbind(df_7d_15min,
           df_7d_30min,
           df_7d_1h,
           df_15d_2h,
           df_1d)




