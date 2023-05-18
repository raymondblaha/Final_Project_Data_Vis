library(shiny)
library(ggplot2)

# Define UI for application
shinyUI(
  fluidPage(
    # Add custom CSS to include the background image and style the box
    tags$head(tags$style(HTML("
      body {
        background: url('www/Trippy.png') no-repeat center center fixed;
        -webkit-background-size: cover;
        -moz-background-size: cover;
        -o-background-size: cover;
        background-size: cover;
      }
      .data-box {
        background-color: #f5f5f5;
        border-radius: 5px;
        padding: 10px;
        color: #333;
      }
    "))),
    
    navbarPage("Music Streaming Analysis",
               
               tabPanel("Overview",
                        fluidRow(
                          column(12, 
                                 HTML("<h2>About The Data</h2>"),
                                 wellPanel(
                                   textOutput("aboutData"),
                                   class = "data-box"
                                 )
                          )
                        )
               ),
               
               tabPanel("Demographics",
                        fluidRow(
                          column(10, selectInput("variable", "Variable:",
                                                 choices = c('Age', '`Hours per day`', 'BPM', 'Anxiety', 'Depression', 'Insomnia', 'OCD'))),
                          column(10, plotOutput("boxPlot"))
                        )
               ),
               
               tabPanel("Genre Preference",
                        fluidRow(
                          column(10, plotOutput("barPlot"))
                        )
               ),
               
               tabPanel("Streaming Hours and Mental Health",
                        fluidRow(
                          column(12, plotOutput("violinPlot"))
                        )
               ),
               
               tabPanel("Mood Improvment by Genre",
                        fluidPage(
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("genre", "Genre:",
                                          choices = c('Hip hop', 'Pop', 'Rock', 'EDM', 'Country', 'R&B', 'Jazz',
                                                      'Classical', 'Video game music', 'Rap', 'Lofi', 'Latin',
                                                      'Folk', 'Metal', 'Gospel', 'K pop'))
                            ),
                            mainPanel(
                              plotOutput("moodPlot")
                            )
                          )
                        )
               )
    )
  )
)
