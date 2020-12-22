# How to report an issue or bug

## Step 1 - Start-Transcript

In order to help us understand and preproduce the problem locally if needed please start transcription before you reproduce the issue.
This will create a record of all or part of a PowerShell session to a text file.

```powershell
PS C:\> Start-Transcript
```

If you do not specify a path, Start-Transcript uses the path in the value of the $Transcript global variable. If you have not created this variable, Start-Transcript stores the transcripts in the $Home\My Documents directory as \PowerShell_transcript.\<time-stamp\>.txt files.

## Step 2 - Reproduce the issue

Perform any necessary steps in order to reproduce the issue.

## Step 3  - Stop-Transcript

```powershell
PS C:\> Stop-Transcript
```

## Step 4 - Open or update a issue

Go to the [github issues page](https://github.com/easitab/EasitGoWebservice/issues) and open or update an already existing issue with the same problem.
Give the issue a simple title and a short description on what the issue, problem or bug is, label it as an *bug* and attach the transcript file produced under step 3.