"""
Physics Research Project
Devin Rose
More testing and code development
"""


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

#find row for wavelength
#OI = oxygen one
wavelengthOI = 777.5388
wavelengthTwo = 337.2671
meanColumn = size(csvArray)[2]

#example one, use example two
rowOI = findWaveRow(wavelengthOI, csvArray)
peakOI = findClosestMax(rowOI, meanColumn, csvArray)
#Change localArray to report local until finding the first local min
localArrayOI = arrayLayers(peakOI, meanColumn, 5, csvArray)
areasCentreOI = areaUnderCurveCentral(localArrayOI)
areasRightOI = areaUnderCurveRightSum(localArrayOI)
areaDeviationOI = vectorStandardDeviation(localArrayOI[:,1])

#example two, run this code
rowTwo = findWaveRow(wavelengthTwo, csvArray)
peakTwo = findClosestMax(rowTwo, meanColumn, csvArray)
localArrayTwo = arrayLayers(peakTwo, meanColumn, 5, csvArray)
areasCentreTwo = areaUnderCurveCentral(localArrayTwo)
areasRightTwo = areaUnderCurveRightSum(localArrayTwo)
areaDeviationTwo = vectorStandardDeviation(localArrayTwo[:,1])


#Testing area is located below
using LsqFit

g(x) = (1/(areaDeviationTwo*sqrt(2pi)))exp((-(x-wavelengthTwo)^2)/2areaDeviationTwo^2)

normalization = 1/(areaDeviationTwo*sqrt(2pi))

xData = localArrayTwo[:,1]
yData = localArrayTwo[:,6]

xOIData = localArrayOI[:,1]
yOIData = localArrayOI[:,6]

stdDev = vectorStandardDeviation(xData)
stdDevOI = vectorStandardDeviation(xOIData)

peakMax = 0
peakOIMax = 0

globalMax = 0

for j = 1:length(yData)
  if peakOIMax < yOIData[j]
    peakOIMax = yOIData[j]
  end

  if peakMax < yData[j]
    peakMax = yData[j]
  end
end

for k = 1:size(csvArray)[1]
  if globalMax < csvArray[k, size(csvArray)[2]]
    globalMax = k
  end
end

maximumWavelength = csvArray[globalMax, 1]

aGuess = [peakMax, csvArray[peakTwo,1], 0.07]
guessOI = [peakOIMax, csvArray[peakOI,1], stdDevOI]

#Gaussian function
workingModel(x, p) = p[1]*exp(-abs(x-p[2])/(2*(p[3]^2)))
model(x, p) = p[1]*exp(-abs(x-p[2])/(2*(p[3]^2)))
modelOI(x, p) = p[1]*exp(-((abs(csvArray[peakOI,1]*x)-x*p[2]+p[2]^2))/(2*(p[3]^2)))

fit = curve_fit(model, xData, yData, aGuess)
fitOI = curve_fit(modelOI, xOIData, yOIData, guessOI)

fit.dof
fit.param
fit.resid
fit.jacobian

fitOi

curveResults = Array(Float64, length(yData))
modelResults = Array(Float64, length(yData))

curveResultsOI = Array(Float64, length(yData))
modelResultsOI = Array(Float64, length(yData))

for i = 1:length(yData)
  curveResults[i] = model(xData[i], fit.param)
  modelResults[i] = model(xData[i], aGuess)

  curveResultsOI[i] = model(xOIData[i], fitOI.param)
  modelResultsOI[i] = model(xOIData[i], guessOI)
end

curveResults

#plots two
fitLayer = layer(x = xData, y = curveResults, Geom.smooth)
dataLayer = layer(x = xData, y = yData, Geom.point)
modelLayer = layer(x = xData, y = modelResults, Geom.smooth)

plot(dataLayer, fitLayer,
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))

plot(layer(x = xData, y = fit.resid, Geom.smooth),
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))



#Plots O I
fitLayerOI = layer(x = xOIData, y = curveResultsOI, Geom.smooth)
dataLayerOI = layer(x = xOIData, y = yOIData, Geom.point)
modelLayerOI = layer(x = xOIData, y = modelResultsOI, Geom.smooth)

plot(dataLayerOI, fitLayerOI,
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))

plot(layer(x = xOIData, y = fitOI.resid, Geom.smooth),
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))














#Lorentzian Function

L(x)=1/pi(1/2Gamma)/((x-x_0)^2+(1/2Gamma)^2),

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
