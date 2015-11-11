
#Package management
Pkg.rm("LsqFit")
Pkg.add("LsqFit")
Pkg.clone("LsqFit")

#packages used
using LsqFit

# a two-parameter exponential model
# x: array of independent variables
# p: array of model parameters
model(x, p) = p[1]*exp(-x.*p[2])-p[3]
modelTwo(x, a) = a[1]*exp((-(x-a[2])^2)/2*a[3]^2)

# some example data
# xdata: independent variables
# ydata: dependent variable
xdata = linspace(0,10,20)
ydata = model(xdata, [1.0 2.0 3.0]) + 0.01*randn(length(xdata))

guess = [0.5, 0.5, 0.5]

fit = curve_fit(model, xdata, ydata, guess)
fitTwo = curve_fit(modelTwo, xdata, ydata, guess)

# fit is a composite type (LsqFitResult), with some interesting values:
#   fit.dof: degrees of freedom
#   fit.param: best fit parameters
#   fit.resid: residuals = vector of residuals
#   fit.jacobian: estimated Jacobian at solution

plot(fit)

# We can estimate errors on the fit parameters,
# to get 95% confidence error bars:
errors = estimate_errors(fit, 0.95)


