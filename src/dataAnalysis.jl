"""
Physics Research Project
Devin Rose
Last update: October 1, 2015
Defines module for using as a package
"""

Pkg.installed()
Pkg.update()

module dataAnalysis

  #List packages used
  using Gadfly

  #export functions used in the module
  export
    #fileIO.jl
    createDirectoryForReport,
    findFilesToAnalyze,
    importFile,
    writeOutPlot,

    #findError.jl
    calculateBackgroundMinimumError,
    errorIntervals,

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
  include("utilities.jl")
  include("vectorStats.jl")
end
