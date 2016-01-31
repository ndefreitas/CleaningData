# CleaningData
### *** Usage Instructions ***
scrub.data()

The "scrub.data()" function is the main driver for this R script.
It first calls "download.data()" which will fetch new data if there's 
no local cache of already downloaded data. 

The next step calls "mergedData <- merge.datasets()" which merges 
training and test datasets together.

The next step calls "cx <- extract.mean.std(mergedData$x)" which 
extracts the mean and standard deviation into.

The next step calls "cy <- name.activities(mergedData$y)" which
applies proper names to the activities.

