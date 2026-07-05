# Setup-Scheduler.ps1
# Run this ONCE to register a daily Windows Task Scheduler job that runs
# Check-Tasks.ps1 automatically every day and pops a notification.

$ErrorActionPreference = "Stop"

$RepoPath = "C:\project-tracker"
$ScriptPath = "$RepoPath\Check-Tasks.ps1"
$TaskName = "ProjectTrackerDailyCheck"

# Default run time: 8:00 AM daily. Change $RunTime below if you want a different time.
$RunTime = "08:00"

$Action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`""

$Trigger = New-ScheduledTaskTrigger -Daily -At $RunTime

$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings -Force

Write-Host "Scheduled task '$TaskName' registered. It will run daily at $RunTime."
Write-Host "You can also right-click it in Task Scheduler and choose 'Run' to test it immediately."
