source("http://bioconductor.org/biocLite.R")
biocLite("EBImage")
library(EBImage)
library(keras) 
library(tensorflow)
library(plyr)
use_condaenv("r-tensorflow")library(yaml)

# We'll Read in images
setwd("C:/"/Processed to JPEG/JPEG/Visible light images")

#UV pics
UV_pics<-c('1444_1_UV.jpg','1445_8_UV.jpg','1449_8_UV.jpg','1457_5_UV.jpg','1464_1_UV.jpg','1464_5_UV.jpg','1475_0_UV.jpg','1501_0_UV.jpg','1519_0_UV.jpg','1533_3_UV.jpg','1536_6_UV.jpg','1537_9_UV.jpg','1538_5_UV.jpg','1539_5_UV.jpg','1542_0_UV.jpg','1542_4_UV.jpg','1544_0_UV.jpg','1552_5_UV.jpg','1566_8_UV.jpg','1579_1_UV.jpg','1583_0_UV.jpg')

#Visible Light 
picsvislight_pics<- c ('SAND_1444_1_vislig.jpg','SAND_1445_8_vislig.jpg','SAND_1449_8_vislig.jpg','SAND_1457_5_vislig.jpg','SAND_1464_1_vislig.jpg','SAND_1464_5_vislig.jpg','SAND_1475_0_vislig.jpg','SAND_1501_0_vislig.jpg','SAND_1519_0_vislig.jpg',                  'SILT_1533_3_vislig.jpg','SILT_1536_6_vislig.jpg','SILT_1537_9_vislig.jpg','SILT_1538_5_vislig.jpg','SILT_1539_5_vislig.jpg','SILT_1542_0_vislig.jpg','SILT_1542_4_vislig.jpg','SILT_1543_6_vislig.jpg','SILT_1544_0_vislig.jpg','SILT_1552_5_vislig.jpg','SILT_1566_8_vislig.jpg','SILT_1579_1_vislig.jpg','SILT_1583_0_vislig.jpg')

#Recognition of UV Pics
mypic <- list()for(i in 1:22){mypic[[i]]<-readImage(vislight_pics[i])}mypic

#Exploring The Imported Pics
print(mypic[[1]])display(mypic[[1]])summary(mypic[[1]])hist(mypic[[1]])str(mypic[1:4])

#Resize Image To Have Same Dimensions
for(i in 1:22 ){mypic[[i]] <- resize(mypic[[i]],28,28)}str(mypic[1:4])

#Convert Images Into Matrices By Reshaping(Take 28x28x3 Into Single Dimension 2,352)for (i in 1:22) {mypic[[i]] <- array_reshape(mypic[[i]],c(28,28,3)) }str(mypic)  #take note to the difference of structure after Reshaping

#Combine Data Into One Using Rowbindtrainx <- NULLfor(i in 1:6){trainx <- rbind(trainx, mypic[[i]])}str(trainx)
testx<-NULLtestx <- rbind(mypic[[7]],mypic[[8]],mypic[[9]],mypic[[19]],mypic[[20]],mypic[[21]],mypic[[22]])str(testx)#We'll Represent Train By: Not Shale=0, Shale=1    trainy <-c(0,0,0,0,0,0,1,1,1,1,1,1,1,1,1)testy <- c(0,0,0,1,1,1,1)

#One Hot Encoding Process Which Converts Categorical Varibles Into A Form That# Could Be Provided to ML Algorithms To do a Better Job In PredictiontrainLabels <- to_categorical(trainy)testLabels <- to_categorical(testy)

#Creating The Modelmodel <- keras_model_sequential()model %>%  #Fully Connected Nueral Networks; 'relu' is most famous activation function  layer_dense(units = 256, activation = 'relu', input_shape =c(2352) ) %>%  layer_dense(units = 128, activation = 'relu')%>%  layer_dense(units = 2, activation = 'softmax')summary(model)

#Compile the Modelmodel %>%    compile(loss = 'binary_crossentropy',            optimizer =optimizer_rmsprop(),            metrics = c('accuracy'))

# Fit Modelhistory <- model %>%        fit(trainx,            trainLabels,            epochs = 30,            batch_size= 32,            validation_split = 0.2) # 20% of data used for validation        plot(history)        # Model Evaluation & Prediction -train data        model %>% evaluate(trainx, trainLabels)                #accuracy will be shown in the form of $acc after this step        pred<- model %>% predict_classes(trainx)

#Create Confusion Matrixtable(Predicted=pred, Actual= trainy)
prob <- model %>% predict_proba(trainx)
#Column Bind The Probality Resultscbind(prob, Predicted = pred, Actual = trainy)
