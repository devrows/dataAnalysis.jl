"""
Physics Research Project
Devin Rose
Example file for a full analysis of data
"""

using dataAnalysis

#parameters
printReport = false
testingParams = false
realRun = true #Add functionality to this

#= For fitType
1 = Gaussian
2 = Lorrentzian
3 = Gaussian+Lorrentzian
4 = Pseudo-voight profile(coming soon)
5= Testing model=#
fitType = 1

fullAnalysis(printReport, testingParams, fitType, realRun)

#for testing
MODEL_test(x, param) = param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2))) + param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2)))
MODEL_test(1,[2,1])
fullAnalysis(printReport, testingParams, fitType, MODEL_test)
