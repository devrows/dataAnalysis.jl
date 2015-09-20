"""
Physics Research Project
Devin Rose
Testing file, testing for the following functions (testing file for images)
- importFile(fileName::ASCIIString)
- plotMeanValues(fileName::ASCIIString)
"""

#Required Package management
Pkg.rm("Gadfly")
Pkg.add("Gadfly")
Pkg.update()
Pkg.installed("Gadfly")

#=**************************************
Initial parameters that will be declared in an example file or passed to the function as an argument
**************************************=#
using Gadfly
fileName = "CL5_461315707rdr_f0401286ccam01719p3.csv"
#=**************************************=#

#Importing the .csv file as an array
#=
importFile(fileName::ASCIIString)
=#

#location is defaulted to the location of the file that calls the function
fileLocation = Base.source_path()

#Parses string, moves to docs directory, reads the files in the docs directory
cd(split(fileLocation, "researchProject")[1]"researchProject/docs/")
readdir()

#loop to search for fileName
fileCheck = false
for i = 1:length(readdir())
  if fileName == readdir()[i]
    fileCheck = true
  end
end

#prints an error statement if the file is not there
if fileCheck == false
  print("ERROR: File ")
  print(fileName)
  print(" could not be found in ")
  print(pwd())
  print(". Now exiting \n")
end

#Reads the table into a Vector
fileLocation = split(fileLocation, "researchProject")[1]"researchProject/docs/"fileName
csvArray = readdlm(fileLocation, ',', Float64)
#meanVector = csvArray[:,size(csvArray)[2]]

#print("$(meanVector[1]) \n")

#=
return csvArray
=#





#Plotting the mean values
#=
plotMeanValues(fileName::ASCIIString)
=#

#creating an array for plotting
arrayToPlot = csvArray[:,size(csvArray)[2]-1:end]

for i = 1:size(csvArray)[1]
  arrayToPlot[i,1] = i
end

if size(arrayToPlot)[1] > 100
  xScale = 100
  if size(arrayToPlot)[1] > 1000
    xScale = 1000
  end
end

max_x = 0

while max_x < size(arrayToPlot)[1]
  xScale = 10
  if max_x >= 400
    xScale = 100
    if max_x >= 4000
      xScale = 1000
      if max_x >= 40000
        xScale = 10000
      end
    end
  end
  max_x += xScale
  print("$max_x, ")

  if max_x + xScale > size(arrayToPlot)[1]
    return max_x
  end
end

myPlot = plot(x=arrayToPlot[1:max_x,1],y=arrayToPlot[1:max_x,2], Geom.line,
              Guide.xlabel("Data Number"), Guide.ylabel("Average value"), Guide.title("Plot of mean values"))


joinpath(Pkg.dir("Gadfly"), "src", "gadfly.js")

plotName = "Plot_of_$fileName.png"

draw(PNG(plotName, 4inch, 3inch), myPlot)

#=
return myPlot
=#

