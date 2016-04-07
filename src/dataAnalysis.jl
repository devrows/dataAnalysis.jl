"""
Physics Research Project
Devin Rose
Last update: October 2015
Defines a module for using this code as a package
"""

module dataAnalysis

  #List packages used
  using DataFrames, Gadfly, LsqFit, ProgressMeter

  #Variables/functions used as trial functions for fitting in the analysis
  #=Gaussian function
    param[1] = normalization constant/peak max
    param[2] = location of peak maximum
    param[3]^2 = standard deviation=#
  MODEL_1(x, param) = param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2)))

  #=Lorrentzian function
    param[1] = normalization constant/peak max
    param[2] = location of peak maximum
    param[3]^2 = width of Lorrentzian peak=#
  MODEL_2(x, param) = param[1]./(1+((x-param[2])/param[3]).^2)

  #=Linear combination of Lorrentzian and Gaussian
    Parameters have the same meaning as the previous two models=#
  MODEL_3(x, param) = param[1]*exp(-((x.-param[2]).^2)/(2*(param[3]^2))) +
    (param[4])./(1+((x-param[5])/param[4]).^2)

  #=Pseudo-voigt - This is an approximation to the convoluton (a type of
    integral transform) of a Gaussian and Lorrentzian
    param[1] = normalization constant/peak max
    param[2] = location of peak maximum
    param[3]^2 = standard deviation of gaussian
    param[3] = width of Lorrentzian peak
    param[4] = transformation factor
    param[5] = =#
  MODEL_4(x, param) = param[1]*((1-param[4])*exp(-((x.-param[2]).^2)/((param[3]).^2)) +
    param[4]./(1+((x-param[2])/param[3]).^2))

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

    #summary.jl
    compareMoc,
    plotMoc,

    #types.jl
    OxideComponents,
    setToZero!,

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

  #List files containing functions in alphabetical order
  include("fileIO.jl")
  include("findError.jl")
  include("fullAnalysis.jl")
  include("plots.jl")
  include("summary.jl")
  include("types.jl")
  include("utilities.jl")
  include("vectorStats.jl")
end
