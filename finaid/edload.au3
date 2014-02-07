#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include "lib.au3"
AutoItSetOption("MustDeclareVars", 1)

Global $settingsFile, $up[5], $down[5], $paths[5]
Global $btnSave, $btnExit

;; declare globals
$settingsFile = @ScriptDir & "\edload.ini"

GUICreate("Finaid Settings", 400, 380, 0, 0, BitOr($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX))

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
$btnExit = GUICtrlCreateButton("Exit", 130, 310, 120, 30)

GUISetState()

_SettingsLoad($up, $down, $paths)

While 1
	Dim $msg = GUIGetMsg(1)    
   
	Select
	Case $msg[0] == $GUI_EVENT_CLOSE
			_SettingsSave($up, $down, $paths)
			ExitLoop
		Case $msg[0] == $btnExit
			_SettingsSave($up, $down, $paths)
			ExitLoop
		Case $msg[0] == $btnSave
			_SettingsSave($up, $down, $paths)
	EndSelect
   
Wend

GUIDelete()

Exit

;; Loads the settings
Func _SettingsLoad(ByRef $up, ByRef $down, ByRef $paths)
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
Func _SettingsSave(ByRef $up, ByRef $down, ByRef $paths)
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