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

function arrayLayers(row::Int64, columnToPlot::Int64, plotSurrounding::Int64, csvArray::Array)
  """
  Add a description
  """
  if (row > plotSurrounding) && (plotSurrounding > 0)
    numberOfRows = (2*plotSurrounding) + 1
    arrayToLayer = Array(Float64, numberOfRows, size(csvArray)[2])

    for i = 1:size(csvArray)[2]
      arrayToLayer[:,i] = csvArray[row-plotSurrounding:row+plotSurrounding, i] #wavelengths
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

  if (waveRow < size(csvArray, 1) && columnToCheck < size(csvArray, 2) && waveRow > 0)
    waveDifferentialRight = csvArray[waveRow+1, columnToCheck] - csvArray[waveRow, columnToCheck]
    waveDifferentialLeft = csvArray[waveRow, columnToCheck] - csvArray[waveRow-1, columnToCheck]
  else
    return null
  end

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

  initLayer = layer(x = arrayForLayers[:,1],y = arrayForLayers[:,i], Geom.line, color = repeat([50]))

  layers = initLayer

  for i = 1:size(arrayForLayers)[2]-2
    layerToAdd = layer(x = arrayForLayers[:,1],y = arrayForLayers[:,i+1], Geom.line, color = repeat([i]))

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


#Plotting the mean values
function plotMeanValues(arrayToPlot::Array, fileName::ASCIIString)
  """
  Plots the mean value of the data
  Packages used: Gadfly
  """

  max_x = 0

  while max_x < size(arrayToPlot)[1]
    xScale = 10
    if max_x >= 400
      xScale = 100
      if max_x >= 4000
        xScale = 1000
        if max_x >= 40000
          xScale = 10000
        end
      end
    end
    max_x += xScale
  end

  #re-scaling the x axis for a better plot
  xScale = 10
  if max_x > 400
    xScale = 100
    if max_x > 4000
      xScale = 1000
      if max_x > 40000
        xScale = 10000
      end
    end
  end

  max_x -= xScale

  #print("Plotting data from 1 - $max_x \n")

  myPlot = plot(x=arrayToPlot[1:max_x,1],y=arrayToPlot[1:max_x,2], Geom.line,
              Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Average value"), Guide.title("Plot of mean values"))

  plotName = "Plot_of_$fileName.png"

  #Write out the plot as a .png file
  #draw(PNG(plotName, 4inch, 3inch), myPlot)

  return myPlot
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

