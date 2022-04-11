#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#Include Lib\Gdip.ahk
;#include Lib\AHK-ViGEm-Bus.ahk

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

; RUF pink 0x583375
; --------- Constants 
; Time at turn in seconds and Stablizing control
t := 220000
intensity := 230
delay := 160
init_delay := 10000

MenuDirect := "Right"
Menu_loops := 6
menu_s := 1
box_size := 3
color_check1 :=  0xBBE044
color_check2 :=  0xBBE044
color_2_delay := 1500

color_tyre_overheat := 0xD42304
tyres_overheating := false

; resolution parameters and pixel search locations
ps_win_width := 720
tolerance := 20
bm_delay := 100
box_size := 2

ps_load_time1 := 14000
ps_load_time2 := 7000 
ps_load_time3 := 8400

/*
; Create a new controller controller
controller := new ViGEmDS4()
controller.SubscribeFeedback(Func("OnFeedback"))

OnFeedback(largeMotor, smallMotor, lightbarColor){
	;OutputDebug % "AHK| Feedback received - LargeMotor: " largeMotor ", SmallMotor:  " smallMotor ", LightBarColor: " lightbarColor
}
*/

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
    t = 220000
	intensity = 220
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
    loop {
		;gosub, Menu
		gosub, PressX
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
	
	loop {
		ControlSend,, {%turnRight% down}, ahk_id %id% 
		DllCall("Sleep", "UInt", intensity)
		ControlSend,, {%turnRight% up}, ahk_id %id% 	
		DllCall("Sleep", "UInt", delay)
	} until tyres_overheating || A_TickCount > tf
    return


TurnLeft:
	t0 := A_TickCount
	tf := t0+t
	
	loop {
		ControlSend,, {%turnLeft% down}, ahk_id %id% 
		DllCall("Sleep", "UInt", intensity)
		ControlSend,, {%turnLeft% up}, ahk_id %id% 
	
		DllCall("Sleep", "UInt", delay)
	} until tyres_overheating || A_TickCount > tf
    return

CheckTyresOverheating:
    tc := BitGrab(tyreX, tyreY, box_size)
    for i, c in tc
    {
        td := Distance(c, color_tyre_overheat)
        if (td < tolerance ) {
            tyres_overheating := true
            break
        }
    }
    return

RetryRace:
    Gosub, PauseLoop
    Sleep 500
    tyres_overheating := false
    controller.Buttons.Options.SetState(true)
    Sleep 500
	controller.Buttons.Options.SetState(false)
    Sleep, 500
    WinActivate, ahk_id %id%
    Sleep, 500
    ControlSend,, {Right down}, ahk_id %id% 
    Sleep, 200
    ControlSend,, {Right up}, ahk_id %id% 
    Goto, AFKLoop
    return

Race:
; Hold Acceleration and manage turning
    
	ControlSend,, {%accel% down}, ahk_id %id% 
	ControlSend,, {%nitros% down}, ahk_id %id% 
	DllCall("Sleep", "UInt", 8200)
    ;SetTimer, CheckTyresOverheating, 1000
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

Screen:	263, 74 (less often used)
Window:	263, 74 (default)
Client:	255, 43 (recommended)
Color:	FF3632 (Red=FF Green=36 Blue=32)
*/
    loop {
        /*
        if (tyres_overheating) {
            Goto, RetryRace
            return
        }
        */
        break_point := false
        c1 := BitGrab(pix1x, pix1y, box_size)
        for i, c in c1
        {
            d1 := Distance(c, color_check1)
            if (d1 < tolerance ) {
                break_point := true
                break
            }
        }
        if (break_point)
            break
        ControlSend,, {%turnRight% down}, ahk_id %id% 
        Sleep, 140
        ControlSend,, {%turnRight% up}, ahk_id %id% 
        Sleep, 200
        /*
        PixelSearch, x, y, pix1x-10, pix1y-10, pix1x+10, pix1y+10, %color_check1%, 32, Fast RGB
        If (ErrorLevel != 0) {
            ControlSend,, {%turnRight% down}, ahk_id %id% 
            Sleep, 140
            ControlSend,, {%turnRight% up}, ahk_id %id% 
            Sleep, 200
        }
        */
    }
	;ToolTip, Found color 1, 100, 100, Screen
    ControlSend,, {%accel% up}, ahk_id %id% 
	ControlSend,, {%nitros% up}, ahk_id %id% 
    return
    
Menu:
    if (menu_s = 1) {
        gosub, Menu_pixel
    }
    if (menu_s = 2) {
        gosub, Menu_time
    }
    return

Menu_pixel:
    ;ToolTip, Menuing, 100, 100, Screen
    loop {
        break_point := false
        c2 := BitGrab(pix2x, pix2y, box_size)
        for i, c in c2
        {
            d2 := Distance(c, color_check2)
            if (d2 < tolerance ){
                break_point := true
                break
            }
        }
        if (break_point)
            break
        gosub, PressX
        sleep %color_2_delay%
        sleep, %bm_delay%
    }
    ;ToolTip, Found color 2, 100, 100, Screen
    Sleep, 200
    ControlSend,, {Esc down}, ahk_id %id% 
    Sleep, 200
    ControlSend,, {Esc up}, ahk_id %id% 
    Sleep, 200
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
	Sleep, %ps_load_time2%
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
	loop, 2 {
        gosub, PressX
        Sleep, 1200
    }
	Sleep, %ps_load_time3%
	loop, 2 {
        gosub, PressX
        Sleep, 1000
    }
    return

Menu_time:
    loop, 9 {
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
		Sleep, 100
		ControlSend,, {%MenuDirect% up}, ahk_id %id% 
		Sleep, 400
	}
	loop, 2 {
        gosub, PressX
        Sleep, 2000
    }
	Sleep, %ps_load_time3%
    gosub, PressX
    Sleep, 2000
    return
    
;; General Functions for AHK

GrabRemotePlay:
    WinGet, remotePlay_id, List, ahk_exe RemotePlay.exe
    if (remotePlay_id = 0)
    {
        MsgBox, PS Remote Play not found
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
    WinMove, ahk_id %id%,,  0, 0, 0, 0
    gosub, Init

    ControlFocus,, ahk_class %remotePlay_class%
    WinActivate, ahk_id %id%
    return

RPwind:
    WinGet, remotePlay_id, List, ahk_exe RemotePlay.exe
    if (remotePlay_id = 0)
    {
        MsgBox, PS Remote Play not found
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
    WinMove, ahk_id %id%,,  -700, -400, 0, 0
    ControlFocus,, ahk_class %remotePlay_class%
    WinActivate, ahk_id %id%
    return

PixelColorSimple(pc_x, pc_y)
{
    WinGet, remotePlay_id, List, ahk_exe RemotePlay.exe
    if (remotePlay_id = 0)
    {
        MsgBox, PS Remote Play not found
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

ConvertARGB(ARGB, Convert := 0)
{
    SetFormat, IntegerFast, Hex
    RGB += ARGB
    RGB := RGB & 0x00FFFFFF
    if (Convert)
        RGB := (RGB & 0xFF000000) | ((RGB & 0xFF0000) >> 16) | (RGB & 0x00FF00) | ((RGB & 0x0000FF) << 16)
    
    return RGB
}

MenuTest:
    MsgBox, This will test the number of Left/Right presses at the championship selection menu. `nTry this if you have not finished all cafe menus. `nPress OK to test
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

    /*
    gosub, GrabRemotePlay

    GetClientSize(id, ps_win_width, ps_win_height)
    MsgBox, Width %ps_win_width% Height %ps_win_height% pix1 %pix1x% 
    */
    return

BitGrab(x, y, b)
{
    HWND := WinExist("PS Remote Play")
    pToken := Gdip_Startup()
    pBitmap := Gdip_BitmapFromHWND2(hwnd)
    
    pixs := []
    for i in range(-1*b, b+1) {
        for j in range(-1*b, b+1) {
            pixel := Gdip_GetPixel(pBitmap,x+i,y+j)
            rgb := ConvertARGB( pixel )
            pixs.Push(rgb)
        }
    }

    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
    return pixs
}

Gdip_BitmapFromHWND2(hwnd)
{
    WinGetPos,,, Width, Height, ahk_id %hwnd%
    hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
    RegExMatch(A_OsVersion, "\d+", Version)
    PrintWindow(hwnd, hdc, Version >= 8 ? 2 : 0)
    pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
    SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
    return pBitmap
}

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
    if (SysCheck = 1) {
        ps_load_time1 := 14000
        ps_load_time2 := 7000 
        ps_load_time3 := 8400
    }
    if (SysCheck = 2) {
        ps_load_time1 := 41500
        ps_load_time2 := 12000
        ps_load_time3 := 40000
    }
    return

MenuSel:
    Gui, Submit, NoHide
    if (MenuCheck = 1) {
        menu_s := 1
    }
    if (MenuCheck = 2) {
        menu_s := 2s
    }
    return

Init:
    ps_win_height := Floor((ps_win_width * 9 / 16) + 2 * 80)    ; PS menu bar is approx 80px
    ps_win_height2 := Floor(ps_win_width * 9 / 16)              ; PS display is in 16/9 ("without" the black bars)
    black_bar_height := Floor((ps_win_height - ps_win_height2) / 2)
    ;msgbox, %ps_win_height% %ps_win_height2% %black_bar_height%

    VarSetCapacity(rect, 16)
    DllCall("GetWindowRect", "ptr", id, "ptr", &rect)
    wwr := NumGet(rect, 8, "int")
    hwr := NumGet(rect, 12, "int")

    DllCall("GetClientRect", "ptr", id, "ptr", &rect)
    wcr := NumGet(rect, 8, "int")
    hcr := NumGet(rect, 12, "int")

    border := wwr - wcr             ;xborder = yborder
    cap := hwr - hcr - border       ;cap = caption = title bar height         
    ;msgbox, %wwr% %hwr% %wcr% %hcr% %border% %cap%

    ps_win_width := ps_win_width + border
    ps_win_height := ps_win_height + border + cap
    ps_win_height2 := ps_win_height2 + border + cap
    ;msgbox, %ps_win_width% %ps_win_height%

    pix1x := Floor(ps_win_width * 0.6982)
    pix1y := Floor((ps_win_height2 * 0.2857) + black_bar_height)
    pix2x := Floor(ps_win_width * 0.9253)
    pix2y := Floor((ps_win_height2 * 0.7995) + black_bar_height)
    tyreX := Floor(ps_win_width * 0.2530)
    tyreY := Floor((ps_win_height2 * 0.9123) + black_bar_height)

    WinMove, ahk_id %id%,,  0, 0, ps_win_width, ps_win_height
    return

Reset:
    gosub, PauseLoop
    Reload
    Sleep 1000
    return

PauseLoop:
    ControlSend,, {%accel% up}, ahk_id %id% 
	ControlSend,, {%nitros% up}, ahk_id %id% 
    ControlSend,, {%turnLeft% up}, ahk_id %id% 
    ControlSend,, {%turnRight% up}, ahk_id %id% 
    return
    
range(start, stop:="", step:=1) {
	static range := { _NewEnum: Func("_RangeNewEnum") }
	if !step
		throw "range(): Parameter 'step' must not be 0 or blank"
	if (stop == "")
		stop := start, start := 0
	; Formula: r[i] := start + step*i ; r = range object, i = 0-based index
	; For a postive 'step', the constraints are i >= 0 and r[i] < stop
	; For a negative 'step', the constraints are i >= 0 and r[i] > stop
	; No result is returned if r[0] does not meet the value constraint
	if (step > 0 ? start < stop : start > stop) ;// start == start + step*0
		return { base: range, start: start, stop: stop, step: step }
}

_RangeNewEnum(r) {
	static enum := { "Next": Func("_RangeEnumNext") }
	return { base: enum, r: r, i: 0 }
}

_RangeEnumNext(enum, ByRef k, ByRef v:="") {
	stop := enum.r.stop, step := enum.r.step
	, k := enum.r.start + step*enum.i
	if (ret := step > 0 ? k < stop : k > stop)
		enum.i += 1
	return ret
}

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