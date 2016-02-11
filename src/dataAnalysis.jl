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
  #Gaussian function
  MODEL_1(x, param) = param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2)))
  #Lorrentzian function
  MODEL_2(x, param) = (param[1])./((x-param[2]).^2 + (0.5*param[1]).^2)
  #Lorrentzian+Gaussian
  MODEL_3(x, param) = param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2))) + (param[4])./((x-param[5]).^2 + (0.5*param[4]).^2)
  #Gaussian*Lorrentzian
  MODEL_4(x, param) = (param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2)))).*((param[4])./((x-param[5]).^2 + (0.5*param[4]).^2))

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

    #plots.jl
    areaUnderCurveRiemann,
    generateFitPlots,
    plotMeanValues,

    #utilities.jl
    areaUnderCurveCentral,
    areaUnderCurveRightSum,
    findClosestMax,
    findLocalArray,
    findWaveRow,
    layerPlots,
    parseArray,
    wavelengthDifferetial,

    #vectorStats.jl
    vectorMean,
    vectorStandardDeviation

  #List files containing functions
  include("fileIO.jl")
  include("findError.jl")
  include("fullAnalysis.jl")
  include("plots.jl")
  include("utilities.jl")
  include("vectorStats.jl")
end
