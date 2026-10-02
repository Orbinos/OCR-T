# OCR-T Architecture

## Simplified flow

```text
Finder selection
      ↓
Shortcuts
      ↓
┌──────────── PDF ────────────┐
│ Finder copy → /tmp          │
│ OCRmyPDF + Tesseract        │
│ Finder replace original     │
│ Cleanup                     │
└─────────────────────────────┘

Folder selection
      ↓
Recursive scan + PDF filter
      ↓
Open progress window
      ↓
Repeat PDF flow for each file
      ↓
Close progress window + cleanup
```

## Complete Shortcuts action order

```text
Receive Folders and PDFs from Quick Actions
│
├─ Run Shell Script                         A: startup cleanup
│
└─ Repeat with each item in Shortcut Input
    │
    ├─ Get File Extension from Repeat Item
    │
    └─ If File Extension is pdf
        │
        ├─ Run AppleScript                   B1: copy direct PDF to /tmp
        │     Input: Repeat Item
        │
        ├─ Run Shell Script                  C1: OCR
        │     Input: AppleScript Result
        │     Pass Input: as arguments
        │
        ├─ Run AppleScript                   D1: replace original
        │     Input: Shell Script Result
        │
        └─ Otherwise
            │
            ├─ Get contents of Repeat Item
            │     Recursive: ON
            │
            ├─ Filter Folder Contents
            │     File Extension is pdf
            │
            ├─ Run Shell Script              E: launch progress
            │     Input: Files
            │     Pass Input: as arguments
            │
            ├─ Repeat with each item in Files
            │   │
            │   ├─ Run AppleScript           B2: copy PDF to /tmp
            │   │     Input: Repeat Item 2
            │   │
            │   ├─ Run Shell Script          C2: OCR
            │   │     Input: AppleScript Result
            │   │     Pass Input: as arguments
            │   │
            │   ├─ Run AppleScript           D2: replace/interpret result
            │   │     Input: Shell Script Result
            │   │
            │   ├─ Get Text from AppleScript Result
            │   │
            │   └─ If Text is CANCELLED
            │       │
            │       ├─ Run Shell Script      F: cancel cleanup
            │       ├─ Stop and Output       "Cancelled"
            │       │
            │       └─ Otherwise
            │           └─ Run Shell Script  G: update progress
            │
            └─ End Repeat
                │
                └─ Run Shell Script          H: close progress
```

All Run Shell Script actions should have **Run as Administrator OFF**.
