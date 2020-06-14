library(shiny)
library(shinydashboard)
library(shinyWidgets)

namelist <- readRDS('namelist.RData')
namelist2 <- as.character(namelist[,1])


ui <- dashboardPage(title = "Feltark for fremmede treslagprosjektet",
              
              dashboardHeader(title = "Feltark for fremmede treslagprosjektet",
                              titleWidth = 400),
              dashboardSidebar(disable = T),
              dashboardBody(
                column(width = 4,
                       selectInput('location', label = NULL,
                                            choices = c("Romsdalen", "Vesterålen", "Vikna")),
                       selectInput('recordedBy', 'Your name', 
                                   choices = c("Lyngstad", "Øien", "Davidsen", "Kolstad")),
                       
                       
                       numericInput('cc', 'Canopy Cover', value = NA, min=0, max = 100),
                       
                       # This input could be made conditional 
                       # on the others above having been filled out
                       selectizeInput(inputId='species', 
                                      label = "Species", 
                                      choices = namelist2, 
                                      #selected = NULL, 
                                      multiple = FALSE,
                                      options = list(create = TRUE,
                                                     placeholder = 'Type species name')),
                       sliderInput('cover', "% cover", min = 0, max = 100, value = 0),
                       actionButton("addSp","Add species to list"),
                       actionButton("save","Save form")
                       
                       
                ),
                column(width = 8,
                       tableOutput('table')
                       )
                
))

server <- function(input, output, session) {
  
  updateSelectizeInput(session, 'species', choices = namelist2, server = TRUE)
  
  df <- reactiveVal(data.frame(Species = as.character(),
                               Cover   = as.numeric()))
  
  observeEvent(input$addSp, {
  
    df(rbind(df(), data.frame(Species = input$species,
                              Cover   = input$cover)))

    
    
  })
  
 
  output$table <- renderTable({
    df()
    })

  
  # remember when exporting to add recordedBy
  # add date from Sys.Date()

  observeEvent(input$save, {
    write.csv(df(), file = 'test.csv', row.names = F)
  })
}

shinyApp(ui = ui, server = server)


# create eventID?
# remove or edit rows
# Add recorder name,...
# add canopy cover, litter, data etc, and show species button only when these are filled out.
# export to local file, but keep sheet
# reset sheet button (with warning)

