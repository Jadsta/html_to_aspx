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

# Write each group to a separate file
foreach ($key in $grouped.Keys) {
    $filename = "graph-$key-etlJobConfig.json"
    $grouped[$key] | ConvertTo-Json -Depth 10 | Set-Content -Path $filename
    Write-Host "Created $filename"
}
