powershell.exe -NonInteractive -Command "&{ Import-Module .\psake.psm1; Invoke-Psake .\makefile.ps1 %1; exit !($psake.build_success) }"

