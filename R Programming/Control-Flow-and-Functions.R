#IF-ELSE STATEMENTS

#Example 1:

# Variables:
oven.temp = 430
result1 = "Oven is not hot enough"
result2 = "Oven is just right"
result3 = "Oven is too hot"

# if-else statement
if (oven.temp == 425){
  print(result2)
} else if (oven.temp > 425) {
  print(result3)
} else {
  print(result1)
}


#Example 2:

y=4

if (y %% 4 == 0) {
  print("y is divided by 4")
} else {
  print("y is not divided by 4")
}

#LOOPS

#Example 1: Basic example

for (val in 1:10){
  print(val)
}

#Example 2: Consecutive sum

sum = 0
for (val in 2:7){
  sum = sum + val
}
print(sum)

#Example 3: Using "for" to fill a vector

sums = NULL
idx = 1
sum = 0

for (val in 2:7){
  sum = sum + val # calculates new sum
  sums[idx] = sum # stores sum in sums vector
  idx = idx + 1   # iterates to next index in the vector
}

#Example 4: Imagine you want to create a variable x that holds all of the values in y that are divisible by 4.

x=NULL
idx = 1

y = seq(1,100, by = 1)

for (num in y){
  if (num %% 4 == 0) {
    sum 
    idx = idx + 1
  }
}

#Example 5: Now given a number z, can you find the factorial of z?

z = 6   #Enter number here
factorial.result = 1  #The ending factorial value should be stored in this

z.array = seq(1,z, 1)

for (num in z.array){
  factorial.result = num*factorial.result
}

# FUNCTIONS

#Example 1

square.num = function(num, expo){
  x = num**expo
  return(x)
}

square.num(3,2)

# Function to return the factorial of a given number

factorial = function(num) {
  
  factorial_value = 1
  z.array = seq(1,num, 1)
  
  for (num in z.array){
    factorial_value = num*factorial_value
  }
  
  return(factorial_value)
}

factorial(7)


