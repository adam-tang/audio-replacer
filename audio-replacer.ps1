# Create a folder for audio replaced videos.
$Destination = "$pwd\Replaced"
New-Item -ItemType Directory -Force -Path $Destination | out-null

# Create a folder for logs.
$LogDir = "$pwd\log"
New-Item -ItemType Directory -Force -Path $LogDir | out-null

$SourceAudioFileExists = $false
$AudioFilename = $null
$SourceAudioFullPath = $null
while (!$SourceAudioFileExists) {
    $AudioFilename = Read-Host -Prompt 'Please enter the filename of the audio file you would like to use'
    $SourceAudioFullPath = "$pwd\$AudioFilename"
    $SourceAudioFileExists = Test-Path $SourceAudioFullPath
    if (!$SourceAudioFileExists) {
	Write-Host "ERROR: `"$SourceAudioFullPath`" does not exist."
    }
}



Write-Host ("Replacing audio tracks for incoming .mp4 files with " + $SourceAudioFullPath)

# Create a watcher for the current directory to monitor newly created .mp4 files.
$Filter = “*.mp4”
$Watcher = New-Object System.IO.FileSystemWatcher $pwd, $Filter -Property @{
	IncludeSubdirectories = $False;
	NotifyFilter = [IO.NotifyFilters]’FileName, LastWrite’
}

$ffmpegProcess = {
    $Source = $pwd
    $Destination = "$pwd\Replaced"
    $SourceAudioFullPath = $event.MessageData

    # Overwrite the existing file if it already exists in the output folder, by default.
    # If you would like to skip over existing files instead, add a # to the beginning of the first line and remove it from the second line.
    $OverwriteIfExists = "-y"
    # $OverwriteIfExists = "-n"

    $Filename = $Event.SourceEventArgs.Name

    # Exclude .tmp.mp4 files from being processed.
    if ($Filename.EndsWith(".tmp.mp4")) { return; }

    $SourceFile = "$Source\$Filename"
    $DestinationFile = "$Destination\$Filename"
    $args = "-i `"$SourceFile`" -i `"$SourceAudioFullPath`" -c:v copy -map 0:v:0 -map 1:a:0 $OverwriteIfExists -shortest `"$DestinationFile`"";
    Write-Host ("Processing " + $Filename);

    $ffmpegPath = "$pwd\ffmpeg\bin\ffmpeg.exe"

    # If ffmpeg is already present on your computer, replace the path with the full path of the ffmpeg.exe file.
    # $ffmpegPath = "C:\Users\Adam\Documents\ffmpeg\bin\ffmpeg.exe"

    # Runs ffmpeg and sends output to a log file.
    Start-Process -FilePath $ffmpegPath -ArgumentList $args -Wait -RedirectStandardError "log\audio-replacer-$($Filename).log";
}

# Process any mp4 files that are created or renamed.
$onCreated = Register-ObjectEvent $Watcher Created -SourceIdentifier FileCreated -MessageData $SourceAudioFullPath -Action $ffmpegProcess
$onRenamed = Register-ObjectEvent $Watcher Renamed -SourceIdentifier FileRenamed -MessageData $SourceAudioFullPath -Action $ffmpegProcess

# Keeps the window open to display output.
while ($true) {Start-Sleep 1}