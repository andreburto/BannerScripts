#NoTrayIcon
AutoItSetOption("MustDeclareVars", 1)

Global $path, $input, $outfile, $verbose = "no", $read = "char"
Global $helpcmd = "catall.exe -p c:\dir\ -i *.txt,*.dat,*.* -o file.dat -read [char/line] -v [yes/no]"

_SplitCmdArgs()

If UBound(StringSplit($input, ",", 2)) = 0 Then _Box("No input queries given.")
Dim $queries = StringSplit($input, ",", 2)

If StringRight($path, 1) <> "\" Then $path &= "\"

Dim $files = _GetFileLists($path, $queries)
If $files = False Then _Box("No files in the path.")

For $file In $files
	Dim $yn = _ConCat($path&$file, $path&$outfile)
	If $yn = False Then
		_Box("Could not write file " & $file)
		ExitLoop
	EndIf
Next

Exit

Func _SplitCmdArgs()
	If StringLen($CmdLineRaw) == 0 Then
		$verbose = "yes"
		_Box($helpcmd)
	ElseIf $cmdline[1] = "-h" or $cmdline[1] = "--help" Then
		$verbose = "yes"
		_Box($helpcmd)
	ElseIf Mod($cmdline[0], 2) = 0 Then
		Dim $count = 1
		While $count < $cmdline[0]
			Switch $cmdline[$count]
			Case "-p"
				$path = $cmdline[$count+1]
			Case "-i"
				$input = $cmdline[$count+1]
			Case "-o"
				$outfile = $cmdline[$count+1]
			Case "-v"
				$verbose = $cmdline[$count+1]
			Case "-read"
				If $cmdline[$count+1] = "char" Or $cmdline[$count+1] = "line" Then $read = $cmdline[$count+1]
			EndSwitch
			$count += 1
		WEnd
	EndIf
EndFunc

Func _ConCat($from, $to)
	Dim $yn = 1
	
	Dim $fr = FileOpen($from, 0)
	If $fr = -1 Then Return False
		
	Dim $ft = FileOpen($to, 1)
	If $ft = -1 Then Return False
		
	If $read = "line" Then
		While 1
			Dim $line = FileReadLine($fr)
			If @error Then ExitLoop
			$yn = FileWriteLine($ft, $line)
			If $yn = 0 Then ExitLoop
		Wend
	Else
		While 1
			Dim $chr = FileRead($fr, 1)
			If @error Then ExitLoop
			$yn = FileWrite($ft, $chr)
			If $yn = 0 Then ExitLoop
		Wend
	EndIf
	
	FileClose($ft)
	FileClose($fr)
	
	If $yn = 0 Then Return False
	Return True
EndFunc

Func _GetFileLists($path, $qry)
	Dim $fl[1]
	Dim $count = 0
	
	For $q In $qry
		Dim $flist = _GetFileList($path, $q)
		If $flist = false Then ContinueLoop
		For $f In $flist
			$count += 1	
			ReDim $fl[$count]
			$fl[$count-1] = $f
		Next
	Next
	
	If $count = 0 Then Return False
	Return $fl
EndFunc

Func _GetFileList($path, $qry)
	Dim $fl[1]
	Dim $count = 0
	Dim $search = FileFindFirstFile($path & $qry)

	If $search = -1 Then Return False
		
	While 1
		Dim $file = FileFindNextFile($search)
		Dim $fp = $path & $file
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib($fp), "D") Then ContinueLoop
		$count += 1
		ReDim $fl[$count]
		$fl[$count-1] = $file
	WEnd
	
	FileClose($search)
	If $count = 0 Then Return False
	Return $fl
EndFunc

Func _Box($msg)
	If $verbose == "yes" Then MsgBox(1024, "ALERT", $msg)
	Exit
EndFunc