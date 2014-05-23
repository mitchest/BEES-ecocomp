## BEES R USer Group

# Why functions? ----------------------------------------------------------

# R is a "functional" programming language
# Beacuase it is based around the use of functions!

# In a general sense, a function is a block of reusable code that
# takes some input/s and produces a definite output

# We use them when we find or expect to do the same thing many times, 
# sometimes with small variations
# They save both physical and mental effort
# They allow us to think more holistically about our program
# They also reduce error, by reducing needless manual input

# Lets get to it.


# Function basics ---------------------------------------------------------

# The basic form (called a declaration or definition) of a function:
MyFunction <- function(argument.1, argument.2, ...) {
  # some use/analysis/manipulation using arguments
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
lm(formula=temp ~ time, data=beaver1, method="model.frame")


# Writing functions -------------------------------------------------------

# Lets start with a basic function we know
mean(beaver1$temp)


# Now write the function yourself
MyMean = function(x) {
  sum(x)/length(x)
}
MyMean(beaver1$temp)


# Do it on the data frame?
MyMean = function(x) {
  sum(x$temp)/length(x$temp)
}
MyMean(beaver1)


# Choose the column?
# We need to add another argument!
MyMean = function(x, column) {
  sum(x[,column])/length(x[,column])
}
MyMean(beaver1, "temp")
MyMean(beaver1, 3)



## HOMEWORK ##
# You really only get the hang of it by trying it out, try:
var()
abs() # try without using sqrt(x^2), hint: use a conditional statement!



# More advanced stuff -----------------------------------------------------

# Functions in functions?
# Of course! In fact we've already done it above...

# A function to convert temperature from C to F
CelsiusToFahrenheit = function(x) {
  x*9/5+32
}
CelsiusToFahrenheit(beaver1$temp)


# function call as an argument? Absolutely.
mean(CelsiusToFahrenheit(beaver1$temp))


# Build it into the function?
MyMean = function(x, column) {
  CelsiusToFahrenheit(sum(x[,column])/length(x[,column]))
}
MyMean(beaver1, "temp")


# That might be a little hard to interpret later on. Let's try something more structured
MyMean = function(x, column) {
  # make a variable
  mean.celcius = sum(x[,column])/length(x[,column])
  # convert to fahrenheit
  CelsiusToFahrenheit(mean.celcius)
}
MyMean(beaver1, "temp")


# How does R know what you want if you've evaluated more than one thing?
# It returns the last evaluated value!
# Although R never REQUIRES it, sometimes it is clearer or easier if we 
# explicitly define what the function returns, we do this with another function!:
return()

# For example, there is no difference from the last version if we do:
MyMean = function(x, column) {
  # make a variable
  mean.celcius = sum(x[,column])/length(x[,column])
  # convert to fahrenheit
  return(CelsiusToFahrenheit(mean.celcius))
}
MyMean(beaver1, "temp")


# if you have a complex function, or perhaps one with conditional statements...
bar <- function() {
  while (a) {
    do_stuff
    for (b) {
      do_stuff
      if (c) return(1)
      for (d) {
        do_stuff
        if (e) return(2)
      }
    }
  }
  return(3)
}


# Practical examples ------------------------------------------------------

# Have shown mostly trivial examples, what about something practical

# Plotting
MyPlot = function(x, y, data, xlab=x, ylab=y) {
  formula = as.formula(paste0(x,"~",y))
  plot(formula, data=data, xlab=xlab, ylab=ylab) +
    text(0,max(data[,x]),paste0("model used: ",x,"~",y), pos=4)
}
MyPlot("temp", "time", beaver1)
MyPlot("temp", "time", beaver1, xlab="Beaver's body temperature", ylab="Time of Day")


# Print model stats
PrintFit = function(x, y, data, plotResid=FALSE){
  # fit the model
  formula = as.formula(paste0(x,"~",y))
  model.fit = lm(formula, data=data)
  # print some stats
  print(paste0("Sample n = ",nrow(data)))
  print(paste0("RMSE = ",summary(model.fit)$sigma))
  print(paste0("R^2 = ",summary(model.fit)$r.squared))
  # plot residuals?
  if (plotResid == TRUE) {
    plot(model.fit$residuals)
  }
}
PrintFit("temp", "time", beaver1)
PrintFit("temp", "time", beaver1, plotResid=TRUE)



## MORE HOMEWORK ##

# 1.
# Take the functions MyPlot() and PrintFit() above, and join their powers together
# to make a side-by-side panel plot of both the data and residuals, and if you're 
# feeling adventurous, make the fit stats print onto the plot instead of in ther terminal!

# 2.
# Try combining your function and looping skills together!
#     e.g. Write a function that opens a .csv and does something cimpel with it,
#     then write a loop (or use l/s/apply()!) to call it on many .csv files

# 3.
# Things to read about:
# Scoping, and the difference between the global environment and a functions environment
# use of the "..." argument
# When you should/n't use the return() argument
# testing functions - e.g. testing input data type/length with conditional statements






