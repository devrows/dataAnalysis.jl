"""
Physics Research Project
Devin Rose
Contains one function that will use other functions for a full analysis
"""

#Function used for a full analysis of all data in the dataToAnalyze section
function fullAnalysis(printReport::Bool, testingParams::Bool)
  #=
    - add paramater to fit certain sol dates
      - Obviously findFilesToAnalyze will need to be updated
    - add paramater for the type of fit
  =#

  #All files to analyze
  print("Running dataAnalysis.jl from "*split(Base.source_path(), "dataAnalysis.jl")[1]*"dataAnalysis.jl")
  allFiles = findFilesToAnalyze()
  totalFiles = length(allFiles)
  print("Analyzing a total of $totalFiles files. \n")

  #wavelengths to check
  wavelength = [289.9785, 337.2671, 766.48991, 777.5388]

  #for all possible files
  for fileNum = 1:totalFiles
    #ProgressMeter
    progressBar = Progress(totalFiles, 1, "Writing file $fileNum of $totalFiles", 30)

    #get files for analysis
    fileName = allFiles[fileNum]
    if typeof(fileName) != ASCIIString
      fileName = convert(ASCIIString, fileName)
    end

    #initial functions called
    #print("Importing file = $fileName into csvArray \n")
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
      #fitColumn = 6
      fitColumn = meanColumn

      #Pre-analysis plots
      #mean total spectrum
      meanPlot = plotMeanValues(parsedArray, fileName, false)
      spectraPlot = plotMeanValues(parsedArray, fileName, true)
      writeOutPlot(fileName, "meanValuePlot", meanPlot)
      writeOutPlot(fileName, "meanValueSpectrum", spectraPlot)

      for peakNum = 1:length(wavelength)
        row = findWaveRow(wavelength[peakNum], csvArray)
        peak = findClosestMax(row, fitColumn, csvArray)
        if #=abs(peak-wavelength[peakNum]) < 5 &&=# peak != null
          #Change localArray to report local until finding the first local min
          localArray = arrayLayers(peak, fitColumn, 5, csvArray)
          areasCentre = areaUnderCurveCentral(localArray)
          areasRight = areaUnderCurveRightSum(localArray)
          areaDeviation = vectorStandardDeviation(localArray[:,1])

          #x and y data for each peak to fit
          xData = localArray[:,1]
          yData = localArray[:,fitColumn]

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
          peakOneMax = 0.7*peakMax
          peakTwoMax = 0.4*peakMax

          #Curve fitting routine
          paramGuess = [peakOneMax, csvArray[peak,1], 0.5*stdDev, peakTwoMax, csvArray[peak,1], 0.01*stdDev]
          fit = curve_fit(MODEL, xData, yData, paramGuess)

          #results
          curveResults = Array(Float64, length(yData))

          for i = 1:length(yData)
            curveResults[i] = MODEL(xData[i], fit.param)
          end

          #plots

          #area under curve over all shots
          wave = csvArray[peak,1]
          areasUnder = Array(Float64, size(areasCentre)[1] -1,2)

          for i = 1:size(areasUnder)[1] -1
            areasUnder[i,1] = areasCentre[i,1]
            areasUnder[i,2] = areasCentre[i,2]
          end

          if printReport
            print("calling plot functions for \n \t peakNum = $peakNum \n \t name = $fileName \n")
          end

          try
            #area under curve shot progression
            areaPlot = Gadfly.plot(x = areasUnder[:,1], y =areasUnder[:,2], Geom.line,
                                 Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"),
                                 Guide.title("Area under the peak over time (wavelength = $wave nm)"))

            writeOutPlot(fileName, "areaUnderCurveProgression[peak-$wave]", areaPlot)
          catch
            error
          end

          #zoom in on peak
          peakLayers = layerPlots(localArray) # just layering

          if peakLayers != null
            peakPlot = plot(layer(x = localArray[:,1], y = localArray[:,size(localArray)[2]], Geom.smooth),
              Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of a combined peak"))
            writeOutPlot(fileName, "localPeakPlot[peak-$wave]", peakPlot)
          end

          #zoom in on one peak
          peakSmall = plot(layer(x = localArray[:,1], y = localArray[:,size(localArray)[2]], Geom.smooth),
              Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of a combined peak"))
          writeOutPlot(fileName, "zoomIn[peak-$wave]", peakSmall)

          #curve fitting
          yMins = yData - 0.05*yData
          yMaxs = yData + 0.05*yData

          fitLayer = layer(x = xData, y = curveResults, Geom.smooth)
          dataLayer = layer(x = xData, y = yData, ymin = yMins, ymax = yMaxs, Geom.point, Geom.errorbar)

          if testingParams
            paramResults = Array(Float64, length(yData))

            for i = 1:length(yData)
              paramResults[i] = MODEL(xData[i], paramGuess)
            end

            paramLayer = layer(x = xData, y = paramResults, Geom.smooth)

            fitPlot = plot(dataLayer, fitLayer, paramLayer,
              Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))
          else
            fitPlot = plot(dataLayer, fitLayer,
              Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of Curve fit"))
          end

          writeOutPlot(fileName, "currentFit[peak-$wave]", fitPlot)

          #curve fitting residual
          fitResidPlot = plot(layer(x = xData, y = fit.resid, Geom.smooth),
              Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Residual"), Guide.title("Residual from curve fitting results"))

          writeOutPlot(fileName, "Residual[peak-$wave]", fitResidPlot)

          if printReport
            print("It worked \n")
          end

        end #end if valid peak
      end #end for peakNum
    end #end if null csvArray
    next!(progressBar)
  end #end for fileNum

  #readall() script to open the reports directory
end
