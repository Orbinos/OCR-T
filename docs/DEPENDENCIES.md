# Dependencies

## Required

### Homebrew

Used to install the command-line dependencies.

https://brew.sh

### OCRmyPDF

```bash
brew install ocrmypdf
```

Expected Apple Silicon path:

```text
/opt/homebrew/bin/ocrmypdf
```

### Tesseract language data

```bash
brew install tesseract-lang
```

OCR-T requires:

- `deu` — German
- `eng` — English

Verify:

```bash
tesseract --list-langs
```

### swiftDialog

Provides the batch progress window.

```bash
brew install --cask swiftdialog
```

Expected path:

```text
/usr/local/bin/dialog
```

Verify:

```bash
/usr/local/bin/dialog --version
```

## macOS permissions

OCR-T uses AppleScript to ask Finder to copy and replace files in locations that may be protected or backed by iCloud Drive. macOS may request permission for Shortcuts to control Finder. This permission should be allowed.

The final workflow does not require Full Disk Access.
