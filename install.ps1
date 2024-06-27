if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}

$currentPolicy = Get-ExecutionPolicy
if ($currentPolicy -eq 'Restricted' -or $currentPolicy -eq 'AllSigned') {
    Write-Warning "Current execution policy is $currentPolicy, which might prevent some scripts from running.`nConsider setting the policy to RemoteSigned or Bypass if you encounter issues."
} else {
    Write-Host "Current execution policy is $currentPolicy. The script will proceed."
}


if (!(Get-Command 'scoop' -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..."
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}


scoop bucket add main
scoop install php
scoop install composer

# Adding Node.js LTS 20 installation
scoop install nodejs-lts

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
