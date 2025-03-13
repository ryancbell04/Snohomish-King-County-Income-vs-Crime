# Load datasets
king_data <- read_excel("king.xlsx")
snoh_data <- read_excel("snoh.xlsx")
income_data <- read_excel("median_household_income_estimates.xlsx")

# Check column names
print(names(king_data))
print(names(snoh_data))
print(names(income_data))  # See the actual column names

# Standardize column names for merging
colnames(income_data) <- tolower(colnames(income_data))  # Convert to lowercase for consistency
colnames(data) <- tolower(colnames(data)) 

# Rename columns in income_data if necessary (adjust these as needed)
income_data <- income_data %>%
  rename(County = `your_county_column_name`, Year = `your_year_column_name`)

# Merge datasets
data <- left_join(data, income_data, by = c("County", "Year"))
