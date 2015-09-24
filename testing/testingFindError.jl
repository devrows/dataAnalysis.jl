"""
Physics Research Project
Devin Rose
Testing file, testing for the following functions (Data analysis functions)
-
"""


#=**************************************
Initial parameters that will be declared in an example file or passed to the function as an argument
**************************************=#
using dataAnalysis
fileName = "CL5_461315707rdr_f0401286ccam01719p3.csv"

csvArray = importFile(fileName)

parsedArray = parseArray(csvArray)
#=**************************************=#




#It might be beneficial to only consider intervals that are not at the end.
#=
function calculateBackgroundError(errorIntervals::Array, parsedArray::Array)
=#

largestInterval = Array(Float64, 1, 3)
largestInterval[1,:] = 0

#find bounds error later
for i = 1:size(errorIntervals)[1]

  errorCheck = errorIntervals[i,2] - errorIntervals[i, 1]

  #checks to see if it is the largest interval
  if errorCheck > largestInterval[1,1]
    largestInterval[1,1] = errorCheck
    largestInterval[1,2] = errorIntervals[i,1]
    largestInterval[1,3] = errorIntervals[i,2]
  end
end

#largestInterval


errorSum = 0
for j = largestInterval[1,2]:largestInterval[1,3]
  errorSum += parsedArray[j,2]
end

backgroundError = errorSum/largestInterval[1,1]

#=
return backgroundError
=#



#=
function "generateErrorFunction()"
=#






#=
return errorFunction
=#




#=
function errorIntervals(parsedArray::Array, mean::Float64)
=#

errorIntervals = Array(Float64, 1, 2)
errorIntervals[1,:] = 1

#find bounds error later
for i = 2:size(parsedArray)[1]
  #beginning of interval
  if parsedArray[i,2] < meanOfAllData && parsedArray[i-1,2] > meanOfAllData
    #create a new array to add to the end of the array
    elementToAdd = Array(Float64, 1, 2)
    elementToAdd[1,1] = parsedArray[i,1]
    elementToAdd[1,2] = 0

    #finds the end of the interval
    while (elementToAdd[1,2] == 0 && i < size(parsedArray)[1])

      i+=1

      #end of interval conditions
      if parsedArray[i,2] > meanOfAllData && parsedArray[i-1,2] < meanOfAllData
        #vertically concatenate the array
        elementToAdd[1,2] = parsedArray[i,1]
        errorIntervals = vcat(errorIntervals, elementToAdd)
      end

      #last value if the last interval is < meanOfData
      if elementToAdd[1,2] == 0 && i == size(parsedArray)[1]
        elementToAdd[1,2] = parsedArray[i,1]
        errorIntervals = vcat(errorIntervals, elementToAdd)
      end
    end #while loop
  end #ends if conditions for the beginning of the loop
end #ends for loop to find all intervals with values less than the mean

#errorIntervals

#=
return errorIntervals
=#










#=
function findMean(parsedArray::Array)
=#

#initialize variables
n = size(parsedArray)[1]
totalSum = 0

if n > 0
  for i = 1:n
    totalSum += parsedArray[i,2]
  end
else
  print("ERROR: sample size is less than one, now exiting with error code $n \n")
  #=
  return n
  =#
end

meanOfAllData = totalSum/n

#=
return mean
=#





#=
function findPeakIntervals(parsedArray::Array, peakMinimum::Float64)
=#

#need totalPeaks


#=
return peakLocations
=#




#=
function findPeakLocations(parsedArray::Array, peakMinimum::Float64)
=#




#=
return peakLocations
=#









#=
function findTotalPeaks(parsedArray::Array, peakMinimum::Float64)
=#

totalPeaks = 0

for i = 1:size(parsedArray)[1]
  if totalPeaks%2 == 0
    if parsedArray[2,i] >
      end
    end
  end



#=
return totalPeaks
=#


