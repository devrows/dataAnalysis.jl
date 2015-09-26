"""
Physics Research Project
Devin Rose
miscellaneous testing
"""



#=**************************************
Initial parameters that will be declared in an example file or passed to the function as an argument
**************************************=#
using dataAnalysis
fileName = "CL5_461315707rdr_f0401286ccam01719p3.csv"

#completed and tested functions
csvArray = importFile(fileName)
parsedArray = parseArray(csvArray)
calculatedMean = findMean(parsedArray)
areaOfLowValues = errorIntervals(parsedArray, calculatedMean)
minimumError = calculateBackgroundMinimumError(areaOfLowValues, parsedArray)
#=**************************************=#


