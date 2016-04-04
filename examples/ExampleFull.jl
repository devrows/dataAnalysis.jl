"""
Physics Research Project
Devin Rose
Example file for a full analysis of data
"""

using dataAnalysis

#parameters
printReport = false
testingParams = false
displayFit = false

#= For fitType
1 = Gaussian
2 = Lorrentzian
3 = Gaussian+Lorrentzian
4 = ***Pseudo-voight profile (coming soon, to a program near you)
5= Testing model=#
fitType = 3

fullAnalysis(printReport, testingParams, fitType, displayFit)

#for testing
MODEL_test(x, param) = param[1]*((1-param[4])*exp(-((x.-param[2]).^2)/((param[3]).^2)) + param[4]./(1+((x-param[2])/param[3]).^2))
MODEL_test(1,[2,1,7,5])
fullAnalysis(printReport, testingParams, 5, false, MODEL_test)
