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

areaOI = Gadfly.plot(x = csvArray[:,1], y = csvArray[:,20], Geom.line,
                    Guide.xlabel("Wavelength (nm)"), Guide.ylabel("Intensity"), Guide.title("Shot Number"))

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
wavelengthOne = 289.9785
wavelengthOI = 777.5388
wavelengthTwo = 337.2671
meanColumn = size(csvArray)[2]

#example One
rowOne = findWaveRow(wavelengthOne, csvArray)
peakOne = findClosestMax(rowOne, meanColumn, csvArray)
localArrayOne = arrayLayers(peakOne, meanColumn, 5, csvArray)
areasCentreOne = areaUnderCurveCentral(localArrayOne)
areasRightOne = areaUnderCurveRightSum(localArrayOne)
areaDeviationOne = vectorStandardDeviation(areasRightOne[:,2])


peakOneSmall = plot(layer(x = localArrayOne[:,1], y = localArrayOne[:,size(localArrayOne)[2]], Geom.smooth),
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of a combined peak"))

writeOutPlot(fileName, "doublePeak", peakOneSmall)


#example OI, use example two
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

xOneData = localArrayOne[:,1]
yOneData = localArrayOne[:,6]

xData = localArrayTwo[:,1]
yData = localArrayTwo[:,6]

xOIData = localArrayOI[:,1]
yOIData = localArrayOI[:,6]

stdDevOne = vectorStandardDeviation(xOneData)
stdDev = vectorStandardDeviation(xData)
stdDevOI = vectorStandardDeviation(xOIData)

peakMax = 0
peakOIMax = 0
peakOneMax = 0

globalMax = 0

for j = 1:length(yData)
  if peakOIMax < yOIData[j]
    peakOIMax = yOIData[j]
  end

  if peakMax < yData[j]
    peakMax = yData[j]
  end

   if peakOneMax < yOneData[j]
    peakOneMax = yOneData[j]
  end
end

for k = 1:size(csvArray)[1]
  if globalMax < csvArray[k, size(csvArray)[2]]
    globalMax = k
  end
end

maximumWavelength = csvArray[globalMax, 1]

aGuess = [peakMax, csvArray[peakTwo,1], 0.07]
aOneGuess = [peakOneMax, csvArray[peakOne,1], stdDevOne]
guessOI = [peakOIMax, csvArray[peakOI,1], stdDevOI]

p = Array(Float64, 3)
p[:] = 0
p

#Gaussian function
workingModel(x, p) = p[1]*exp(-abs(x-p[2])/(2*(p[3]^2)))
model(x, p) = p[1]*exp(-((x-p[2])^2)/(2*(p[3]^2)))
modelOI(x, p) = p[1]*exp(-abs(x-p[2])/(2*(p[3]^2)))
lorentzModel(x, p) = (1/pi)*(((1/2)*p[1])/((x-p[2])^2+((1/2)*p[1])^2))

modelTest(x, p) = -square((x-p[2]))

fit = curve_fit(lorentzModel, xData, yData, [csvArray[peakTwo,1], 0.07])
fitOne = curve_fit(model, xOneData, yOneData, aOneGuess)
fitOI = curve_fit(modelOI, xOIData, yOIData, guessOI)

fit.dof
fit.param
fit.resid
fit.jacobian

fitOi

curveResults = Array(Float64, length(yData))
modelResults = Array(Float64, length(yData))

curveOneResults = Array(Float64, length(yOneData))
modelOneResults = Array(Float64, length(yOneData))

curveResultsOI = Array(Float64, length(yData))
modelResultsOI = Array(Float64, length(yData))

for i = 1:length(yData)
  curveResults[i] = model(xData[i], fit.param)
  modelResults[i] = model(xData[i], aGuess)

  curveResults[i] = model(xOneData[i], fitOne.param)
  modelResults[i] = model(xOneData[i], aOneGuess)

  curveResultsOI[i] = model(xOIData[i], fitOI.param)
  modelResultsOI[i] = model(xOIData[i], guessOI)
end

curveResults




#plots two
fitLayer = layer(x = xData, y = curveResults, Geom.smooth)
dataLayer = layer(x = xData, y = yData, Geom.point)
modelLayer = layer(x = xData, y = modelResults, Geom.smooth)


#plots two
fitOneLayer = layer(x = xOneData, y = curveOneResults, Geom.smooth)
dataOneLayer = layer(x = xOneData, y = yOneData, Geom.point)
modelOneLayer = layer(x = xOneData, y = modelOneResults, Geom.smooth)


#Plots O I
fitLayerOI = layer(x = xOIData, y = curveResultsOI, Geom.smooth)
dataLayerOI = layer(x = xOIData, y = yOIData, Geom.point)
modelLayerOI = layer(x = xOIData, y = modelResultsOI, Geom.smooth)











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









#plots

#mean total spectrum
meanPlot = plotMeanValues(parsedArray, fileName)
writeOutPlot(fileName, "meanValuePlot", meanPlot)



#zoom in on peak
plotOne = layerPlots(localArrayOne)
writeOutPlot(fileName, "localPeakPlotOne", plotOne)

plotTwo = layerPlots(localArrayTwo)
writeOutPlot(fileName, "localPeakPlotTwo", plotTwo)

plotOI = layerPlots(localArrayOI)
writeOutPlot(fileName, "localPeakPlotOI", plotOI)


#area under curve over all shots
waveTwo = csvArray[peakTwo,1]

areasUnderTwo = Array(Float64, size(areasRightTwo)[1] -1,2)

for i = 1:size(areasRightTwo)[1] -1
  areasUnderTwo[i,1] = areasRightTwo[i,1]
  areasUnderTwo[i,2] = areasRightTwo[i,2]
end


areaTwo = Gadfly.plot(x = areasUnderTwo[:,1], y =areasUnderTwo[:,2], Geom.line,
            Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"),
            Guide.title("Area under the peak over time (wavelength = $waveTwo)"))

writeOutPlot(fileName, "areaUnderCurveTwo", areaTwo)






waveOI = csvArray[peakOI,1]
areasUnderOI = Array(Float64, size(areasRightOI)[1] -1,2)

for i = 1:size(areasRightTwo)[1] -1
  areasUnderOI[i,1] = areasRightOI[i,1]
  areasUnderOI[i,2] = areasRightOI[i,2]
end

areaOI = Gadfly.plot(x = areasRightOI[:,1], y =areasRightOI[:,2], Geom.line,
                    Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"), Guide.title("Area under the peak over time (wavelength = $waveOI)"))

writeOutPlot(fileName, "areaUnderCurveOI", areaOI)





#current curve fitting
fitOnePlot = plot(dataOneLayer, fitOneLayer,
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))

fitPlot = plot(dataLayer, fitLayer,
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))

writeOutPlot(fileName, "currentFitTwo", fitPlot)


fitOIPlot = plot(dataLayerOI, fitLayerOI,
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))

writeOutPlot(fileName, "currentFitOI", fitOIPlot)


#residual
fitResidPlotTwo = plot(layer(x = xData, y = fit.resid, Geom.smooth),
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Residual"), Guide.title("Residual from curve fitting results"))

writeOutPlot(fileName, "residualTwo", fitResidPlotTwo)


fitOIResidPlot = plot(layer(x = xOIData, y = fitOI.resid, Geom.smooth),
      Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Residual"), Guide.title("Residual from curve fitting results"))

writeOutPlot(fileName, "residualOI", fitOIResidPlot)



spy(csvArray)



parameterResults = Array(float64, numberOfPeaks, 3)

fitCurves(x,p) = curve_simulation(model(x,p), parameterResults)


function curve_simulation(modelFunction(x,p)::Function, parameterResults)



end



http://pds-geosciences.wustl.edu/msl/msl-m-chemcam-libs-4_5-rdr-v1/mslccm_1xxx/data/sol00899/

csvArray = readdlm("http://pds-geosciences.wustl.edu/msl/msl-m-chemcam-libs-4_5-rdr-v1/mslccm_1xxx/data/sol00899/cl5_477306561ccs_f0450150ccam01899p3.csv", ',', Float64)



download("http://pds-geosciences.wustl.edu/msl/msl-m-chemcam-libs-4_5-rdr-v1/mslccm_1xxx/data/sol00899/cl5_477306561ccs_f0450150ccam01899p3.csv")
read(julia)

read()
