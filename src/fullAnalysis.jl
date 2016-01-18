"""
Physics Research Project
Devin Rose
Contains one function that will use other functions for a full analysis
"""

#Function used for a full analysis of all data in the dataToAnalyze section
function fullAnalysis()
  #All files to analyze
  allFiles = findFilesToAnalyze()
  totalFiles = length(allFiles)
  print("Analyzing a total of $totalFiles files. \n")

  #Gaussian function used as a model
  model(x, param) = param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2)))

  #wavelengths to check
  wavelength = [289.9785, 337.2671, 777.5388]

  #for all possible files
  for fileNum = 1:totalFiles
    #ProgressMeter
    progressBar = Progress(totalFiles, 5, "Writing file $fileNum of $totalFiles", 30)

    #Add progress bar
    fileName = allFiles[fileNum]

    #initial functions called
    csvArray = importFile(fileName)

    if(csvArray != null)
      createDirectoryForReport(fileName)
      parsedArray = parseArray(csvArray)
      #=not yet needed
      calculatedMean = vectorMean(parsedArray[:,2])
      areaOfLowValues = errorIntervals(parsedArray, calculatedMean)
      minimumError = calculateBackgroundMinimumError(areaOfLowValues, parsedArray)
      maxAndMinWavelength = wavelengthDifferetial(parsedArray)=#

      #Defining the mean column
      meanColumn = size(csvArray)[2]
      fitColumn = 6

      #Pre-analysis plots
      #mean total spectrum
      meanPlot = plotMeanValues(parsedArray, fileName)
      writeOutPlot(fileName, "meanValuePlot", meanPlot)

      for peakNum = 1:length(wavelength)
        row = findWaveRow(wavelength[peakNum], csvArray)
        peak = findClosestMax(row, fitColumn, csvArray)
        #Change localArray to report local until finding the first local min
        localArray = arrayLayers(peak, fitColumn, 5, csvArray)
        areasCentre = areaUnderCurveCentral(localArray)
        areasRight = areaUnderCurveRightSum(localArray)
        areaDeviation = vectorStandardDeviation(localArray[:,1])

        #x and y data for each peak to fit
        xData = localArray[:,1]
        yData = localArray[:,6]

        #stdDev = vectorStandardDeviation(xOneData)
        stdDev = vectorStandardDeviation(xData)

        #finding max peak vlaues for fitting paramaters
        peakMax = 0

        for j = 1:length(yData)
          if peakMax < yData[j]
            peakMax = yData[j]
          end
        end

        #finding global max
        globalMax = 0

        for k = 1:size(csvArray)[1]
          if globalMax < csvArray[k, size(csvArray)[2]]
            globalMax = k
          end
        end

        maximumWavelength = csvArray[globalMax, 1]

        #fit routine
        paramGuess = [peakMax, csvArray[peak,1], stdDev]
        fit = curve_fit(model, xData, yData, paramGuess)

        #results
        curveResults = Array(Float64, length(yData))

        for i = 1:length(yData)
          curveResults[i] = model(xData[i], fit.param)
        end

        #plots

        #area under curve over all shots
        wave = csvArray[peak,1]
        areasUnder = Array(Float64, size(areasCentre)[1] -1,2)

        for i = 1:size(areasUnder)[1] -1
          areasUnder[i,1] = areasCentre[i,1]
          areasUnder[i,2] = areasCentre[i,2]
        end

        #area under curve shot progression
        areaPlot = Gadfly.plot(x = areasUnder[:,1], y =areasUnder[:,2], Geom.line,
                               Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"),
                               Guide.title("Area under the peak over time (wavelength = $wave)"))

        writeOutPlot(fileName, "areaUnderCurveProgression$peakNum", areaPlot)

        #zoom in on peak
        peakLayers = layerPlots(localArray) # just layering

        if peakLayers != null
          peakPlot = plot(layer(x = localArray[:,1], y = localArray[:,size(localArray)[2]], Geom.smooth),
            Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of a combined peak"))
          writeOutPlot(fileName, "localPeakPlot[peak$peakNum]", peakPlot)
        end

        #zoom in on one fit
        fitLayer = layer(x = xData, y = curveResults, Geom.smooth)
        dataLayer = layer(x = xData, y = yData, Geom.point)

        peakSmall = plot(layer(x = localArray[:,1], y = localArray[:,size(localArray)[2]], Geom.smooth),
            Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of a combined peak"))
        writeOutPlot(fileName, "zoomIn[peak$peakNum]", peakSmall)

        #curve fitting
        fitPlot = plot(dataLayer, fitLayer,
            Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))

        writeOutPlot(fileName, "currentFit[peak$peakNum]", fitPlot)

        #curve fitting residual
        fitResidPlot = plot(layer(x = xData, y = fit.resid, Geom.smooth),
            Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Residual"), Guide.title("Residual from curve fitting results"))

        writeOutPlot(fileName, "Residual[peak$peakNum]", fitResidPlot)
      end #end for peanNum
    end #end if null csvArray
    next!(progressBar)
  end #end for fileNum

  #readall() script to open the reports directory
end
