"""
Physics Research Project
Devin Rose
Functions used to analyze the peak data
"""



function calculateBackgroundMinimumError(errorIntervals::Array, parsedArray::Array)
  """
  This function finds the minimum error that can be used as the background error
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




