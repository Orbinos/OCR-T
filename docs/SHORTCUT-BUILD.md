# Shortcut Build Reference

This file maps the individual source files in `scripts/` to the actions in the macOS Shortcuts editor.

| Label | Shortcut action | Input | Source file |
|---|---|---|---|
| A | Run Shell Script | none | `scripts/startup-cleanup.sh` |
| B1 | Run AppleScript | outer `Repeat Item` | `scripts/copy-to-temp.applescript` |
| C1 | Run Shell Script | `AppleScript Result`, as arguments | `scripts/ocr.sh` |
| D1 | Run AppleScript | `Shell Script Result` | `scripts/replace-original.applescript` |
| E | Run Shell Script | filtered `Files`, as arguments | `scripts/progress-launch.sh` |
| B2 | Run AppleScript | inner `Repeat Item 2` | `scripts/copy-to-temp.applescript` |
| C2 | Run Shell Script | `AppleScript Result`, as arguments | `scripts/ocr.sh` |
| D2 | Run AppleScript | `Shell Script Result` | `scripts/replace-original.applescript` |
| F | Run Shell Script | none | `scripts/cancel-cleanup.sh` |
| G | Run Shell Script | none | `scripts/progress-update.sh` |
| H | Run Shell Script | none | `scripts/progress-close.sh` |

## Required native Shortcuts actions

The non-script actions are:

1. Receive **Folders and PDFs** from Quick Actions.
2. Repeat with each item in `Shortcut Input`.
3. Get **File Extension** from the outer `Repeat Item`.
4. If `File Extension` is `pdf`.
5. Otherwise, Get Contents of the folder with **Recursive ON**.
6. Filter the returned contents where **File Extension is pdf**.
7. Repeat with each item in the filtered `Files` list.
8. After D2, Get Text from `AppleScript Result`.
9. If that Text is `CANCELLED`, run F then **Stop and Output** `Cancelled`; otherwise run G.
10. After the inner repeat ends, run H.

All shell actions must have **Run as Administrator OFF**.
