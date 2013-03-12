:: MSTest.exe setup script
:: This script will get run after MSTest has processed the test settings and just before it is about to the load
:: the assemblies for execution.
::   This means the input / output folders exists
::   All deployment items specified in the testsettings have been copied (Runtime items may have not yet)
::   Any collectors have been initialized (but that means nothing because collectors don't work on .net 3.5 assemblies)
::
:: The script below will manually perform the process to collect code coverage information for assemblies under test
:: Visit this url for more details: http://blogs.microsoft.co.il/blogs/royrose/archive/2011/08/30/manually-configure-and-run-code-coverage.aspx
::

:: Change this file name if you want a different type of log file
set MyLogFile=%TestRunResultsDirectory%\net35_test_setup_output.txt

:: Path to the Visual Studio performance tools, append \x64 if you will run your app / tests in x64 mode
:: The default .testsettings file will for 32-bit test execution
set PerfToolsPath=C:\Program Files (x86)\Microsoft Visual Studio 11.0\Team Tools\Performance Tools

echo Starting: net35_test_setup.bat > "%MyLogFile%"
echo Environment is: >> "%MyLogFile%"
set >> "%MyLogFile%" >> "%MyLogFile%"

:: The current directory should be the deployment directory so all your assemblies are located here
echo Current Directory is %CD% >> "%MyLogFile%"
dir >> "%MyLogFile%"

echo Instrumenting Assemblies with "%PerfToolsPath%\VSInstr.exe" >> "%MyLogFile%"

:: This is the call to create an instrumented version of the assembly and debug symbols so they can profiled for code coverage
:: Add more calls for all the assemblies you would like to collect coverage for
"%PerfToolsPath%\VSInstr.exe" "MultiTargetLib.net35.dll" /coverage

echo After instrumenting directory is: >> "%MyLogFile%"
dir >> "%MyLogFile%"

:: Finally we want to copy our assemblies and pdb files to the output directory so we can later download them from TFS to view code coverage locally
::   So far this is the only error: viewing code coverage in visual studio itself after clicking the test results from the TFS build summary
::   The two workarounds are copy the testresults directory directly from the TFS build folder, not DropFolder
::   Or downloading the test files and putting them next to the data.coverage file on your local machine, then manually loading the results
::
echo Copying instrumented assemblies to run results directory "%TestRunResultsDirectory%\" >> "%MyLogFile%"
xcopy MultiTargetLib.net35.dll "%TestRunResultsDirectory%\" /Y
xcopy MultiTargetLib.net35.instr.pdb "%TestRunResultsDirectory%\" /Y
xcopy MultiTargetLib.net35.dll.orig "%TestRunResultsDirectory%\" /Y
xcopy MultiTargetLib.net35.pdb "%TestRunResultsDirectory%\" /Y

:: Log the directory contents after the copy, for diagnostics you can confirm the assemblies were actually copied
dir %TestRunResultsDirectory% >> "%MyLogFile%"

:: Start the actual visual studio profiler, the cleanup.bat script has the call to shut it down
:: We drop the coverage file in the same place that it normally goes, %testrunresultsdirectory% with a file name data.coverage
echo Starting Profiler "%PerfToolsPath%\VSPerfCmd.exe"
"%PerfToolsPath%\VSPerfCmd.exe" /start:coverage /output:"%TestRunResultsDirectory%\data.coverage"
