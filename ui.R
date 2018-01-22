
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)
library(stringr)

# friendly state labels
states <- list.files("gifs") %>% 
  str_replace_all("\\.gif", "") %>% 
  str_replace_all("_", " ") %>% 
  str_to_title() %>% 
  str_replace(" Of ", " of ")

shinyUI(fluidPage(

  titlePanel("U.S. Income Distributions Over Time"),
  
  p('"Tracing" the distribution (and redistribution) of annual income within each state from 2009 to 2016'),
  br(),
  br(),

  # Sidebar with a slider input for number of bins
  sidebarLayout(

    # controls
    sidebarPanel(
      selectInput(
        "state_input",
        "State",
        states
      )
    ),
    # place for the state's gif
    mainPanel(
      plotOutput("income_distro")
    )
  )
))
