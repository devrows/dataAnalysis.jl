"""
Physics Research Project
Devin Rose
Contains functions to write out, and import files
"""


function findFilesToAnalyze()
  """
  Add description
  """

  #move to the correct directory
  filePath = Base.source_path()
  cd()
  cd(split(filePath, "dataAnalysis.jl")[1]"dataAnalysis.jl/docs/dataToAnalyze")

  fileNames = readdir()

  return fileNames
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

