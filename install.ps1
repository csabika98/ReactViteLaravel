# Check if the script is running as an administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Relaunch the script with administrator privileges and keep the window open after execution
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"" + $MyInvocation.MyCommand.Definition + "`" -Wait"
    Start-Process PowerShell -ArgumentList $arguments -Verb RunAs
    Exit
}

# Your existing script starts here
$currentPolicy = Get-ExecutionPolicy
if ($currentPolicy -eq 'Restricted' -or $currentPolicy -eq 'AllSigned') {
    Write-Warning "Current execution policy is $currentPolicy, which might prevent some scripts from running.`nConsider setting the policy to RemoteSigned or Bypass if you encounter issues."
} else {
    Write-Host "Current execution policy is $currentPolicy. The script will proceed."
}

scoop bucket add main
scoop install php
scoop install composer

$username = [Environment]::UserName
$phpIniDestPath = "C:\Users\$username\scoop\apps\php\current\"

$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$phpIniSourcePath = Join-Path -Path $scriptDirectory -ChildPath "php.ini"
Copy-Item -Path $phpIniSourcePath -Destination $phpIniDestPath -Force

# New part: Copy database.sqlite to a new directory called 'database'
$databaseSourcePath = Join-Path -Path $scriptDirectory -ChildPath "database.sqlite"
$databaseDestDirectory = Join-Path -Path $scriptDirectory -ChildPath "database"
New-Item -Path $databaseDestDirectory -ItemType Directory -Force
Copy-Item -Path $databaseSourcePath -Destination $databaseDestDirectory -Force

Write-Host "PHP and Composer have been installed and configured. Database file has been copied."
