# Data Types

class('This is a character') # Character
class(5)    # Numeric
class(4.5)  # Numeric

c('blue', 'green', 'brown', 'brown')

vector(mode='numeric', length=5)

seq(1, 10, length.out=20)

x = c(4,3,3,4,3,1)
x

q = seq(0,1, by = 0.1)
q

y = seq(0,1, length.out = 11)
y


heights = c(67, 74, 63, 70)
heights >= 70 # compares all values in heights to 70
any(heights <= 70)
all(heights <= 70)
which(heights <= 70)

eye.colors = c('blue', 'green', 'brown', 'brown')
subset(eye.colors, heights < 70)


x <- seq(1,27)
dim(x) <- c(3,9)
is.array(x)
is.matrix(x)