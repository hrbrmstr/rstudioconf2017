#' ---
#' title: "CalesTak SATCAT"
#' author: ""
#' date: ""
#' output:
#'   html_document:
#'     toc: true
#'     toc_float: true
#'     theme: spacelab
#'     highlight: kate
#' ---
#+ include=FALSE
knitr::opts_chunk$set(message=FALSE, warning=FALSE, echo=TRUE, cache=FALSE, collapse=FALSE)
options(width=100)

#' ### Setup

#+ libraries
library(tidyverse)
library(stringi)
library(rvest)
library(tools)

#' ### Read in data

#+ data, cache=TRUE
source("data.r")

#' ### What does our data look like?

#+ eda
glimpse(satcat)

#' ### How many satellites launched per source (country) [top 20]

count(satcat, source_full_name, sort=TRUE) %>%
  mutate(ct=scales::comma(n), pct=scales::percent(n/sum(n))) %>%
  select(-n) %>%
  print(n=20)

#' ### How many satellites launched per source (country) that are still active? [top 20]

filter(satcat, is_active) %>%
  count(source_full_name, sort=TRUE) %>%
  mutate(ct=scales::comma(n), pct=scales::percent(n/sum(n))) %>%
  select(-n) %>%
  print(n=20)


#' ### What's the most popular launch site? [top 20]

count(satcat, launch_site_full_name, sort=TRUE) %>%
  mutate(ct=scales::comma(n), pct=scales::percent(n/sum(n))) %>%
  select(-n) %>%
  mutate(launch_site_full_name=abbreviate(launch_site_full_name, 80)) %>%
  print(n=20)

#' ### What's the most popular launch site this century? [top 20]

filter(satcat, lubridate::year(launch_date) >= 2000) %>%
  count(launch_site_full_name, sort=TRUE) %>%
  mutate(ct=scales::comma(n), pct=scales::percent(n/sum(n))) %>%
  select(-n) %>%
  mutate(launch_site_full_name=abbreviate(launch_site_full_name, 80)) %>%
  print(n=20)

