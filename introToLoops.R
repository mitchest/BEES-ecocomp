# we'll be using the iris data
data(iris)


# logical operators -------------------------------------------------------
# if statement
if (TRUE) {
  "DO SOMETHING"
} else {
  "THIS HAPPENS"
}

# lets test some of the data
if (iris$Sepal.Length[1] < 3.5) {
  flower.stage = "bud"
}

# lets add an alternative
if (iris$Sepal.Length[1] < 3.5) {
  flower.stage = "bud"
} else {
  flower.stage = "flower"
}

# lets add another option
if (iris$Sepal.Length[1] < 3.5) {
  flower.stage = "hidden bud"
} else if (iris$Sepal.Length[1] >= 3.5 & iris$Sepal.Length[1] < 5.0) {
  flower.stage = "final bud"
} else {
  flower.stage = "open flower"
}


# what if we want to know something about all of the observations?
iris$Sepal.Length>5
sepal.gt.5 = which(iris$Sepal.Length>5)
iris$Species[sepal.gt.5]


# for loops ---------------------------------------------------------------
# basic loop syntax
for (i in 1:10) {
  print(i)
}

for (i in 1:10) {
  print(i^2)
}

# what if we want to keep the results?
# when we don't know what the length of the resutls is going to be (and we don't mind going slow...): 
x = numeric()
for (i in 1:10) {
  x = append(x, i^2)
}

# when we do know the length (this is a MUCH MUCH MUCH better option):
x = numeric(10)
for (i in 1:10) {
  x[i] = i^2
}

# we can use a variable instead of a numeric index
var = 1:10
for (i in var) {
  x[i] = i^2
}


# lets use a loop to do somethign a little more useful
flower.stage = character(length(iris$Sepal.Length))
for (i in 1:length(iris$Sepal.Length)) {
  if (iris$Sepal.Length[i] < 3.5) {
    flower.stage[i] = "hidden bud"
  } else if (iris$Sepal.Length[i] >= 3.5 & iris$Sepal.Length[i] < 5.0) {
    flower.stage[i] = "final bud"
  } else {
    flower.stage[i] = "open flower"
  }
}


# lets get some summary information using a loop
unique.species = unique(iris$Species) # do we know the unique() function
iris.summary = list()
for (species in unique.species) {
  look.at.rows = iris$Species==species
  iris.summary[[species]] = summary(iris[look.at.rows,])
}
iris.summary
iris.summary$setosa


# more than one for loop?
iris.sample = list()
for (species in unique(iris$Species)) {
  #print(species)
  temp = c()
  for (i in c(1:30)) {
    temp = append(temp, mean(sample(iris$Sepal.Length[iris$Species==species], i)))
    #print(mean(sample(iris$Sepal.Length[iris$Species==species], i)))
  }
  iris.sample[[species]] = temp
  #print(species)
  #print(sd(iris.sample[[species]]))
}


# loops to open and save files??
getwd()
setwd()

# save the subsets we created above as separate files
for (i in 1:length(iris.summary)) {
  write.csv(iris.summary[[i]], file=paste0(names(iris.summary)[i], ".csv")) # could do somethign better here to name the files
}

# get a list of target files and read them in
filenames = list.files(getwd(), pattern="*.csv", full.names=TRUE)
filenames

var1 = read.csv(filenames[1])

# we can use a loop to read them in and assign as variables too!
for (file in filenames) {
  assign(file, read.csv(file)) # you should do a better job here with the object naming!
}














