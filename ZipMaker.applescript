on run
	display dialog "パスワードの形式を選択してください" buttons {"英数字のみ", "英数字&記号"}
	set passBtn to button returned of result
	
	
	display dialog "設定するパスワードの文字数を入力してください" default answer ""
	set passTmp to result
	
	if text returned of passTmp is "" then
		display alert "文字数を入力してください"
		quit
	end if
	
	display dialog "圧縮対象を選択してください" buttons {"ファイル", "フォルダ"}
	set fBtn to button returned of result
	
	try
		set passLen to text returned of passTmp as number
		set passwd to randomHashByStrLen(passLen, passBtn)
		if fBtn is "ファイル" then
			set f to choose file
		else
			set f to choose folder
		end if
		
	on error
		display alert "入力形式が正しくありません"
		quit
	end try
	compressFolderByZip(f, passwd, fBtn)
end run


----------- function --------------

on randomHashByStrLen(aLen, aButton)
	set pass to ""
	set hashCharacter to "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwsyz0123456789"
	if aButton is "英数字&記号" then
		set hashCharacter to hashCharacter & "#$%&!?\@+"
	end if
	set hashCnt to count of hashCharacter
	repeat aLen times
		set idx to random number from 1 to hashCnt
		set pass to pass & character idx of hashCharacter
	end repeat
	return pass
end randomHashByStrLen


on compressFolderByZip(f, aPassword, fBtn)
	try
		tell application "Finder"
			set fname to name of f
		end tell
		
		set ptd to (path to desktop folder from user domain) as text
		set zipPath to POSIX path of (ptd & fname & ".zip")
		set sourcePath to POSIX path of f
		
		if fBtn is "ファイル" then
			-- ファイルへのパスから、フォルダまでのパスをsourcePathとする --
			set tmp to AppleScript's text item delimiters
			set AppleScript's text item delimiters to "/"
			set sourcePath to text from text item 1 to text item -2 of (sourcePath as string)
			set AppleScript's text item delimiters to tmp
			
			set cmd1 to "cd " & sourcePath
			set cmd2 to "zip -P " & aPassword & " " & zipPath & " " & fname
		else
			set cmd1 to "cd " & sourcePath & ".."
			set cmd2 to "zip -rP " & aPassword & " " & zipPath & " " & fname
		end if
		
		do shell script cmd1 & ";" & cmd2
		display alert "圧縮しました" & return & "パスワード: " & aPassword
		
	on error
		display alert "圧縮に失敗しました"
		quit
	end try
end compressFolderByZip

