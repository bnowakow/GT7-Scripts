#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#Include Lib\Gdip.ahk
#Include Lib\AHK-ViGEm-Bus.ahk
#Include Lib\__utility__.ahk
#Include Lib\__controller_functions__.ahk
#Include Mod\Mods.ahk
#Include Race.ahk

hModule := DllCall("LoadLibrary", "Str", A_LineFile "\..\Lib\SuperSleep.dll", "Ptr")
SuperSleep := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", A_LineFile "\..\Lib\SuperSleep.dll", "Ptr"), "AStr", "super_sleep", "Ptr")

ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.

SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
DetectHiddenWindows, On
#Persistent

; --------- Constants
; Time at turn in seconds and Stablizing control
Global t := 210000
;Global debug_mode := 0
intensity := 230
delay := 300
init_delay := 10000

MenuDirect := "Right"
Menu_loops := 6
menu_s := 1
color_check1 := 0x3D1755
color_check2 := 0xAAD02F
color_2_delay := 250

global box_size := 2
global tolerance := 20

; resolution parameters and pixel search locations
ps_win_width := 640
ps_win_height := 540
pix1x := 225
pix1y := 426
pix2x := 607
pix2y := 380

box_size := 2

ps_load_time1 := 12000
ps_load_time2 := 6200
ps_load_time3 := 9200
global SysCheck := 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Variable Save Settings                                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Race selection from dropdown list
IniRead, RaceChoice, config.ini, Race, RaceChoice
; Console Selection in radio group
loop, 3{
  IniRead, SysCheck%A_Index%, config.ini, Vars, SysCheck%A_Index%, 0

  if (SysCheck%A_Index% = 1){

    SysCheck = %A_Index%
  }
}
gosub, PSystem
; Menu color Checks
IniRead, color_check1, config.ini, Vars, color_check1
IniRead, color_check2, config.ini, Vars, color_check2
IniRead, race_start_delay, config.ini, Vars, race_start_delay, 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Actual Script Starts Here                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Create a new controller controller
Global controller := new ViGEmDS4()
controller.SubscribeFeedback(Func("OnFeedback"))

OnFeedback(largeMotor, smallMotor, lightbarColor){
  ;OutputDebug % "AHK| Feedback received - LargeMotor: " largeMotor ", SmallMotor:  " smallMotor ", LightBarColor: " lightbarColor
}

; ---------- Gui Setup -------------
Gui, -MaximizeBox
Gui, 2: -MaximizeBox
Gui, 2: -MinimizeBox
Gui, Color, c282a36, c6272a4
Gui, Add, Button, x15 y10 w70 default, Start
Gui, Add, Button, x15 y40 w70 default gVariableWindow, Variables
Gui, Add, Button, x15 y70 w70 default gCheckHairpin, Stuck Leaderboard
Gui, Add, Button, x110 y70 w70 default gGetColo_g, Stuck Replay
Gui, Add, Button, x110 y10 w70 default gModWindow, Mods
Gui, Add, DropDownList, w50 Choose1 vMenuDirect, Right|Left
Gui, Add, Edit, vMenu_loops w20 x165 y39, 6
Gui, Font, ce8dfe3 s9 w550 Bold

Gui, Add, Radio, Group x15 y115 altsubmit Checked%SysCheck1% gPSystem vSysCheck, PS5
Gui, Add, Radio, x70 y115 altsubmit Checked%SysCheck2% gPSystem, PS4
Gui, Add, Radio, x125 y115 altsubmit Checked%SysCheck3% gPSystem, PS4 Pro
;Gui, Add, Radio, Group x15 y130 altsubmit Checked gMenuSel vMenuCheck, Pixel
;Gui, Add, Radio, x70 y120 altsubmit  gMenuSel, Timing
Gui, Add, Button, x70 y135 w70 default gReset, Reset
Gui, Add, Button, default gMouseColor, Color Picker
Gui, Font, ce8dfe3 s9 w550 Bold
loop, Files, % A_ScriptDir "\Races\*.ahk*"
{
  SplitPath, A_LoopFileName,,,, FileName
  List .= FileName "|"
}
List := RTrim(List, "|")
List := StrReplace(List, RaceChoice "|", RaceChoice "||",, 1) ; make first item default
Gui, Add, DropDownList, gSaveRace vRaceChoice, % List
Gui, Add, Button, default gSettingsSheet, Settings / Tune
Gui, Show

;--------- Gui 2 Setup --------------
Gui, 2: Color, c535770, c6272a4
Gui, 2: Font, c11f s9 Bold
Gui, 2: Add, Text,, Turn Length (time miliseconds)
Gui, 2: Add, Edit, w100 vA, %t%
Gui, 2: Add, Text,, Race Start Delay
Gui, 2: Add, Edit, w100 vB, %race_start_delay%
Gui, 2: Add, Text,, Color Check 1
Gui, 2: Add, Edit, w100 vC, %color_check1%
Gui, 2: Add, Text,, Color Check 2
Gui, 2: Add, Edit, w100 vD, %color_check2%
Gui, 2: Add, Text, x130 y90, Color 2 Delay
Gui, 2: Add, Edit, x130 y110 w40 vE, %color_2_delay%
Gui, 2: Add, Button, x20 y200 gSaveVars, Save
Gui, 2: Add, Button, x100 y200 gVarDef, Defaults
Gui, 2: Add, Checkbox, x130 y150 Checked vdebug_mode gDebugging, Debug Mode
; TODO Might need port from 0.9995.5

;--------- Gui 4 Setup --------------
Gui, 4: -dpiscale
Gui, 4: +resize
Gui, 4: Add, Button, x10 y10 gAssists1, Assists 1
Gui, 4: Add, Button, x70 y10 gAssists2, Assists 2
Gui, 4: Add, Button, x130 y10 gTune1, Tuning
Gui, 4: Add, Button, x180 y10 gTune2, Gears
Gui, 4: Add, Button, x220 y10 gControllerSetting, Controller
Gui, 4: Add, Picture, w800 h-1 vCurrentPic
Gui, Show,, GT7AHK
return


Debugging:
	MsgBox, %debug_mode%
return


VariableWindow:
	Gui, 2: Show, w240 h240, Variables
return


ModWindow:
	Gui, 3: Show, AutoSize, Mod List
return


SaveRace:
	Gui, Submit, NoHide
	IniWrite, %RaceChoice%, config.ini, Race, RaceChoice
return


SaveVars:
	Gui, 2:Submit
	GuiControlGet, t, 2:, A
	GuiControlGet, race_start_delay, 2:, B
	GuiControlGet, color_check1, 2:, C
	GuiControlGet, color_check2, 2:, D
	GuiControlGet, color_2_delay, 2:, E
return


SaveToIni:
	; System
	loop, 3{
		if( SysCheck = A_Index){
			IniWrite, 1, config.ini, Vars, SysCheck%A_Index%
		}
		else {
			IniWrite, 0, config.ini, Vars, SysCheck%A_Index%
		}
	}
	; Color Check
	; Can't find a way to change colors
	IniWrite %color_check1%, config.ini, Vars, color_check1
	IniWrite %color_check2%, config.ini, Vars, color_check2
	IniWrite %color_2_delay%, config.ini, Vars, color_2_delay
	IniWrite %race_start_delay%, config.ini, Vars, race_start_delay
return


VarDef:
	t := 210000
	race_start_delay := 0
	color_2_delay := 400
	intensity := 230
	delay := 300
	GuiControl, 2:, A, %t%
	GuiControl, 2:, B, %race_start_delay%
	GuiControl, 2:, C, %delay%
	GuiControl, 2:, D, %color_2_delay%
return


ButtonStart:
	Gui, Submit, NoHide
	id := ""
	SetKeyDelay, 10
	Process, priority, , High
	gosub, GrabRemotePlay
	if (id = "")
		return
	gosub, PauseLoop
	CoordMode, Pixel, Screen
	CoordMode, ToolTip, Screen
	sleep(1000)
	gosub, AFKLoop
; ---------- Gui Setup End-------------


; ---------- AFK Loop -----------------
AFKLoop:
	loop
	{
		gosub, Race
		gosub, Menu
	}
return


;; General Functions for AHK
PixelTuning:
	x_ratio := ps_win_width/640
	y_ratio := ps_win_height/501
	pix1x := Floor(pix1x*x_ratio)
	pix1y := Floor(pix1y*y_ratio)
	pix2x := Floor(pix2x*x_ratio)
	pix2y := Floor(pix2y*y_ratio)
	tyreX := Floor(tyreX*x_ratio)
	tyreY := Floor(tyreY*y_ratio)
return


GrabRemotePlay:
	WinGet, remotePlay_id, List, ahk_exe RemotePlay.exe
	if (remotePlay_id = 0)
	{
		MsgBox, PS4 Remote Play not found
		return
	}
	Loop, %remotePlay_id%
	{
		id := remotePlay_id%A_Index%
		WinGetTitle, title, % "ahk_id " id
		If InStr(title, "PS Remote Play")
			break
	}
	WinGetClass, remotePlay_class, ahk_id %id%
	WinMove, ahk_id %id%,, 0, 0, 640, 540
	ControlFocus,, ahk_class %remotePlay_class%
	WinActivate, ahk_id %id%
	GetClientSize(id, ps_win_width, ps_win_height)
	gosub, PixelTuning
return


MenuTest:
	;MsgBox, This will test the number of Left/Right presses at the championship selection menu. 	nTry this if you have not finished all cafe menus. `nPress OK to test
	gosub, GrabRemotePlay
	Gui, Submit, NoHide
	loop, %menu_loops% {
		controller.Dpad.SetState(MenuDirect)
		Sleep, 125
		controller.Dpad.SetState("None")
		Sleep, 200
	}
return


GetColo_p:
	gosub, GrabRemotePlay
	color_check1 := PixelColorSimple(pix1x, pix1y)
return


GetColo_g:
	gosub, GrabRemotePlay
	color_check2 := PixelColorSimple(pix2x, pix2y)
return


PSystem:
	Gui, Submit, NoHide
	Switch SysCheck {
		Case 1:
			ps_load_time1 := 12000
			ps_load_time2 := 6200
			ps_load_time3 := 9200
		Case 2:
			ps_load_time1 := 44000
			ps_load_time2 := 12000
			ps_load_time3 := 37000
		Case 3:
			ps_load_time1 := 37000
			ps_load_time2 := 12000
			ps_load_time3 := 32000
	}
return


Reset:
    gosub, PauseLoop
    Reload
    Sleep 1000
return


PauseLoop:
    controller.Buttons.Cross.SetState(false)
    controller.Buttons.Square.SetState(false)
    controller.Buttons.Triangle.SetState(false)
    controller.Buttons.Circle.SetState(false)

    controller.Buttons.L1.SetState(false)
    controller.Buttons.L2.SetState(false)
    controller.Axes.L2.SetState(0)
    controller.Buttons.R1.SetState(false)
    controller.Buttons.R2.SetState(false)
    controller.Axes.R2.SetState(0)

    controller.Buttons.RS.SetState(false)
    controller.Axes.RX.SetState(50)
    controller.Axes.RY.SetState(50)

    controller.Buttons.LS.SetState(false)
    controller.Axes.LX.SetState(50)
    controller.Axes.LY.SetState(50)

    controller.Dpad.SetState("None")
return


MouseHelp:
    coord=relative
    sleep, 1000
    CoordMode, ToolTip, %coord%
    CoordMode, Pixel, %coord%
    CoordMode, Mouse, %coord%
    CoordMode, Caret, %coord%
    CoordMode, Menu, %coord%
return


Refresh:
	MouseGetPos, x, y
	PixelGetColor, cBGR, %x%, %y%,, Alt RGB
	WinGetPos,,, w, h, A
	ToolTip,Location: %x% x %y%`nRGB: %cBGR%`nWindow Size: %w% x %h%
return


MouseColor:
	gosub, MouseHelp
	SetTimer, Refresh, 75
return


GuiClose:
	gosub, PauseLoop
	gosub, SaveToIni
ExitApp
  
^Esc::ExitApp
