"""
Physics Research Project
Devin Rose
Last update: March, 2015
Simple data structures used
"""

#oxideComponents data type
type OxideComponents
  #variables used
  O2::Float64
  Si::Float64
  K2::Float64
  Na2::Float64
  Mg::Float64
  setZero!::Function

  #internal methods
  function setToZero!(compIn::OxideComponents)
    compIn.O2 = 0
    compIn.Si = 0
    compIn.K2 = 0
    compIn.Na2 = 0
    compIn.Mg = 0
  end

  #constructors
  OxideComponents(a, b, c, d, e) = new(a, b, c, d, e, setToZero!)
  OxideComponents() = new(0, 0, 0, 0, 0, setToZero!)
end
