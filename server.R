library(shiny)
library(ggplot2)
library(readr)

# Load the data
data <- read_csv("https://raw.githubusercontent.com/raymondblaha/Final_Project_Data_Vis/main/music_data.csv")

# drop all of the NA values
data <- na.omit(data)

# Remove the extreme outlier in BPM column 999999999
data <- data[data$BPM != 999999999,]

# Define server logic required
shinyServer(function(input, output, session) {
  
  # Add the resource path for the www directory
  addResourcePath("www", "www")
  
  # Summarize data for the Overview tab
  output$aboutData <- renderText({
    "Context:
    Music therapy, or MT, is the use of music to improve an individual's stress, mood, and overall mental health. 
    MT is also recognized as an evidence-based practice, using music as a catalyst for 'happy' hormones such as oxytocin."
  })
  
  # Box plot for the Demographics tab
  output$boxPlot <- renderPlot({
    ggplot(data, aes_string(x = "`Primary streaming service`", y = input$variable)) +
      geom_boxplot() +
      xlab("`Streaming Service`") + ylab(input$variable) +
      theme_bw()
  })
  
  # Bar plot for the Genre Preference tab
  output$barPlot <- renderPlot({
    ggplot(data, aes(x = `Fav genre`)) +
      geom_bar() +
      theme_bw()
  })
  
  # Violin plot for the Mental Health tab
  output$violinPlot <- renderPlot({
    ggplot(data, aes_string(x = "`Primary streaming service`", y = '`Hours per day`')) +
      geom_violin() +
      facet_wrap(~ `Music effects`) +
      xlab("`Streaming Service`") + ylab("`Hours per day`") +
      theme_bw()
  })
  
  # Function to filter data based on selected genre
  filterData <- reactive({
    if (!is.null(input$genre) && input$genre != "") {
      filtered_data <- data[data$`Fav genre` == input$genre, ]
    } else {
      filtered_data <- data
    }
    filtered_data
  })
  
  # Plot for Music and Mood tab
  output$moodPlot <- renderPlot({
    filtered_data <- filterData()
    
    # Calculate the count of each mood effect for each genre
    mood_counts <- table(filtered_data$`Music effects`)
    
    # Convert the table to a data frame
    mood_data <- as.data.frame(mood_counts)
    
    # Rename the columns
    colnames(mood_data) <- c("Mood", "Count")
    
    # Order the moods to prioritize improvement, no effect, and worsening
    mood_data$Mood <- factor(mood_data$Mood, levels = c("Improve", "No effect", "Worsen"))
    
    # Create the plot
    ggplot(mood_data, aes(x = Mood, y = Count, fill = Mood)) +
      geom_col(position = "dodge") +
      theme_bw() +
      labs(title = paste("Effect of", input$genre, "on Mood"),
           x = "Mood",
           y = "Count", 
           fill = "Mood") +
      theme(axis.title.x = element_text(angle = 45, hjust = 1))
  })
})