# California Housing Price Prediction

A machine learning project that predicts California housing prices using a Random Forest model in R. This project demonstrates end-to-end data science workflow including data cleaning, feature engineering, exploratory data analysis (EDA), and model evaluation.

---

##  Overview

This project uses the California Housing dataset to build a predictive model for estimating median house values across census block groups.

The model achieves a stable prediction error of approximately **$48,310 RMSE**, showing strong generalization to unseen data.

---

##  Objective

- Predict median house values using demographic, geographic, and housing features
- Apply data science techniques learned in coursework to a real-world dataset
- Evaluate model performance using RMSE and generalization metrics

---

##  Dataset

- Source: California Housing Dataset (1990 Census)
- Observations: 20,640 census block groups
- Features: 9 numerical + 1 categorical variable
- Missing Values: 207 (in `total_bedrooms`)

Key variables include:
- `median_income`
- `latitude`, `longitude`
- `housing_median_age`
- `population`, `households`
- `ocean_proximity` (categorical)

---

##  Exploratory Data Analysis

Key insights from EDA:

- Median income is the strongest predictor of housing prices
- Coastal properties ("NEAR OCEAN", "ISLAND") have significantly higher values
- Strong multicollinearity exists among total counts (rooms, bedrooms, population)
- Data distributions show right skew and presence of outliers

Visualizations include:
- Histograms of all numeric variables
- Boxplots for outlier detection
- Geographic comparisons by ocean proximity

---

##  Data Processing

### Data Cleaning
- Imputed 207 missing values in `total_bedrooms` using median

### Feature Engineering
- Created:
  - `mean_rooms` (rooms per household)
  - `mean_bedrooms` (bedrooms per household)

### Encoding
- One-hot encoded `ocean_proximity`

### Scaling
- Standardized numeric variables (mean = 0, sd = 1)

### Feature Selection
- Removed redundant variables to reduce multicollinearity

---

##  Model

### Algorithm
- Random Forest (R `randomForest` package)
- 500 trees (`ntree = 500`)

### Why Random Forest?
- Handles non-linear relationships
- Reduces overfitting via ensemble learning
- Provides feature importance insights

---

##  Model Performance

| Metric            | Value        |
|------------------|-------------|
| Training RMSE     | ~$49,603    |
| Test RMSE         | ~$48,310    |
| Performance Delta | -2.61%      |

### Key Takeaways:
- Model generalizes well (no overfitting)
- Stable performance on unseen data
- High reliability for real-world prediction

---

##  Key Insights

- **Median Income** is the strongest predictor
- **Geographic location (lat/long)** plays a major role
- Coastal proximity significantly increases property value
- Engineered features improved model performance

---

##  What I Learned

- How to build a full machine learning pipeline in R
- Importance of feature engineering over raw data
- Handling missing data and multicollinearity
- Evaluating model robustness using RMSE comparison
- Translating technical results into business insights

---

##  How to Run

1. Clone this repository:
```bash
git clone https://github.com/yourusername/california-housing-price-prediction.git
