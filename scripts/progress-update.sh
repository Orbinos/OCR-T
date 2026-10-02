#!/bin/bash

CMD="/tmp/OCR-T-progress.log"
COUNTFILE="/tmp/OCR-T-progress-count"
TOTALFILE="/tmp/OCR-T-progress-total"

if [[ ! -f "$CMD" || ! -f "$COUNTFILE" || ! -f "$TOTALFILE" ]]; then
    exit 0
fi

CURRENT="$(cat "$COUNTFILE")"
TOTAL="$(cat "$TOTALFILE")"
CURRENT=$((CURRENT + 1))

printf '%s' "$CURRENT" > "$COUNTFILE"
printf 'progress: %s
' "$CURRENT" >> "$CMD"
printf 'progresstext: %s of %s
' "$CURRENT" "$TOTAL" >> "$CMD"

exit 0
