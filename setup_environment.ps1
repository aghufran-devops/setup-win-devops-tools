
# Ensure running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install packages
choco install vscode -y
choco install git -y
choco install git.install -y
choco install awscli -y
choco install terraform -y
choco install mobaxterm -y
choco install openjdk --version=21.0.2 -y
choco install maven -y
choco install nilesoft-shell -y

# Define paths to add
$pathsToAdd = @(
    "C:\Program Files\Microsoft VS Code\bin",
    "C:\Program Files\Git\cmd",
    "C:\Program Files\Git\bin",
    "C:\Program Files\Amazon\AWSCLIV2\",
    "C:\ProgramData\chocolatey\bin",
    "C:\Program Files\OpenJDK\jdk-21.0.2\bin",
    "C:\ProgramData\chocolatey\lib\maven\apache-maven-3.9.11\bin"
)

# Get current system PATH
$envPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
$envPathList = $envPath -split ";"

# Add missing paths
foreach ($path in $pathsToAdd) {
    if (-not ($envPathList -contains $path)) {
        Write-Output "Adding $path to system PATH"
        $envPath += ";$path"
    }
}

# Update system PATH
[Environment]::SetEnvironmentVariable("Path", $envPath, [EnvironmentVariableTarget]::Machine)

# Set JAVA_HOME if not already set
$currentJavaHome = [Environment]::GetEnvironmentVariable("JAVA_HOME", [EnvironmentVariableTarget]::Machine)
if ([string]::IsNullOrEmpty($currentJavaHome)) {
    $javaHome = "C:\Program Files\OpenJDK\jdk-21.0.2"
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, [EnvironmentVariableTarget]::Machine)
    Write-Output "JAVA_HOME was not set. Now set to: $javaHome"
} else {
    Write-Output "JAVA_HOME is already set to: $currentJavaHome"
}

Write-Output "Installation and environment setup complete. Please restart your computer to apply changes."
