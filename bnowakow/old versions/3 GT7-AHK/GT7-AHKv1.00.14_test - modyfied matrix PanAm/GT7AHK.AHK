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
#Include Menu.ahk

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
Global debug_mode := 0
Global remote_play_offsetY := 0
Global MenuSelection := 0
race_start_delay := 0

MenuDirect := "Right"
Menu_loops := 6
menu_s := 1
Global color_check1 := 0xBBE044
color_check2 := 0xBBE044
color_2_delay := 400

Global box_size := 2
Global tolerance := 20

; resolution parameters and pixel search locations
ps_win_width := 640
ps_win_height := 360
Global pix1x := 458
Global pix1y := 114
Global pix2x := 607
Global pix2y := 319

bm_delay := 100
box_size := 2

Global ps_load_time1 := 12000
Global ps_load_time2 := 8000
Global ps_load_time3 := 8400
Global SysCheck := 1

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
IniRead, color_check1, config.ini, Vars, color_check1, 0xBBE044
IniRead, color_check2, config.ini, Vars, color_check2, 0xBBE044
IniRead, race_start_delay, config.ini, Vars, race_start_delay, 0
IniRead, debug_mode, config.ini, Vars, debug_mode, 0
IniRead, color_2_delay, config.ini, Vars, color_2_delay, 300

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Actual Script Starts Here                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Create a new controller controller
Global controller := new ViGEmDS4()
controller.SubscribeFeedback(Func("OnFeedback"))

OnFeedback(largeMotor, smallMotor, lightbarColor){
  ;OutputDebug % "AHK| Feedback received - LargeMotor: " largeMotor ", SmallMotor:  " smallMotor ", LightBarColor: " lightbarColor
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GUI Setups                                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

guicolor1:="000000" ; border
guicolor2:="ffffff" ; Title
guicolor3:="c282a36" ; body background
guicolor4:="c6272a4" ; control color
guicolor5:="ce8dfe3" ; body text

; ---------- Gui 1 Setup -------------
; Starting Gui
;
; -----------------------------------

Menu, Tray, Icon, Src\gt.ico
Menu, Tray, Standard

Gui, -MaximizeBox
Gui, 2: -MaximizeBox
Gui, 2: -MinimizeBox
Gui, Color, c282a36, c6272a4
Gui, Font, Q5 %guicolor4% s8 w550
Gui, Add, Button, x15 y10 w70 default, Start
Gui, Add, Button, x15 y40 w70 default gVariableWindow, Variables

Gui, Add, Button, x110 y10 w75 default gModWindow, Mods
Gui, Add, DropDownList, w50 Choose1 vMenuDirect, Right|Left
Gui, Font, Q5 %guicolor3% s8 w550 Bold
Gui, Add, Edit, vMenu_loops w20 x165 y39, 6

Gui, Font, ce8dfe3 s9 w550 Bold
Gui, Add, Radio, Group x15 y75 altsubmit Checked%SysCheck1% gPSystem vSysCheck, PS5
Gui, Add, Radio, x70 y75 altsubmit Checked%SysCheck2% gPSystem, PS4
Gui, Add, Radio, x125 y75 altsubmit Checked%SysCheck3% gPSystem, PS4 Pro


Gui, Font, Q5 %guicolor4% s8 w550
Gui, Add, Button, x15 y100 w70 default gReset, Reset
Gui, Add, Button, x110 y100 w75 default gMouseColor, Color Picker
Gui, Font, ce8dfe3 s9 w550 Bold
loop, Files, % A_ScriptDir "\Races\*.ahk*"
{
  SplitPath, A_LoopFileName,,,, FileName
  List .= FileName "|"
}
List := RTrim(List, "|")
List := StrReplace(List, RaceChoice "|", RaceChoice "||",, 1) ; make first item default

Gui, Font, Q5 %guicolor5% s8 w550 Bold
Gui, Add, Text, x10 y135, Race :
Gui, Add, DropDownList, x65 y130 w120 gSaveRace vRaceChoice, % List
Gui, Font, Q5 %guicolor4% s8 w550
Gui, Add, Button, default gSettingsSheet, Settings / Tune
Gui, Show, w220, GT7 AFK

;--------- Gui 2 Setup --------------
; Variables Gui
;
; -----------------------------------
Gui, 2: Color, c535770, c6272a4
Gui, 2: Font, c11f s9

Gui, 2: Font, Q5 %guicolor5% s8 w550 Bold
Gui, 2: Add, Text,, Turn Length (time miliseconds)
Gui, 2: Add, Edit, w70 vA, %t%

Gui, 2: Add, Text,, Race Start Delay
Gui, 2: Add, Edit, w40 vB, %race_start_delay%

Gui, 2: Add, Text,, Color Check 1
Gui, 2: Font, Q5 c%color_check1% s8 w550 Bold
Gui, 2: Add, Edit, vC, %color_check1%

Gui, 2: Font, Q5 %guicolor5% s8 w550 Bold
Gui, 2: Add, Text,, Color Check 2
Gui, 2: Font, Q5 c%color_check2% s8 w550 Bold
Gui, 2: Add, Edit, vD, %color_check2%

Gui, 2: Font, Q5 %guicolor5% s8 w550 Bold
Gui, 2: Add, Text, x100 y100, Color 2 Delay
Gui, 2: Add, Edit, x100 y120 w40 vE, %color_2_delay%

Gui, 2: Add, Button, x20 y200 gSaveVars Default, Save
Gui, 2: Add, Button, x100 y200 gVarDef, Defaults
Gui, 2: Add, Checkbox, x100 y160 Checked%debug_mode% vdebug_mode gDebugging, Debug Mode
Gui, 2: Font, c11f s9

; --------- Gui 3 Setup --------------
; Mods Gui
;
; -----------------------------------

Gui, 3: -MaximizeBox
Gui, 3: -MinimizeBox
Gui, 3: Color, c535770, c6272a4
Gui, 3: Font, c11f s9
Gui, 3: Font, Q5 %guicolor5% s8 w550 Bold
; Load mod settings
Loop, Parse, _mod_vars, |
{
  IniRead, %A_LoopField%, config.ini, Mods, %A_LoopField%, 0
}

Loop, Parse, _mod_vars, |
{

  if ( %A_LoopField% = 1){
    Gui, 3: Add, Checkbox, Checked v%A_LoopField%, % _mod_names[A_Index]
  }
  else {
    Gui, 3: Add, Checkbox, v%A_LoopField%, % _mod_names[A_Index]
  }

}

Gui, 3: Add, Button, gSaveMods, Save
Gui, 3: Font, c11f s9

; End of Gui Setup
;--------- Gui 4 Setup --------------
; Settings/Tunings Gui
;
; -----------------------------------

Gui, 4: -dpiscale
Gui, 4: +resize
Gui, 4: Font, Q5 %guicolor4% s8 w550 Bold
Gui, 4: Add, Button, x10 y10 gAssists1, Assists 1
Gui, 4: Add, Button, x85 y10 gAssists2, Assists 2
Gui, 4: Add, Button, x155 y10 gTune1, Tuning
Gui, 4: Add, Button, x215 y10 gTune2, Gears
Gui, 4: Add, Button, x270 y10 gControllerSetting, Controller
Gui, 4: Add, Picture, w800 h-1 vCurrentPic

return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GUI Functions                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
  These are subroutines used by the interaction with GUIs

  Some functions may be located in Mod files
*/

MenuTest:
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

Debugging:

return

VariableWindow:
  Gui, 2: Show, AutoSize, Variables
return

ModWindow:
  Gui, 3: Show, AutoSize, Mod List
return

SaveRace:
  Gui, Submit, NoHide
  IniWrite, %RaceChoice%, config.ini, Race, RaceChoice
return

SaveVars:
  Gui, 2:Submit, NoHide
  GuiControlGet, t, 2:, A
  GuiControlGet, race_start_delay, 2:, B
  GuiControlGet, color_check1, 2:, C
  GuiControlGet, color_check2, 2:, D
  GuiControlGet, color_2_delay, 2:, E

  Gui, 2: Font, Q5 c%color_check1% s8 w550 Bold
  GuiControl, 2: Font, C
  Gui, 2: Font, Q5 c%color_check2% s8 w550 Bold
  GuiControl, 2: Font, D

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
  IniWrite %color_check1%,      config.ini, Vars, color_check1
  IniWrite %color_check2%,      config.ini, Vars, color_check2
  IniWrite %race_start_delay%,  config.ini, Vars, race_start_delay
  IniWrite, %debug_mode%,        config.ini, Vars, debug_mode
  IniWrite, %color_2_delay%,     config.ini, Vars, color_2_delay

return

VarDef:
  t := 210000
  race_start_delay := 0
  color_2_delay := 400
  GuiControl, 2:, A, %t%
  GuiControl, 2:, B, %race_start_delay%
  GuiControl, 2:, C, 0xBBE044
  GuiControl, 2:, D, 0xBBE044
  GuiControl, 2:, E, 300
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
  sleep 1000
  gosub, AFKLoop
  return


  ; ---------- Gui Setup End-------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Actual Race Loop                                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AFKLoop:
  loop{
    Press_X()
    Sleep(race_start_delay)
    gosub, Race
    gosub, Menu
    SetFormat, IntegerFast, d
    ToolTip, %A_Index% Races completed ٩(^ ᴗ ^)۶, 100, 100, Screen
  }
return

;; General Functions for AHK

PixelTuning:
  x_ratio := ps_win_width/640
  y_ratio := ps_win_height/360
;  pix1x := Floor(pix1x*x_ratio)
;  pix1y := Floor(pix1y*y_ratio)
;  pix2x := Floor(pix2x*x_ratio)
;  pix2y := Floor(pix2y*y_ratio)
;  tyreX := Floor(tyreX*x_ratio)
;  tyreY := Floor(tyreY*y_ratio)

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
  if(__enableRemotePlaySizer_mod__ = 1){
    gosub, RemotePlay_ChangeSize
    WinMove, ahk_id %id%,, 0, 0, 640, 540
  }
  else{
    WinMove, ahk_id %id%,, 0, 0, 640, 360
  }
  ControlFocus,, ahk_class %remotePlay_class%
  WinActivate, ahk_id %id%
  GetClientSize(remotePlay_id5, ps_win_width, ps_win_height)
  gosub, PixelTuning
return


PSystem:
  Gui, Submit, NoHide
  if (SysCheck = 1){
    ps_load_time1 := 12000
    ps_load_time2 := 8000
    ps_load_time3 := 8400
  }
  if (SysCheck = 2){
    ps_load_time1 := 44000
    ps_load_time2 := 12000
    ps_load_time3 := 37000
  }
  if (SysCheck = 3){
    ps_load_time1 := 37000
    ps_load_time2 := 12000
    ps_load_time3 := 32000
  }
return

Reset:
  gosub, PauseLoop
  gosub, SaveToIni
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

/*
Pink RUF color"
 which is the standart first one to buy if you want to buy car manufactur color (for me german GT7 i think its same for everyone)
 0xFA559F

i have put that into Color check 1 and 2 works since 5 cycles - so maybe put them in with like (not tested)
(i think the first option that gets shown to buy a new color is the easiest to explain for people to buy except for colors the car exists in anyways (venom green)
here is the Hex Code for Porsche "Sternrubin" Ruby or Starruby depending on language:
0xBA3A64
*/
