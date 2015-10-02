"""
Physics Research Project
Devin Rose
More testing and code development
"""


#Initial parameters
using Gadfly, dataAnalysis
fileName = "CL5_461315707rdr_f0401286ccam01719p3.csv"

#functions called
csvArray = importFile(fileName)
parsedArray = parseArray(csvArray)

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

function findStandardDeviation(findDeviation::Array)

end

