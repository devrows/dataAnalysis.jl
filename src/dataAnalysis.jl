"""
Physics Research Project
Devin Rose
Defines module for using as a package
"""

#List packages used
#export functions with return values
#List files with functions used

module dataAnalysis

using Gadfly

export
  #findError.jl
  calculateMinimumBackgroundError,
  errorIntervals,
  findMean,

  #utilities.jl
  importFile,
  parseArray,
  plotMeanValues

include("findError.jl")
include("utilities.jl")

end
