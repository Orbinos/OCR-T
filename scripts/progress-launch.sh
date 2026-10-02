#!/bin/bash

DIALOG="/usr/local/bin/dialog"

CMD="/tmp/OCR-T-progress.log"
COUNTFILE="/tmp/OCR-T-progress-count"
TOTALFILE="/tmp/OCR-T-progress-total"
FOLDERFILE="/tmp/OCR-T-progress-folders.txt"
CANCELFILE="/tmp/OCR-T-cancel"
PIDFILE="/tmp/OCR-T-ocr.pid"

TOTAL="$#"

rm -f     "$CMD"     "$COUNTFILE"     "$TOTALFILE"     "$FOLDERFILE"     "$CANCELFILE"     "$PIDFILE"

printf '0' > "$COUNTFILE"
printf '%s' "$TOTAL" > "$TOTALFILE"
touch "$CMD"

if [[ "$TOTAL" -eq 0 ]]; then
    exit 0
fi

if [[ ! -x "$DIALOG" ]]; then
    osascript -e 'display alert "OCR-T" message "swiftDialog was not found at /usr/local/bin/dialog."'
    exit 1
fi

for f in "$@"; do
    dirname "$f"
done | sort -u > "$FOLDERFILE"

FOLDERS_HTML=""
while IFS= read -r folder; do
    if [[ -n "$folder" ]]; then
        FOLDERS_HTML="${FOLDERS_HTML}• ${folder}<br>"
    fi
done < "$FOLDERFILE"

MESSAGE="**Current file**<br>Waiting to start…<br><br>**Folders**<br>${FOLDERS_HTML}"

(
    "$DIALOG"         --title "OCR-T"         --icon none         --message "$MESSAGE"         --messagealignment left         --progress "$TOTAL"         --progresstext "0 of $TOTAL"         --width 650         --height 360         --resizable         --windowbuttons close,min,max         --button1text none         --button2text "Cancel OCR"         --button2symbol "xmark.circle"         --commandfile "$CMD"         >/dev/null 2>&1

    RESULT=$?

    if [[ "$RESULT" -eq 2 ]]; then
        touch "$CANCELFILE"

        if [[ -f "$PIDFILE" ]]; then
            OCRPID="$(cat "$PIDFILE")"
            /usr/bin/pkill -TERM -P "$OCRPID" 2>/dev/null || true
            /bin/kill -TERM "$OCRPID" 2>/dev/null || true
        fi
    fi
) &

sleep 0.3
exit 0
