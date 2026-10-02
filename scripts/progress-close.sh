#!/bin/bash

CMD="/tmp/OCR-T-progress.log"

if [[ -f "$CMD" ]]; then
    printf 'progress: complete
' >> "$CMD"
    printf 'progresstext: Complete
' >> "$CMD"
    sleep 0.8
    printf 'quit:
' >> "$CMD"
fi

rm -f     "/tmp/OCR-T-cancel"     "/tmp/OCR-T-ocr.pid"     "/tmp/OCR-T-progress-count"     "/tmp/OCR-T-progress-total"     "/tmp/OCR-T-progress-folders.txt"     "/tmp/OCR-T-progress.log"

rm -rf "/tmp/OCR-T-Work"

exit 0
