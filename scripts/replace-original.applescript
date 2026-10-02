on run {input, parameters}

    set shellOutput to input as text
    set outputParts to paragraphs of shellOutput

    if (count of outputParts) > 0 then
        if item 1 of outputParts is "CANCELLED" then
            do shell script "/bin/rm -rf '/tmp/OCR-T-Work'"
            return "CANCELLED"
        end if
    end if

    if (count of outputParts) > 0 then
        if item 1 of outputParts is "SKIP_SIGNATURE" then
            do shell script "/bin/rm -rf '/tmp/OCR-T-Work'"
            return "SKIPPED"
        end if
    end if

    if (count of outputParts) < 2 then
        error "OCR-T received an unexpected OCR result: " & shellOutput
    end if

    set finishedPath to item 1 of outputParts
    set destinationPath to item 2 of outputParts

    set finishedAlias to POSIX file finishedPath as alias
    set destinationAlias to POSIX file destinationPath as alias

    set oldAlertVolume to alert volume of (get volume settings)

    try
        set volume alert volume 0

        tell application "Finder"
            duplicate file finishedAlias to folder destinationAlias with replacing
        end tell

    on error errMsg number errNum
        set volume alert volume oldAlertVolume
        error errMsg number errNum
    end try

    set volume alert volume oldAlertVolume

    do shell script "/bin/rm -rf '/tmp/OCR-T-Work'"

    return "OK"

end run
