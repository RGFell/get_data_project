# get_data_project
Repository for the project assignment for the Getting and Cleaning Data Course from the Coursera Data Science Specialization 



```R
address <- "https://s3.amazonaws.com/coursera-uploads/user-4b3867938524790c458319eb/973499/asst-3/1a71c9c0cd9a11e4b8381b8ddf9f86ee.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) 
View(data)
```
