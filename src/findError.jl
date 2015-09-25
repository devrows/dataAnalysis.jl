"""
Physics Research Project
Devin Rose
Functions used to analyze the peak data
"""


#need to be able to find the indexing for errorIntervals to access the proper indexing
function calculateBackgroundMinimumError(errorIntervals::Array, parsedArray::Array)
  """
  This function finds the minimum error that can be used as the background error. Returns
  """
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

  errorSum = 0
  for j = largestInterval[1,2]:largestInterval[1,3]
    errorSum += parsedArray[j,2]
  end

  backgroundError = errorSum/largestInterval[1,1]

  return backgroundError
end




function errorIntervals(parsedArray::Array, mean::Float64)
"""
Finds the intervals of values that are below the mean of the entire data
"""
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

  return errorIntervals
end




function findMean(parsedArray::Array)
  """
  Find the mean of all values in the data
  """
  #initialize variables
  n = size(parsedArray)[1]
  totalSum = 0

  if n > 0
    for i = 1:n
      totalSum += parsedArray[i,2]
    end
  else
    print("ERROR: sample size is less than one, now exiting with error code $n \n")

  #return n
  end

  meanOfAllData = totalSum/n
  return meanOfAllData
end
