"""
Physics Research Project
Devin Rose
Contains functions to write out, and import files
"""


function createDirectoryForReport(fileName::ASCIIString)
  """
  Creates a directory for the report
  """

  #Get to the reports directory
  currentPath = Base.source_path()
  cd()
  cd(split(currentPath, "dataAnalysis.jl")[1]"dataAnalysis.jl/docs/reports")

  filesInDirectory = readdir()
  dirCheck = false

  #searches files
  for i = 1:length(filesInDirectory)
    if fileName == filesInDirectory[i]
      dirCheck = true
    end
  end

  #reports the status about the directory
  if dirCheck == false
    mkdir(fileName)
    print("Successfully created a directory created in: ")
    print(pwd())
    print("\n")
  else
    print("Successfully found directory \n")
  end
end


function findFilesToAnalyze()
  """
  Add description
  """

  #move to the correct directory
  filePath = Base.source_path()
  cd()
  cd(split(filePath, "dataAnalysis.jl")[1]"dataAnalysis.jl/docs/dataToAnalyze")

  allFiles = readdir()

  return allFiles
end



#Importing the .csv file as an array
function importFile(fileName::ASCIIString)
  """
  Creates an array from the file name
  If a file cannot be analyzed, function returns null
  """

  #location is defaulted to the location of the file that calls the function
  fileLocation = Base.source_path()

  #Parses string, moves to docs directory, reads the files in the docs directory
  cd()
  cd(split(fileLocation, "dataAnalysis.jl")[1]"dataAnalysis.jl/docs/dataToAnalyze")

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

    return null
  end

  #Reads the table into a Vector
  fileLocation = pwd()"/"fileName
  csvArray = readdlm(fileLocation, ',', Float64)

  return csvArray
end

function writeOutPlot(name::ASCIIString, plotType::ASCIIString, plotToWriteOut::Plot)
  #location is defaulted to the location of the file that calls the function
  currentLocation = Base.source_path()

  #Parses string, moves to docs directory, reads the files in the docs directory
  cd()
  cd(split(currentLocation, "dataAnalysis.jl")[1]"dataAnalysis.jl/docs/reports")
  cd(name)

  #plotName = name"-" plotType ".png"=#

  plotNameSVG = string(name, "-", plotType, ".svg")
  plotNamePNG = string(name, "-", plotType, ".png")
  tempPlotName = string(plotType, ".svg")

  draw(SVG(tempPlotName, 4inch, 3inch), plotToWriteOut)
  #draw(SVG(plotNameSVG, 4inch, 3inch), plotToWriteOut)
  #draw(PNG(plotNameSVG, 4inch, 3inch), plotToWriteOut)
end



