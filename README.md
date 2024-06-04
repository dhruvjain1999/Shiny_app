link: https://dhruvjain.shinyapps.io/Shiny_project/


<br>

Here's a sample README file for your project. It includes sections for project title, description, installation instructions, usage instructions, contribution guidelines, and license information. You can modify it as per your needs.

```markdown
# Satellite Data Analysis Shiny App

## Project Description

This project is a Shiny application for analyzing satellite data. The application allows users to visualize various aspects of satellites in orbit around Earth using interactive plots and summaries. The data used in this project is sourced from the [Active Satellites in Orbit Around Earth](https://www.kaggle.com/datasets/ucsusa/active-satellites?datasetId=744) dataset on Kaggle.

## Installation Instructions

To run this project, you'll need to have R and RStudio installed on your computer. You can install the required packages using the following R script:

```r
# Install necessary packages
install.packages(c("shiny", "shinyWidgets", "tidyverse", "scatterplot3d",
                   "datasets", "dbplyr", "ggplot2", "dplyr", "tibble", "data.table",
                   "ggmosaic", "ggforce", "ggmap", "ggthemes", "purrr",
                   "keep", "readr", "maps", "mapproj", "tmap", "leaflet", "sf",
                   "tidyr", "DT", "rnaturalearth", "rnaturalearthdata", "lwgeom",
                   "geos", "ggspatial", "plotly", "shinydashboard", "htmlwidgets",
                   "wordcloud2", "ggplot2", "MASS", "htmlwidgets"))
```

Then, clone this repository and run the `app.R` script in RStudio.

## Usage Instructions

1. **Load the Data:**
    ```r
    data <- read_csv('Active_Satellites_in_Orbit_Around_Earth.csv')
    ```

2. **Clean the Data:**
    ```r
    # Replace NA values with "unknown"
    satellite$`Type of Orbit` <- ifelse(is.na(satellite$`Type of Orbit`), "unknown", satellite$`Type of Orbit`)

    # Remove non-numeric characters and impute missing values
    satellite$`Dry Mass (Kilograms)` <- as.numeric(gsub("[^0-9]", "", satellite$`Dry Mass (Kilograms)`))
    satellite$`Launch Mass (Kilograms)`[is.na(satellite$`Launch Mass (Kilograms)`)] <- median(satellite$`Launch Mass (Kilograms)`, na.rm = TRUE)
    satellite$`Dry Mass (Kilograms)`[is.na(satellite$`Dry Mass (Kilograms)`)] <- median(satellite$`Dry Mass (Kilograms)`, na.rm = TRUE)
    satellite$`Expected Lifetime (Years)` <- as.numeric(gsub("[^0-9]", "", satellite$`Expected Lifetime (Years)`))
    satellite$`Expected Lifetime (Years)`[is.na(satellite$`Expected Lifetime (Years)`)] <- mean(satellite$`Expected Lifetime (Years)`, na.rm = TRUE)
    satellite <- na.omit(satellite)

    # Separate date into day, month, and year
    satellite <- separate(satellite, col = `Date of Launch`, into = c("month", "day", "year"), sep = "/")
    ```

3. **Run the Shiny App:**
    ```r
    # Define UI and server in app.R script
    shinyApp(ui = ui, server = server)
    ```

## Shiny App Features

- **Plot 1:** Displays a polar bar plot of the maximum count of satellites by country.
- **Plot 2:** Pie chart showing the count of users in India.
- **Plot 3:** Bar plot showing the count of users by country and year.
- **Plot 4:** Scatter plot of perigee and apogee distances colored by the country of contractor.
- **Summary:** Displays a summary and the first 10 rows of the satellite dataset.

## Contribution Guidelines

Contributions are welcome! Please fork the repository and create a pull request with your changes. Make sure to follow the existing coding style and include tests for any new features or bug fixes.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Credits

Credit for the code goes to Dhruv Jain.

## Important Links

- Source Link: [Kaggle Dataset](https://www.kaggle.com/datasets/ucsusa/active-satellites?datasetId=744)

```

Feel free to customize any sections as needed!
