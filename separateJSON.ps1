# Load and parse the JSON
$json = Get-Content -Raw -Path "input.json" | ConvertFrom-Json

# Group by the second part of jobKey
$grouped = @{}
foreach ($job in $json) {
    $parts = $job.jobKey -split '\.'
    if ($parts.Length -ge 3) {
        $key = $parts[1]
        if (-not $grouped.ContainsKey($key)) {
            $grouped[$key] = New-Object System.Collections.ArrayList
        }
        [void]$grouped[$key].Add($job)
    }
}

# Write each group to a separate file with consistent array formatting
foreach ($key in $grouped.Keys) {
    $filename = "graph-$key-etlJobConfig.json"
    $jsonArray = @($grouped[$key] | ForEach-Object { $_ })
    $jsonArray | ConvertTo-Json -Depth 10 | Set-Content -Path $filename
    Write-Host "Created $filename"
}
