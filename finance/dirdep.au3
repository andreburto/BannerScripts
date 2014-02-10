#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
AutoItSetOption("MustDeclareVars", 1)

;; Global variables -- I know, globals bad
Global $gui, $winTitle, $winWidth, $winHeight, $startPosX, $startPosY
Global $btnDownload, $btnSettings, $txtFilename, $lblDirections
Global $settingsFile = @ScriptDir & "\settings.ini"
Global $dlScr = "download.txt", $dlLog = "down_log.txt"
Global $base_dir = StringLeft(@ScriptDir, StringInStr(@ScriptDir, "BIN") - 1)

;; Set some initial values
$winTitle = "Direct Deposit Download"
$winWidth = 320
$winHeight = 150
$startPosX = (@DesktopWidth - $winWidth) / 2
$startPosY = (@DesktopHeight - $winHeight) / 2

;; Build the GUI
$gui = GUICreate($winTitle, $winWidth, $winHeight, $startPosX, $startPosY)
$lblDirections = GUICtrlCreateLabel("Enter the sequence number of the Direct Deposit below.", 5, 5, 310, 60)
GUICtrlSetBkColor($lblDirections, 0x000000)
GUICtrlSetColor($lblDirections, 0xff0000)
GUICtrlSetFont($lblDirections, 18)
GUICtrlSetTip($lblDirections, "You know what to do.")
$txtFilename = GUICtrlCreateInput("", 5, 70, 310, 25);
GUICtrlSetFont($txtFilename, 10)
GUICtrlSetTip($txtFilename, "Yep, right here.")
$btnDownload = GUICtrlCreateButton("Download", 5, 105, 150, 35)
$btnSettings = GUICtrlCreateButton("Settings", 165, 105, 150, 35)

;; Display the GUI
GUISetState(@SW_SHOW, $gui);

;; Check for the settings file
If FileExists($settingsFile) = 0 Then
	_SettingsGUI()
	_Box("New settings file created. Please run the program again to load the file.")
EndIf

;; Event Loop
While 1
	Local $msg = GUIGetMsg()
	
	Switch $msg
        Case $GUI_EVENT_CLOSE ; Ends the program
            ExitLoop
		Case $btnDownload ; Downloads the LIS file
			Local $file = _MakeDIRDFile(GUICtrlRead($txtFilename))
			If StringLen($file) > 0 Then
				Local $settings[5]
				_SettingsGet($settings)
				_ScriptDownload($settings[0],$settings[1],$settings[2],$settings[4],$settings[3],$base_dir,$file)
				_TransferFiles($dlScr, $dlLog)
				If FileExists($base_dir&"\"&$file) = 1 Then
					FileDelete($dlScr)
					FileDelete($dlLog)
					ShellExecute("explorer.exe", $base_dir)
					ExitLoop
				Else
					MsgBox(1024, "ALERT", "The file did not download.")
					MsgBox(1024, "ALERT", $base_dir&"\"&$file)
				EndIf
			Else
				MsgBox(1024, "ALERT", "You must enter a file name.")
			EndIf
		Case $btnSettings ; Runs the Settings GUI
			GUISetState(@SW_MINIMIZE, $gui);
			_SettingsGUI();
			GUISetState(@SW_RESTORE, $gui);
	EndSwitch
WEnd

;; End the main loop, exit program, goodnight
GUIDelete($gui)
Exit

;; This is the GUI for modifying the settings.ini file.
Func _SettingsGUI()
	;; Variables for the GUI
	Local $sgui, $swidth, $sheight, $sX, $sY
	Local $up[5], $btnSave, $btnNevermind

	;; GUI variables
	$swidth = 310
	$sheight = 250
	$sX = (@DesktopWidth - $swidth) / 2
	$sY = (@DesktopHeight - $sheight) / 2

	;; Setup the GUI
	$sgui = GUICreate("Settings", $swidth, $sheight, $sX, $sY)
	GUICtrlCreateLabel("Information for the Batch Server", 15, 10, 250, 15)
	GUICtrlCreateLabel("User name: ", 15, 35, 85, 15, $SS_RIGHT)
	$up[0] = GUICtrlCreateInput("", 100, 35, 200, 20)
	GUICtrlCreateLabel("Password: ", 15, 70, 85, 15, $SS_RIGHT)
	$up[1] = GUICtrlCreateInput("", 100, 70, 200, 20)
	GUICtrlCreateLabel("Remote Host: ", 15, 105, 85, 15, $SS_RIGHT)
	$up[2] = GUICtrlCreateInput("", 100, 105, 200, 20)
	GUICtrlCreateLabel("Remote Path: ", 15, 140, 85, 15, $SS_RIGHT)
	$up[3] = GUICtrlCreateInput("", 100, 140, 200, 20)
	GUICtrlCreateLabel("Hostkey: ", 15, 175, 85, 15, $SS_RIGHT)
	$up[4] = GUICtrlCreateInput("", 100, 175, 200, 20)
	$btnSave = GUICtrlCreateButton("Save & Exit", 10, 205, 140, 35)
	$btnNevermind = GUICtrlCreateButton("Nevermind", 160, 205, 140, 35)
	
	;; Display the GUI
	GUISetState(@SW_SHOW, $sgui);
	
	;; Load settings
	_SettingsLoad($up)
	
	;; Event loop
	While 1
		Local $msg = GUIGetMsg();
		
		Switch $msg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $btnSave
				_SettingsSave($up)
				ExitLoop
			Case $btnNevermind
				ExitLoop
		EndSwitch
	WEnd
	
	;; Bye bye
	GUIDelete($sgui);
EndFunc

;; This area is updating/saving the settings.ini file.
Func _SettingsSave(ByRef $up)
	;; Batch settings
	IniWrite($settingsFile, "batch", "sftp_user", GUICtrlRead($up[0]))
	IniWrite($settingsFile, "batch", "sftp_pass", GUICtrlRead($up[1]))
	IniWrite($settingsFile, "batch", "sftp_remotehost", GUICtrlRead($up[2]))
	IniWrite($settingsFile, "batch", "sftp_remotepath", GUICtrlRead($up[3]))
	IniWrite($settingsFile, "batch", "sftp_hostkey", GUICtrlRead($up[4]))
EndFunc

;; This is for loading the settings.ini file.
Func _SettingsLoad(ByRef $up)
	;; Batch settings
	GUICtrlSetData($up[0], IniRead($settingsFile, "batch", "sftp_user", ""))
	GUICtrlSetData($up[1], IniRead($settingsFile, "batch", "sftp_pass", ""))
	GUICtrlSetData($up[2], IniRead($settingsFile, "batch", "sftp_remotehost", ""))
	GUICtrlSetData($up[3], IniRead($settingsFile, "batch", "sftp_remotepath", ""))
	GUICtrlSetData($up[4], IniRead($settingsFile, "batch", "sftp_hostkey", ""))
EndFunc

;; This is for loading the settings.ini file.
Func _SettingsGet(ByRef $up)
	;; Batch settings
	$up[0] = IniRead($settingsFile, "batch", "sftp_user", "")
	$up[1] = IniRead($settingsFile, "batch", "sftp_pass", "")
	$up[2] = IniRead($settingsFile, "batch", "sftp_remotehost", "")
	$up[3] = IniRead($settingsFile, "batch", "sftp_remotepath", "")
	$up[4] = IniRead($settingsFile, "batch", "sftp_hostkey", "")
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

;; Stupid simple function for building the file name
Func _MakeDIRDFile($seq)
	Return "phpdird_" & $seq & ".lis"
EndFunc