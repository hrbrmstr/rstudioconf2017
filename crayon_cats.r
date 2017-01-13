#' ---
#' title: "Crayon Cats"
#' author: ""
#' date: ""
#' output:
#'   html_document:
#'     toc: true
#'     toc_float: true
#'     theme: spacelab
#'     highlight: espresso
#' ---
#+ include=FALSE, message=FALSE
knitr::opts_chunk$set(message=FALSE, warning=FALSE, echo=TRUE, cache=FALSE, collapse=FALSE)
options(width=60)
library(tidyverse)

#' Just a working example from the slide deck

#+ crayon
cat(crayon::red(paste0(sprintf("I <3 %s", map_chr(c("dGhpcyBhdWRpZW5jZQ==", "bXkgZmFtaWx5", "Ug=="), ~rawToChar(openssl::base64_decode(.)))), collapse="\n")))

c("dGhpcyBhdWRpZW5jZQ==", "bXkgZmFtaWx5", "Ug==") %>%
  map(openssl::base64_decode) %>%
  map_chr(rawToChar) %>%
  sprintf(fmt="I <3 %s") %>%
  paste0(collapse="\n") %>%
  crayon::red() %>%
  cat()
