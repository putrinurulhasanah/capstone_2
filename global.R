library(readxl)
library(lubridate)
library(dplyr)
library(ggplot2)
library(plotly)
library(MASS)
library(shiny)
library(shinydashboard)
library(data.table)

shipping <- read_excel("shipping.xlsx")

selectDateRangeShipping <- function() {
  tagList(
    tags$label("Start"),
    dateInput(
      inputId = "date_range_start_shipping",
      label = NULL,
      value = max(shipping$Ship_Date) - 90,
      min = min(shipping$Ship_Date),
      max = max(shipping$Ship_Date),
      format = "yyyy-mm-dd"
      ),
    tags$label("End"),
    dateInput(
      inputId = "date_range_end_shipping",
      label = NULL,
      value = max(shipping$Ship_Date),
      min = min(shipping$Ship_Date),
      max = max(shipping$Ship_Date),
      format = "yyyy-mm-dd"))}

selectProductCategory <- unique(shipping$Product_Category)

selectDateRangeOrder <- function() {
  tagList(
    tags$label("Start"),
    dateInput(
      inputId = "date_range_start_order",
      label = NULL,
      value = max(shipping$Order_Date) - 90,
      min = min(shipping$Order_Date),
      max = max(shipping$Order_Date),
      format = "yyyy-mm-dd"
    ),
    tags$label("End"),
    dateInput(
      inputId = "date_range_end_order",
      label = NULL,
      value = max(shipping$Order_Date),
      min = min(shipping$Order_Date),
      max = max(shipping$Order_Date),
      format = "yyyy-mm-dd"))}
