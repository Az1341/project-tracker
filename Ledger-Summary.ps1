# Ledger-Summary.ps1
# Prints total spend by project and by category, plus a grand total.

$ErrorActionPreference = "Stop"
$RepoPath = "C:\project-tracker"
Set-Location $RepoPath

Write-Host "Pulling latest ledger..."
git pull --quiet

$data = Get-Content "$RepoPath\ledger.json" -Raw | ConvertFrom-Json

if ($data.entries.Count -eq 0) {
    Write-Host "No entries in the ledger yet."
    exit
}

Write-Host ""
Write-Host "===== SPEND BY PROJECT ====="
$data.entries | Group-Object project | ForEach-Object {
    $total = ($_.Group | Measure-Object -Property amount -Sum).Sum
    $currency = $_.Group[0].currency
    Write-Host "$($_.Name): $currency$total"
}

Write-Host ""
Write-Host "===== SPEND BY CATEGORY ====="
$data.entries | Group-Object category | ForEach-Object {
    $total = ($_.Group | Measure-Object -Property amount -Sum).Sum
    $currency = $_.Group[0].currency
    Write-Host "$($_.Name): $currency$total"
}

Write-Host ""
Write-Host "===== GRAND TOTAL ====="
$grandTotal = ($data.entries | Measure-Object -Property amount -Sum).Sum
Write-Host "$($data.default_currency)$grandTotal across $($data.entries.Count) entries"

Write-Host ""
Write-Host "===== LAST 5 ENTRIES ====="
$data.entries | Select-Object -Last 5 | ForEach-Object {
    Write-Host "$($_.id)  $($_.date)  [$($_.project)/$($_.category)]  $($_.currency)$($_.amount)  $($_.description)"
}
