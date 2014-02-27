#NoTrayIcon
AutoItSetOption("MustDeclareVars", 1)

;; GLOBAL VARIABLES
Global $settingsFile = @ScriptDir & "\corrdl.ini"
Global $dlScr = "download.txt", $dlLog = "down_log.txt"
Global $rmScr = "delete.txt", $rmLog = "rm_log.txt"
Global $filepattern = "corr*.* craa*.* crpg*.* crth*.* pgrq*.* trninfin*.*"
Local $up[5], $down[5]

;; load settings
_SettingsLoad($up, $down)

;; Banner Log folder
Local $bl = $up[0] & $up[1] & "\"

;; Split the patterns, handle one at a time.
For $fpat In StringSplit($filepattern, " ", 1)
   ;; DOWNLOAD CORRECTIONS
   _ScriptDownload($down[0], $down[1], $down[2], $down[4], $down[3], $bl, $fpat)
   _TransferFiles($dlScr, $dlLog)

   ;; Remove corrections from the server
   _ScriptDelete($down[0], $down[1], $down[2], $down[4], $down[3], $filepattern)
   _TransferFiles($rmScr, $rmLog)
Next

;; Remove Winscp.rnd file from share
FileDelete($bl & "winscp.rnd")

;; Delete the WinSCP scripts
FileDelete(@ScriptDir & "\" & $dlScr)
FileDelete(@ScriptDir & "\" & $rmScr)

;; Exit script
Exit

;; Load the Settings for the ProcessClose
Func _SettingsLoad(ByRef $up, ByRef $down)
	;; Ariel settings
	$up[0] = IniRead($settingsFile, "samba", "drivepath", "")
	$up[1] = IniRead($settingsFile, "samba", "pfolder", "")
	;; Oracle settings
	$down[0] = IniRead($settingsFile, "oracle", "sftp_user", "")
	$down[1] = IniRead($settingsFile, "oracle", "sftp_pass", "")
	$down[2] = IniRead($settingsFile, "oracle", "sftp_remotehost", "")
	$down[3] = IniRead($settingsFile, "oracle", "sftp_remotepath", "")
	$down[4] = IniRead($settingsFile, "oracle", "sftp_hostkey", "")
EndFunc

;; Create the WinSCP download script
Func _ScriptDownload($id, $pw, $host, $hk, $rd, $ld, $files)
	Dim $fr = FileOpen($dlScr, 2)
	If $fr = -1 Then _Box("Cannot create download script.")
	FileWriteLine($fr, "option batch abort")
	FileWriteLine($fr, "option confirm off")
	FileWriteLine($fr, "open sftp://" & $id & ":" & $pw & "@" & $host & " -hostkey=""" & $hk & """")
	FileWriteLine($fr, "option transfer binary")
	FileWriteLine($fr, "cd " & $rd)
	FileWriteLine($fr, "lcd " & $ld)
	FileWriteLine($fr, "get " & $files)
	FileWriteLine($fr, "close")
	FileWriteLine($fr, "exit")
	FileClose($fr)
EndFunc

;; Delete dat files from the Batch server
Func _ScriptDelete($id, $pw, $host, $hk, $rd, $files)
	Dim $fr = FileOpen($rmScr, 2)
	If $fr = -1 Then _Box("Cannot create download script.")
	FileWriteLine($fr, "option batch abort")
	FileWriteLine($fr, "option confirm off")
	FileWriteLine($fr, "open sftp://" & $id & ":" & $pw & "@" & $host & " -hostkey=""" & $hk & """")
	FileWriteLine($fr, "option transfer binary")
	FileWriteLine($fr, "cd " & $rd)
	FileWriteLine($fr, "rm " & $files)
	FileWriteLine($fr, "close")
	FileWriteLine($fr, "exit")
	FileClose($fr)
EndFunc

;; Run WinSCP using a file as the commands
Func _TransferFiles($script, $log)
	Dim $params = " /script=" & $script & " /log=" & $log
	ShellExecuteWait("WinSCP.exe", $params, @ScriptDir)
EndFunc

;; A generic error message box and program exit
Func _Box($msg)
	MsgBox(1024, "ALERT", $msg)
	Exit
EndFunc