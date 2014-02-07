#include <Array.au3>
#include "lib.au3"
AutoItSetOption("MustDeclareVars", 1)

;; GLOBAL VARIABLES
Global $up[5], $down[5], $paths[5]
Global $settingsFile = @ScriptDir & "\edload.ini"
Global $upScr = "upload.txt", $upLog = "up_log.txt"
Global $dlScr = "download.txt", $dlLog = "down_log.txt"

;; load settings
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

;; Exit script
Exit