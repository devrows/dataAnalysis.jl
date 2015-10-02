"""
Physics Research Project
Devin Rose
Example file that will call functions for a proper analysis of peak data
"""

#Initial parameters
using Gadfly, dataAnalysis
fileName = "CL5_461315707rdr_f0401286ccam01719p3.csv"

#functions called
csvArray = importFile(fileName)
parsedArray = parseArray(csvArray)

#not yet needed
calculatedMean = findMean(parsedArray)
areaOfLowValues = errorIntervals(parsedArray, calculatedMean)
minimumError = calculateBackgroundMinimumError(areaOfLowValues, parsedArray)
maxAndMinWavelength = wavelengthDifferetial(parsedArray)

#find row for wavelength
wavelengthOne = 289.9785
wavelengthTwo = 337.2671
meanColumn = size(csvArray)[2]

rowOne = findWaveRow(wavelengthOne, csvArray)
rowTwo = findWaveRow(wavelengthTwo, csvArray)

peakOne = findClosestMax(rowOne, meanColumn, csvArray)
peakTwo = findClosestMax(rowTwo, meanColumn, csvArray)

localArrayOne = arrayLayers(peakOne, meanColumn, 5, csvArray)
localArrayTwo = arrayLayers(peakTwo, meanColumn, 5, csvArray)

areasCentreOne = areaUnderCurveCentral(localArrayOne)
areasCentreTwo = areaUnderCurveCentral(localArrayTwo)
areasRightOne = areaUnderCurveRightSum(localArrayOne)
areasRightTwo = areaUnderCurveRightSum(localArrayTwo)

#plots
plot = plotMeanValues(parsedArray, fileName)
plotOne = layerPlots(localArrayOne)
plotTwo = layerPlots(localArrayTwo)

waveOne = csvArray[peakOne,1]
waveTwo = csvArray[peakTwo,1]



Gadfly.plot(x = areasRightOne[:,1], y =areasRightOne[:,2], Geom.line,
                    Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"), Guide.title("Area under the peak over time (wavelength = $peakOne)"))

plot(x = areasRightTwo[:,1], y =areasRightTwo[:,2], Geom.line,
                    Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"), Guide.title("Area under the peak over time (wavelength = $peakTwo)"))
