# Add-Expense.ps1
# Adds a spend entry to ledger.json, then commits and pushes so Claude
# sees it too on next read.

$ErrorActionPreference = "Stop"
$RepoPath = "C:\project-tracker"
Set-Location $RepoPath

Write-Host "Pulling latest ledger first..."
git pull --quiet

$jsonPath = "$RepoPath\ledger.json"
$data = Get-Content $jsonPath -Raw | ConvertFrom-Json

Write-Host ""
$project = Read-Host "Project (Famviai / GoalCurrent / DKAMS / General)"
$category = Read-Host "Category (e.g. hosting, domains, ads, tools, API, other)"
$description = Read-Host "Description"
$amount = Read-Host "Amount (numbers only, e.g. 12.99)"
$currencyInput = Read-Host "Currency (leave blank for GBP)"
if ([string]::IsNullOrWhiteSpace($currencyInput)) { $currencyInput = $data.default_currency }

$existingIds = $data.entries | ForEach-Object { $_.id }
$nextNum = 1
if ($existingIds.Count -gt 0) {
    $nums = $existingIds | ForEach-Object { [int]($_ -replace '\D','') }
    $nextNum = ($nums | Measure-Object -Maximum).Maximum + 1
}
$newId = "LDG-{0:D4}" -f $nextNum

$newEntry = [PSCustomObject]@{
    id          = $newId
    date        = (Get-Date -Format "yyyy-MM-dd")
    project     = $project
    category    = $category
    description = $description
    amount      = [double]$amount
    currency    = $currencyInput
    added_by    = "manual"
}

$data.entries = @($data.entries) + $newEntry
$data.last_updated = (Get-Date -Format "yyyy-MM-dd")

$data | ConvertTo-Json -Depth 10 | Set-Content $jsonPath -Encoding UTF8

git add ledger.json
git commit -m "Add expense $newId ($project, $currencyInput $amount)"
git push

Write-Host ""
Write-Host "$newId added: $project / $category / $currencyInput$amount - $description"
