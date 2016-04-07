"""
Physics Research Project
Devin Rose
Example file for a full analysis of data
"""

using dataAnalysis

#parameters
#will periodic update the user before function calls to find bugs
printReport = false
#Will plot the estimated parameters with the fit to show how accurate the guess was
testingParams = false
#Will display the fit for every single file if the user would like to see it
displayFit = false

#= For fitType
1 = Gaussian
2 = Lorrentzian
3 = Gaussian+Lorrentzian
4 = Pseudo-voight profile
5= Testing model=#
fitType = 1

fullAnalysis(printReport, testingParams, fitType, displayFit)

#=
TO TEST NEW MODELS:
1. Change the parameter estimations in generateFitPlots()
2. Change the calculation of area in fullAnalysis()
=#
MODEL_test(x, param) = param[1]*((1-param[4])*exp(-((x.-param[2]).^2)/((param[3]).^2))
  +param[4]./(1+((x-param[2])/param[3]).^2))
MODEL_test(1,[2,1,7,5]) #just to make sure the model works
fullAnalysis(printReport, testingParams, 5, false, MODEL_test)
