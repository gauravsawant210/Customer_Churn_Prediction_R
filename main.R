# Telecom Churn Analysis

# Read Library

library(plyr)  
library(rpart.plot) 
library(caret)
library(gridExtra) 
library(tidyverse) 
library(rsample)
library(e1071) 
library(GGally)
library(data.table)
library(DT)
library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)
library(corrplot)
library(rms)
library(MASS)
library(e1071)
library(ROCR)
library(gplots)
library(pROC)
library(rpart)
library(randomForest)
library(ggpubr)



#Read data file
churn <- read.csv("WA_Fn-UseC_-Telco-Customer-Churn.csv")
head(churn)


#Data preprocessing
sapply(churn, function(x) sum(is.na(x)))
churn[is.na(churn$TotalCharges),]
sum(is.na(churn$TotalCharges))/nrow(churn)

churn_clean <- churn[complete.cases(churn), ]

churn_clean$SeniorCitizen <- as.factor(mapvalues(churn_clean$SeniorCitizen,
                                                 from=c("0","1"),
                                                 to=c("No", "Yes")))
churn_clean$MultipleLines <- as.factor(mapvalues(churn_clean$MultipleLines,from=c("No phone service"),
                                                 to=c("No")))
for(i in 10:15){
  churn_clean[,i] <- as.factor(mapvalues(churn_clean[,i],from= c("No internet service"), to= c("No")))
}
churn_clean$customerID <- NULL


#Data visualization
#Gender plot
gender_p <- ggplot(churn_clean, aes(x=gender,fill=Churn))+ geom_bar( show.legend = FALSE) +scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))+ theme_minimal()

#Senior citizen plot
SeniorCitizen_p <- ggplot(churn_clean, aes(x=SeniorCitizen,fill=Churn))+ geom_bar(show.legend = TRUE) +scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))+ theme_minimal()

#Dependents plot
dependents_p <- ggplot(churn_clean, aes(x=Dependents,fill=Churn))+ geom_bar(show.legend = FALSE) +scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))+ theme_minimal()

#Partner plot
partner_p <- ggplot(churn_clean, aes(x=Partner,fill=Churn))+ geom_bar(show.legend = TRUE) +scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))+ theme_minimal()

options(repr.plot.width=8, repr.plot.height=6)
grid.arrange (gender_p,SeniorCitizen_p,dependents_p,partner_p, ncol=2)

#Observing the demographic plots, we can see that the sample shows an even distribution across gender and partner status. 
#Senior citizens and individuals with dependents constitute a minority within the sample.

#internet service breakdown
onlinesecurity_p <- ggplot(subset(churn_clean, OnlineSecurity %in% c("No","Yes")), aes(x=OnlineSecurity,fill=Churn))+ geom_bar( show.legend = FALSE) + theme_minimal()+ scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))

onlinebackup_p <- ggplot(subset(churn_clean, OnlineBackup %in% c("No","Yes")), aes(x=OnlineBackup,fill=Churn))+ geom_bar( show.legend = FALSE) + theme_minimal()+ scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))

deviceprotection_p <- ggplot(subset(churn_clean, DeviceProtection %in% c("No","Yes")), aes(x=DeviceProtection,fill=Churn))+ geom_bar( show.legend = TRUE) + theme_minimal()+ scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))

techsupport_p <- ggplot(subset(churn_clean, TechSupport %in% c("No","Yes")), aes(x=TechSupport,fill=Churn))+ geom_bar( show.legend = FALSE) + theme_minimal()+ scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))

streaming_tv_p <- ggplot(subset(churn_clean, StreamingTV %in% c("No","Yes")), aes(x=StreamingTV,fill=Churn))+ geom_bar( show.legend = FALSE) + theme_minimal()+ scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))

streaming_movies_p <- ggplot(subset(churn_clean, StreamingMovies %in% c("No","Yes")), aes(x=StreamingMovies,fill=Churn))+ geom_bar( show.legend = TRUE) + theme_minimal()+ scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))

options(repr.plot.width=8, repr.plot.height=5)
grid.arrange(onlinesecurity_p,onlinebackup_p,deviceprotection_p,techsupport_p,streaming_tv_p,streaming_movies_p, ncol=3)


#tenure vs average total charge breakdown by churn
month <- ggplot(subset(churn_clean, Contract %in% c("Month-to-month")),aes(x = tenure, color=Churn)) + geom_freqpoly(size=2) + theme_minimal() + labs(title="Month to month", x = "Tenure(month)")+scale_color_manual(values = c("Yes"="#E69F00", "No"="#71706e"))
one_year <- ggplot(subset(churn_clean, Contract %in% c("One year")),aes(x = tenure, color=Churn)) + geom_freqpoly(size=2) + theme_minimal() + labs(title="One year", x = "Tenure(month)")+scale_color_manual(values = c("Yes"="#E69F00", "No"="#71706e"))
two_year <- ggplot(subset(churn_clean, Contract %in% c("Two year")),aes(x = tenure, color=Churn)) + geom_freqpoly(size=2) + theme_minimal() + labs(title="Two year", x = "Tenure(month)")+scale_color_manual(values = c("Yes"="#E69F00", "No"="#71706e"))
grid.arrange(month,
             one_year,
             two_year)
#The analysis reveals that a significant number of monthly contract customers tend to churn from the company during the initial months, 
#with a decline in churn as the tenure progresses. However, for longer contract periods, customers exhibit higher loyalty and are less likely 
#to churn from the company.


ggplot(data = churn_clean) + 
  geom_line(aes(x=tenure, y=MonthlyCharges, color=Churn),lwd=2, stat="summary",fun="mean")+labs(title="Tenure vs average monthly charge",x = "Tenure(month)",y="average monthly charge")+scale_color_manual(values = c("Yes"="#E69F00", "No"="#71706e"))+theme_minimal()

churn_plot <- ggplot(churn_clean, aes(x = Churn)) + theme_minimal()+ scale_fill_manual(values = c("Yes"="#E69F00", "No"="#71706e"))+
  geom_bar(aes(fill = Churn)) +
  geom_text(aes(y = ..count.. -200, 
                label = paste0(round(prop.table(..count..),4) * 100, '%')), 
            stat = 'count', 
            position = position_dodge(.1), 
            size = 3)
churn_plot+ggtitle("Churn distribution") +
  xlab("Churn") + ylab("Count")

set.seed(56)
split_train_test <- createDataPartition(churn_clean$Churn,p=0.7,list=FALSE)
dtrain<- churn_clean[split_train_test,]
dtest<-  churn_clean[-split_train_test,]


#Statistical modeling

#Decission tree
tr_fit <- rpart(Churn ~., data = dtrain, method="class")
rpart.plot(tr_fit)

tr_prob1 <- predict(tr_fit, dtest)
tr_pred1 <- ifelse(tr_prob1[,2] > 0.5,"Yes","No")
table(Predicted = tr_pred1, Actual = dtest$Churn)


tr_prob2 <- predict(tr_fit, dtrain)
tr_pred2 <- ifelse(tr_prob2[,2] > 0.5,"Yes","No")
tr_tab1 <- table(Predicted = tr_pred2, Actual = dtrain$Churn)
tr_tab2 <- table(Predicted = tr_pred1, Actual = dtest$Churn)

# Train
confusionMatrix(
  as.factor(tr_pred2),
  as.factor(dtrain$Churn),
  positive = "Yes" 
)

# Test
confusionMatrix(
  as.factor(tr_pred1),
  as.factor(dtest$Churn),
  positive = "Yes",mode = "everything"  
)

tr_acc <- sum(diag(tr_tab2))/sum(tr_tab2)
tr_acc



#2) RandomForest
#Set control parameters for random forest model selection
ctrl <- trainControl(method = "cv", number=5, 
                     classProbs = TRUE, summaryFunction = twoClassSummary)

#Exploratory random forest model selection
 rf_fit1 <- train(Churn ~., data = dtrain,
                  method = "rf",
                  ntree = 75,
                  tuneLength = 5,
                  metric = "ROC",
                  trControl = ctrl)

 saveRDS(rf_fit1, "Churn.RDS")

rf_fit1 <- readRDS("Churn.RDS")


#Run optimal model
rf_fit2 <-randomForest(as.factor(Churn)~.,data = dtrain,ntree = 75,mtry = 2, 
                             importance = TRUE, proximity = TRUE)


#Display variable importance from random tree
varImpPlot(rf_fit2, sort=T, n.var = 10, 
           main = 'Top 10 important variables')

rf_pred1 <- predict(rf_fit2, dtest)
table(Predicted = rf_pred1, Actual = dtest$Churn)

plot(rf_fit2)

rf_pred2 <- predict(rf_fit2, dtrain)
rf_tab1 <- table(Predicted = rf_pred2, Actual = dtrain$Churn)
rf_tab2 <- table(Predicted = rf_pred1, Actual = dtest$Churn)

# Train
confusionMatrix(
  as.factor(rf_pred2),
  as.factor(dtrain$Churn),
  positive = "Yes" 
)


# Test
confusionMatrix(
  as.factor(rf_pred1),
  as.factor(dtest$Churn),
  positive = "Yes" ,mode = "everything" 
)

rf_acc <- sum(diag(rf_tab2))/sum(rf_tab2)
rf_acc



#3) Logistic
lr_fit <- glm(as.factor(Churn)~., data = dtrain,
              family=binomial(link='logit'))
summary(lr_fit)


lr_prob1 <- predict(lr_fit, dtest, type="response")
lr_pred1 <- ifelse(lr_prob1 > 0.5,"Yes","No")
table(Predicted = lr_pred1, Actual = dtest$Churn)


lr_prob2 <- predict(lr_fit, dtrain, type="response")
lr_pred2 <- ifelse(lr_prob2 > 0.5,"Yes","No")
lr_tab1 <- table(Predicted = lr_pred2, Actual = dtrain$Churn)
lr_tab2 <- table(Predicted = lr_pred1, Actual = dtest$Churn)

# Train
confusionMatrix(
  as.factor(lr_pred2),
  as.factor(dtrain$Churn),
  positive = "Yes" 
)

# Test
confusionMatrix(
  as.factor(lr_pred1),
  as.factor(dtest$Churn),
  positive = "Yes",mode = "everything" 
)

lr_acc <- sum(diag(lr_tab2))/sum(lr_tab2)
lr_acc

