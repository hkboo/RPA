library(shiny)
library(DT)

source("./global.R")

first_tbl <- readRDS(info_tbl_path)
shinyServer(function(input, output) {
    input_items_df <- reactive({
        row_df <- as.data.frame(
            list(
                paper_type = input$paper_type,
                paper_name = input$paper_name,
                paper_writer = input$paper_writer,
                paper_year = input$paper_year,
                paper_journal_name = input$paper_journal_name,
                paper_data = input$paper_data,
                paper_method = input$paper_method,
                paper_summary = input$paper_summary,
                paper_doi = input$paper_doi
            )
        )
    })
    output$temp_return <- renderTable({input_items_df()})
    return_tbl <- reactiveVal(first_tbl)
    output$saved_info_tbl <- renderDT({
        return_tbl()
    })
    
    observeEvent(input$saveBtn, {
        new_row <- input_items_df()
        new_info_tbl <- rbind(return_tbl(), new_row)
        new_info_tbl <- new_info_tbl[!duplicated(new_info_tbl), ]
        return_tbl(new_info_tbl)
        saveRDS(new_info_tbl, info_tbl_path)
        
        output$saved_info_tbl <- renderDT({
            return_tbl()
        })
    })
    
    observeEvent(input$clearBtn, {
        shinyjs::reset("side-panel")
    })

})
