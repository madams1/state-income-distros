require(dplyr)
require(magrittr)
require(ggplot2)
require(gganimate)
require(animation)
require(data.world)

# get data ------------------------------------------------------------------------------------

data_url <- "https://data.world/makeovermonday/2018-w-3-u-s-household-income-distribution-by-state"

## show available datasets
query(qry_sql("SELECT * FROM Tables"), dataset = data_url)

state_income_data <- qry_sql("SELECT * FROM income") %>%
  query(dataset = data_url)

glimpse(state_income_data)

state_income_data %<>%
  filter(state != "Puerto Rico") %>% 
  mutate(
    # ordinal labels for income brackets
    income_level = factor(
      income_level,
      levels = unique(income_level)[c(11, 1:2, 13:14, 4, 12, 15:16, 5:6, 3, 7:9, 10) %>% rev],
      labels = c(
        "< $10K",
        "$10 - 15K",
        "$15 - 20K",
        "$20 - 25K",
        "$25 - 30K",
        "$30 - 35K",
        "$35 - 40K",
        "$40 - 45K",
        "$45 - 50K",
        "$50 - 60K",
        "$60 - 75K",
        "$75 - 100K",
        "$100 - 125K",
        "$125 - 150K",
        "$150 - 200K",
        ">= $200K"
      ) %>% rev
    )
  )

# make animated bars for each state -----------------------------------------------------------

animate_state_incomes <- function(s, font = "Avenir") {
  
  state_level_data <- state_income_data %>% filter(state == s)
  
  p <- ggplot(state_level_data, aes(x = income_level, y = percent_of_total, frame = year)) +
    geom_col(
      position = "identity",
      width = 0.81,
      fill = "dodgerblue3",
      alpha = 0.6
    ) +
    geom_errorbar(
      aes(
        cumulative = TRUE,
        alpha = year,
        x = income_level,
        ymin = percent_of_total,
        ymax = percent_of_total
      ),
      width = 0.775,
      position = "identity",
      color = "dodgerblue4",
      show.legend = FALSE
    ) +
    geom_text(
      aes(label = income_level, y = 0.0015),
      hjust = 0,
      vjust = 0.5,
      color = "white",
      family = font,
      size = 7.5
    ) +
    scale_y_continuous(
      labels = scales::percent,
      breaks = c(0, 0.05, 0.1, 0.15, 0.2),
      limits = c(0, 0.16),
      expand = c(0.02, 0)
    ) +
    labs(
      subtitle = paste0("\nDistribution of Annual Household Income in ", s, "\n"),
      caption = "\nData from U.S. Census Bureau — Matt Adams\n",
      x = "",
      y = "Percentage of Households in Income Bracket"
    ) +
    coord_flip() +
    theme_classic(base_family = font, base_size = 24) +
    theme(
      panel.grid = element_blank(),
      axis.text.y = element_blank(),
      axis.title.x = element_text(size = 24, hjust = 0.02, vjust = 0),
      axis.ticks.y = element_blank(),
      axis.line.y = element_blank(),
      axis.line.x = element_blank(),
      plot.title = element_text(size = 40, hjust = 0),
      plot.caption = element_text(size = 18, color = "#666666", hjust = 0),
      plot.subtitle = element_text(face = "bold", size = 30, hjust = 0)
    )
  
  # create a gif for this state
  formatted_state_name <- tolower(s) %>% stringr::str_replace_all(" ", "_")
  
  gganimate(
    p,
    interval = 0.8,
    verbose = FALSE,
    filename = paste0("./gifs/", formatted_state_name, ".gif"),
    # title_frame = FALSE,
    ani.width = 1100,
    ani.height = 1040
  )
}

# make all the gifs
lapply(
  unique(state_income_data$state) %>% sort,
  animate_state_incomes
)
