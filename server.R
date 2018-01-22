
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)

shinyServer(function(input, output) {
  
  format_state_name <- function(state) {
    tolower(state) %>% stringr::str_replace_all(" ", "_")
  }

  output$income_distro  <- renderImage({
    filename <- normalizePath(
      file.path("./gifs", paste0(format_state_name(input$state_input), ".gif"))
    )
    list(src = filename, width = "600px")
  }, deleteFile = FALSE)

})
