
# Define the URL and destination paths
$zipUrl = "https://s3.amazonaws.com/module-non-videos/industry_grade%20project%20i%20-%20java%20project_qej_5zeqqmng.zip"

# Get the current user's Downloads folder
$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$zipFilePath = Join-Path $downloadsPath "downloaded.zip"
$extractPath = Join-Path $downloadsPath "unzipped"

# Download the ZIP file
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFilePath

# Create the extraction directory if it doesn't exist
if (!(Test-Path -Path $extractPath)) {
    New-Item -ItemType Directory -Path $extractPath | Out-Null
}

# Extract the ZIP file
Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force

# Delete the downloaded ZIP file
Remove-Item -Path $zipFilePath -Force

# Output the location of the extracted files
Write-Host "Files extracted to: $extractPath"
