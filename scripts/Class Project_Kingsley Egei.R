#Kingsley Egei Final Proj

#1. Access the Data Set 
housing <- read.csv("/Users/kings/Downloads/housing.csv")
housing$ocean_proximity <- as.factor(housing$ocean_proximity) #converting to Factor
levels(housing$ocean_proximity) # Display levels

# > levels(housing$ocean_proximity) # Display levels
# [1] "<1H OCEAN"  "INLAND"     "ISLAND"     "NEAR BAY"   "NEAR OCEAN"


# 2. EDA and Data Visualization 
head(housing)
tail(housing) 
summary(housing) #total bedroom has 207 NAs

housing_numeric <- housing[, sapply(housing, is.numeric)] #Cor can only work with numeric
str(housing_numeric) #confirming all numeric
print(colSums(is.na(housing_numeric))) #once again confirming Total bedrooms has NAs
cor_matrix <- cor(housing_numeric, use = "complete.obs") #correlation analysis $ removed NAs from Total bedrooms

#part D
par(mfrow = c(3, 3), mar = c(4, 4, 2, 1)) #setting up plot and playing with Margins
for(i in 1:ncol(housing_numeric)) {
  hist(housing_numeric[, i],
       main = paste("Histogram of", names(housing_numeric)[i]),
       xlab = names(housing_numeric)[i],
       col = "steelblue",
       breaks = 30)
}
par(mfrow = c(1, 1))

#part E
par(mfrow = c(3, 3), mar = c(4, 8, 3, 1))
for(i in 1:ncol(housing_numeric)) {
  boxplot(housing_numeric[, i],
          main = names(housing_numeric)[i],
          xlab = names(housing_numeric)[i],
          horizontal = TRUE,
          col = "purple",
          border = "darkblue",
          las = 1)
  points(mean(housing_numeric[, i], na.rm = TRUE), 1,  # Add mean point
         pch = 19, col = "yellow", cex = 1.5)
}
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2))

#Part F
#can use housing data, now instead of housing numeric
colors()
ocean_colors <- c("dodgerblue", "palegreen2", "gold", "tomato1", "orchid2")
par(mfrow = c(1, 3), mar = c(8, 4, 4, 2)) # Set up 3-panel plot with margins

boxplot(housing_median_age ~ ocean_proximity,                                   # 1. Housing Median Age
        data = housing,
        main = "Housing Median Age by Ocean Proximity",
        xlab = "",
        ylab = "Median Age (years)",
        col = ocean_colors,
        border = "black",
        las = 2,
        cex.axis = 0.8,
        cex.main = 1)

boxplot(median_income ~ ocean_proximity,                                        # 2. Median Income
        data = housing,
        main = "Median Income by Ocean Proximity",
        xlab = "",
        ylab = "Median Income ($10,000s)",
        col = ocean_colors,
        border = "black",
        las = 2,
        cex.axis = 0.8,
        cex.main = 1)

boxplot(median_house_value ~ ocean_proximity,                                   # 3. Median House Value
        data = housing,
        main = "Median House Value by Ocean Proximity",
        xlab = "",
        ylab = "Median House Value ($)",
        col = ocean_colors,
        border = "black",
        las = 2,
        cex.axis = 0.8,
        cex.main = 1)

par(mfrow = c(1, 1), mar = c(5, 4, 4, 2))  # Reset


# 3. Data Transformation 

#part A
summary(housing)
sum(is.na(housing$total_bedrooms)) #we know there are 207 NA that need imputation
# Calculate median (excluding NAs)
median_bedrooms <- median(housing$total_bedrooms, na.rm = TRUE) #using total bedrooms we calculate median and us na.rm = TRUE
median_bedrooms
housing$total_bedrooms[is.na(housing$total_bedrooms)] <- median_bedrooms #Impute anything that is na in total bedroom to equal the median
sum(is.na(housing$total_bedrooms)) #verify imputation


#part B
print(levels(housing$ocean_proximity))
ocean_dummies <- model.matrix(~ ocean_proximity - 1, data = housing) #cool code
ocean_df <- as.data.frame(ocean_dummies) #converted to a date frame
names(ocean_df) <- gsub("ocean_proximity", "", names(ocean_df)) # Rename columns to match required names
housing <- cbind(housing, ocean_df) # add back to housing data
housing$ocean_proximity <- NULL # Remove original variable


#Part C
housing$mean_bedrooms <- housing$total_bedrooms / housing$households #mean_bedrooms (bedrooms per household)
housing$mean_rooms <- housing$total_rooms / housing$households # mean_rooms (rooms per household)
print(summary(housing$mean_bedrooms))
print(summary(housing$mean_rooms))
# for safety if households = 0, Handle any Inf or NaN values (division by zero)
housing$mean_bedrooms[is.infinite(housing$mean_bedrooms) | is.nan(housing$mean_bedrooms)] <- 0
housing$mean_rooms[is.infinite(housing$mean_rooms) | is.nan(housing$mean_rooms)] <- 0
housing$total_bedrooms <- NULL # Remove total_bedrooms and total_rooms
housing$total_rooms <- NULL

#Part D 
# Exclude: median_house_value (the response variable) and binary variables (<1H ocean ~ NEAR OCEAN)
vars_to_scale <- c("longitude", "latitude", "housing_median_age", 
                   "population", "households", "median_income", 
                   "mean_bedrooms", "mean_rooms")
print(vars_to_scale)
# Perform scaling (standardization: mean=0, sd=1), kind of confusing
for(var in vars_to_scale) {
  housing[[var]] <- scale(housing[[var]])
}
# Verify scaling (mean ≈ 0, sd ≈ 1). Verification - means after scaling (should be ≈ 0)
print(round(colMeans(housing[, vars_to_scale]), 10))
#Verification - standard deviations after scaling (should be ≈ 1):\n")
print(apply(housing[, vars_to_scale], 2, sd))


#Part E
# Reorder columns to match required order
cleaned_housing <- housing[, c("NEAR BAY", "<1H OCEAN", "INLAND", "NEAR OCEAN", "ISLAND",
                               "longitude", "latitude", "housing_median_age", 
                               "population", "households", "median_income", 
                               "mean_bedrooms", "mean_rooms", "median_house_value")]

print(names(cleaned_housing))
str(cleaned_housing)
print(head(cleaned_housing))
print(summary(cleaned_housing))



# 4. Create Training and Test Sets 
set.seed(67) 
train_index <- sample(1:nrow(cleaned_housing),   #70 %
                      size = 0.70 * nrow(cleaned_housing))
train <- cleaned_housing[train_index, ] # the 70%
test <- cleaned_housing[-train_index, ] # remaining 30%
#14447 + 6193 = 20640


# 5. Supervised Machine Learning - Regression 
train_x <- subset(train, select = -median_house_value)
train_y <- train$median_house_value #response variable
str(train_x) #validations
ncol(train_x)
ncol(train)
class(train_y)
library(randomForest)
rf <- randomForest(x = train_x, 
                         y = train_y, 
                         ntree = 500,           # Number of trees to grow
                         importance = TRUE)     # Tracks which variables matter most

names(rf)


# 6. Evaluating Model Performance 

#Part A
final_mse_train <- tail(rf$mse, 1) # Extract the final MSE value from the forest
rmse_train <- sqrt(final_mse_train) # Calculate the Square Root to get RMSE
print(paste("Training (OOB) RMSE: ", round(rmse_train, 2)))

#Part B
test_x <- subset(test, select = -median_house_value) # 1. Create test_x (Features only)
test_y <- test$median_house_value # 2. Create test_y (Target vector only)
predicted_values <- predict(rf, newdata = test_x) # 3. Generate predictions using the trained model

#Part C
mse_test <- mean((test_y - predicted_values)^2) # Calculate the Mean Squared Error for the test set
rmse_test <- sqrt(mse_test) # Calculate the Root Mean Squared Error
print(paste("Test Set RMSE: ", round(rmse_test, 2)))


#Part D
rmse_diff <- rmse_test - rmse_train                 # Calculate the absolute difference and the percentage increase
percent_change <- (rmse_diff / rmse_train) * 100
cat("Training RMSE:", round(rmse_train, 2), "\n")   # Print the comparison
cat("Test RMSE:    ", round(rmse_test, 2), "\n")
cat("Difference:   ", round(rmse_diff, 2), "\n")
cat("Percent Incr: ", round(percent_change, 2), "%\n\n")


if (percent_change > 20) {                          # Logic to determine if the model is overfit
  print("Warning: Potential Overfitting. The model performs significantly worse on new data.")
} else if (percent_change < 0) {
  print("Insight: The model performed better on the test set (this is rare and lucky!).")
} else {
  print("Success: The model is robust. Training and Test performance are roughly the same.")
}


#Part E
# Generate the Importance Plot
importance_values <- importance(rf)
print(importance_values)
varImpPlot(rf, 
           main = "Feature Impact Analysis", 
           col = "steelblue", 
           pch = 19)
cat("\n=== COMMENTARY ===\n")
cat("If variables like median_income or longitude/latitude appear at the top, \n") 
cat("it indicates that economic status and geography are the dominant predictors.  \n")  
cat("From a strategic standpoint, if a feature like total_rooms is at the very bottom,  \n") 
cat("you might choose to re-train the model without it. Removing 'noisy' or irrelevant  \n") 
cat("features often simplifies the model, reduces computation time, and can actually  \n") 
cat("improve the Test RMSE by reducing overfitting. \n") 
#part 


 
# 7. Project Report - Complete in a PDF
