properties {
	$solutionFile = "C:\Projects\myABILITY\WebSolutions\Ability.Portal\Ability.Portal.sln"
	$msbuildpath = join-path -path (Get-ItemProperty "HKLM:\software\Microsoft\MSBuild\ToolsVersions\4.0")."MSBuildToolsPath" -childpath "msbuild.exe"
}

task default -depends Test

task Test -depends Compile, Clean -ContinueOnError -description "This task runs the unit tests" { 
 	'Executed Test' 
 	throw 'I failed on purpose'
}

task Compile -depends Clean -description "This task builds the solution" { 
	iex "$msbuildpath $solutionFile"
	if($lastexitcode -ne 0){
		throw 'build failed'
	}
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
