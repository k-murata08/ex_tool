on run
	display dialog "���k�Ώۂ�I�����Ă�������" buttons {"�t�@�C��", "�t�H���_"}
	set fBtn to button returned of result
	try
		if fBtn is "�t�@�C��" then
			set f to choose file
		else
			set f to choose folder
		end if
	on error
		display alert "���������f����܂���"
		quit
	end try
	
	display dialog "���k�t�@�C���̃p�X���[�h�������������܂�" & return & "�p�X���[�h�̌`����I�����Ă�������" buttons {"�p�����̂�", "�p����&�L��"}
	set passBtn to button returned of result
	
	display dialog "�ݒ肷��p�X���[�h�̕���������͂��Ă�������" default answer "" with number
	set passTmp to result
	
	if text returned of passTmp is "" then
		display alert "����������͂��Ă�������"
		quit
	end if
	
	set passLen to text returned of passTmp as number
	set passwd to randomHashByStrLen(passLen, passBtn)
	compressFolderByZip(f, passwd, fBtn)
end run


----------- function --------------

on randomHashByStrLen(aLen, aButton)
	set pass to ""
	set hashCharacter to "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwsyz0123456789"
	if aButton is "�p����&�L��" then
		set hashCharacter to hashCharacter & "#$%&\@_{}()<>+-"
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
		
		if fBtn is "�t�@�C��" then
			-- �t�@�C���ւ̃p�X����A�t�H���_�܂ł̃p�X��sourcePath�Ƃ��� --
			set tmp to AppleScript's text item delimiters
			set AppleScript's text item delimiters to "/"
			set sourcePath to text from text item 1 to text item -2 of (sourcePath as string)
			set AppleScript's text item delimiters to tmp
			
			set cmd1 to "cd " & sourcePath
			set cmd2 to "zip -P �"" & aPassword & "�" " & zipPath & " " & fname
		else
			set cmd1 to "cd " & sourcePath & ".."
			set cmd2 to "zip -rP �"" & aPassword & "�" " & zipPath & " " & fname
		end if
		
		do shell script cmd1 & ";" & cmd2
		display alert "���k���܂���" & return & "�p�X���[�h: " & aPassword
		
	on error
		display alert "���k�Ɏ��s���܂���"
		quit
	end try
end compressFolderByZip

