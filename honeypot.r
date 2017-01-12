#' ---
#' title: "Honeypots"
#' author: ""
#' date: ""
#' output:
#'   html_document:
#'     toc: true
#'     toc_float: true
#'     theme: spacelab
#'     highlight: espresso
#' ---
#+ include=FALSE
knitr::opts_chunk$set(message=FALSE, warning=FALSE, echo=TRUE, cache=FALSE, collapse=FALSE)
options(width=60)

#' ### The "good 'ol days"

library(ndjson)
library(anytime)

#+ cache=TRUE
do.call(rbind, lapply(list.files("data/honeypot", pattern="cowrie.*json.gz", full.names=TRUE), function(x) {
  df <- as.data.frame(stream_in(x))
  df <- df[,c("timestamp", "src_ip", "src_port", "sensor", "session", "dst_port", "eventid", "username", "password")]
  df$timestamp <- anytime(df$timestamp)
  df
})) -> cowrie_df

str(cowrie_df)

#' ### If you wanted your co-workers to not hate you

#+ cache=TRUE
stream_and_filter <- function(x) {
  df <- as.data.frame(stream_in(x))
  df <- df[,c("timestamp", "src_ip", "src_port", "sensor", "session", "dst_port", "eventid", "username", "password")]
  df$timestamp <- anytime(df$timestamp)
  df
}

fils <- list.files("data/honeypot", pattern="cowrie.*json.gz", full.names=TRUE)
cowrie_df_list <- lapply(fils, stream_and_filter)
cowrie_df <- do.call(rbind, cowrie_df_list)

#' ### Time for pipes

library(tidyverse)

#+ cache=TRUE
list.files("data/honeypot", pattern="cowrie.*json.gz", full.names=TRUE) %>%
  map_df(stream_in) %>%
  select(timestamp, src_ip, src_port, sensor, session,
         dst_port, eventid, username, password) %>%
  mutate(timestamp=anytime(timestamp))
