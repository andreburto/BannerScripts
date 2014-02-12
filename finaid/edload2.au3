#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

AutoItSetOption("MustDeclareVars", 1)

Global $gui, $winTitle, $winWidth, $winHeight, $startPosX, $startPosY
Global $settingsFile
Global $btnBegin, $btnSettings, $btnExit
Global $upScr = "upload.txt", $upLog = "up_log.txt"
Global $dlScr = "download.txt", $dlLog = "down_log.txt"

;; declare globals
$settingsFile = @ScriptDir & "\edload.ini"

;; Set some initial values
$winTitle = $winTitle
$winWidth = 320
$winHeight = 120
$startPosX = (@DesktopWidth - $winWidth) / 2
$startPosY = (@DesktopHeight - $winHeight) / 2

;; Create the GUI
$gui = GUICreate($winTitle, $winWidth, $winHeight, $startPosX, $startPosY, BitOr($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX))
$btnBegin = GUICtrlCreateButton("Start", 5, 5, 305, 35)
$btnSettings = GUICtrlCreateButton("Settings", 5, 45, 150, 35)
$btnExit = GUICtrlCreateButton("Exit", 160, 45, 150, 35)

;; Display the GUI
GUISetState(@SW_SHOW, $gui);

;; Check for the settings file
If FileExists($settingsFile) = 0 Then
	_SettingsGUI()
	_Box("New settings file created. Please run the program again to load the file.")
EndIf

;; Main Event Loop
While 1
	Local $msg = GUIGetMsg()
	
	Switch $msg
        Case $GUI_EVENT_CLOSE ; Ends the program
            ExitLoop
		Case $btnBegin ; Starts the process
			_TheProcess();
		Case $btnSettings ; Runs the Settings GUI
			GUISetState(@SW_MINIMIZE, $gui);
			_SettingsGUI();
			GUISetState(@SW_RESTORE, $gui);
		Case $btnExit
			ExitLoop
	EndSwitch
WEnd

;; End the main loop, exit program, goodnight
GUIDelete($gui)
Exit

;; This is the GUI for modifying the settings.ini file.
Func _SettingsGUI()
	;; Variables for the GUI
	Local $sgui, $swidth, $sheight, $sX, $sY
	Local $up[5], $down[5], $paths[5]
	Local $up[5], $btnSave, $btnNevermind

	;; GUI variables
	$swidth = 400
	$sheight = 380
	$sX = (@DesktopWidth - $swidth) / 2
	$sY = (@DesktopHeight - $sheight) / 2

	;; Setup the GUI
	$sgui = GUICreate("Settings", $swidth, $sheight, $sX, $sY)
	GUICtrlCreateTab(5, 5, 385, 300)

	GUICtrlCreateTabItem("DOWNLOAD")
	GUICtrlCreateLabel("Information for the ED Connect Server", 15, 30, 250, 15)
	GUICtrlCreateLabel("User name: ", 15, 55, 85, 15, $SS_RIGHT)
	$down[0] = GUICtrlCreateInput("", 100, 55, 200, 20)
	GUICtrlCreateLabel("Password: ", 15, 90, 85, 15, $SS_RIGHT)
	$down[1] = GUICtrlCreateInput("", 100, 90, 200, 20)
	GUICtrlCreateLabel("Remote Host: ", 15, 125, 85, 15, $SS_RIGHT)
	$down[2] = GUICtrlCreateInput("", 100, 125, 200, 20)
	GUICtrlCreateLabel("Remote Path: ", 15, 160, 85, 15, $SS_RIGHT)
	$down[3] = GUICtrlCreateInput("", 100, 160, 200, 20)
	GUICtrlCreateLabel("Hostkey: ", 15, 195, 85, 15, $SS_RIGHT)
	$down[4] = GUICtrlCreateInput("", 100, 195, 200, 20)

	GUICtrlCreateTabItem("UPLOAD")
	GUICtrlCreateLabel("Information for the Oracle Server", 15, 30, 250, 15)
	GUICtrlCreateLabel("User name: ", 15, 55, 85, 15, $SS_RIGHT)
	$up[0] = GUICtrlCreateInput("", 100, 55, 200, 20)
	GUICtrlCreateLabel("Password: ", 15, 90, 85, 15, $SS_RIGHT)
	$up[1] = GUICtrlCreateInput("", 100, 90, 200, 20)
	GUICtrlCreateLabel("Remote Host: ", 15, 125, 85, 15, $SS_RIGHT)
	$up[2] = GUICtrlCreateInput("", 100, 125, 200, 20)
	GUICtrlCreateLabel("Remote Path: ", 15, 160, 85, 15, $SS_RIGHT)
	$up[3] = GUICtrlCreateInput("", 100, 160, 200, 20)
	GUICtrlCreateLabel("Hostkey: ", 15, 195, 85, 15, $SS_RIGHT)
	$up[4] = GUICtrlCreateInput("", 100, 195, 200, 20)

	GUICtrlCreateTabItem("PATH INFO")
	GUICtrlCreateLabel("Path Information for This Client", 15, 30, 250, 15)
	GUICtrlCreateLabel("CORRECTIONS: ", 15, 55, 85, 15, $SS_RIGHT)
	$paths[0] = GUICtrlCreateInput("", 100, 55, 200, 20)
	GUICtrlCreateLabel("COMPILED: ", 15, 90, 85, 15, $SS_RIGHT)
	$paths[1] = GUICtrlCreateInput("", 100, 90, 200, 20)
	GUICtrlCreateLabel("BIN: ", 15, 125, 85, 15, $SS_RIGHT)
	$paths[2] = GUICtrlCreateInput("", 100, 125, 200, 20)
	GUICtrlCreateLabel("TEMP: ", 15, 160, 85, 15, $SS_RIGHT)
	$paths[3] = GUICtrlCreateInput("", 100, 160, 200, 20)

	GUICtrlCreateTabItem("")

	$btnSave = GUICtrlCreateButton("Save", 5, 310, 120, 30)
	$btnNevermind = GUICtrlCreateButton("Exit", 130, 310, 120, 30)
	
	;; Display the GUI
	GUISetState(@SW_SHOW, $sgui);
	
	;; Load settings
	_SettingsLoadforGUI($up, $down, $paths)
	
	;; Event loop
	While 1
		Local $msg = GUIGetMsg();
		
		Switch $msg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $btnSave
				_SettingsSaveforGUI($up, $down, $paths)
				ExitLoop
			Case $btnNevermind
				ExitLoop
		EndSwitch
	WEnd
	
	;; Bye bye
	GUIDelete($sgui);
EndFunc

;; Loads the settings
Func _SettingsLoadforGUI(ByRef $up, ByRef $down, ByRef $paths)
	;; Ariel settings
	GUICtrlSetData($down[0], IniRead($settingsFile, "samba", "sftp_user", ""))
	GUICtrlSetData($down[1], IniRead($settingsFile, "samba", "sftp_pass", ""))
	GUICtrlSetData($down[2], IniRead($settingsFile, "samba", "sftp_remotehost", ""))
	GUICtrlSetData($down[3], IniRead($settingsFile, "samba", "sftp_remotepath", ""))
	GUICtrlSetData($down[4], IniRead($settingsFile, "samba", "sftp_hostkey", ""))
	;; Oracle settings
	GUICtrlSetData($up[0], IniRead($settingsFile, "oracle", "sftp_user", ""))
	GUICtrlSetData($up[1], IniRead($settingsFile, "oracle", "sftp_pass", ""))
	GUICtrlSetData($up[2], IniRead($settingsFile, "oracle", "sftp_remotehost", ""))
	GUICtrlSetData($up[3], IniRead($settingsFile, "oracle", "sftp_remotepath", ""))
	GUICtrlSetData($up[4], IniRead($settingsFile, "oracle", "sftp_hostkey", ""))
	;; Path settings
	GUICtrlSetData($paths[0], IniRead($settingsFile, "client", "COR", "CORRECTIONS"))
	GUICtrlSetData($paths[1], IniRead($settingsFile, "client", "COM", "COMPILED"))
	GUICtrlSetData($paths[2], IniRead($settingsFile, "client", "BIN", "BIN"))
	GUICtrlSetData($paths[3], IniRead($settingsFile, "client", "TMP", "TEMP"))
EndFunc

;; Saves the settings
Func _SettingsSaveforGUI(ByRef $up, ByRef $down, ByRef $paths)
	;; Ariel settings
	IniWrite($settingsFile, "samba", "sftp_user", GUICtrlRead($down[0]))
	IniWrite($settingsFile, "samba", "sftp_pass", GUICtrlRead($down[1]))
	IniWrite($settingsFile, "samba", "sftp_remotehost", GUICtrlRead($down[2]))
	IniWrite($settingsFile, "samba", "sftp_remotepath", GUICtrlRead($down[3]))
	IniWrite($settingsFile, "samba", "sftp_hostkey", GUICtrlRead($down[4]))
	;; Oracle settings
	IniWrite($settingsFile, "oracle", "sftp_user", GUICtrlRead($up[0]))
	IniWrite($settingsFile, "oracle", "sftp_pass", GUICtrlRead($up[1]))
	IniWrite($settingsFile, "oracle", "sftp_remotehost", GUICtrlRead($up[2]))
	IniWrite($settingsFile, "oracle", "sftp_remotepath", GUICtrlRead($up[3]))
	IniWrite($settingsFile, "oracle", "sftp_hostkey", GUICtrlRead($up[4]))
	;; Path settings
	IniWrite($settingsFile, "client", "COR", GUICtrlRead($paths[0]))
	IniWrite($settingsFile, "client", "COM", GUICtrlRead($paths[1]))
	IniWrite($settingsFile, "client", "BIN", GUICtrlRead($paths[2]))
	IniWrite($settingsFile, "client", "TMP", GUICtrlRead($paths[3]))
EndFunc

;; Load the Settings for the ProcessClose
Func _SettingsLoad(ByRef $up, ByRef $down, ByRef $paths)
	;; Ariel settings
	$down[0] = IniRead($settingsFile, "samba", "sftp_user", "")
	$down[1] = IniRead($settingsFile, "samba", "sftp_pass", "")
	$down[2] = IniRead($settingsFile, "samba", "sftp_remotehost", "")
	$down[3] = IniRead($settingsFile, "samba", "sftp_remotepath", "")
	$down[4] = IniRead($settingsFile, "samba", "sftp_hostkey", "")
	;; Oracle settings
	$up[0] = IniRead($settingsFile, "oracle", "sftp_user", "")
	$up[1] = IniRead($settingsFile, "oracle", "sftp_pass", "")
	$up[2] = IniRead($settingsFile, "oracle", "sftp_remotehost", "")
	$up[3] = IniRead($settingsFile, "oracle", "sftp_remotepath", "")
	$up[4] = IniRead($settingsFile, "oracle", "sftp_hostkey", "")
	;; Path settings
	$paths[0] = IniRead($settingsFile, "client", "COR", "CORRECTIONS")
	$paths[1] = IniRead($settingsFile, "client", "COM", "COMPILED")
	$paths[2] = IniRead($settingsFile, "client", "BIN", "BIN")
	$paths[3] = IniRead($settingsFile, "client", "TMP", "TEMP")
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

;; Create the WinSCP upload script
Func _ScriptUpload($id, $pw, $host, $hk, $rd, $ld, $files)
	Dim $fr = FileOpen($upScr, 2)
	If $fr = -1 Then _Box("Cannot create download script.")
	FileWriteLine($fr, "option batch abort")
	FileWriteLine($fr, "option confirm off")
	FileWriteLine($fr, "open sftp://" & $id & ":" & $pw & "@" & $host & " -hostkey=""" & $hk & """")
	FileWriteLine($fr, "option transfer binary")
	FileWriteLine($fr, "cd " & $rd)
	FileWriteLine($fr, "lcd " & $ld)
	FileWriteLine($fr, "put " & $files)
	FileWriteLine($fr, "close")
	FileWriteLine($fr, "exit")
	FileClose($fr)
EndFunc

;; Run WinSCP using a file as the commands
Func _TransferFiles($script, $log)
	Dim $params = " /script=" & $script & " /log=" & $log
	ShellExecuteWait("WinSCP.exe", $params, @ScriptDir)
EndFunc

;; Run catall.exe to concatenate files.
Func _CatFiles($p, $i, $o)
	Dim $args = "-p " & $p & " -i " & $i & " -o " & $o & " -read char"
	ShellExecuteWait("catall.exe", $args, @ScriptDir)
EndFunc

Func _TimeStamp()
	return @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC
EndFunc

;; A generic error message box and program exit
Func _Box($msg)
	MsgBox(1024, "ALERT", $msg)
	Exit
EndFunc

;; The Process
Func _TheProcess()
	;; Settings holders
	Local $up[5], $down[5], $paths[5]
	
	;; base directory where the folders are
	Dim $base_dir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, $paths[2]) - 1)

	;; Calculate the years
	Dim $year = Int(StringRight(@YEAR, 2))
	Dim $next = $year + 1
	Dim $nextnext = $year + 2
	Dim $last = $year - 1
	If $last < 0 Then $last = 99

	;;;;;
	;; DOWNLOAD CORRECTIONS
	_ScriptDownload($down[0], $down[1], $down[2], $down[4], $down[3], $base_dir & $paths[3], "igco*.*")
	_ScriptUpload($up[0], $up[1], $up[2], $up[4], $up[3], $base_dir & $paths[0], "*.tap")
	_TransferFiles($dlScr, $dlLog)

	_CatFiles($base_dir & $paths[3], "igco" & $year & "*.*", $last & $year & "corr.tap")
	_CatFiles($base_dir & $paths[3], "igco" & $next & "*.*", $year & $next & "corr.tap")
	_CatFiles($base_dir & $paths[3], "igco" & $nextnext & "*.*", $next & $nextnext & "corr.tap")

	FileMove($base_dir & $paths[3] & "\*corr.tap", $base_dir & $paths[0], 1)

	_TransferFiles($upScr, $upLog)

	;; After everything, clear out the TEMP directories. LEAVE $paths[2] ALONE!
	FileDelete($base_dir & $paths[3] & "\*.*")

	;;;;;
	;; DOWNLOAD AND COMPILE esar FILES
	Dim $filesegs[6] = ["isrf", "igsa", "idap", "idsa", "igsa", "igsg"]
	Dim $twoyears[2] = [$next, $nextnext]
	For $files In $filesegs
	   For $yr In $twoyears
		  _ScriptDownload($down[0], $down[1], $down[2], $down[4], $down[3], $base_dir & $paths[3], $files & $yr & "*.*")
		  _TransferFiles($dlScr, $dlLog)
	   Next
	Next

	Dim $catstr = _ArrayToString($filesegs, "99*.*,") & "99*.*"
	_CatFiles($base_dir & $paths[3], StringReplace($catstr, "99", $next), $year & $next & "ESAR.TAP")
	_CatFiles($base_dir & $paths[3], StringReplace($catstr, "99", $nextnext), $next & $nextnext & "ESAR.TAP")

	FileMove($base_dir & $paths[3] & "\*ESAR.TAP", $base_dir & $paths[1], 1)

	_ScriptUpload($up[0], $up[1], $up[2], $up[4], $up[3], $base_dir & $paths[1], "*ESAR.TAP")

	_TransferFiles($upScr, $upLog)

	;; After everything, clear out the TEMP directories. LEAVE $paths[2] ALONE!
	FileDelete($base_dir & $paths[3] & "\*.*")

	;; Delete the WinSCP scripts
	FileDelete(@ScriptDir & "\" & $upScr)
	FileDelete(@ScriptDir & "\" & $dlScr)

	;; Alert
	MsgBox(1024, "Finished", "You may complete the process in Banner.")
EndFunc