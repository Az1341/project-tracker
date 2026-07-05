# Project Tracker — Windows Setup

One shared `tasks.json` file on GitHub is the single source of truth.
Your laptop reads/writes it locally; Claude reads (and sometimes updates) the
same file via GitHub. Neither side goes out of sync.

## One-time setup

1. **Create the GitHub repo** (if not already done):
   - Go to github.com, create a new **public** repo named `project-tracker`
   - Don't initialise it with a README (we already have one)

2. **Clone it to your laptop:**
   ```
   cd $HOME
   git clone https://github.com/Az1341/project-tracker.git
   ```

3. **Copy these files into that folder** (`tasks.json`, `Check-Tasks.ps1`,
   `Mark-Done.ps1`, `Setup-Scheduler.ps1`, this README), then push:
   ```
   cd $HOME\project-tracker
   git add .
   git commit -m "Initial tracker setup"
   git push
   ```

4. **Install the notification module** (one time):
   ```
   Install-Module -Name BurntToast -Scope CurrentUser
   ```
   If prompted about an untrusted repository, type `Y` to confirm.

5. **Register the daily automatic check:**
   ```
   .\Setup-Scheduler.ps1
   ```
   This runs `Check-Tasks.ps1` every day at 8:00 AM and pops a Windows
   notification if anything is overdue, due today, or tells you what's next.
   Change the `$RunTime` variable inside `Setup-Scheduler.ps1` first if you
   want a different time.

## Daily use

- **Check status any time** (not just the scheduled run):
  ```
  .\Check-Tasks.ps1
  ```

- **Mark a task done:**
  ```
  .\Mark-Done.ps1
  ```
  This shows your open tasks, asks which one to mark done, then commits and
  pushes automatically — so Claude sees the update next time too.

## How Claude stays in sync

Claude reads `tasks.json` from GitHub directly. When you ask Claude to:
- add a new task
- reschedule a deadline
- mark something done from chat instead of the laptop

Claude will update the file and push the change (this needs a short-lived
GitHub personal access token from you, scoped to just this repo — paste it
only when you want Claude to push, never stored).

## Adding new tasks

Open `tasks.json` and add an entry to the `tasks` array:
```json
{
  "id": "GC-001",
  "project": "GoalCurrent",
  "title": "Fix www vs non-www canonical conflict",
  "start_date": "2026-07-06",
  "deadline": "2026-07-07",
  "status": "todo",
  "completed_date": "",
  "notes": ""
}
```
Then `git add tasks.json && git commit -m "add task" && git push`.

Two tasks (GC-000, DKAMS-000) currently have **no dates** — they're flagged
in `notes` as needing a schedule. Nothing was invented for them; add real
dates when you decide on them.
