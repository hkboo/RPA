library(shiny)
library(rclipboard)
library(stringr)
# library(rsconnect)
# rsconnect::deployApp('path/to/your/app')

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    rclipboardSetup(),

    # Application title
    titlePanel("Remove newlines"),
    h3("2021-07-14 hkboo@kookmin.ac.kr"),
    h4("Input your text and remove newlines"),
    br(),
    fluidRow(column(12, div(actionButton("clearBtn", "CLEAR", class = "btn-warning"),
                            style = "float: right"))),
    br(),
    textAreaInput("textLines", NULL, width = '100%', height = "300px"),
    fluidRow(column(12, textOutput("nchar"), style = "text-align: right")),
    br(),
    actionButton("convertBtn", "CONVERT", width = '100%', class = "btn-primary"),
    br(),
    br(),
    uiOutput("copy"),
    br(),
    verbatimTextOutput("value"),
    fluidRow(
        column(width = 4, 
            actionButton("goTrans1", "Go to google translate", onclick ="window.open('https://translate.google.com', '_blank')",
                         width = '100%', class='btn-info')),
        column(width = 4, 
               actionButton("goTrans2", "Go to papago translate", onclick ="window.open('https://papago.naver.com', '_blank')",
                            width = '100%', class='btn-info')),
        column(width = 4, 
               actionButton("goTrans3", "Go to bing translate", onclick ="window.open('https://www.bing.com/translator', '_blank')",
                            width = '100%', class='btn-info'))
    )
)

server <- function(input, output, session) {

    remove_newlines <- function(text) {
        new_text <- str_replace_all(text, "\\n|\\t", " ")
        new_text <- str_replace_all(new_text, "\\s+", " ")
        return(new_text)
    }
    
    count_nchar <- function(text) {
        return(nchar(text))
    }
    
    observeEvent(input$clearBtn, {
        updateTextAreaInput(session, "textLines", value = "")
    })
    
    observe({
        return_text <- paste("CHARACTERS WITH SPACE:", 
                             count_nchar(input$textLines))
        output$nchar <- renderText({return_text})
    })
    
    new_text <- reactiveVal("")
    observeEvent(input$convertBtn, {
        output_text <- remove_newlines(input$textLines)
        new_text(output_text)
    })
    
    output$value <- renderText({
        new_text()
    })
    
    output$copy <- renderUI({
        rclipButton("copyBtn", "COPY", new_text(), icon("clipboard"), width = '100%')
    })
}
# Run the application 
shinyApp(ui = ui, server = server)
