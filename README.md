# get_data_project
Repository for the project assignment for the Getting and Cleaning Data Course from the Coursera Data Science Specialization 

Pointers for the readmeFile

1. The raw data.
2. A tidy data set
3. A code book describing each variable and its values in the tidy data set.
4. An explicit and exact recipe you used to go from 1 -> 2,3


```R
address <- "https://s3.amazonaws.com/coursera-uploads/user-4b3867938524790c458319eb/973499/asst-3/1a71c9c0cd9a11e4b8381b8ddf9f86ee.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) 
View(data)
```
