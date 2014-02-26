AutoItSetOption("MustDeclareVars", 1)

;; GLOBAL VARIABLES
Global $settingsFile = @ScriptDir & "\corrdl.ini"
Global $dlScr = "download.txt", $dlLog = "down_log.txt"
Global $filepattern = "corr*in*.dat"
Local $up[5], $down[5]

;; load settings
_SettingsLoad($up, $down)

;;;;;
;; DOWNLOAD CORRECTIONS
_ScriptDownload($down[0], $down[1], $down[2], $down[4], $down[3], @ScriptDir, $filepattern)
_TransferFiles($dlScr, $dlLog)

;; Delete the WinSCP scripts
FileDelete(@ScriptDir & "\" & $dlScr)

;; Move the file
FileMove(@ScriptDir & "\" & $filepattern, $up[0] & "\" & $up[1], 1)

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