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

mean = totalSum/n

#=
return mean
=#





#=
function findPeakIntervals(parsedArray::Array, peakMinimum::Float64)
=#

totalPeaks


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


