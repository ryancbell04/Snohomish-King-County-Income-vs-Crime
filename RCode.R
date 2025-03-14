library(readxl)
library(dplyr)
library(tidyr)
library(writexl)

# Load datasets
crime_df <- read_excel("merged_crime_data.xlsx", sheet = "Sheet1")
income_df <- read_excel("medianhousehold.xlsx", sheet = "Prelim2023Proj2024 (PV)(Final)")

# Clean income dataset
income_df_cleaned <- income_df[-(1:2), ]  # Remove metadata rows
colnames(income_df_cleaned) <- c("County", as.character(income_df_cleaned[1, -1]))  # Set proper column names
income_df_cleaned <- income_df_cleaned[-1, ]  # Remove duplicate header row

# Convert to long format (County, Year, Median_Income)
income_long <- income_df_cleaned %>%
  pivot_longer(cols = -County, names_to = "Year", values_to = "Median_Income") %>%
  mutate(Year = as.numeric(Year),
         Median_Income = as.numeric(Median_Income))

# Reshape crime dataset
crime_long <- crime_df %>%
  pivot_longer(cols = -c(Category, Year), names_to = "County", values_to = "Crime_Count") %>%
  mutate(County = recode(County, 
                         "King County" = "King",
                         "Snohomish County" = "Snohomish"))

# Merge datasets
merged_df <- left_join(crime_long, income_long, by = c("Year", "County"))

# Save merged dataset
write_xlsx(merged_df, "merged_dataset.xlsx")
