"""
Physics Research Project
Devin Rose
Last update: October 1, 2015
Defines module for using as a package
"""

module dataAnalysis

  #List packages used
  using Gadfly

  #export functions used in the module
  export
    #findError.jl
    calculateBackgroundMinimumError,
    errorIntervals,
    findMean,

    #utilities.jl
    areaUnderCurveCentral,
    areaUnderCurveRightSum,
    arrayLayers,
    findClosestMax,
    findWaveRow,
    importFile,
    layerPlots,
    parseArray,
    plotMeanValues,
    wavelengthDifferetial

  #List files containing functions
  include("findError.jl")
  include("utilities.jl")

end
