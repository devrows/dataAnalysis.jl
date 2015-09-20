"""
Physics Research Project
Devin Rose
Contains functions that will be used for an analysis of peak data
"""


#Importing the .csv file as an array
function importFile(fileName::ASCIIString)
  """
  Creates an array from the file name
  Packages used: none
  """

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

  return csvArray
end


function parseArray(arrayFromFile::Array)
  """
  Parses the array for easier access from other functions
  Packages used: None
  """

  #creating an array for plotting
  parsedArray = arrayFromFile[:,size(arrayFromFile)[2]-1:end]

  #setting all values in one column
  for i = 1:size(arrayFromFile)[1]
    parsedArray[i,1] = i
  end

  return parsedArray
end


#Plotting the mean values
function plotMeanValues(arrayToPlot::Array, fileName::ASCIIString)
  """
  Plots the mean value of the data
  Packages used: Gadfly
  """

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
  end

  #re-scaling the x axis for a better plot
  xScale = 10
  if max_x > 400
    xScale = 100
    if max_x > 4000
      xScale = 1000
      if max_x > 40000
        xScale = 10000
      end
    end
  end

  max_x -= xScale

  print("Plotting data from 1 - $max_x \n")

  myPlot = plot(x=arrayToPlot[1:max_x,1],y=arrayToPlot[1:max_x,2], Geom.line,
              Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Average value"), Guide.title("Plot of mean values"))

  plotName = "Plot_of_$fileName.png"

  #draw(PNG(plotName, 4inch, 3inch), myPlot)

  return myPlot
end



