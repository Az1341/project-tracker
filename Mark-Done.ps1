# Mark-Done.ps1
# Lists open tasks, lets you pick one to mark as done, then commits and pushes
# the update to GitHub so Claude sees it too on next read.

$ErrorActionPreference = "Stop"
$RepoPath = "C:\project-tracker"
Set-Location $RepoPath

Write-Host "Pulling latest tasks first..."
git pull --quiet

$jsonPath = "$RepoPath\tasks.json"
$data = Get-Content $jsonPath -Raw | ConvertFrom-Json

$openTasks = $data.tasks | Where-Object { $_.status -ne "done" }

if ($openTasks.Count -eq 0) {
    Write-Host "No open tasks. Everything is marked done."
    exit
}

Write-Host ""
Write-Host "Open tasks:"
Write-Host "-----------"
foreach ($t in $openTasks) {
    Write-Host "$($t.id)  [$($t.project)]  $($t.title)  (deadline: $($t.deadline))"
}
Write-Host ""

$idToMark = Read-Host "Enter the task ID to mark as done (e.g. FAM-005)"

$task = $data.tasks | Where-Object { $_.id -eq $idToMark }

if (-not $task) {
    Write-Host "Task ID '$idToMark' not found. No changes made."
    exit
}

$task.status = "done"
$task.completed_date = (Get-Date -Format "yyyy-MM-dd")
$data.last_updated = (Get-Date -Format "yyyy-MM-dd")

$data | ConvertTo-Json -Depth 10 | Set-Content $jsonPath -Encoding UTF8

git add tasks.json
git commit -m "Mark $idToMark done"
git push

Write-Host ""
Write-Host "$idToMark marked done and pushed to GitHub."
