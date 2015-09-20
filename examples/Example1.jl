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

plot = plotMeanValues(parsedArray, fileName)
