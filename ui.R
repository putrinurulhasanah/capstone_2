library(shiny)
library(shinydashboard)

header <- dashboardHeader(
  title = tags$b("Shipping Analysis")
)

sidebar <- dashboardSidebar(
  collapsed = FALSE,
  sidebarMenu(
    menuItem(
      text = "Shipping Summary",
      tabName = "Shipping_Summary",
      icon = icon("truck-fast")
    ),
    menuItem(
      text = "Revenue and Profit Analysis",
      tabName = "Revenue_and_Profit_Analysis",
      icon = icon("dollar-sign")
    ),
    menuItem(
      text = "Data",
      tabName = "Data",
      icon = icon("file")
    ),
    menuItem("Source_Code",
      icon = icon("code"),
      href = "https://github.com/putrinurulhasanah/capstone_2")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "Shipping_Summary",
      fluidPage(
        h2(tags$b("Shipping Summary")),
        br(),
        div(style = "text-align:justify", 
            p("Shipping Data provide information about orders, customers, products, pricing, discounts, and profitability.
            They can be used to analyze sales, track customer behavior, evaluate profit margins, and optimize shipping
            processes, among other insights."),
            br()
        )
      ),
      fluidRow(
        valueBox("1,138,807 USD",
                 "Total Revenue",
                 color = "orange",
                 width = 4),
        valueBox("530,891.1 USD",
                 "Total Profit",
                 color = "orange",
                 width = 4),
        valueBox("46.62%",
                 "Total Profit Ratio",
                 color = "orange",
                 width = 4)),

      fluidPage(
        box(width = 10,
            solidHeader = T,
            title = tags$b("Profit Ratio (Profit/Revenue)"),
            plotlyOutput("profit_ratio_plot")),
        box(width = 2,
            solidHeader = TRUE,
            title = tags$b("Shipping Date Range"),
            background = "blue",
            height = 200,
            selectDateRangeShipping()),
        valueBoxOutput(width = 2,
                       "total_order"),
        valueBoxOutput(width = 2,
                       "total_order_quantity"))),
    tabItem(
      tabName = "Revenue_and_Profit_Analysis",
      fluidPage(
        box(width = 10,
            solidHeader = T,
            title = tags$b("Total Revenue and Profit"),
            plotlyOutput("analysis1_plot")),
        box(width = 2,
            solidHeader = TRUE,
            title = tags$b("Order Date Range"),
            background = "blue",
            height = 200,
            selectDateRangeOrder()),
        box(width = 2,
            solidHeader = T,
            background = "blue",
            height = 150,
            selectInput(inputId = "Product_Category",
                        label = h4(tags$b("Select Product Category:")),
                        choices = selectProductCategory))
        ),
      fluidPage(
        box(width = 10,
            solidHeader = T,
            title = tags$b("Scatterplot of Total Profit vs. Discount Amount Over Time"),
            plotlyOutput("analysis3_plot")),
        valueBoxOutput(width = 2,
                       "corr"),
        box(
          width = 2,
          title = "Coefficient Correlation",
          status = "primary",
          solidHeader = TRUE,
          p("The coefficient correlation between Total Profit and Discount Amount over time measures their relationship.
            A correlation value of -1 indicates a perfect negative relationship, 0 indicates no relationship,
            and +1 indicates a perfect positive relationship. Values closer to -1 or +1 imply a stronger linear association,
            while values closer to 0 suggest a weaker or non-linear relationship.")))),
    tabItem(
      tabName = "Data",
      h2(tags$b("Shipping Data")),
      DT::dataTableOutput("data"))))

dashboardPage(
  header = header,
  body = body,
  sidebar = sidebar,
  skin = "blue")
  