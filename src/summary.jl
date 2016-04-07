"""
Physics Research Project
Devin Rose
Last update: March, 2016
Utilities to summarize the report and do consistancy checks.
"""

#Returns:Array for comparing results with MOC
function compareMoc(test::Array)
  comparison = Array(ASCIIString, size(test)[1], 2*(size(test)[2]-2)-2)
  comparison[:,:] = "0"
  comparison[:,1:3] = test[:, 1:3]
  comparison[:,5] = test[:,4]
  comparison[:,7] = test[:,5]
  comparison[:,9] = test[:,6]

  #Move to the corrct location of the moc files
  cd()
  cd(split(Base.source_path(), "dataAnalysis.jl")[1]"dataAnalysis.jl/docs/moc")
  mocArray = readtable(pwd()"/compareMOC.csv")

  #Converts to ASCIIString for the array
  for row = 1:size(comparison)[1]
    for mocRow = 1:size(mocArray)[1]
      if comparison[row, 1] == lowercase(mocArray[mocRow, 1])
        for column = 1:div((size(comparison)[2]-2), 2)
          comparison[row, (2*column)+2] = "$(mocArray[mocRow, 2*column])"
        end
        rowMoc = size(mocArray)[1]
      end
    end
  end

  return comparison
end

#Returns: Plot of the comparison
function plotMoc(compMoc::Array, compToCompare::Int64)
  @assert(compToCompare > 0 && compToCompare < 5, "Element number must be between 1 and 4 for a proper comparison.")
  #for spectraNum = 1:size(testMoc)[1]
  #end

  if compToCompare == 1
    plotTitle = "Predicted Concentration of SiO2 versus ChemCam prediction"
  elseif compToCompare == 2
    plotTitle = "Predicted Concentration of MgO versus ChemCam prediction"
  elseif compToCompare == 3
    plotTitle = "Predicted Concentration of Na2O versus ChemCam prediction"
  elseif compToCompare == 4
    plotTitle = "Predicted Concentration of k2O versus ChemCam prediction"
  end

  xVals = Array(Float64, size(compMoc)[1]-1)
  yVals = Array(Float64, size(compMoc)[1]-1)

  xCol = (2*compToCompare)+1

  for index = 1:length(xVals)
    xVals[index] = 100*(float(compMoc[index+1,xCol]))
    yVals[index] = float(compMoc[index+1,xCol+1])
  end

  #Too hard to read with error bars
  compareLayer = layer(x=xVals,y=yVals, Geom.point)

  #Linear regression, remove the comment below and in Plot to use it
  #=linear(x, p) = p[1]*x+p[2]
  regFit = linreg(xVals,yVals)
  regLayer = layer(x=xVals, y=linear(xVals, regFit), Geom.smooth)=#

  myPlot = plot(compareLayer, #regLayer,
    Guide.title(plotTitle), Guide.xlabel("Normalized area"), Guide.ylabel("MOC concentration(%)"))

  return myPlot
end
