"""
Physics Research Project
Devin Rose
Example file that will call functions for a proper analysis of peak data.
Once a full analysis has been completed with all tools developed, a fullAnalysis() function will be written from the Example1.jl skeleton.
"""

#Initial parameters
using Gadfly, dataAnalysis

allFiles = findFilesToAnalyze()
#Add progress bar
#for all possible files
fileName = allFiles[1]


#initial functions called
csvArray = importFile(fileName)

#if(csvArray != null)
createDirectoryForReport(fileName)
parsedArray = parseArray(csvArray)

#not yet needed
calculatedMean = vectorMean(parsedArray[:,2])
areaOfLowValues = errorIntervals(parsedArray, calculatedMean)
minimumError = calculateBackgroundMinimumError(areaOfLowValues, parsedArray)
maxAndMinWavelength = wavelengthDifferetial(parsedArray)

#find row for wavelength
wavelengthOne = 289.9785
wavelengthTwo = 337.2671
meanColumn = size(csvArray)[2]

#example one, use example two
rowOne = findWaveRow(wavelengthOne, csvArray)
peakOne = findClosestMax(rowOne, meanColumn, csvArray)
localArrayOne = arrayLayers(peakOne, meanColumn, 5, csvArray)
areasCentreOne = areaUnderCurveCentral(localArrayOne)
areasRightOne = areaUnderCurveRightSum(localArrayOne)
areaDeviationOne = vectorStandardDeviation(areasRightOne[:,2])

#example two, run this code
rowTwo = findWaveRow(wavelengthTwo, csvArray)
peakTwo = findClosestMax(rowTwo, meanColumn, csvArray)
localArrayTwo = arrayLayers(peakTwo, meanColumn, 5, csvArray)
areasCentreTwo = areaUnderCurveCentral(localArrayTwo)
areasRightTwo = areaUnderCurveRightSum(localArrayTwo)
areaDeviationTwo = vectorStandardDeviation(areasRightTwo[:,2])

#plots
plot = plotMeanValues(parsedArray, fileName)

#plots one
plotOne = layerPlots(localArrayOne)
waveOne = csvArray[peakOne,1]
Gadfly.plot(x = areasRightOne[:,1], y =areasRightOne[:,2], Geom.line,
            Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"),
            Guide.title("Area under the peak over time (wavelength = $waveOne)"))

#plots two
plotTwo = layerPlots(localArrayTwo)
waveTwo = csvArray[peakTwo,1]
Gadfly.plot(x = areasRightTwo[:,1], y =areasRightTwo[:,2], Geom.line,
                    Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"), Guide.title("Area under the peak over time (wavelength = $waveTwo)"))

#else print "couldn't open file name"
#end for

#open results directory with new files
