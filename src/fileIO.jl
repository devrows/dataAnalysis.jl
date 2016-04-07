"""
Physics Research Project
Devin Rose
Contains functions to write out, and import files
"""


#=Returns: N/A=#
function createDirectoryForReport(fileName::ASCIIString)
  """
    Uses defensive programming style to check for a directory for reports and
    creates a one if a directory is not found.
  """

  #Get to the reports directory
  currentPath = Base.source_path() #Base.source_path() is the file path of this file
  cd()
  cd(split(currentPath, "dataAnalysis.jl")[1]"dataAnalysis.jl/docs/reports")

  if (contains(fileName, "/"))
    dirName = split(fileName, '/')[1]
    fileName = split(fileName, '/')[2]

    #if there is not a directory, create one
    if isdir(dirName) == false
      mkdir(dirName)
    end

    #move to the created/existing directory
    cd(dirName)
    if isdir(fileName) == false
      #create a directory for the soectrum analyzed
      mkdir(fileName)
    end

    #move to the new file
    cd(fileName)
  end
end


#=Returns: list of file names=#
function findFilesToAnalyze()
  """
    Finds all files in the filesToAnalyze directory inside of docs.
  """

  #move to the correct directory
  filePath = Base.source_path()
  directoryPath = split(filePath, "dataAnalysis.jl")[1]"dataAnalysis.jl/docs/dataToAnalyze"
  cd()
  cd(directoryPath)

  #Intialize memory for the list
  allDirs = Array(ASCIIString)
  allDirs = readdir()
  needFirstFile = true
  allFiles = Array(ASCIIString, 1)
  allFiles[1] = "test"

  #Creates a list of all files found in directories dataToAnalyze/sol...
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



#=Returns: array of spectra from one file,
  If a file fails, the function returns null=#
function importFile(fileName::ASCIIString)
  """
    Creates an array from the file name passed
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

  #"test" is used as a dummy to intialize memory and ".DS_Store" is a file
  #storing customization for Apple OSX
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
      #pwd = Print working directory, shows if the path is correct
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


#=Returns: N/A=#
function writeOutPlot(name::ASCIIString, plotType::ASCIIString, plotToWriteOut::Plot)
  """
    Simply uses draw to save the plot as a .png file
  """
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

  #I prefer png files but one could also use svg=scalable vector graphics
  #plotNameSVG = string(plotType, ".svg")
  plotNamePNG = string(plotType, ".png")

  #draw(SVG(plotNameSVG, 6inch, 4.5inch), plotToWriteOut)
  draw(PNG(plotNamePNG, 6inch, 4.5inch), plotToWriteOut)
end
