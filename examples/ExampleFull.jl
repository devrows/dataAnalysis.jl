"""
Physics Research Project
Devin Rose
Example file for a full analysis of data
"""

using dataAnalysis

#parameters
printReport = false
testingParams = true

#= For fitType
1 = Gaussian
2 = Lorrentzian
3 = Gaussian+Lorrentzian
4 = Gaussian+Gaussian=#
fitType = 4

fullAnalysis(printReport, testingParams, fitType)
