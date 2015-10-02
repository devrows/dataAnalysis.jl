"""
Physics Research Project
Devin Rose
Sept 2015
miscellaneous testing
"""


#=**************************************
Initial parameters that will be declared in an example file or passed to the function as an argument
**************************************=#
using dataAnalysis, Gadfly
fileName = "CL5_461315707rdr_f0401286ccam01719p3.csv"

#completed and tested functions
csvArray = importFile(fileName)
parsedArray = parseArray(csvArray)
#plot = plotMeanValues(parsedArray, fileName)
calculatedMean = findMean(parsedArray)
areaOfLowValues = errorIntervals(parsedArray, calculatedMean)
minimumError = calculateBackgroundMinimumError(areaOfLowValues, parsedArray)
maxAndMinWavelength = wavelengthDifferetial(parsedArray)
#=**************************************=#

#find row for wavelength
wavelengthOne = 289.9785
wavelengthTwo = 337.2671
meanColumn = size(csvArray)[2]

#utilities.jl
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


rowOne = findWaveRow(wavelengthOne, csvArray)
rowTwo = findWaveRow(wavelengthTwo, csvArray)



#utilities.jl
function findClosestMax(waveRow::Int64, columnToCheck::Int64, csvArray::Array)
  """
  Recursively calls a function to find the closest peak
  """

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
end

peakOne = findClosestMax(rowOne, meanColumn, csvArray)
peakTwo = findClosestMax(rowTwo, meanColumn, csvArray)


#testing plotLocal function
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

localArrayOne = arrayLayers(peakOne, meanColumn, 5, csvArray)
localArrayTwo = arrayLayers(peakTwo, meanColumn, 5, csvArray)






#function for local plots
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



layersOne = layerPlots(localArrayOne)
layersTwo = layerPlots(localArrayTwo)

#for plotting, two is the good one
localPlotOne = plot(layersOne,
                    Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of peak"))
localPlotTwo = plot(layersTwo,
                    Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of peak"))





#use number two for testing
function areaUnderCurveEachShot(localArray::Array)
  """
  Uses a Riemman sum (centred interval method) to find the area under the curve
  """

  areaUnderCurve = Array(Float64, size(localArray)[2]-2, 2)

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

      areaUnderCurve [localColumn-1, 2] = length*width
    end
  end

  return areaUnderCurve
end


areasOne = areaUnderCurveEachShot(localArrayOne)
areasTwo = areaUnderCurveEachShot(localArrayTwo)



plot(x = areasOne[:,1], y =areasOne[:,2], Geom.line,
     Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"), Guide.title("Area under the peak over time (wave length = $csvArray[peakOne,1]"))

plot(x = areasTwo[:,1], y =areasTwo[:,2], Geom.line,
                    Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"), Guide.title("Area under the peak over time (wave length = $csvArray[peakTwo,1]"))


