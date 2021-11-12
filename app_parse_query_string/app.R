library(shiny)


x2_x3_choices <- list(
    `a` = c("1", "2", "3"),
    `b` = c("4", "5", "6"),
    `c` = c("7", "8", "9")
)

x2_choices <- names(x2_x3_choices)
x2_selected_first <- head(x2_choices, 1)
x3_choices <- x2_x3_choices[[x2_selected_first]]
x5_choices <- list("number"=list(`no.1`=1, `no.2`=2, `no.3`=3))

# Define UI
ui <- fluidPage(
    
    # Application title
    titlePanel("TEST. parseQueryString()"),
    h4("This is a test app about parseQueryString()"),
    p("Parameters: x1, x2, x3, x4, x5"),
    p("Example 1. https://hkboo.shinyapps.io/app_parse_query_string/?x1=tester"),
    p("Example 2. https://hkboo.shinyapps.io/app_parse_query_string/?x1=tester$x4=4"),
    br(),
    
    # Sidebar
    sidebarLayout(
        sidebarPanel(
            textInput('x1', 'X1'),
            selectInput('x2', 'X2', choices = x2_choices, selected = x2_selected_first),
            selectInput('x3', 'X3', choices = x3_choices),
            numericInput('x4', 'X4', value = 1, min = 0, max = 10),
            textInput('x5', 'X5'),
        ),
        mainPanel(
            h3("Input values"),
            verbatimTextOutput('values'),
            
            h3("URL components"),
            verbatimTextOutput("urlText"),
            
            h3("Parsed query string"),
            verbatimTextOutput("queryText")
        )
    )
)

# Define
server <- function(session, input, output) {
    
    observe({
        x <- input$x2
        if (!is.null(x)) {
            input_values <- x2_x3_choices[[x]]
            updateSelectInput(
                session,
                "x3",
                "X3",
                choices = input_values,
                selected = head(input_values, 1)
            )
        }
        
    })
    
    output$values <- renderPrint({
        list(x1 = input$x1, x2 = input$x2, 
             x3 = input$x3, x4 = input$x4, x5 = input$x5)
    })
    
    output$urlText <- renderText({
        paste(sep = "",
              "protocol: ", session$clientData$url_protocol, "\n",
              "hostname: ", session$clientData$url_hostname, "\n",
              "pathname: ", session$clientData$url_pathname, "\n",
              "port: ",     session$clientData$url_port,     "\n",
              "search: ",   session$clientData$url_search,   "\n"
        )
    })
    
    ########## URL PARSING ########## 
    # Parse the GET query string
    output$queryText <- renderText({
        search <- trimws(session$clientData$url_search)
        if (search == "") {
            paste("파싱 대상 쿼리가 없습니다.")
        } else {
            query <- parseQueryString(search)
            # Return a string with key-value pairs
            paste0(search, '\n', paste(names(query), query, sep = "=", collapse=", "))
        }
    })
    
    observe({
        
        search <- trimws(session$clientData$url_search)
        if (search != "") {
            query <- parseQueryString(search)
            print(query)
            
            if (!is.null(query[['x1']])) {
                updateTextInput(session,
                                "x1",
                                "X1",
                                value = query[['x1']])  
            }
            if (!is.null(query[['x2']])) {
                return_indexs <- which(x2_choices == query[['x2']])
                selected_val <- x2_choices[return_indexs]
                if (length(return_indexs) > 0) {
                    updateSelectInput(session,
                                      "x2",
                                      "X2",
                                      choices = x2_choices,
                                      selected = selected_val)
                    
                    # x2에 의존적이므로
                    input_values <- x2_x3_choices[[x2_selected_first]]
                    return_sub_indexs <- which(input_values == query[['x3']])
                    if (length(return_sub_indexs) > 0) {
                        updateSelectInput(session,
                                          "x3",
                                          "X3",
                                          choices = input_values,
                                          selected = input_values[return_sub_indexs])  
                        
                    } else {
                        updateSelectInput(session,
                                          "x3",
                                          "X3",
                                          choices = input_values,
                                          selected = head(input_values, 1))  
                    }
                    
                }
                
            }
            if (!is.null(query[['x4']])) {
                input_val <- as.numeric(query[['x4']])
                print(input_val)
                min_v <- 0 
                max_v <- 10
                print(input_val >= min_v & input_val <= max_v)
                if (input_val >= min_v & input_val <= max_v) {
                    updateNumericInput(session,
                                       "x4",
                                       "X4",
                                       value = input_val,
                                       min = min_v, 
                                       max = max_v)
                }
            }
            if (!is.null(query[['x5']])) {
                updateTextInput(session,
                                "x5",
                                "X5",
                                value = query[['x5']])  
            }
            
        }
        
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)