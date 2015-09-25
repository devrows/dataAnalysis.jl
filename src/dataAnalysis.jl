"""
Physics Research Project
Devin Rose
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
    importFile,
    parseArray,
    plotMeanValues

  #List files containing functions
  include("findError.jl")
  include("utilities.jl")

end
