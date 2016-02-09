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

  if (contains(fileName, "/"))
    dirName = split(fileName, '/')[1]
    fileName = split(fileName, '/')[2]

    if isdir(dirName) == false
      mkdir(dirName)
    end

    cd(dirName)

    if isdir(fileName) == false
      mkdir(fileName)
    end

    cd(fileName)
  end
end


function findFilesToAnalyze()
  """
  Add description
  """

  #move to the correct directory
  filePath = Base.source_path()
  directoryPath = split(filePath, "dataAnalysis.jl")[1]"dataAnalysis.jl/docs/dataToAnalyze"
  cd()
  cd(directoryPath)

  allDirs = Array(ASCIIString)
  allDirs = readdir()
  needFirstFile = true
  allFiles = Array(ASCIIString, 1)
  allFiles[1] = "test"

  for i = 1:length(allDirs)
    cd()
    cd(directoryPath)

    if isdir(allDirs[i])
      cd(allDirs[i])
      filesInDir = readdir()

      for j = 1:length(filesInDir)
        requiredPath = string(allDirs[i], "/", filesInDir[j])
        filesInDir[j] = requiredPath
      end

      allFiles = cat(1, allFiles, filesInDir)
    end
  end

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

  if (contains(fileName, "/"))
    dirName = split(fileName, '/')[1]
    fileName = split(fileName, '/')[2]
    cd(dirName)
  end

  #loop to search for fileName
  fileCheck = false
  printError = true

  for i = 1:length(readdir())
    if fileName == readdir()[i]
      fileCheck = true
    end
  end

  if fileName == "test" || fileName == ".DS_Store" || fileName == "."
    fileCheck = false
    printError = false
  end

  #prints an error statement if the file is not there
  if fileCheck == false
    if printError
      print("ERROR: File ")
      print(fileName)
      print(" could not be found in ")
      print(pwd())
      print(". Now exiting \n")
    end

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

  if (contains(name, "/"))
    dirName = split(name, '/')[1]
    fileName = split(name, '/')[2]

    cd(dirName)
    cd(fileName)
  else
    cd(name)
  end

  #plotName = name"-" plotType ".png"=#

  plotNameSVG = string(name, "-", plotType, ".svg")
  plotNamePNG = string(name, "-", plotType, ".png")
  tempPlotName = string(plotType, ".svg")

  #Switch to .png graphics

  draw(SVG(tempPlotName, 4inch, 3inch), plotToWriteOut)
  #draw(SVG(plotNameSVG, 4inch, 3inch), plotToWriteOut)
  #draw(PNG(plotNameSVG, 4inch, 3inch), plotToWriteOut)
end

function writeOutText(name::ASCIIString, writingToFile::LsqFit.LsqFitResult{Float64})


end

