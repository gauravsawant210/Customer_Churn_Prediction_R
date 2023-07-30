# Telecommunication Churn Prediction

## Introduction
Customer churn, also known as customer attrition, is the loss of clients or customers. Churn is an important business metric for subscription-based services such as telecommunications companies. This project demonstrates churn analysis using data downloaded from [IBM sample datasets](https://www.kaggle.com/datasets/blastchar/telco-customer-churn). We will use the R statistical programming language to identify variables associated with customer churn.

`Tasks:` [Ref](https://rpubs.com/ezrasote/churn)
1. Load the data and the relevant R libraries.
2. Preprocess the data with various cleaning and recoding techniques.
3. Data visualizations.
4. Fit models using statistical classification methods.
   - Decision tree analysis
   - Random forest analysis
   - Logistic regression
5. Examine additional data visualizations of selected variables based on our modeling techniques.


## Read Data
The dataset used in this project is called "Telco Customer Churn." It contains information about telecommunications customers and whether they have churned or not. The variables in the dataset are as follows:

- customerID: Customer ID
- gender: Customer gender (female, male)
- SeniorCitizen: Whether the customer is a senior citizen or not (1, 0)
- Partner: Whether the customer has a partner or not (Yes, No)
- Dependents: Whether the customer has dependents or not (Yes, No)
- tenure: Number of months the customer has stayed with the company
- PhoneService: Whether the customer has a phone service or not (Yes, No)
- MultipleLines: Whether the customer has multiple lines or not (Yes, No, No phone service)
- InternetService: Customer’s internet service provider (DSL, Fiber optic, No)
- OnlineSecurity: Whether the customer has online security or not (Yes, No, No internet service)
- OnlineBackup: Whether the customer has online backup or not (Yes, No, No internet service)
- DeviceProtection: Whether the customer has device protection or not (Yes, No, No internet service)
- TechSupport: Whether the customer has tech support or not (Yes, No, No internet service)
- StreamingTV: Whether the customer has streaming TV or not (Yes, No, No internet service)
- StreamingMovies: Whether the customer has streaming movies or not (Yes, No, No internet service)
- Contract: The contract term of the customer (Month-to-month, One year, Two years)
- PaperlessBilling: Whether the customer has paperless billing or not (Yes, No)
- PaymentMethod: The customer’s payment method (Electronic check, Mailed check, Bank transfer (automatic), Credit card (automatic))
- MonthlyCharges: The amount charged to the customer monthly
- TotalCharges: The total amount charged to the customer
- Churn: Whether the customer churned or not (Yes or No)

## Data Preprocessing
We perform data preprocessing tasks to clean and recode certain variables for ease of analysis. The steps include:

1. Removing cases with missing values in the "TotalCharges" variable.
2. Recoding the "SeniorCitizen" variable from 0/1 to Yes/No.
3. Recoding the "MultipleLines," "OnlineSecurity," "OnlineBackup," "DeviceProtection," "TechSupport," "StreamingTV," and "StreamingMovies" variables from "No internet service" to "No."
4. Removing the "customerID" variable.


## Data Visualization for Descriptive Statistics
We use various data visualizations to explore descriptive statistics of the data.
- Observing the demographic plots, we can see that the sample shows an even distribution across gender and partner status. Senior citizens and individuals with dependents constitute a minority within the sample.
- The line chart reveals that a significant number of monthly contract customers tend to churn from the company during the initial months, with a decline in churn as the tenure progresses. However, for longer contract periods, customers exhibit higher loyalty and are less likely to churn from the company.


## Modelling
We use three machine learning models for churn prediction: Naive Bayes, Decision Tree, and Random Forest.

1. Decision Tree Analysis: We use the "rpart" library for recursive partitioning methods to build a decision tree that identifies the most important variables related to churn in a hierarchical format.
    - The decision tree model exhibits a reasonable level of accuracy, correctly predicting the churn status of customers in the test subset approximately 79% of the time.
<br>

2. Random Forest Analysis: We use the "randomForest" library to build an ensemble of decision trees to improve the accuracy of predictions.
    - The random forest model shows a slightly higher level of accuracy compared to the decision tree model, achieving an 81.1% correct prediction rate for the churn status of customers in the test subset.
<br>

3. Logistic Regression Analysis: We use logistic regression to model the probability of customer churn based on predictor variables.
    - The logistic regression model exhibits a slightly better performance with an accuracy rate of 81.4%, surpassing both the decision tree and random forest models.

## Conclusion
In conclusion, our analysis has identified important churn predictor variables. Notably, customers with a longer tenure with the company or who have made higher total payments demonstrate lower churn rates. These trends can be attributed to factors such as customer loyalty, switching costs, and incentives for long-term customers.

These valuable findings can empower telecommunication companies to better understand and predict customer churn. By proactively addressing potential churn risks and making strategic improvements to their services, companies can effectively retain customers and foster improved customer satisfaction.