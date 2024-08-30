function Process-HTMLFiles {
    param (
        [string]$folderPath
    )

    # Get HTML files in the current folder
    $htmlFiles = Get-ChildItem -Path $folderPath -Filter "*.html"

    foreach ($file in $htmlFiles) {
        # Rename the file extension
        $newFileName = $file.Name -replace '\.html$', '.aspx'
        Rename-Item -Path $file.FullName -NewName $newFileName

        # Read the HTML content
        $htmlContent = Get-Content -Path $file.FullName -Raw

        # Replace .html with .aspx in href attributes
        $updatedContent = $htmlContent -replace '\.html"', '.aspx"'

        # Save the modified content back to the file
        Set-Content -Path $file.FullName -Value $updatedContent
    }

    # Process subfolders
    $subfolders = Get-ChildItem -Path $folderPath -Directory
    foreach ($subfolder in $subfolders) {
        Process-HTMLFiles -folderPath $subfolder.FullName
    }
}

# Start processing from the script's folder
$scriptFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
Process-HTMLFiles -folderPath $scriptFolder

Write-Output "Renamed and updated links for HTML files in subfolders."
