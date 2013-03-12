set MyLogFile=%TestRunResultsDirectory%\net35_test_setup_output.txt
set PerfToolsPath=C:\Program Files (x86)\Microsoft Visual Studio 11.0\Team Tools\Performance Tools

echo Starting: net35_test_cleanup.bat >> "%MyLogFile

:: Stop the profiler from running so it can finalize the coverage results
echo Stopping Profiler "%PerfToolsPath%\VSPerfCmd.exe"
"%PerfToolsPath%\VSPerfCmd.exe" /shutdown


echo Results Directory %TestRunResultsDirectory%
dir %TestRunResultsDirectory% >> "%MyLogFile%"
