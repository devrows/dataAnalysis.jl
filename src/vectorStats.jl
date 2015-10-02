"""
Physics Research Project
Devin Rose
All functions in this file will take a vector as an argument and do some analysis
"""

function vectorMean(findMean::Vector)
  """
  Find the mean of all values in the data
  """
  #initialize variables
  n = length(findMean)
  totalSum = 0

  if n > 0
    for i = 1:n
      totalSum += findMean[i]
    end
  else
    print("ERROR: sample size is less than one, now exiting with error code $n \n")
  end

  meanOfAllData = totalSum/n

  return meanOfAllData
end


function vectorStandardDeviation(findDeviation::Vector)
  """
  Add description
  """
  n = length(findDeviation)

  mean = vectorMean(findDeviation)

  standardDeviation = 0

  for j = 1:n
    standardDeviation += (mean-findDeviation[j])^2
  end

  standardDeviation = sqrt(standardDeviation/(n-1))

  return standardDeviation
end


#function findAllMaxes
