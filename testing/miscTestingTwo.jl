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
wavelengthOne = 289.9785
wavelengthTwo = 337.2671
meanColumn = size(csvArray)[2]

#example one, use example two
rowOne = findWaveRow(wavelengthOne, csvArray)
peakOne = findClosestMax(rowOne, meanColumn, csvArray)
localArrayOne = arrayLayers(peakOne, meanColumn, 5, csvArray)
areasCentreOne = areaUnderCurveCentral(localArrayOne)
areasRightOne = areaUnderCurveRightSum(localArrayOne)
areaDeviationOne = vectorStandardDeviation(areasRightOne[:,2])

#example two, run this code
rowTwo = findWaveRow(wavelengthTwo, csvArray)
peakTwo = findClosestMax(rowTwo, meanColumn, csvArray)
localArrayTwo = arrayLayers(peakTwo, meanColumn, 5, csvArray)
areasCentreTwo = areaUnderCurveCentral(localArrayTwo)
areasRightTwo = areaUnderCurveRightSum(localArrayTwo)
areaDeviationTwo = vectorStandardDeviation(areasRightTwo[:,2])

#plots
plot = plotMeanValues(parsedArray, fileName)

#plots one
plotOne = layerPlots(localArrayOne)
waveOne = csvArray[peakOne,1]
Gadfly.plot(x = areasRightOne[:,1], y =areasRightOne[:,2], Geom.line,
            Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"),
            Guide.title("Area under the peak over time (wavelength = $waveOne)"))

#plots two
plotTwo = layerPlots(localArrayTwo)
waveTwo = csvArray[peakTwo,1]
Gadfly.plot(x = areasRightTwo[:,1], y =areasRightTwo[:,2], Geom.line,
                    Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"), Guide.title("Area under the peak over time (wavelength = $waveTwo)"))


#Testing area is located below
using LsqFit

#a = normalization,
#c = standard deviation

g(x) = (1/(areaDeviationTwo*sqrt(2pi)))exp((-(x-wavelengthTwo)^2)/2areaDeviationTwo^2)
model(x, a) = a[1]*exp((-(x-a[2])^2)/2c^2)

f(x,a,b,c) = a*exp((-(x-b)^2)/2c^2)
J1(x,a,b,c) = exp((-(x-b)^2)/2c^2)
J2(x,a,b,c) = (a*(x-b)/c^2)*exp((-(x-b)^2)/2c^2)
J3(x,a,b,c) = (a*((x-b)^2)/c^3)*exp((-(x-b)^2)/2c^2)

s1(yi,xi,a,b,c,delta) = (yi-f(xi,a,b,c)-J1(xi,a,b,c)*delta)^2
s2(yi,xi,a,b,c,delta) = (yi-f(xi,a,b,c)-J2(xi,a,b,c)*delta)^2
s3(yi,xi,a,b,c,delta) = (yi-f(xi,a,b,c)-J3(xi,a,b,c)*delta)^2

normalization = 1/(areaDeviationTwo*sqrt(2pi))

aGuess = [normalization
          wavelengthTwo
          areaDeviationTwo]

a = normalization
b = wavelengthTwo
c = areaDeviationOne

x = localArrayTwo[:,size(localArrayTwo)[1]]
y = localArrayTwo[:,size(localArrayTwo)[2]]



curve_fit(model, x, y, aGuess)

#start with delta = 0
delta = 0
sumOfSquares1Init = 0
sumOfSquares2Init = 0
sumOfSquares3Init = 0



#for the first point
for i = 1:length(x)
  sumOfSquares1Init += s1(y[i],x[i],a,b,c,delta)
end

s2(y[1],x[1],a,b,c,delta)

for i = 1:length(x)
  sumOfSquares2Init += s2(y[i],x[i],a,b,c,delta)
end

for i = 1:length(x)
  sumOfSquares3Init += s3(y[i],x[i],a,b,c,delta)
end

deltaOne = 0
deltaTwo = 0
deltaThree = 0
sumOfSquares1Final = 0


#upwards
while (sumOfSquares1Init < sumOfSquares1Final) && (checkOne < 500)
  while (sumOfSquares2Init < sumOfSquares2Final) && (checkOne < 500)
    sumOfSquares2Init = sumOfSquares2Final
    while (sumOfSquares3Init < sumOfSquares3Final) && (checkOne < 500)
      sumOfSquares3Init = sumOfSquares3Final
      sumOfSquares3Final = 0
      for i = 1:length(x)
        sumOfSquares3Final += s3(y[i],x[i],a,b,c,deltaThree)
      end
      deltaThree += 0.001
      checkThree += 1
    end
    sumOfSquares2Final = 0
    for i = 1:length(x)
      sumOfSquares2Final += s2(y[i],x[i],a,b,c,deltaTwo)
    end
    deltaTwo += 0.001
    checkTwo += 1
  end
  sumOfSquares1Final = 0
  for i = 1:length(x)
    sumOfSquares1Final += s1(y[i],x[i],a,b,c,deltaOne)
  end
  deltaThree+=0.001
  checkOne += 1
  sumOfSquares1Init = sumOfSquares1Final
end

