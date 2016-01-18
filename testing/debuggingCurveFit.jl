"""
Physics Research Project
Devin Rose
More testing and code development
"""

Pkg.status()
Pkg.update()

Pkg.installed("LsqFit")
Pkg.add("LsqFit")

Pkg.clone("LsqFit")

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

wavelengthOI = 777.5388
meanColumn = size(csvArray)[2]

#example OI, use example two
rowOI = findWaveRow(wavelengthOI, csvArray)
peakOI = findClosestMax(rowOI, meanColumn, csvArray)
#Change localArray to report local until finding the first local min
localArrayOI = arrayLayers(peakOI, meanColumn, 5, csvArray)
areasCentreOI = areaUnderCurveCentral(localArrayOI)
areasRightOI = areaUnderCurveRightSum(localArrayOI)
areaDeviationOI = vectorStandardDeviation(localArrayOI[:,1])

#=Pkg.add("LsqFit")
Pkg.checkout("LsqFit")

Pkg.update()=#

#Testing area is located below
using LsqFit

xOIData = localArrayOI[:,1]
yOIData = localArrayOI[:,6]

stdDevOI = vectorStandardDeviation(xOIData)
peakOIMax = 0
globalMax = 0

for j = 1:length(yOIData)
  if peakOIMax < yOIData[j]
    peakOIMax = yOIData[j]
  end
end

for k = 1:size(csvArray)[1]
  if globalMax < csvArray[k, size(csvArray)[2]]
    globalMax = k
  end
end

maximumWavelength = csvArray[globalMax, 1]

guessOI = [peakOIMax, csvArray[peakOI,1], 4*stdDevOI]

#Gaussian function
#workingModel(x, p) = p[1]*exp(-abs(x.-p[2])/(2*(p[3]^2)))
workingModel(x, p) = p[1]*exp(-abs(x-p[2])/(2*(p[3]^2)))

#model(x, param) = param[1]*exp(-((x.-param[2]).*(x.-param[2]))/(2*(param[3]^2)))
model(x, param) = param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2)))

workingFit = curve_fit(workingModel, xOIData, yOIData, guessOI)
fitOI = curve_fit(model, xOIData, yOIData, guessOI)

workingFit

println("Starting curve_fit...")
fitOI = curve_fit(model, xOIData, yOIData, guessOI)

fitOI.dof
fitOI.param
fitOI.resid
fitOI.jacobian

curveResultsOI = Array(Float64, length(yOIData))
modelResultsOI = Array(Float64, length(yOIData))
workingResultsOI = Array(Float64, length(yOIData))

for i = 1:length(yOIData)
  curveResultsOI[i] = model(xOIData[i], fitOI.param)
  #modelResultsOI[i] = model(xOIData[i], guessOI) #guessing results
  workingResultsOI[i] = workingModel(xOIData[i], workingFit.param)
end

curveResultsOI

#Plots O I
fitLayerOI = layer(x = xOIData, y = curveResultsOI, Geom.smooth)
dataLayerOI = layer(x = xOIData, y = yOIData, Geom.point)
modelLayerOI = layer(x = xOIData, y = modelResultsOI, Geom.smooth)
workingFitOI = layer(x = xOIData, y = workingResultsOI, Geom.smooth)

fitOIPlot = plot(dataLayerOI, fitLayerOI, #=workingFitOI,=#
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))


























#Lorentzian Function

curveResultsAll = Array(Float64, length(yData))

for i = 1:length(yData)
  curveResultsAll[i] = model(xData[i], fit.param)
end

fitLayerAll = layer(x = xData, y = curveResultsAll, Geom.smooth)

dataLayerAll = layer(x = xData, y = yData, Geom.point)

plot(fitLayerAll, dataLayerAll,
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))

modelAll(337.2,fitAll.param)
modelAll(337.2,guessAll)

model(337.2,fit.param)
model(337.2, aGuess)

plot(layer(x = xData, y = fitAll.resid, Geom.smooth),
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))

fitAll = curve_fit(modelAll, xData, yData, guessAll)

#current curve fitting
fitOIPlot = plot(dataLayerOI, fitLayerOI,
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))

fitOIResidPlot = plot(layer(x = xOIData, y = fitOI.resid, Geom.smooth),
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Residual"), Guide.title("Residual from curve fitting results"))











parameterResults = Array(float64, numberOfPeaks, 3)

fitCurves(x,p) = curve_simulation(model(x,p), parameterResults)


function spectra_simulation(modelFunction(x,p)::Function, parameterResults)



end


