# Load and parse the JSON
$json = Get-Content -Raw -Path "etlJobConfig.json" | ConvertFrom-Json

# Group by the second part of jobKey
$grouped = @{}
foreach ($job in $json) {
    $parts = $job.jobKey -split '\.'
    if ($parts.Length -ge 3) {
        $key = $parts[1]
        if (-not $grouped.ContainsKey($key)) {
            $grouped[$key] = @()
        }
        $grouped[$key] += $job
    }
}

# Write each group to a separate file, always as a JSON array
foreach ($key in $grouped.Keys) {
    $filename = "graph-$key-etlJobConfig.json"

    # Force into an array even if only one item
    $jsonArray = @($grouped[$key])

    # Convert to JSON with square brackets guaranteed
    $jsonText = ConvertTo-Json $jsonArray -Depth 10

    # Save to file
    $jsonText | Out-File -FilePath $filename -Encoding utf8

    Write-Host "Created $filename"
}
