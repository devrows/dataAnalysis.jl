"""
Physics Research Project
Devin Rose
Example file for a full analysis of data
"""

using dataAnalysis

#parameters
printReport = false
testingParams = false

#= For fitType
1 = Gaussian
2 = Lorrentzian
3 = Gaussian+Lorrentzian
4 = Gaussian*Lorrentzian
5= Testing model=#
fitType = 3

fullAnalysis(printReport, testingParams, fitType)

#for testing
MODEL_test(x, param) = (param[1])./((x-param[2]).^2 + (0.5*param[1]).^2)
MODEL_test(1,[2,1])
fullAnalysis(printReport, testingParams, fitType, MODEL_test)
