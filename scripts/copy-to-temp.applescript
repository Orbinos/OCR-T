on run {input, parameters}

    if class of input is list then
        set sourceItem to item 1 of input
    else
        set sourceItem to input
    end if

    set sourcePath to POSIX path of sourceItem
    set sourceAlias to POSIX file sourcePath as alias

    set tempPath to "/tmp/OCR-T-Work"

    do shell script "/bin/rm -rf " & quoted form of tempPath
    do shell script "/bin/mkdir -p " & quoted form of tempPath

    set tempFolderAlias to POSIX file tempPath as alias

    set oldAlertVolume to alert volume of (get volume settings)

    try
        set volume alert volume 0

        tell application "Finder"
            set copiedFile to duplicate file sourceAlias to folder tempFolderAlias with replacing
        end tell

    on error errMsg number errNum
        set volume alert volume oldAlertVolume
        error errMsg number errNum
    end try

    set volume alert volume oldAlertVolume

    return {POSIX path of (copiedFile as alias), sourcePath}

end run
