"""
Physics Research Project
Devin Rose
Last update: October 1, 2015
Defines module for using as a package
"""

module dataAnalysis

  #List packages used
  using Gadfly, LsqFit, ProgressMeter

  #Variables/functions used in the analysis
  #MODEL(x, param) = param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2))) #Gaussian function
  #MODEL(x, param) = 0.5*param[4]/( ((x.-param[2]).^2) + ((0.5*param[4])^2) ) #Lorrentzian function
  #Combination of Gaussian and lorrentzian added together, doesn't work well
  #MODEL(x, param) = param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2))) + ((0.5*param[4])/pi)*(1/( ((x.-param[5]).^2) + ((0.5*param[4])^2)))
  MODEL(x, param) = param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2))) + param[4]*exp(-((x.-param[5]).^2)/(2*(param[6]^2)))

  #export functions used in the module
  export
    #fileIO.jl
    createDirectoryForReport,
    findFilesToAnalyze,
    importFile,
    writeOutPlot,
    writeOutText,

    #findError.jl
    calculateBackgroundMinimumError,
    errorIntervals,

    #fullAnalysis.jl
    fullAnalysis,

    #utilities.jl
    areaUnderCurveCentral,
    areaUnderCurveRightSum,
    arrayLayers,
    findClosestMax,
    findWaveRow,
    layerPlots,
    parseArray,
    plotMeanValues,
    wavelengthDifferetial,

    #vectorStats.jl
    vectorMean,
    vectorStandardDeviation

  #List files containing functions
  include("fileIO.jl")
  include("findError.jl")
  include("fullAnalysis.jl")
  include("utilities.jl")
  include("vectorStats.jl")
end
