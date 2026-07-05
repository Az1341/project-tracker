# Check-Tasks.ps1
# Pulls the latest tasks.json from GitHub, checks dates, and shows a Windows
# toast notification summarising overdue tasks, tasks due today, and what's next.
#
# Requires: git (configured with push/pull access to the repo),
#           BurntToast module (Install-Module -Name BurntToast -Scope CurrentUser)

$ErrorActionPreference = "Stop"

# --- CONFIG: update this path to wherever you cloned project-tracker ---
$RepoPath = "C:\project-tracker"

Set-Location $RepoPath

Write-Host "Pulling latest tasks from GitHub..."
git pull --quiet

$data = Get-Content "$RepoPath\tasks.json" -Raw | ConvertFrom-Json
$today = Get-Date -Format "yyyy-MM-dd"
$todayDate = Get-Date $today

$overdue = @()
$dueToday = @()
$upcoming = @()

foreach ($t in $data.tasks) {
    if ($t.status -eq "done") { continue }
    if ([string]::IsNullOrWhiteSpace($t.deadline)) { continue }

    $deadlineDate = Get-Date $t.deadline

    if ($deadlineDate -lt $todayDate) {
        $overdue += $t
    }
    elseif ($deadlineDate.ToString("yyyy-MM-dd") -eq $today) {
        $dueToday += $t
    }
    else {
        $upcoming += $t
    }
}

# Next up = earliest start_date among remaining todo tasks that have a start date
$nextUp = $upcoming | Where-Object { -not [string]::IsNullOrWhiteSpace($_.start_date) } |
          Sort-Object { Get-Date $_.start_date } | Select-Object -First 1

# Build notification text
$lines = @()

if ($overdue.Count -gt 0) {
    $lines += "OVERDUE ($($overdue.Count)):"
    foreach ($o in $overdue) { $lines += " - [$($o.project)] $($o.id): $($o.title)" }
}

if ($dueToday.Count -gt 0) {
    $lines += "DUE TODAY ($($dueToday.Count)):"
    foreach ($d in $dueToday) { $lines += " - [$($d.project)] $($d.id): $($d.title)" }
}

if ($nextUp) {
    $lines += "NEXT UP: [$($nextUp.project)] $($nextUp.id): $($nextUp.title) (starts $($nextUp.start_date))"
}

if ($lines.Count -eq 0) {
    $lines += "Nothing overdue. Nothing due today. No upcoming tasks scheduled."
}

$body = ($lines -join "`n")

Write-Host "----- TASK STATUS -----"
Write-Host $body
Write-Host "------------------------"

# Show Windows toast notification
try {
    Import-Module BurntToast -ErrorAction Stop
    New-BurntToastNotification -Text "Project Tracker - $today", $body
}
catch {
    Write-Warning "BurntToast module not found. Install it with: Install-Module -Name BurntToast -Scope CurrentUser"
    Write-Warning "Notification skipped, but status was printed above."
}
