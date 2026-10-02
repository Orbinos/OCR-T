# OCR-T

OCR-T is a macOS Finder Quick Action for OCRing PDFs in place. It handles individual PDFs, multiple selections, folders, and recursively nested subfolders. The workflow is designed to work with protected and iCloud-backed locations by letting Finder/AppleScript copy files into a temporary local workspace before OCRmyPDF processes them.

## Features

- Finder Quick Action for PDFs and folders
- Recursive subfolder scanning
- German + English OCR
- Deskewing and 400 DPI oversampling
- Replaces poor existing OCR with a fresh text layer
- Live batch progress window via swiftDialog
- Current-file and folder display
- Safe batch cancellation
- Skips cryptographically signed PDFs instead of invalidating signatures
- Cleans temporary files and stale state automatically

## Install

Install the dependencies with Homebrew:

```bash
brew install ocrmypdf
brew install tesseract-lang
brew install --cask swiftdialog
```

Verify them:

```bash
/opt/homebrew/bin/ocrmypdf --version
tesseract --list-langs | grep -E '^(deu|eng)$'
/usr/local/bin/dialog --version
```

OCR-T currently assumes an Apple Silicon Mac, with OCRmyPDF at `/opt/homebrew/bin/ocrmypdf`. On Intel Macs this path normally needs to be changed to `/usr/local/bin/ocrmypdf` in the OCR shell action.

## Get the Shortcut

The current shared shortcut is available here:

https://www.icloud.com/shortcuts/c40f71394eab4ec9ba93325296b9ab35

The repository keeps the individual Bash and AppleScript components under [`scripts/`](scripts/) so the logic can be reviewed and versioned without digging through the Shortcuts editor.

## Architecture

```text
Finder selection
      ↓
Shortcuts identifies PDFs
      ↓
Finder copies each PDF → /tmp/OCR-T-Work
      ↓
OCRmyPDF + Tesseract
      ↓
Finder replaces original
      ↓
Cleanup

Folder selection
      ↓
Recursive PDF scan
      ↓
Progress window
      ↓
Process each PDF using the flow above
      ↓
Cleanup + close progress window
```

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the complete Shortcut action order.

## OCR configuration

OCR-T uses:

```text
--mode force
--deskew
--oversample 400
--pdf-renderer fpdf2
--output-type pdf
--language deu+eng
```

These settings prioritize recognition quality and reasonably tight text-selection geometry in macOS PDF viewers. `--mode force` rasterizes pages, so OCR-T is intended mainly for scanned/image-based PDFs and PDFs with poor existing OCR.

## Important behavior

**Digitally signed PDFs:** OCR-T leaves cryptographically signed PDFs untouched and continues with the rest of the batch. It deliberately does not use `--invalidate-digital-signatures`.

**Handwriting:** Tesseract is primarily intended for printed text. Handwriting may be misrecognized or represented by inaccurate invisible OCR text.

**Cancellation:** During folder batches, the Cancel OCR button terminates the active OCRmyPDF process, preserves the original file, removes temporary state, and stops the Shortcut.

**Permissions:** macOS may ask for permission for Shortcuts to control Finder. Allow this. Full Disk Access is not required by the final workflow.

## Temporary files

OCR-T may create the following during a run:

```text
/tmp/OCR-T-Work/
/tmp/OCR-T-cancel
/tmp/OCR-T-ocr.pid
/tmp/OCR-T-progress.log
/tmp/OCR-T-progress-count
/tmp/OCR-T-progress-total
/tmp/OCR-T-progress-folders.txt
```

They are removed during normal completion or cancellation. Startup cleanup also removes leftovers from an interrupted previous run.

## Repository layout

```text
OCR-T/
├── README.md
├── .gitignore
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DEPENDENCIES.md
│   └── SHORTCUT-BUILD.md
├── scripts/
│   ├── startup-cleanup.sh
│   ├── copy-to-temp.applescript
│   ├── ocr.sh
│   ├── replace-original.applescript
│   ├── progress-launch.sh
│   ├── cancel-cleanup.sh
│   ├── progress-update.sh
│   └── progress-close.sh
└── shortcut/
    ├── README.md
    └── OCR-T.webloc
```
