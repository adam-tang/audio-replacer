Overview
--------
This script will watch a folder for new mp4 video files, and replace the audio track of the video with a specified audio file. The resulting video file will be trimmed down to the length of the video or audio file, whichever is shorter.



Prerequisites
-------------
* Before running this script, you will need to change the default Windows 10 PowerShell execution policy by opening a PowerShell console with administrative privileges (Start Menu -> "Windows PowerShell" -> right-click -> "Run as administrator") and typing in the following command without quotes: "Set-ExecutionPolicy RemoteSigned". This will enable you to run PowerShell scripts.

* This script requires the .NET 4.5 framework to be installed.



Usage
-----
Place the contents of this .zip file in the directory where unprocessed files will be stored. The audio file that you will use should also be placed in this directory.

To run the script, right-click on "audio-replacer.ps1" and select "Run with PowerShell". A PowerShell window will open displaying the status of the watcher script. If prompted, enter "y" in the PowerShell window to allow the script to run.

Enter the name of the audio file (e.g. ExampleAudio.mp3) that you would like to use. 

Once you have selected an audio file, the script will automatically check for new .mp4 files in the directory and process them as long as the PowerShell window is open. The processed files will be stored in the "Replaced" subdirectory.

To stop processing videos, close the PowerShell window. The script will terminate automatically.