"""
Physics Research Project
Devin Rose
Functions used to analyze the peak data
"""


#Returns: integer of a minimum background error
function calculateBackgroundMinimumError(areaOfLowValues::Array, parsedArray::Array)
  """
    Simple calculation of the minimum background error to see if the actual
    error calculated is feasible.
  """
  largestInterval = Array(Float64, 1, 3)
  largestInterval[1,:] = 0

  #find bounds error later
  for i = 1:size(areaOfLowValues)[1]

    errorCheck = areaOfLowValues[i,2] - areaOfLowValues[i, 1]

    #checks to see if it is the largest interval
    if errorCheck > largestInterval[1,1]
      largestInterval[1,1] = errorCheck
      largestInterval[1,2] = areaOfLowValues[i,1]
      largestInterval[1,3] = areaOfLowValues[i,2]
    end
  end

  errorSum = 0
  for j = largestInterval[1,2]:largestInterval[1,3]
    errorSum += parsedArray[j,2]
  end

  backgroundError = errorSum/largestInterval[1,1]

  return backgroundError
end



#Returns: Array of error intervals
function errorIntervals(parsedArray::Array, meanOfAllData::Float64)
  """
    Finds the intervals of values that are below the mean of the entire data.
  """
  lowValueIntervals = Array(Float64, 1, 2)
  lowValueIntervals[1,:] = 1

  #find bounds error later
  for i = 2:size(parsedArray)[1]
    #beginning of interval
    if parsedArray[i,2] < meanOfAllData && parsedArray[i-1,2] > meanOfAllData
      #create a new array to add to the end of the array
      elementToAdd = Array(Float64, 1, 2)
      elementToAdd[1,1] = i
      elementToAdd[1,2] = 0

      #finds the end of the interval
      while (elementToAdd[1,2] == 0 && i < size(parsedArray)[1])
        i+=1
        #end of interval conditions
        if parsedArray[i,2] > meanOfAllData && parsedArray[i-1,2] < meanOfAllData
          #vertically concatenate the array
          elementToAdd[1,2] = i
          lowValueIntervals = vcat(lowValueIntervals, elementToAdd)
        end

        if elementToAdd[1,2] == 0 && i == size(parsedArray)[1]
          elementToAdd[1,2] = i
          lowValueIntervals = vcat(lowValueIntervals, elementToAdd)
        end
      end #end while loop
    end #ends if conditions for the beginning of the loop
  end #ends for loop to find all intervals with values less than the mean

  return lowValueIntervals
end
