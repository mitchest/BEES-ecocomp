# This is a "comment"
# Anything preceeded by a "#" will not be executed



# Objects -----------------------------------------------------------------

# R is an object orientated language, meaning everything you do revolves around the use of,
# you guessed it, objects. This is opposed to procedural programming (like C). An object is
# a data container, which can take a number of forms (known as data structure). An object 
# also contains procedures (code), but that is not so useful to explain just yet.
# As an aside you can also do "Functional Programming" in R too

# All objects have a name too. When we name an object, we call it "assignment".
# In R, you should assign with "<-", opposed to every other language where, one
# uses "=". However, unless you are writing packages, you can choose

# e.g.
my.number <- 100
# is the same as
100 -> my.number
# and
my.number = 100

# You should name your objects sensibly, this makes it easy to find them. Here, 100 is the
# object, and "my.number" is the name we are giving it.
my.number

# You can read about naming convention in the Google style guide, along with a whole bunch
# of other "rules" you should try to follow
# https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml



# So what are the data structures -----------------------------------------

# Atomic Vectors
# Atomic Vectors are the "simplest" form of data you usually run into, these are often
# referred to as just "vectors". They are one-dimensional (flat) and have a "length".
# Simplest is one with length 1, which is refered to as a "scalar"
length(my.object)

# Vectors can obviously have any length
my.vector = 1:10
my.vector

my.vector = 1:1000000
head(my.vector)

# Atomic Vectors also have different "data types" they can hold 
# There are 4 main data types we should be concerned with:
integer
double # or numeric
logical
character

# Integer is the simplest to imagine
my.integer = integer(10)
my.integer = as.integer(c(1,2,3,4,5))
my.integer = 1:5 # we don't need to coerce, if we're happy to leave it up to R

# Numeric is similer, except it is a floating value
my.numeric = seq(from=0, to=1, by=0.25)
my.numeric

# Logical can take the values TRUE or FALSE
my.logical = c(TRUE,FALSE,TRUE,FALSE,TRUE)
my.logical

# Character, also known as a string, is simply text
my.character = c("one", "two", "three", "four", "five")
my.character

# Additionally, each of these data types can contain an
NA
# Note that in R, NA != (not equal to) NULL, see:
str(c(1,2,3,NA,5))
str(c(1,2,3,NULL,5))


# You can use str() to find out, or is.* to test what type of object/data type somethign is
str(my.integer)
str(my.logical)
is.character(my.character)
is.double(my.numeric)
is.numeric(my.numeric)

# we can "coerce" a vector into another type
as.character(my.integer)
# to demonstrate coercion, looks what happens with
str(c(1, FALSE, "string", 1.3))
str(c(1, 2, 3, 4.5, 6.7))

# We won't talk about attributes here, but check out
?attr # and
?attributes 

attr(my.character, "whatami") = "This is a vector of strings"
attr(my.character, "whatami")
attributes(my.character)



# Next we have lists, which are actually a type of vector. Again, they have a length,
# but each element of a list can be of any data structure (even another list)
my.list = list(1:5, seq(from=0, to=1, by=0.25), c(TRUE,FALSE,TRUE,FALSE,TRUE), 
               c("one", "two", "three", "four", "five"))
str(my.list)

# we could have just used our objects
str(list(my.integer, my.numeric, my.logical, my.character))

# Lists are the main underlying data structure for most complex objects in R
# This includes data frames (which we will see shortly) and model fit objects for example

# Matrices and Arrays are pretty self explanatory - they are what you would be used to
# in any mathmatical/data environemnt. A matrix is 2D and an array is nD, where each column
# has an equal row length - the only cavet is that all elements much be of the same data type.
matrix(1, nrow=4, ncol=4)
matrix(1:20, nrow=4)
matrix(1:20, ncol=4)
matrix(1:20, ncol=4, byrow=T)
as.matrix(my.integer)
as.matrix(c(my.integer, my.character))

# there are some more things to know about using and making matrices, but not that we need
# to cover now - the key thing to note is that they have a dim() attribute
dim(matrix(1:20, nrow=4))
dim(matrix(1:20, ncol=4))



# Data frames, though conceptually similar to a matrix, are actually a special type of list.
# The difference is that each element must be of the same length. This allows multiple different
# data types
my.df = data.frame(1:5, seq(from=0, to=1, by=0.25), c(TRUE,FALSE,TRUE,FALSE,TRUE), 
                    c("one", "two", "three", "four", "five"))
my.df
data.frame(my.list) # looks the same?

# Can name the columns to make it easier for us
names(my.df) = c("int", "num", 'logi', "char")
my.df

str(my.df) # eek the character vector converted to factor, try stringsAsFactors=FALSE

# Of course we can use our names objects to make a data frame, and the names() are inherited
str(data.frame(my.integer, my.numeric, my.logical, my.character, stringsAsFactors=FALSE))



# Accessing elements of your objects --------------------------------------

# The way we access bit of our objects (subsetting) varies a bit depending on the data structure

# Get the first element of an atomic vector
my.integer[1]
# Get the first 3 elements of an atomic vector
my.integer[1:3]
# Get the first 3 elements of an atomic vector, and make a new object from it
my.integer.subset = my.integer[1:3]
str(my.integer.subset)

# Get the first element of a list
my.list[[1]]
# note the difference between
str(my.list[[1]])
str(my.list[1])
str(my.list[1:3])

# If we had named the list,
names(my.list) = c("int", "num", 'logi', "char")
# we can access via the name
my.list$int
my.list["num"]


# Since data frames are lists, we can access elements in the same way
my.df$int
my.df["num"]

# Since they also have a matrix like structure, we can index them as such
# Get the whole first row
my.df[1,]
# Get the whole first column
my.df[,1]
# Get the element in row 1, column 4
my.df[1,4]
# Get the whole first row by name
my.df[,"int"]

# try these ones
my.df[1:3,]
my.df[,1:3]
my.df[1:3,1:2]
my.df[,c(1,3)]
my.df[,c("int","char")]
my.df[c(TRUE,TRUE,TRUE,FALSE,FALSE),]
my.df[my.logical,]



# Functions ---------------------------------------------------------------

# Functions are also objects, not surprisingly. They make life easy
# We're not going to go into detail today, just the basics.

# The basic form (called a declaration or definition) of a function:
Function <- function(argument.1, argument.2, ...) {
  # some use/analysis/manipulation using input arguments
  return(what.you.want.as.output)
}

# When you ?query a function (e.g. ?lm) you get info on the arguments requires/accepted
# Arguments can be ordered or named
# Both are useful, and usually functions have a few ordered arguments and
# then maybe some more default argument values, e.g. lm()

data(beavers)

?lm
lm(temp ~ time, beaver1)
lm(formula=temp ~ time, data=beaver1)
lm(formula=temp ~ time, data=beaver1, method="qr")

# Also remember using stringsAsFactors=FALSE above
str(data.frame(my.integer, my.numeric, my.logical, my.character))
str(data.frame(my.integer, my.numeric, my.logical, my.character, stringsAsFactors=TRUE))
str(data.frame(my.integer, my.numeric, my.logical, my.character, stringsAsFactors=FALSE))


# Some useful functions
?str
?colnames
?row.names
?dim
?summary
?head
?hist
?plot



# Logical operators -------------------------------------------------------

# These are just like normal mathmatical logic
# Try:

1 == 1
1 == 2

1 > 0
1 > 2

1 != 1
1 != 2

1 == 1 & 2 == 2
1 == 1 & 2 == 3
1 == 1 | 2 == 3

TRUE > FALSE
sum(TRUE)
sum(my.logical)

my.df$int == 1
my.df$int == 0
my.df$int > 1
sum(my.df$int > 1)

# we could combine logcial operators and subsetting, read more about this if you like
my.df[my.df$int==1,]
my.df[my.df$int>1,]
my.df[my.df$char=="one",]

# read about "if statements" to make more functional use of logical operators, e.g.
if (TRUE) {
  "DO SOMETHING"
} else {
  "THIS HAPPENS"
}

if (FALSE) {
  "DO SOMETHING"
} else {
  "THIS HAPPENS"
}



# More... -----------------------------------------------------------------

# Google it
# Go here: http://adv-r.had.co.nz/
# Come to some more R User Group sessions on functions, looping etc.
