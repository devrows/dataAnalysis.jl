"""
Physics Research Project
Devin Rose
README file for an explanation of how to use this software
"""

Before computing an analysis of a .csv file, make sure to have the .csv file located in the docs/dataToAnalyze directory and run the program from the examples directory.

After this, you really don't need to worry about anything below, just follow the examples/exampleFull instructions.

**********
Compilation
**********

No arguments are required, simply call the fullAnalysis() function making sure all data is in the docs/dataToAnalyze directory and the file running the function is in the examples directory of the package.


**********
Running the program
**********

No user interface. When the function is called, a full analysis of files in the /dataToAnalyze directory will be completed.

**********
Limitations
**********

Many plots causes a slow run time.

**********
File locations/contents
**********
assets
	- Miscellaneous research and testing notes.
		- futureDevelopment.txt
		- testingInfo.txt

docs
	- Documents generated or used for analysis. Generated documents are post analysis summaries and images.
		- /dataToAnalyze
		- /reports
		- wavelengthDatabase.txt

examples
	- Contains a Julia (.jl) file demonstrating available functionality of the dataAnalysis.jl package.
		- Example1.jl
		- ExampleFill.jl

src
	- Contains the Julia source code.
		- dataAnalysis.jl
		- findError.jl
		- utilities.jl
		- fileIO.jl
		- fullAnalysis.jl
		- vectorStats.jl

testing
	- Contains testing and development information.
		- miscTesting.jl
		- testCurveFitting.jl
		- testingUtilities.jl
		- miscTestingTwo.jl
		- testingFindError.jl

tools
	- Software developed in other languages used to help the project
