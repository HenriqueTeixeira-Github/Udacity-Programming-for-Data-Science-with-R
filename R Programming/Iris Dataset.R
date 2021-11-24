?iris
#Shows iris' information in the help console.

iris
#Returns the entire dataset in the console.

head(iris,10)
#Shows the headers and some of the first lines in the dataset.

tail(iris,5)
#Returns the last rows of the dataset.

names(iris)
#Returns the name of the columns from a specific dataset.

iris$Sepal.Length
#Returns just one column from the dataset.

mean(iris$Sepal.Length)
#Returns the mean of one column of the dataset.

median(iris$Sepal.Length)
#Returns the median of one column of the dataset.

sd(iris$Sepal.Length)
#Returns the standard deviation of one column of the dataset.

virginicas = subset(iris, Species=='virginica')
#Creates a subset from the iris dataset with the rows that meet the criteria specified.
dim(iris)
#Returns the iris dataset dimensions.

dim(virginicas)
#Returns the subset dimensions.

virginicas_big_length = subset(iris, Species=='virginica' & Petal.Length > 5)
#Creates a subset from the iris dataset with the rows that meet the criterias specified.

dim (virginicas_big_length)
#Returns the subset dimensions.

summary(iris)
#Returns all the summary statistics for every column in the dataframe.


#Dataset Quiz 1

#1.List the dimension (column) names
names(iris)

#2.Show the fist four rows
head(iris, 4) #or iris[1:4,]

#3.Show the first row
iris[1,] #or head(iris,1)

#4.Sepal length of the first 10 samples
iris$Sepal.Length[1:10] #or head(iris$Sepal.Length,10)

#5.Allow replacing iris$Sepal.Length with shorter Sepal.Length
attach(iris, warn.conflicts = FALSE)

