"""
Physics Research Project
Devin Rose
Contains functions that will be used for actual plotting of data
"""


#Function for
function areaUnderCurveRiemann(local_array::Array)
  #area under curve over all shots
  areasCentre = areaUnderCurveCentral(local_array)
  areasUnder = Array(Float64, size(areasCentre)[1] -1,2)

  for i = 1:size(areasUnder)[1] -1
    areasUnder[i,1] = areasCentre[i,1]
    areasUnder[i,2] = areasCentre[i,2]
  end

  #area under curve shot progression
  areaPlot = Gadfly.plot(x = areasUnder[:,1], y =areasUnder[:,2], Geom.point,
                         Guide.xlabel("Shot Number"), Guide.ylabel("Area under the peak"),
                         Guide.title("Area under the peak over time (wavelength = $wave nm)"))

  writeOutPlot(fileName, "areaUnderCurveProgression[peak-$wave]", areaPlot)

  return areasUnder
end


#Function for fitting curve and generating a plot of the fit
function generateFitPlots(csv_array::Array, x_data::Array, y_data::Array,
  file_name::ASCIIString, peak::Int64, testing_params::Bool, fit_function::Int64,
  MODEL::Function, displayFit::Bool)

  #stdDev = vectorStandardDeviation(xOneData)
  stdDev = vectorStandardDeviation(x_data)

  #finding max peak vlaues for fitting paramaters
  peakMax = 0

  for j = 1:length(y_data)
    if peakMax < y_data[j]
      peakMax = y_data[j]
    end
  end

  #results
  curveResults = Array(Float64, length(y_data))
  peakLocation = csv_array[peak,1]
  weightVector =  Array(Float64, length(y_data))
  paramToSkip = 0
  for it = 1:length(y_data)
    weightVector[it] = 0.1*y_data[it]
  end

  #Curve fitting routine
  if fit_function == 1
    MODEL = MODEL_1
    paramGuess = [1.2*peakMax, peakLocation, 0.5*stdDev]
  elseif fit_function == 2
    MODEL = MODEL_2
    paramGuess = [2/(pi*peakMax), peakLocation]
  elseif fit_function == 3
    MODEL = MODEL_3
    peakOneMax = 0.8*peakMax
    peakTwoMax = 0.3*peakMax

    paramGuess = [peakOneMax, peakLocation, 0.5*stdDev, 2/peakTwoMax, peakLocation]
  elseif fit_function == 4
    MODEL = MODEL_4
    peakOneMax = 0.8*peakMax
    peakTwoMax = 0.4*peakMax

    paramGuess = [peakOneMax, peakLocation, 0.4*stdDev, peakTwoMax, peakLocation, 0.4*stdDev]
    elseif fit_function == 5
    #MODEL is already defined

    paramGuess = [peakMax, peakLocation, stdDev, 0.05]
  end

  fit = curve_fit(MODEL, x_data, y_data, weightVector, paramGuess)
  #fit = curve_fit(MODEL, x_data, y_data, paramGuess)

  wave = csv_array[peak,1]

  try
    fitResidPlot = plot(layer(x = x_data, y = fit.resid, Geom.point),
                        Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Residual of curve fitting at $wave"), Guide.title("Residual from curve fitting results"))
    writeOutPlot(file_name, "Residual[peak-$wave]", fitResidPlot)
  catch
    MethodError
  end

  for i = 1:length(y_data)
    curveResults[i] = MODEL(x_data[i], fit.param)
  end

  #curve fitting
  yMins = y_data - 0.1*y_data
  yMaxs = y_data + 0.1*y_data

  fitLayer = layer(x = x_data, y = curveResults, Geom.smooth)
  dataLayer = layer(x = x_data, y = y_data, ymin = yMins, ymax = yMaxs, Geom.point, Geom.errorbar)

  if testing_params
    paramResults = Array(Float64, length(y_data))

    for i = 1:length(y_data)
      paramResults[i] = MODEL(x_data[i], paramGuess)
    end

    paramLayer = layer(x = x_data, y = paramResults, Geom.smooth)

    fitPlot = plot(dataLayer, fitLayer, paramLayer,
                   #=Guide.manual_color_key("Legend", ["dataLayer", "fitLayer", "paramLayer"], ["green", "deepskyblue", "black"]),=#
                   Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"),
                   Guide.title("Local plot of Curve fit (wavelength = $wave)"))
  else
    fitPlot = plot(dataLayer, fitLayer,
                   Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Peak Intensity"),
                   Guide.title("Local plot of Curve fit (wavelength = $wave)"))
  end

  writeOutPlot(file_name, "currentFit[peak-$wave]", fitPlot)
  if displayFit
    display(fitPlot)
  end

  return fit
end


#Plotting the mean values
function plotMeanValues(arrayToPlot::Array, fileName::ASCIIString, plotErrors::Bool)
  """
  Plots the mean value of the data
  Packages used: Gadfly
  """

  max_x = 0

  while max_x < size(arrayToPlot)[1]
    xScale = 10
    if max_x >= 400
      xScale = 100
      if max_x >= 4000
        xScale = 1000
        if max_x >= 40000
          xScale = 10000
        end
      end
    end
    max_x += xScale
  end

  #re-scaling the x axis for a better plot
  xScale = 10
  if max_x > 400
    xScale = 100
    if max_x > 4000
      xScale = 1000
      if max_x > 40000
        xScale = 10000
      end
    end
  end

  max_x -= xScale

  #print("Plotting data from 1 - $max_x \n")

  if plotErrors == false
    myPlot = plot(x=arrayToPlot[1:max_x,1],y=arrayToPlot[1:max_x,size(arrayToPlot)[2]],
                  Geom.line,Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Average Intensity"), Guide.title("Plot of mean values"))

    plotName = "meanValuePlot"
  else
    yMins = arrayToPlot[1:max_x,2] - sqrt(abs(arrayToPlot[1:max_x,2]))
    yMaxs = arrayToPlot[1:max_x,2] + sqrt(abs(arrayToPlot[1:max_x,2]))

    myPlot = plot(x=arrayToPlot[1:max_x,1],y=arrayToPlot[1:max_x,size(arrayToPlot)[2]], ymin = yMins, ymax = yMaxs, Geom.point, Geom.errorbar,
                Guide.xlabel("Wavelength(nm)"), Guide.ylabel("Average Intensity"), Guide.title("Spectrum of mean values"))

    plotName = "meanValueSpectrum"
  end

  writeOutPlot(fileName, plotName, myPlot)

  #plotName = "Plot_of_$fileName.png"

  #Write out the plot as a .png file
  #draw(PNG(plotName, 4inch, 3inch), myPlot)

  return myPlot
end
