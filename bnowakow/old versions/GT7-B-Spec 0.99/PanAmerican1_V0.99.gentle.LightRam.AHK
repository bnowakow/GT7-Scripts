#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#Include Lib\Gdip.ahk
#Include Lib\AHK-ViGEm-Bus.ahk
#Include Lib\__utility__.ahk
#Include Lib\__controller_functions__.ahk
#Include Race.ahk
#Include Mod\Maintenance.ahk
#Include Mod\ChampionshipMenuing.ahk


hModule := DllCall("LoadLibrary", "Str", A_LineFile "\..\Lib\SuperSleep.dll", "Ptr")
SuperSleep := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", A_LineFile "\..\Lib\SuperSleep.dll", "Ptr"), "AStr", "super_sleep", "Ptr")

ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenWindows, On
#Persistent

; RUF pink 0x583375
; --------- Constants
; Time at turn in seconds and Stablizing control
Global t := 220000
intensity := 230
delay := 300
init_delay := 10000

MenuDirect := "Right"
Menu_loops := 6
menu_s := 1
box_size := 3
color_check1 :=  0xBBE044
color_check2 :=  0xBBE044
color_2_delay := 400

color_tyre_overheat := 0xD42304
tyres_overheating := false
tyreX := 166
tyreY := 364

; resolution parameters and pixel search locations
ps_win_width  := 640
ps_win_height := 360
pix1x := 458
pix1y := 114
pix2x := 607
pix2y := 319
tolerance := 20
bm_delay := 100
box_size := 2

ps_load_time1 := 12000
ps_load_time2 := 6000
ps_load_time3 := 8400

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
Gui, Add, Button, x15 y70 w70 default gGetColo_p, Stuck Leaderboard
Gui, Add, Button, x110 y70 w70 default gGetColo_g, Stuck Replay
Gui, Add, Button, x110 y10 w70 default gMenuTest, MenuTest
Gui, Add, DropDownList, w50 Choose1 vMenuDirect, Right|Left
Gui, Add, Edit, vMenu_loops w20 x165 y39, 6
Gui, Font, ce8dfe3 s9 w550 Bold
Gui, Add, Radio, Group x15 y115 altsubmit Checked gPSystem vSysCheck, PS5
Gui, Add, Radio, x70 y115 altsubmit  gPSystem, PS4
Gui, Add, Radio, x125 y115 altsubmit  gPSystem, PS4 Pro
;Gui, Add, Radio, Group x15 y130 altsubmit Checked gMenuSel vMenuCheck, Pixel
;Gui, Add, Radio, x70 y120 altsubmit  gMenuSel, Timing
Gui, Add, Button, x70 y135 w70 default gReset, Reset
Gui, Font, ce8dfe3 s9 w550 Bold

;--------- Gui 2 Setup --------------
Gui, 2: Color, c535770, c6272a4
Gui, 2: Font, c11f s9 Bold
Gui, 2: Add, Text,, Turn Length (time miliseconds)
Gui, 2: Add, Edit,  w70 vA, %t%
Gui, 2: Add, Text,, Turn Intensity
Gui, 2: Add, Edit,  w40 vB, %intensity%
Gui, 2: Add, Text,, Turn Delay
Gui, 2: Add, Edit,  w40 vC, %delay%
Gui, 2: Add, Text, x100 y90, Color 2 Delay
Gui, 2: Add, Edit, x100 y110 w40 vD, %color_2_delay%

Gui, 2: Add, Button, x20  y170 gSaveVars, Save
Gui, 2: Add, Button, x100 y170 gVarDef, Defaults
Gui, Show,w220 h170,  GT7 Pan American AFK

return

VariableWindow:
    Gui, 2: Show, w220 h205, Variables
    return

SaveVars:
    Gui, 2:Submit
    GuiControlGet, t, 2:, A
    GuiControlGet, intensity, 2:, B
    GuiControlGet, delay, 2:, C
    GuiControlGet, color_2_delay, 2:, D
    return

VarDef:
t := 220000
intensity := 230
delay := 300
    GuiControl, 2:, A, %t%
    GuiControl, 2:, B, %intensity%
    GuiControl, 2:, C, %delay%
    GuiControl, 2:, D, %color_2_delay%
    return

ButtonStart:
    Gui, Submit, NoHide
    id := ""
    SetKeyDelay, 10
    Process, priority, , High
    gosub, GrabRemotePlay
    if  (id = "")
        return
    gosub, PauseLoop
    CoordMode, Pixel, Screen
    CoordMode, ToolTip, Screen
    sleep 1000
    gosub, AFKLoop
; ---------- Gui Setup End-------------

; ---------- AFK Loop -----------------
AFKLoop:
  loop{
    CheckForOilChange := Mod(A_Index, 29)
    CheckForMaintenance := Mod(A_Index, 107)
	if (CheckForOilChange = 0) {
	  OCremain := 0
	}
	if (CheckForOilChange > 0) {
	  OCremain := 30 - CheckForOilChange
	  SetFormat, IntegerFast, d
	}
	if (CheckForMaintenance = 0) {
	  EOremain := 0
	}
	if (CheckForMaintenance > 0) {
	  EOremain := 108 - CheckForMaintenance
	  SetFormat, IntegerFast, d
	}
	ToolTip, Oil: %OCremain% race(s) remaining`nEngine: %EOremain% race(s) remaining, 250, 45, Screen
    Press_X()
    DllCall("Sleep", "UInt", 10000) ; This is dependent on load time, probably different for ps4 version
    gosub, Race
    /*
    if (tyres_overheating) {
        break
    }
    */
    gosub, Menu
  }
  return

;; General Functions for AHK

PixelTuning:
x_ratio := ps_win_width/640
y_ratio := ps_win_height/360
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
WinMove, ahk_id %id%,,  0, 0, 640, 360
ControlFocus,, ahk_class %remotePlay_class%
WinActivate, ahk_id %id%
GetClientSize(id, ps_win_width, ps_win_height)
gosub, PixelTuning
return



MenuTest:
;MsgBox, This will test the number of Left/Right presses at the championship selection menu. `nTry this if you have not finished all cafe menus. `nPress OK to test
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
  if (SysCheck = 1){
      ps_load_time1 := 12000
      ps_load_time2 := 6000
      ps_load_time3 := 8400
  }
  if (SysCheck = 2){
      ps_load_time1 := 37000
      ps_load_time2 := 12000
      ps_load_time3 := 32000
  }
  if (SysCheck = 3){
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
  controller.Dpad.SetState("None")
  controller.Dpad.SetState("None")
  controller.Dpad.SetState("None")
  return



GuiClose:
    gosub, PauseLoop
    ExitApp
^Esc::ExitApp

/*
Pink RUF color"
 which is the standart first one to buy if you want to buy car manufactur color (for me german GT7 i think its same for everyone)
 0xFA559F

i have put that into Color check 1 and 2 works since 5 cycles - so maybe put them in with like (not tested)
(i think the first option that gets shown to buy a new color is the easiest to explain for people to buy except for colors the car exists in anyways (venom green)
here is the Hex Code for Porsche "Sternrubin" Ruby or Starruby depending on language:
0xBA3A64
*/
