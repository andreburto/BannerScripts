#include-once

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

;; A generic error message box and program exit
Func _Box($msg)
	MsgBox(1024, "ALERT", $msg)
	Exit
EndFunc