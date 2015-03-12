# Define file locations
fxtrain<-".\\train\\X_train.txt"
fytrain<-".\\train\\Y_train.txt"
fstrain<-".\\train\\subject_train.txt"
fytest<-".\\test\\Y_test.txt"
fxtest<-".\\test\\X_test.txt"
fstest<-".\\test\\subject_test.txt"
flabels<-".\\activity_labels.txt"
ffeatures<-".\\features.txt"
fsummary<-".\\summary.txt"

# Read names of activities and features
labels<-read.table(flabels)
features<-read.table(ffeatures)

# read training data
xtrain<-read.table(fxtrain,header=FALSE)
ytrain<-read.table(fytrain,header=FALSE)
strain<-read.table(fstrain,header=FALSE)
names(strain)<-c("Subject")

# Since feature names are not unbique (there are only 477 unique names among 561 features),
#   produce unique names by concatenating auto-generated V<i> with the name   
uniquefeatures<-paste(names(xtrain), features$V2, sep="-")
names(xtrain)<-uniquefeatures

# Join row activity labels with activity names (by activity code) 
#   add textual activity labels and subject indexes to the training data rows
y<-merge(ytrain,labels,sort=FALSE)
xtrain$Activity<-y$V2
xtrain$Subject<-strain$Subject

# read test data
xtest<-read.table(fxtest,header=FALSE)
ytest<-read.table(fytest,header=FALSE)
stest<-read.table(fstest,header=FALSE)
names(stest)<-c("Subject")

# Produce unique feature names by concatenating auto-generated V<i> with the name 
uniquefeatures<-paste(names(xtest), features$V2, sep="-")
names(xtest)<-uniquefeatures

# Join row activity labels with activity names (by activity code) 
#   add textual activity labels and subject indexes to the test data rows
y<-merge(ytest,labels,sort=FALSE)
xtest$Activity<-y$V2
xtest$Subject<-stest$Subject

# Now we have 2 ready data frames for learning / validation
#... 
#    ... here goes real training / testing...
#...

# Combine training and test data frames into one 
xall<-rbind(xtrain,xtest)

# Calculate mean and average as requested in step 2
res2<-apply(xall[1:561], 2, function(x) c(mean(x), sd(x)))
row.names(res2)<-c("mean", "std")

# Calculate and write  summary data set as requested in step 5
res5<-aggregate(xall[1:561], xall[562:563], FUN=mean)
names(res5)[1]<-"Activity"
names(res5)[2]<-"Subject"
if (file.exists(fsummary))
{
    file.remove(fsummary);
}
write.table(res5, fsummary, sep=" ", row.names = FALSE)
# end...
