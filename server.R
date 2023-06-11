library(shiny)
function(input, output) {

    #output 1
  
    output$profit_ratio_plot <- renderPlotly({
      
      shipping_ratio <- shipping %>% 
        filter(Ship_Date >= input$date_range_start_shipping & Ship_Date <= input$date_range_end_shipping) %>%
        group_by(Product_Category) %>%
        summarise(Total_Revenue = sum(Total_Cost),
                  Total_Profit = sum(Total_Profit),
                  .groups = "drop") %>%
        mutate(text = paste0("Profit Ratio: ", round(Total_Profit/Total_Revenue*100, digits=2), " %"))
      shipping_ratio$Profit_Ratio <- (shipping_ratio$Total_Profit/shipping_ratio$Total_Revenue)*100
      
      profit_ratio_plot <- ggplot(shipping_ratio, aes(x=reorder(Product_Category, Profit_Ratio), y=Profit_Ratio, text=text)) +
        geom_col(aes(fill=Profit_Ratio), show.legend=F) +
        coord_flip() +
        labs(y = "Percentage",
             x = NULL) +
        scale_y_continuous(limits=c(0,100)) +
        scale_fill_gradient(high="black", low="darkblue") +
        theme(plot.title = element_text(face = "bold", size = 15, hjust = 0.5),
              axis.ticks.y = element_blank(),
              panel.background = element_rect(fill = "#ffffff"), 
              panel.grid.major.x = element_line(colour = "grey"),
              axis.line.x = element_line(color = "grey"),
              axis.text = element_text(size = 8, colour = "black"))
      
      ggplotly(profit_ratio_plot, tooltip="text")
    })
    
    output$total_order <- renderValueBox({
      total_order <- shipping %>%
        filter(Ship_Date >= input$date_range_start_shipping & Ship_Date <= input$date_range_end_shipping) %>%
        nrow()
      valueBox(
        value = total_order,
        subtitle = "Total Order", 
        color = "light-blue")})
    
    output$total_order_quantity <- renderValueBox({
      total_quantity <- sum(shipping$Order_Quantity[shipping$Ship_Date >= input$date_range_start_shipping & shipping$Ship_Date <= input$date_range_end_shipping])
      valueBox(
        value = total_quantity,
        subtitle = "Total Order Quantity", 
        color = "light-blue")})
    
    #output 2
    
    output$analysis1_plot <- renderPlotly({
      
      analysis1 <- shipping %>%
        group_by(Order_Date, Product_Category) %>%
        summarize(Total_Revenue = round(sum(Total_Cost), digits = 0),
                  Total_Profit = round(sum(Total_Profit), digits = 0),
                  Num_Order = n(),
                  .groups = "drop",
                  Order_Date = as.Date(Order_Date))%>%
        filter(Product_Category == input$Product_Category,
               Order_Date >= input$date_range_start_order & Order_Date <= input$date_range_end_order) %>%
        rename("Total Revenue" = Total_Revenue,
               "Order Date" = Order_Date,
               "Total Profit" = Total_Profit)
      
      analysis1_plot <- ggplot(analysis1, aes(x = `Order Date`)) +
        geom_line(aes(y = `Total Revenue`, color = "Total Revenue")) +
        geom_line(aes(y = `Total Profit`, color = "Total Profit")) +
        labs(x = "Order Date", y = "Total Revenue (USD)", color = "") +
        scale_color_manual(values = c("Total Revenue" = "steelblue", "Total Profit" = "darkorange")) +
        theme(axis.ticks.y = element_blank(),
              panel.background = element_rect(fill = "#ffffff"), 
              panel.grid.major.x = element_line(colour = "grey"),
              axis.line.x = element_line(color = "grey"),
              axis.text = element_text(size = 10, colour = "black"))
      
      ggplotly(analysis1_plot)
      })
    
    #output 3
    output$analysis3_plot <- renderPlotly({
      analysis3 <- shipping %>%
        filter(Product_Category == input$Product_Category) %>%
        rename("Discount Amount" = `Discount_$`,
               "Total Profit" = Total_Profit,
               "Product Category"= Product_Category,
               "Order No" = Order_No)
      analysis3$`Total Profit`= round(analysis3$`Total Profit`, digits = 2)
      analysis3$`Discount Amount` = round(analysis3$`Discount Amount`, digits = 2)
      
      analysis3_plot <- ggplot(analysis3, aes(x = `Total Profit`, y = `Discount Amount`)) +
        geom_point(size = 1) +
        geom_smooth(formula = y ~ x, method = "lm", se = FALSE, color = "#237278", size = 0.5) +
        labs(x = "Total Profit", y = "Discount Amount in USD") +
        theme(axis.ticks.x = element_blank(),
              panel.background = element_rect(fill = "#ffffff"),
              panel.grid.major.y = element_line(colour = "grey"),
              axis.line.y = element_line(color = "grey"),
              axis.text = element_text(size = 10, colour = "black"))
      
      ggplotly(analysis3_plot)
      })
    
    output$corr <- renderValueBox({
      analysis3 <- shipping %>%
        filter(Product_Category == input$Product_Category) %>%
        rename("Discount Amount" = `Discount_$`,
               "Total Profit" = Total_Profit,
               "Product Category"= Product_Category,
               "Order No" = Order_No)
      cor_coef <- round(cor(analysis3$`Total Profit`, analysis3$`Discount Amount`), digits = 2)
      valueBox(
        value = cor_coef,
        subtitle = "Coefficient Correlation", 
        color = "light-blue")})
    
    #output 4
    output$data <- DT::renderDataTable(shipping, options = list(scrollX = T))
}

