"""
Physics Research Project
Devin Rose
Contains one function that will use other functions for a full analysis
"""


#Function used for a full analysis of all data in the dataToAnalyze section
#=
  - add paramater to fit certain sol dates
=#
function fullAnalysis(printReport::Bool, testingParams::Bool, fitFunction::Int64, fitDisplay::Bool, testingModel=null::Function)
  @assert(fitFunction > 0 && fitFunction < 6, "The fit type must be an integer of 1,2,3, 4, 5")

  #All files to analyze
  print("Running dataAnalysis.jl from "*split(Base.source_path(), "dataAnalysis.jl")[1]*"dataAnalysis.jl")
  allFiles = findFilesToAnalyze()
  totalFiles = length(allFiles)
  oxideComp = OxideComponents()

  #wavelengths to check
  #337.2671, 289.something for double peaks
  wavelength = [777.5388, 844.85, #O2=1,2
                288.21, 412.05, 634.85, #SiO2=3,4,5
                766.48991, 766.7, 770.1, #K2O=6,NOT7,8, 7 and 8 are the same peak
                589.2, 818.6, 819.8, #Na2O=9,10,11
                279.6, 285.29, 293.74, 518.50, #MgO=12,13,14,NOT15
                289.9785, 289.75, 337.2671] #Calcium, or iron

  fullReport = Array(ASCIIString, 1, 8)
  fullReport[1,:] = ["File", "Sol Number",
                     "SiO2 Area", "MgO Area", "Na2O Area", "K2O Area", "Oxygen Area", "Total Oxide Components (Oxygen not included)"]

  #Initialize the ProgressMeter
  progressBar = Progress(totalFiles, 3, " Writing file 1 of $totalFiles ", 30)

  #for all possible files
  for fileNum = 1:totalFiles
    progressBar.desc = " Writing file $fileNum of $totalFiles "
    #display(progressBar)

    #get files for analysis
    fileName = allFiles[fileNum]
    if typeof(fileName) != ASCIIString
      fileName = convert(ASCIIString, fileName)
    end

    #Importing .csv file
    csvArray = importFile(fileName)

    if(csvArray != null)
      fileReport = Array(ASCIIString, 1, 8)
      fileReport[1,1:2] = [split(fileName, "/")[2], split(fileName, "/")[1]]
      oxideComp.setZero!(oxideComp)

      createDirectoryForReport(fileName)
      parsedArray = parseArray(csvArray)

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
          localArray = findLocalArray(peak, 4, csvArray)

          #x and y data for each peak to fit
          xData = localArray[:,1]
          yData = localArray[:,fitColumn]

          fit_results = generateFitPlots(csvArray, xData, yData, fileName, peak,
            testingParams, fitFunction, testingModel, fitDisplay)

          if fitFunction == 2
            FWHM_L = 2*fit_results.param[1]
            height_L = MODEL_2(fit_results.param[2], fit_results.param)
            area = FWHM_L*height_L
          elseif fitFunction == 5
            #write testing code here
            sigmaTest = 0.8*fit_results.param[3]
            heightTest = fit_results.param[1]
            area = sigmaTest*heightTest
          else
            sigma1 = fit_results.param[3]
            FWHM_G = 2*sigma1*sqrt(2*log(e, 2))
            height_G = fit_results.param[1]
            area = FWHM_G*height_G
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
        end #end if peak != null

        #switch to array to make the code easy to read
        if peakNum < 3
          oxideComp.O2 += area
        elseif peakNum > 2 && peakNum < 6
          oxideComp.Si += area
        elseif peakNum == 6 || peakNum == 8
          oxideComp.K2 += area
        elseif peakNum > 8 && peakNum < 12
          oxideComp.Na2 += area
        elseif peakNum > 11 && peakNum < 15
          oxideComp.Mg += area
        end
      end #end for peakNum

      totalOxideComponents = oxideComp.Si+oxideComp.K2+oxideComp.Na2+oxideComp.Mg
      fileReport[1, 3:8] = ["$(oxideComp.Si/oxideComp.O2)", "$(oxideComp.Mg/oxideComp.O2)",
                            "$(oxideComp.Na2/oxideComp.O2)","$(oxideComp.K2/oxideComp.O2)",
                            "$(oxideComp.O2/oxideComp.O2)", "$totalOxideComponents"]
      fullReport = vcat(fullReport, fileReport)
    end #end if null csvArray
    next!(progressBar)
  end #end for fileNum

  #summary for entire report
  comparisonMoc = compareMoc(fullReport)

  cd()
  cd(split(Base.source_path(), "dataAnalysis.jl")[1]"dataAnalysis.jl/docs/reports")

  writedlm("elemetCompositionInfo[fitType=$fitFunction].csv", fullReport, ',')
  writedlm("comparisonWithRelevantMocData[fitType=$fitFunction].csv", comparisonMoc, ',')

  for elementNum = 1:4
    comparisonPlot = plotMoc(comparisonMoc, elementNum)

    draw(PNG("plotOfComparisonWithMocData[fitType=$fitFunction,elementNum=$elementNum].png", 6inch, 4.5inch), comparisonPlot)
  end

  return fullReport
end
