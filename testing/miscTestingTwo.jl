"""
Physics Research Project
Devin Rose
More testing and code development
"""


#Initial parameters
using Gadfly, dataAnalysis
allFiles = findFilesToAnalyze()

fileName = allFiles[1]

#functions called
csvArray = importFile(fileName)
parsedArray = parseArray(csvArray)

#find row for wavelength
wavelengthOne = 289.9785
wavelengthTwo = 337.2671
meanColumn = size(csvArray)[2]

#example one, use example two
rowTwo = findWaveRow(wavelengthTwo, csvArray)
peakTwo = findClosestMax(rowTwo, meanColumn, csvArray)
localArrayTwo = arrayLayers(peakTwo, meanColumn, 5, csvArray)
areasCentreTwo = areaUnderCurveCentral(localArrayTwo)
areasRightTwo = areaUnderCurveRightSum(localArrayTwo)

