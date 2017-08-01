library(shiny)
library(rgl)

# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("Gail vs. Tyrer-Cuzick vs. BCSC Risk Percentages"),
  
  # Show a plot of the generated distribution
  mainPanel(
    rglwidgetOutput("thewidget1")
  )
)

library(readr)
br_cancer <- read_csv("all_covariates_and_scores.csv")

options(rgl.useNULL = TRUE)

server <- function(input, output, session) {
  br_cancer$pcolor[br_cancer$Race == 1] <- "maroon4" #White
  br_cancer$pcolor[br_cancer$Race == 3] <- "hotpink" #Hispanic
  br_cancer$pcolor[br_cancer$Race >= 6] <- "orange" #Asian
  open3d()

  plot3d(br_cancer$GailRisk, br_cancer$TCRisk, br_cancer$BCSC_Score_5_year,        # x y and z axis
         col=br_cancer$pcolor, 
         type = "p",        # circle color indicates no. of cylinders
         scale.y=.75,                 # scale y axis (reduce by 25%)
         #main="Gail vs. Tyrer-Cuzick vs. BCSC Risk Percentages",
         xlab="Gail Risk",
         ylab="TC Risk",
         zlab="BCSC Risk")
  abclines3d(x = 0.358323963,a = 0.56444786 ,b= 0.56444786 + 0.121427149,c= 0.56444786,col = "red")
  scene1 <- scene3d()
  rgl.close()
  
  save <- options(rgl.inShiny = TRUE)
  on.exit(options(save))
  
  output$thewidget1 <- renderRglwidget(rglwidget(scene1))
}

# Run the application 
shinyApp(ui = ui, server = server)