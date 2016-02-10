"""
Physics Research Project
Devin Rose
Contains one function that will use other functions for a full analysis
"""

#Function used for a full analysis of all data in the dataToAnalyze section
#=
  - add paramater to fit certain sol dates
=#
function fullAnalysis(printReport::Bool, testingParams::Bool, fitFunction::Int64)
  @assert(fitFunction > 0 && fitFunction < 5, "The fit type must be an integer of 1,2,3, or 4")

  #All files to analyze
  print("Running dataAnalysis.jl from "*split(Base.source_path(), "dataAnalysis.jl")[1]*"dataAnalysis.jl")
  allFiles = findFilesToAnalyze()
  totalFiles = length(allFiles)
  print("Analyzing a total of $totalFiles files. \n")

  #wavelengths to check
  wavelength = [289.9785, 337.2671, 766.48991, 777.5388]

  #=if fitFunction == 1
    MODEL = MODEL_1
  elseif fitFuntion == 2
    MODEL = MODEL_2
  elseif fitFuntion == 3
    MODEL = MODEL_3
  elseif fitFuntion == 4
    MODEL = MODEL_4
  end=#

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
      writeOutPlot(fileName, "meanValuePlot", meanPlot)
      spectraPlot = plotMeanValues(parsedArray, fileName, true)
      writeOutPlot(fileName, "meanValueSpectrum", spectraPlot)

      for peakNum = 1:length(wavelength)
        row = findWaveRow(wavelength[peakNum], csvArray)
        peak = findClosestMax(row, fitColumn, csvArray)
        wave = csvArray[peak,1]
        if peak != null
          #Change localArray to report local until finding the first local min
          localArray = arrayLayers(peak, 5, csvArray)

          #x and y data for each peak to fit
          xData = localArray[:,1]
          yData = localArray[:,fitColumn]

          fitPlot = generateFitPlots(csvArray, xData, yData, fileName, peak, testingParams, fitFunction)
          writeOutPlot(fileName, "currentFit[peak-$wave]", fitPlot)

          if printReport
            print("calling plot functions for \n \t peakNum = $peakNum \n \t name = $fileName \n")
          end

          try
            areaPlot = areaUnderCurveRiemann(localArray)

            writeOutPlot(fileName, "areaUnderCurveProgression[peak-$wave]", areaPlot)
          catch
            error
          end

          #zoom in on peak
          peakLayers = layerPlots(localArray) # just layering

          if peakLayers != null
            #writeOutPlot(fileName, "localPeakPlotOverAllShots[peak-$wave]", peakLayers)
          end

          peakPlot = plot(layer(x = xData, y = yData, Geom.point),
              Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of one peak"))
          writeOutPlot(fileName, "localPeakPlot[peak-$wave]", peakPlot)

          #zoom in on one peak
          peakSmall = plot(layer(x = localArray[:,1], y = localArray[:,size(localArray)[2]], Geom.smooth),
              Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"), Guide.title("Local plot of a combined peak"))
          writeOutPlot(fileName, "zoomIn[peak-$wave]", peakSmall)

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
