library(shiny)
library(DT)


shinyUI(fluidPage(
    shinyjs::useShinyjs(),
    
    # Application title
    titlePanel("Paper Manager"),
    
    strong("2021-07-28 hkboo@kookmin.ac.kr"),
    p("Manage your papers"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            id = 'side-panel',
            selectInput(
                inputId = "paper_type",
                label = "Choose a paper type:",
                choices = c("국내", "국외")
            ),
            textInput(
                value = "",
                inputId = "paper_name",
                label = "Input paper name"
            ),
            textInput(
                value = "",
                inputId = "paper_writer",
                label = "Input paper writer"
            ),
            numericInput(
                value = 2021,
                inputId = "paper_year",
                label = "Input paper publiched year"
            ),
            textInput(
                value = "",
                inputId = "paper_journal_name",
                label = "Input journal name"
            ),
            textInput(
                value = "",
                inputId = "paper_data",
                label = "Input dataset in paper"
            ),
            textInput(
                value = "",
                inputId = "paper_method",
                label = "Input methods in paper"
            ),
            textAreaInput(
                value = "",
                inputId = "paper_summary",
                label = "Input paper summary",
                height = '100px'
            ),
            textAreaInput(
                value = "",
                inputId = "paper_doi",
                label = "Input paper doi"
            ),
            actionButton(inputId = "saveBtn",
                         label = "Save All",
                         class = "btn-success"),
            actionButton(inputId = "clearBtn", 
                         label = "Clear All",
                         class = "btn-light")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(DTOutput("saved_info_tbl"))
    )
))
