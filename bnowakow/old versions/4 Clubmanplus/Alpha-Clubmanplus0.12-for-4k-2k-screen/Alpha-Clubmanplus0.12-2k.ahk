; v0.12 loop using menu pixel back to "retry" clubman+ with searching retry icon on the screen, keep send Button "x" before found that page -BobGT@20220420
; put the menu-retry.png file to the same folder of your scrips
#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#Include %A_ScriptDir%
SetWorkingDir %A_ScriptDir% 
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

; --------- Controls
accel := "Enter"
turnLeft := "Left"
turnRight := "Right"
brake := "Up"
nitros := "Down"

; --------- Constants 
; Time at turn in seconds and Stablizing control
t := 380000
intensity := 1
delay := 500

MenuDirect := "Right"
Menu_loops := 6
menu_s := 1
color_check1 :=  0xBBE044
color_check2 :=  0xACCF3B
c1_alt := false
color_2_delay := 1500

; resolution parameters and pixel search locations
ps_win_width  := 640
ps_win_height := 360
pix1x := 457
pix1y := 112
pix2x := 608
pix2y := 321

ps_load_time1 := 3000
ps_load_time2 := 7000 
ps_load_time3 := 8400

; ---------- Gui Setup -------------
Gui, -MaximizeBox
Gui, 2: -MaximizeBox
Gui, 2: -MinimizeBox
Gui, Color, c282a36, c6272a4
Gui, Add, Button, x15 y10 w70 default, Start
Gui, Add, Button, x15 y40 w70 default gVariableWindow, Variables
Gui, Add, Button, x15 y70 w70 default gGetColo_p, ColorP1
Gui, Add, Button, x110 y70 w70 default gGetColo_g, ColorP2
Gui, Add, Button, x110 y10 w70 default gMenuTest, MenuTest
Gui, Add, DropDownList, w50 Choose1 vMenuDirect, Right|Left
Gui, Add, Edit, vMenu_loops w20 x165 y39, 6
Gui, Font, ce8dfe3 s9 w550 Bold
Gui, Add, Radio, Group x15 y100 altsubmit Checked gPSystem vSysCheck, PS5
Gui, Add, Radio, Group x15 y120 altsubmit Checked gMenuSel vMenuCheck, Pixel
Gui, Add, Text,, _________________
Gui, Add, Text,, GT7 Clubman Cup AFK Script
Gui, Add, Text,, Alpha Version 0.12
Gui, Add, Text,, Long term stability not tested.
Gui, Add, Text,, Credit: Septomor, Rust, JordanD
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
Gui, Show,w210 h280,  GT7 Clubman Plus AFK
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
    t = 390000
	intensity = 50
	delay := 140
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

	
AFKLoop:
    loop{
		gosub, PressX
        DllCall("Sleep", "UInt", 6000) ; This is dependent on load time, probably different for ps4 version
        gosub, Race
        gosub, Menu
    }
    return

PressX:
; Just for menuing, does not hold X down
    ControlSend,, {%accel% down}, ahk_id %id% 
	DllCall("Sleep", "UInt", 200)
    ControlSend,, {%accel% up}, ahk_id %id% 
    return
    
PressO:
; Just for menuing, does not hold O down
    ControlSend,, {Esc down}, ahk_id %id% 
	DllCall("Sleep", "UInt", 200)
    ControlSend,, {Esc up}, ahk_id %id% 
    return
    
PressRight:
; For turning 
    ControlSend,, {%turnRight% down}, ahk_id %id% 
    Sleep, 50
    ControlSend,, {%turnRight% up}, ahk_id %id% 
    return
    
; given time t in miliseconds, turn right for that long, with intensity being how much the turn button is held for
TurnRight:
	t0 := A_TickCount
	tf := t0+t
	
	loop 	{
		ControlSend,, {%turnRight% down}, ahk_id %id% 
		 DllCall("Sleep", "UInt", intensity)
		ControlSend,, {%turnRight% up}, ahk_id %id% 	
		 DllCall("Sleep", "UInt", delay)
	} until A_TickCount > tf
    return


TurnLeft:
	t0 := A_TickCount
	tf := t0+t
	
	loop 	{
		ControlSend,, {%turnLeft% down}, ahk_id %id% 
		DllCall("Sleep", "UInt", intensity)
		ControlSend,, {%turnLeft% up}, ahk_id %id% 
	
		DllCall("Sleep", "UInt", delay)
	} until A_TickCount > tf
    return


Race:
; Hold Acceleration and manage turning
	ToolTip, Start to race, 100, 100, Screen    
	ControlSend,, {%accel% down}, ahk_id %id% 
	ControlSend,, {%nitros% down}, ahk_id %id% 
	DllCall("Sleep", "UInt", 100)
	gosub TurnRight
/* 
; This section detects the end of the race. Can be used to be faster/more accurate at the ending but good timing takes less computer resources
Screen:	218, 359 (less often used)
Window:	222, 357 (default)
Client:	214, 326 (recommended)
Color:	3F1757 (Red=3F Green=17 Blue=57)

Screen:	247, 65 (less often used)
Window:	-129, -376 (default)
Client:	-129, -376 (recommended)
Color:	FD3C37 (Red=FD Green=3C Blue=37)

Screen:	210, 64 (less often used)
Window:	210, 64 (default)
Client:	202, 33 (recommended)
Color:	5091E9 (Red=50 Green=91 Blue=E9)

Screen:	261, 39 (less often used)
Window:	261, 39 (default)
Client:	253, 8 (recommended)
Color:	A774A9 (Red=A7 Green=74 Blue=A9)
*/
    loop {
        PixelSearch, x, y, pix1x-10, pix1y-10, pix1x+10, pix1y+10, %color_check1%, 32, Fast RGB
            If (ErrorLevel != 0) {
                ControlSend,, {%turnRight% down}, ahk_id %id% 
				Sleep, 140
				ControlSend,, {%turnRight% up}, ahk_id %id% 
				Sleep, 200
            }
            else{
                break
            }
        
        
    }
	ToolTip, Found color 1, 100, 100, Screen
    ControlSend,, {%accel% up}, ahk_id %id% 
	ControlSend,, {%nitros% up}, ahk_id %id%
    return
    
Menu:
if (menu_s = 1){
    gosub, Menu_pixel
}
if (menu_s = 2){
    gosub, Menu_time
}
return

Menu_pixel:
	ToolTip, Menuing, 100, 100, Screen
    WinMove, ahk_id %id%,,  0, 0, 640, 360 ;make sure PSremote is in the right position
    WinActivate, ahk_id %id%

/*
    loop, 7 {
        gosub, PressX
        Sleep, 1700
    }
*/
    loop {
	 	DllCall("Sleep", "UInt", 800)
;		ImageSearch, OutputVarX3, OutputVarY3, 290, 340, 390, 385, *20 %A_ScriptDir%\menu-retry.png  ;for 2K screen
        ImageSearch, OutputVarX3, OutputVarY3, 440, 530, 480, 555, *20 %A_ScriptDir%\menu-retry-4k.png  ; for 4K screen

    	If (ErrorLevel = 0) {
			break				
		}
		else{
			gosub, PressX 
		}
    }      
 /* ToolTip, Menuing, 100, 100, Screen
   loop {
         PixelSearch, x, y, pix2x-2, pix2y-2, pix2x+2, pix2y+2, %color_check2%, 32, Fast RGB
            If (ErrorLevel != 0) {
                 gosub, PressX
                 sleep %color_2_delay%
            }
            else{
                break
            }
    }
    ToolTip, Found color 2, 100, 100, Screen
*/

; now select "Retry"
	ToolTip, Retry-menu, 100, 100, Screen
    ControlSend,, {Right down}, ahk_id %id% 
    Sleep, 200
    ControlSend,, {Right up}, ahk_id %id% 
    Sleep, 500
    gosub, PressX
    Sleep, 1500  ; waiting time for Menu to new start page 
    return

Menu_time:
    loop, 9{
        gosub, PressX
        Sleep, 1700
    }
    Sleep, 2000
    ControlSend,, {Right down}, ahk_id %id% 
    Sleep, 200
    ControlSend,, {Right up}, ahk_id %id% 
    Sleep, 500
    gosub, PressX
    Sleep, %ps_load_time1%
	gosub, PressX
	Sleep, 1000
	ControlSend,, {Esc down}, ahk_id %id% 
    Sleep, 200
    ControlSend,, {Esc up}, ahk_id %id% 
	loop, 2 {
		gosub, PressX
		Sleep, 500
	}
	Sleep,  %ps_load_time2%
	ControlSend,, {Down down}, ahk_id %id% 
    Sleep, 200
    ControlSend,, {Down up}, ahk_id %id% 
	Sleep, 500
	loop, %menu_loops% {
		ControlSend,, {%MenuDirect% down}, ahk_id %id% 
		Sleep, 50
		ControlSend,, {%MenuDirect% up}, ahk_id %id% 
		Sleep, 200
	}
	loop, 2{
        gosub, PressX
        Sleep, 2000
    }
	Sleep,  %ps_load_time3%
    gosub, PressX
    Sleep, 2000
    
    
    return
;; General Functions for AHK

PixelTuning:
x_ratio := ps_win_width/640
y_ratio := ps_win_height/360
pix1x := Floor(pix1x*x_ratio)
pix1y := Floor(pix1y*y_ratio)
pix2x := Floor(pix2x*x_ratio)
pix2y := Floor(pix2y*y_ratio)
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

RPwind:
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
WinMove, ahk_id %id%,,  -700, -400, 640, 360
ControlFocus,, ahk_class %remotePlay_class%
WinActivate, ahk_id %id%
return

PixelColorSimple(pc_x, pc_y)
{
    WinGet, remotePlay_id, List, ahk_exe RemotePlay.exe
    if (remotePlay_id = 0)
    {
        MsgBox, PS4 Remote Play not found
        return
    }
    if remotePlay_id
    {
        pc_wID := remotePlay_id[0]
        pc_hDC := DllCall("GetDC", "UInt", pc_wID)
        pc_fmtI := A_FormatInteger
        SetFormat, IntegerFast, Hex
        pc_c := DllCall("GetPixel", "UInt", pc_hDC, "Int", pc_x, "Int", pc_y, "UInt")
        pc_c := pc_c >> 16 & 0xff | pc_c & 0xff00 | (pc_c & 0xff) << 16
        pc_c .= ""
        SetFormat, IntegerFast, %pc_fmtI%
        DllCall("ReleaseDC", "UInt", pc_wID, "UInt", pc_hDC)
        return pc_c
        
    }
}

GetClientSize(hWnd, ByRef w := "", ByRef h := "")
{
    VarSetCapacity(rect, 16)
    DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
    w := NumGet(rect, 8, "int")
    h := NumGet(rect, 12, "int")
}

Distance(c1, c2)
{ ; function by [VxE], return value range = [0, 441.67295593006372]
return Sqrt((((c1>>16)-(c2>>16))**2)+(((c1>>8&255)-(c2>>8&255))**2)+(((c1&255)-(c1&255))**2))
}

MenuTest:
/*
gosub, GrabRemotePlay
Gui, Submit, NoHide
loop, %menu_loops% {
		ControlSend,, {%MenuDirect% down}, ahk_id %id% 
		Sleep, 200
		ControlSend,, {%MenuDirect% up}, ahk_id %id% 
		Sleep, 200
	}
*/
/*this section was used to test resoltuion specs
*/
gosub, GrabRemotePlay

GetClientSize(id, ps_win_width, ps_win_height)
gosub, PixelTuning
MsgBox, Width %ps_win_width% Height %ps_win_height% pix1 %pix1x% 

return

GetColo_p:
gosub, GrabRemotePlay
;Screen:	218, 359 (less often used)
color_check1 := PixelColorSimple(pix1x, pix1y)
;MsgBox, At the screen with [Replay] [Next Race], Press ColorP2
c1_alt := true
MsgBox, Put this in for color_check1 %color_check1%
return

GetColo_g:
gosub, GrabRemotePlay
;Screen:	218, 359 (less often used)
color_check2 := PixelColorSimple(pix2x, pix2y)
c1_alt := false
MsgBox, Put this in for color_check2 %color_check2%
return

PSystem:
Gui, Submit, NoHide
if (SysCheck = 1){
    ps_load_time1 := 14000
    ps_load_time2 := 7000 
    ps_load_time3 := 8400
}
if (SysCheck = 2){
    ps_load_time1 := 41500
    ps_load_time2 := 12000
    ps_load_time3 := 40000
}
return

MenuSel:
Gui, Submit, NoHide
if (MenuCheck = 1){
    menu_s := 1
}
if (MenuCheck = 2){
    menu_s := 2
}
return


PauseLoop:
    ControlSend,, {%accel% up}, ahk_id %id% 
	ControlSend,, {%nitros% up}, ahk_id %id% 
    ControlSend,, {%turnLeft% up}, ahk_id %id% 
    ControlSend,, {%turnRight% up}, ahk_id %id% 
    return

GuiClose:
    gosub, PauseLoop
    ExitApp

^Esc::ExitApp