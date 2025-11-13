# Load and parse the JSON
$json = Get-Content -Raw -Path "input.json" | ConvertFrom-Json

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

    # Build an array explicitly (handles single or multiple items)
    $jsonArray = @()
    $jsonArray += $grouped[$key]

    $jsonText = $jsonArray | ConvertTo-Json -Depth 10
    # Use Out-File to avoid encoding quirks
    $jsonText | Out-File -FilePath $filename -Encoding utf8

    Write-Host "Created $filename"
}
