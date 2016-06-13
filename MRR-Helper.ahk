;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
; Description
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/
; Moves MRR videos and closes them as well.



;~~~~~~~~~~~~~~~~~~~~~
;Compile Options
;~~~~~~~~~~~~~~~~~~~~~
StartUp()
The_AppName = Race Replay Helper
The_Version = v1.1.0

;Dependencies
#Include %A_ScriptDir%\Functions
;None

;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
; StartUp
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/

;No GUI for now
Gui_Build()
Sb_TrayMenu()
Return

^2::
~F2::
If (Toggle_Active = True) {
SetTitleMatchMode, 2
X_pos := 70
Y_pos := 20
WindowArray := []
	
Gui_Show("Moving Race Videos")
	
	;Flash video name format (no capitalization on race)
	Loop, 40 {
		IfWinExist, Race %A_Index%%A_Space%,,,
		{
		WinActivate
		WinMove,,, %X_pos%, %Y_Pos%, 300, 342
		X_Pos += 300
		}

		If (X_Pos > 1400) {
		Y_pos += 320
		X_pos := 70
		}
	}

	WindowArray := []

	;Windows Media name format
	Loop, 40 {
		IfWinExist, race %A_Index%%A_Space%,,,
		{
		WinActivate
		WinMove,,, %X_pos%, %Y_Pos%,
		X_Pos += 300
		}
		
		If (X_Pos > 1400) {
		Y_pos += 320
		X_pos := 70
		}
	}
;Gui, Submit
}
Return

^3::
~F3::
If (Toggle_Active = True) {
SetTitleMatchMode, 2
	
Gui_Show("Closing Race Videos")

	;Flash video name format (no capitalization on race)
	Loop, 40 {
		IfWinExist, Race %A_Index%%A_Space%,,,
		{
		WinClose
		}
	}

	WindowArray := []

	;Windows Media name format
	Loop, 40 {
		IfWinExist, race %A_Index%%A_Space%,,,
		{
		WinClose
		}
	}
;Gui, Submit
}
Return

;~^F3::
;GoSub, menu_MenuHandler
;Return

::/mrr::
InputBox, Day, MMDD Date Please, , , 200, 120, X, Y, , , ;%g_WeekdayName%
FormatTime, Year, , yyyy
FormatTime, Date, %Year%%Day%, LongDate
SendInput tvgsche{Tab}Wager{Tab 3}
SendInput TVG MRR report for %Date% {Tab}
SendInput Neulion,{Enter 2}
	If (Date != ""){
	SendInput Attached is the missing replay report for the races of %Date%{Enter}
	} else {
	SendInput Attached is the missing replay report.
	}
SendInput ( Errors){left 8}
Return


;/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\
;Functions
;\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/--\--/
StartUp()
{
#SingleInstance Force
}


GUI()
{
global
Gui +AlwaysOnTop

Gui, Font, s14 w70, Arial
Gui, Add, Text, x2 y0 w280 h40 +Center, MRR Helper %The_VersionName%
Gui, Font, s10 w70, Arial
Gui, Add, Text, x2 y20 w280 h20 +Center vGUI_CurrentSystem,

Gui, Show, x127 y87 h80 w288, MRR Helper


;Gui, Add, Button, x382 y40 w100 h30 gRunReport, Run Report
;Gui, Add, Button, x382 y70 w100 h30 , Update Info

Gui, Add, Progress, x2 y50 w280 h10 vGUI_ProgressBar1, 1
Gui, Add, Progress, x2 y60 w280 h20 vGUI_ProgressBar2, 1

Return
}

Gui_Build()
{
Global

Gui, Color, FFFFFF
Gui, Font, S33, Arial Black
Gui, Add, Text, BackgroundTrans +Center W1000 vT1, alf
Gui, Add, Text, BackgroundTrans xp-3 yp-3 c019e59 +Center  vT2 W1000, alf2
Gui +LastFound +AlwaysOnTop +ToolWindow
WinSet, TransColor, FFFFFF
Gui -Caption
}

Gui_Show(para_Text)
{
Global
GuiControl,, T1, %para_Text%
GuiControl,, T2, %para_Text%
Sleep 100	
Gui, Show
SetTimer, HideGUI, -3000
Return

HideGUI:
Gui, Submit
Return
}




Sb_TrayMenu()
{
Global
Menu, tray, NoStandard
Menu, tray, add, %The_AppName% %The_Version%, menu_ConfluenceLink
Menu, tray, Icon, %The_AppName% %The_Version%, %A_ScriptDir%\%A_ScriptName%, 1, 0
Menu, tray, add, Help, menu_Help
Menu, tray, add, Confluence, menu_ConfluenceLink
Menu, tray, add, Toggle On/Off, menu_MenuHandler
Menu, tray, ToggleCheck, Toggle On/Off
Menu, tray, add, Quit, Quit
Toggle_Active := True
Return

menu_Help:
Msgbox, Use F2 or Ctrl+2 to arrange all MRR windows onto the default Monitor after opening . F3 or Ctrl+3 closes all MRR windows. Recommended Browser: Chrome `n`nSee Confluence for more help.
Return

menu_ConfluenceLink:
Run http://confluence.tvg.com/display/wog/Ops+Tool+-+Race+Replay+Helper
Return

Quit:
ExitApp
}

menu_MenuHandler:
Menu, tray, ToggleCheck, Toggle On/Off
If(Toggle_Active = True)
{
Toggle_Active := False
}
Else If(Toggle_Active = False || Toggle_Active = "")
{
Toggle_Active := True
}
Gui_Show("Listening for input = " . Toggle_Active)
Return