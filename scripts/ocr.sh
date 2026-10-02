#!/bin/bash

INPUT="$1"
ORIGINAL="$2"

NAME="$(basename "$ORIGINAL")"
DESTDIR="$(dirname "$ORIGINAL")"

WORKDIR="/tmp/OCR-T-Work"
OUTPUT="$WORKDIR/OCR-T-output.pdf"
FINAL="$WORKDIR/$NAME"
LOG="$WORKDIR/ocrmypdf.log"

CMD="/tmp/OCR-T-progress.log"
FOLDERFILE="/tmp/OCR-T-progress-folders.txt"
CANCELFILE="/tmp/OCR-T-cancel"
PIDFILE="/tmp/OCR-T-ocr.pid"

if [[ -f "$CANCELFILE" ]]; then
    rm -rf "$WORKDIR"
    printf 'CANCELLED
'
    exit 0
fi

if [[ -f "$CMD" ]]; then
    FOLDERS_HTML=""

    if [[ -f "$FOLDERFILE" ]]; then
        while IFS= read -r folder; do
            if [[ -n "$folder" ]]; then
                FOLDERS_HTML="${FOLDERS_HTML}• ${folder}<br>"
            fi
        done < "$FOLDERFILE"
    fi

    MESSAGE="**Current file**<br>${NAME}<br><br>**Folders**<br>${FOLDERS_HTML}"
    printf 'message: %s
' "$MESSAGE" >> "$CMD"
fi

/opt/homebrew/bin/ocrmypdf     --mode force     --deskew     --oversample 400     --pdf-renderer fpdf2     --output-type pdf     --language deu+eng     "$INPUT"     "$OUTPUT"     >"$LOG" 2>&1 &

OCRPID=$!
printf '%s' "$OCRPID" > "$PIDFILE"

wait "$OCRPID"
STATUS=$?

rm -f "$PIDFILE"

if [[ -f "$CANCELFILE" ]]; then
    rm -rf "$WORKDIR"
    printf 'CANCELLED
'
    exit 0
fi

if [[ $STATUS -ne 0 ]]; then
    if grep -qi "digital signature" "$LOG"; then
        printf 'SKIP_SIGNATURE
%s
' "$ORIGINAL"
        exit 0
    fi

    cat "$LOG" >&2
    rm -rf "$WORKDIR"
    exit $STATUS
fi

rm -f "$INPUT"
mv "$OUTPUT" "$FINAL"

printf '%s
%s
' "$FINAL" "$DESTDIR"
