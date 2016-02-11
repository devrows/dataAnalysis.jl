"""
Physics Research Project
Devin Rose
Contains one function that will use other functions for a full analysis
"""

#Function used for a full analysis of all data in the dataToAnalyze section
#=
  - add paramater to fit certain sol dates
=#
function fullAnalysis(printReport::Bool, testingParams::Bool, fitFunction::Int64, testingModel=null::Function)
  @assert(fitFunction > 0 && fitFunction < 6, "The fit type must be an integer of 1,2,3, 4, 5")

  #All files to analyze
  print("Running dataAnalysis.jl from "*split(Base.source_path(), "dataAnalysis.jl")[1]*"dataAnalysis.jl")
  allFiles = findFilesToAnalyze()
  totalFiles = length(allFiles)
  print("Analyzing a total of $totalFiles files. \n")

  #wavelengths to check
  #337.2671
  wavelength = [288.21, 412.05, 634.85, 766.48991, 770.1, 777.5388, 844.85]

  #for all possible files
  for fileNum = 1:totalFiles
    #Initialize the ProgressMeter
    progressBar = Progress(totalFiles, 5, "Writing file $fileNum of $totalFiles", 30)

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
      fullReport = Array(ASCIIString, 1, 5)
      fullReport[1,:] = ["File name", "Wavelength", "Element",
                         "Max Peak", "Area Under the curve"]
      #Write out to a new file for each element, then maybe combine it with all moc files
      #Plot each each element against oxygen separately
      #Plot my abundance calculations against theirs

      #Defining the mean column
      meanColumn = size(csvArray)[2]
      fitColumn = meanColumn

      #Pre-analysis plots
      #mean total spectrum
      #changed parsedArray to csvArray
      meanPlot = plotMeanValues(csvArray, fileName, false)
      spectraPlot = plotMeanValues(csvArray, fileName, true)

      for peakNum = 1:length(wavelength)
        row = findWaveRow(wavelength[peakNum], csvArray)
        peak = findClosestMax(row, fitColumn, csvArray)
        wave = csvArray[peak,1]
        if peak != null
          #Change localArray to report local until finding the first local min
          localArray = findLocalArray(peak, 3, csvArray)

          #x and y data for each peak to fit
          xData = localArray[:,1]
          yData = localArray[:,fitColumn]

          fit_results = generateFitPlots(csvArray, xData, yData, fileName, peak, testingParams, fitFunction, testingModel)


          if printReport
            print("calling plot functions for \n \t peakNum = $peakNum \n \t name = $fileName \n")
          end

          try
            areasUnderEstimate = areaUnderCurveRiemann(localArray, fileName)
          catch
            error
          end

          #zoom in on peak
          peakLayers = layerPlots(localArray) # just layering

          try
            writeOutPlot(fileName, "localPeakPlotOverAllShots[peak-$wave]", peakLayers)
          catch
            error
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
