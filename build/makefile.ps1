properties {
	#load the functions definition script
	. ".\functions.ps1"
	#set variables (which can be overridden by caller)
	$solutionFile = 	"C:\Research\psake-example\DummySolution\DummySolution.sln"
	$webConfig =    	"C:\Research\psake-example\DummySolution\DummySolution.WebProject\Web.config"
	$webConfigTransform = 	"C:\Research\psake-example\DummySolution\DummySolution.WebProject\Web.Debug.config"
	$msbuildpath = 		"C:\Program Files (x86)\MSBuild\14.0\Bin\msbuild.exe"
	$mstestpath = 		"C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\mstest.exe"
	#the following msbuild fails with missing "webapplication.targets" error
	#$msbuildpath = join-path -path (Get-ItemProperty "HKLM:\software\Microsoft\MSBuild\ToolsVersions\4.0")."MSBuildToolsPath" -childpath "msbuild.exe"
}

task default -depends Test

task Test -depends Compile, Clean -ContinueOnError -description "This task runs the unit tests" { 
 	'Executed Test' 
 	throw 'I failed on purpose'
}

task TranslateWebConfig -depends Compile -description "This task converts the web.config into the specific environment" {
	XmlDocTransform $webConfig $webConfigTransform
}

task Compile -depends Clean -description "This task builds the solution" { 
	& $msbuildpath $solutionFile
	Assert ($lastexitcode -eq 0) "Compile step failed."
}

task Clean -description "This task cleans all output" { 
	'Executed Clean'
}

task RunOtherBuildScript -description "Example of invoking external script as a task" {
	Invoke-psake '.\subdir\othermakefile.ps1'
}

task ? -Description "Helper to display task info" {
	Write-Documentation
}
