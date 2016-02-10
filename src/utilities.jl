"""
Physics Research Project
Devin Rose
Contains functions that will be used for an analysis of peak data
"""

function areaUnderCurveCentral(localArray::Array)
  """
  Uses a Riemman sum (centred interval method) to find the area under the curve
  """

  areaUnderCurve = Array(Float64, size(localArray)[2]-2, 2)
  areaUnderCurve[:,:] = 0

  #column 1 is the shot number
  for i = 1:size(areaUnderCurve)[1]
    areaUnderCurve[i, 1] = i
  end

  #Because this function uses the centred interval method, the first and last data point is not used for finding the area
  for localColumn = 2:size(localArray)[2]-1 #cuts mean and wavelength
    for localRow = 2:size(localArray)[1]-1 #cuts data boundaries
      startingWidth = (localArray[localRow,1] + localArray[localRow-1, 1])/2
      endingWidth = (localArray[localRow,1] + localArray[localRow+1, 1])/2

      width = endingWidth - startingWidth
      length = localArray[localRow, localColumn]

      areaUnderCurve[localColumn-1, 2] += length*width
    end
  end

  return areaUnderCurve
end



function areaUnderCurveRightSum(localArray::Array)
  """
  Riemann sum, using the right handed method
  """
  areaUnderCurve = Array(Float64, size(localArray)[2]-2, 2)
  areaUnderCurve[:,:] = 0

  #column 1 is the shot number
  for i = 1:size(areaUnderCurve)[1]
    areaUnderCurve[i, 1] = i
  end

  #Because this function uses the centred interval method, the first and last data point is not used for finding the area
  for localColumn = 2:size(localArray)[2]-1 #cuts mean and wavelength
    for localRow = 1:size(localArray)[1]-1 #cuts data boundaries
      width = localArray[localRow+1,1] - localArray[localRow,1]
      length = localArray[localRow, localColumn]

      areaUnderCurve[localColumn-1, 2] += length*width
    end
  end

  return areaUnderCurve
end

function arrayLayers(rowPeak::Int64, plotSurrounding::Int64, csvArray::Array)
  """
  Add a description
  """
  if (rowPeak > plotSurrounding) && (plotSurrounding > 0)
    numberOfRows = (2*plotSurrounding) + 1
    arrayToLayer = Array(Float64, numberOfRows, size(csvArray)[2])

    for i = 1:size(csvArray)[2]
      arrayToLayer[:,i] = csvArray[rowPeak-plotSurrounding:rowPeak+plotSurrounding, i] #wavelengths
    end
  else
    print("The surrounding data cannot not be properly plotted, readjust the amount of surrounding data you are plotting.")
    return null
  end

  return arrayToLayer
end


function findClosestMax(waveRow::Int64, columnToCheck::Int64, csvArray::Array)
  """
  Recursively calls a function to find the closest peak
  """

  if (waveRow < size(csvArray, 1) && waveRow > 0 && waveRow != null)
    waveDifferentialRight = csvArray[waveRow+1, columnToCheck] - csvArray[waveRow, columnToCheck]
    waveDifferentialLeft = csvArray[waveRow, columnToCheck] - csvArray[waveRow-1, columnToCheck]

    #found peak if
    if (waveDifferentialRight < 0) && (waveDifferentialLeft > 0)
      return waveRow
    end

    if waveDifferentialRight > 0 #Look right
      theRow = findClosestMax(waveRow+1, columnToCheck, csvArray)
    elseif waveDifferentialLeft < 0 #look left
      theRow = findClosestMax(waveRow-1, columnToCheck, csvArray)
    else
      theRow = waveRow
    end

    return theRow
  else
    return null
  end
end


function findWaveRow(waveValue::Float64, csvArray::Array)
  """
  Add a description
  """
  #initialize row and start a loop to find the first value larger than the wavelength
  row = 2
  while (waveValue > csvArray[row, 1]) && (row < size(csvArray)[1])
    row+=1
  end

  #Check if row-1 or row values are closer to the wavelength
  if (waveValue - csvArray[row-1, 1]) < (csvArray[row, 1] - waveValue)
    return row-1
  else
    return row
  end
end



function layerPlots(arrayForLayers::Array)
  """
  Add description
  """
  i = size(arrayForLayers)[2]

  initLayer = layer(x = arrayForLayers[:,1],y = arrayForLayers[:,i], Geom.point, color = repeat([50]))

  layers = initLayer

  for j = 2:size(arrayForLayers)[2]-1
    layerToAdd = layer(x = arrayForLayers[:,1],y = arrayForLayers[:,j], Geom.point, color = repeat([j]))

    layers = vcat(layers, layerToAdd)
  end

  plotToReturn = plot(layers,
                    Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of peak"))

  return plotToReturn
end

function parseArray(arrayFromFile::Array)
  """
  Parses the array for easier access from other functions
  Packages used: None
  """

  #creating an array for plotting
  parsedArray = arrayFromFile[:,size(arrayFromFile)[2]-1:end]

  #setting all values in one column
  for i = 1:size(arrayFromFile)[1]
    parsedArray[i,1] = arrayFromFile[i,1]
  end

  return parsedArray
end

function wavelengthDifferetial(reducedArray::Array)
  """
  Returns an array of the smallest and largest wavelength
  """
  #Allocate memory for the array
  waveMaxAndMin = Array(Float64, 1, 2)
  arrayLength = size(reducedArray)[1]

  waveMaxAndMin[1,1] = reducedArray[1,1]
  waveMaxAndMin[1,2] = reducedArray[arrayLength, 1]

  return waveMaxAndMin
end

