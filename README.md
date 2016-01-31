# run_analysis.R CodeBook

### *** Execution Sample ***
scrub.data()

The above command runs the analysis.

### *** Variable & Function descriptions ***
The "scrub.data()" function is the main driver for this R script.
It first calls "download.data()" which will fetch new data if there's 
no local cache of already downloaded data. 

The next step calls "mergedData <- merge.datasets()" which merges 
training and test datasets together.

The next step calls "cx <- extract.mean.std(mergedData$x)" which 
extracts the mean and standard deviation into.

The next step calls "cy <- name.activities(mergedData$y)" which
applies proper names to the activities.

The next step calls "combinedData <- combine.data(cx, cy, mergedData$subject)"
which combines the data frames.

The next step creates the scrubbed data "cleanData <- create.clean.dataset(combinedData)".
then writes it to an output file "UCI_HAR_CleanData.csv" in the working directory.


