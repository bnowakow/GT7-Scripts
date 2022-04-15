#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#Include Lib\Gdip.ahk
#Include Lib\AHK-ViGEm-Bus.ahk

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

; --------- Controls
accel := "Enter"
turnLeft := "Left"
turnRight := "Right"
brake := "Up"
nitros := "Down"


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
color_2_delay := 500

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
ps_load_time3 := 9000

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

	
AFKLoop:
    loop{
		gosub, ResetControllerState
		gosub, PressX
        gosub, Race
        gosub, Menu_End_Race
		gosub, Menu_Start_Race
    }
    return

PressX:
; Just for menuing, does not hold X down
    controller.Buttons.Cross.SetState(true)
	DllCall("Sleep", "UInt", 200)
    controller.Buttons.Cross.SetState(false)
    return
    
PressO:
; Just for menuing, does not hold O down
    controller.Buttons.Circle.SetState(true)
	DllCall("Sleep", "UInt", 200)
    controller.Buttons.Circle.SetState(false)
    return
    
PressRight:
; For turning 
    controller.Dpad.SetState("Right") 
    Sleep, 50
    controller.Dpad.SetState("None")
    return
    
; given time t in miliseconds, turn right for that long, with intensity being how much the turn button is held for
TurnRight:
	t0 := A_TickCount
	tf := t0+t
    
	loop {
        Sleep(100)
	} until  A_TickCount > tf
    return

TurnLeft:
	t0 := A_TickCount
	tf := t0+t
	
	loop {	
		Sleep(100)
	} until A_TickCount > tf
    return

; Set the time you want to turn for in miliseconds and how hard (50, 100), 100 being the most, 50 being neutral
Turn_Right(sleept, inten){
    t := sleept
    controller.Axes.LX.SetState(inten)
    gosub, TurnRight
    controller.Axes.LX.SetState(50)
}

; Set the time you want to turn for in miliseconds and how hard (0, 50), 0 being the most
Turn_Left(sleept, inten){   
    t := sleept
    controller.Axes.LX.SetState(inten)
    gosub, TurnLeft
    controller.Axes.LX.SetState(50)
}


ResetControllerState:
	controller.Axes.RT.SetState(0)
	controller.Buttons.R2.SetState(false) 
	controller.Dpad.SetState("None") 
    controller.Axes.LX.SetState(50)
    controller.Axes.LY.SetState(50)
	controller.Axes.RX.SetState(50)
	controller.Axes.RY.SetState(50)
	controller.Button.LS.SetState(false)
    controller.Button.RS.SetState(false)
	controller.Button.RT.SetState(false)
	controller.Buttons.Cross.SetState(false)
	controller.Buttons.Circle.SetState(false)
	controller.Buttons.Square.SetState(false)
	controller.Buttons.Triangle.SetState(false)	
    return


;This will do only an oil change. will leave user at race menu to resume.
DoOilChange:
    Sleep, 1000
    controller.Buttons.Circle.SetState(true)
    Sleep, 200
    controller.Buttons.Circle.SetState(false)
    Sleep, 2800
    loop, 2 {
    controller.Dpad.SetState("Right") 
        Sleep, 140
        controller.Dpad.SetState("None")
        Sleep, 200
     }
    controller.Dpad.SetState("Down") 
    Sleep, 200
    controller.Dpad.SetState("None") 
    Sleep, 200
    
    loop, 2 {
		gosub, PressX
		Sleep, 1000
	}
    
    Sleep, 2000
    controller.Dpad.SetState("Down") 
    Sleep, 140
    controller.Dpad.SetState("None")
    Sleep, 200
    loop, 2 {
		gosub, PressX
		Sleep, 500
	}
    Sleep, 7000
    gosub, PressX
    Sleep, 500

	controller.Buttons.Circle.SetState(true)
	Sleep, 200
	controller.Buttons.Circle.SetState(false)
	Sleep, 200
	Sleep, 3000
	controller.Dpad.SetState("Up") 
	Sleep, 140
	controller.Dpad.SetState("None")
	Sleep, 200
	controller.Dpad.SetState("Left") 
	Sleep, 200
	controller.Dpad.SetState("None")
	Sleep, 500
	controller.Dpad.SetState("Left") 
	Sleep, 200
	controller.Dpad.SetState("None")
	Sleep, 500
	gosub, PressX
	Sleep, 4800
	return


;This will do complete maintenance on the car including oil, engine and body. will leave user at race menu to resume.
DoMaintenance:
	Sleep, 1000
	controller.Buttons.Circle.SetState(true)
	Sleep, 200
	controller.Buttons.Circle.SetState(false)
	Sleep, 2800
	loop, 2 {
		controller.Dpad.SetState("Right") 
		Sleep, 140
		controller.Dpad.SetState("None")
		Sleep, 200
	}
	controller.Dpad.SetState("Down") 
	Sleep, 200
	controller.Dpad.SetState("None") 
	Sleep, 200
    
	loop, 2 {
		gosub, PressX
		Sleep, 1000
	}
    
	Sleep, 2000
	controller.Dpad.SetState("Down") 
	Sleep, 140
	controller.Dpad.SetState("None")
	Sleep, 200
	loop, 2 {
		gosub, PressX
		Sleep, 500
	}
	Sleep, 7000
	gosub, PressX
	Sleep, 500

	controller.Dpad.SetState("Down") 
	Sleep, 140
    controller.Dpad.SetState("None")
	Sleep, 200
	controller.Dpad.SetState("Down") 
	Sleep, 140
	controller.Dpad.SetState("None")
	Sleep, 200
	loop, 2 {
		gosub, PressX
		Sleep, 500
	}
	Sleep, 7000
	gosub, PressX
	Sleep, 500

	controller.Dpad.SetState("Down") 
	Sleep, 140
	controller.Dpad.SetState("None")
	Sleep, 200
	controller.Dpad.SetState("Down") 
	Sleep, 140
	controller.Dpad.SetState("None")
	Sleep, 200
	controller.Dpad.SetState("Down") 
	Sleep, 140
	controller.Dpad.SetState("None")
	Sleep, 200
	loop, 2 {
		gosub, PressX
		Sleep, 500
	}
	Sleep, 8500
	gosub, PressX
	Sleep, 500

	controller.Buttons.Circle.SetState(true)
	Sleep, 200
	controller.Buttons.Circle.SetState(false)
	Sleep, 200
	Sleep, 3000
	controller.Dpad.SetState("Up") 
	Sleep, 140
	controller.Dpad.SetState("None")
	Sleep, 200
	controller.Dpad.SetState("Left") 
	Sleep, 200
	controller.Dpad.SetState("None")
	Sleep, 500
	controller.Dpad.SetState("Left") 
	Sleep, 200
	controller.Dpad.SetState("None")
	Sleep, 500
	gosub, PressX
	Sleep, 4800
	return


Menu_Start_Race:
	controller.Dpad.SetState("Down") 
	Sleep, 50
	controller.Dpad.SetState("None") 
	Sleep, 50
	loop, %menu_loops% {
		controller.Dpad.SetState(MenuDirect) 
		Sleep, 50
		controller.Dpad.SetState("None") 
		Sleep, 50
	}
	loop, 2{
		gosub, PressX
		Sleep, 500
	}
	Sleep, %ps_load_time3%
	gosub, PressX
	Sleep, 1000
	gosub, PressX
	return


Race:
; Hold Acceleration and manage turning
    Tooltip
	controller.Buttons.Cross.SetState(true)
	controller.Dpad.SetState("Down") 
	Sleep, 17500
	controller.Axes.LX.SetState(67)

	CheckForOilChange := Mod(A_Index, 30)
	CheckForMaintenance := Mod(A_Index, 180)
	OCremain := 30 - CheckForOilChange
	SetFormat, IntegerFast, d
	EOremain := 180 - CheckForMaintenance
	SetFormat, IntegerFast, d
	ToolTip, Oil: %OCremain% race(s) remaining`nEngine: %EOremain% race(s) remaining, 250, 45, Screen

	race_complete := false
	SetTimer, RaceComplete, 225000
	
	; Retry race if time is taking more than 5.5 mins 
	; (assume something went wrong with race)
	SetTimer, RetryRace, 330000

    loop {
		;ToolTip, Racing, 100, 100, Screen
        break_point := false
        c1 := BitGrab(pix1x, pix1y, box_size)
        for i, c in c1
        {
            d1 := Distance(c, color_check1)
            if (d1 < tolerance ){
                break_point := true
                break
            }
        }
        if (break_point)
            break
		if (race_complete) {
			controller.Dpad.SetState("Right") 
			Sleep, 50
			controller.Dpad.SetState("None")
		}
        Sleep, 2000
    }
	ToolTip, Found color 1, 100, 100, Screen
	SetTimer, RetryRace, off
	gosub, ResetControllerState
	Sleep, 500
	return


RaceComplete:
	race_complete := true
	return


Menu_End_Race:
    ToolTip, Menuing, 100, 100, Screen
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
        sleep, %color_2_delay%
    }
	ToolTip, Found color 2, 100, 100, Screen
	Sleep, 1000
	controller.Buttons.Circle.SetState(true)
	Sleep, 200
	controller.Buttons.Circle.SetState(false)
	Sleep, 200
	controller.Dpad.SetState("Right") 
	Sleep, 200
	controller.Dpad.SetState("None") 
	Sleep, 500
	gosub, PressX
	Tooltip
	Sleep, %ps_load_time1%
	gosub, PressX
	Sleep, 1000
	controller.Buttons.Circle.SetState(true)
	Sleep, 200
	controller.Buttons.Circle.SetState(false)
	loop, 2 {
		gosub, PressX
		Sleep, 500
	}
	Sleep, %ps_load_time2% 
	;Conduct Maintenance here.
	if (CheckForMaintenance = 0) {
		gosub, DoMaintenance
	}
	else {
		if (CheckForOilChange = 0) {
			gosub, DoOilChange
		}
	}
	return


RetryRace:
	ToolTip, Retry Race, 100, 100, Screen
    WinActivate, ahk_id %id%
    Sleep, 500
    Gosub, ResetControllerState
    Sleep 200
    controller.Buttons.Options.SetState(true)
    Sleep 200
	controller.Buttons.Options.SetState(false)
    Sleep, 200
    controller.Dpad.SetState("Right") 
    Sleep, 200
    controller.Dpad.SetState("None")
	Sleep, 200
    Goto, AFKLoop
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
	;MsgBox, This will test the number of Left/Right presses at the championship selection menu. `nTry this if you have not finished all cafe menus. `nPress OK to test

	gosub, GrabRemotePlay
	Gui, Submit, NoHide
	loop, %menu_loops% {
			controller.Dpad.SetState(MenuDirect) 
			Sleep, 125
			controller.Dpad.SetState("None") 
			Sleep, 200
		}


	/*this section was used to test resoltuion specs

	/*
	gosub, GrabRemotePlay

	GetClientSize(id, ps_win_width, ps_win_height)
	gosub, PixelTuning
	MsgBox, Width %ps_win_width% Height %ps_win_height% pix1 %pix1x% 
	*/
	return


BitGrab(x, y, b)
{
    HWND := WinExist("PS Remote Play")
    pToken := Gdip_Startup()
    pBitmap := Gdip_BitmapFromHWND2(hwnd)
    
    pixs := []
    for i in range(-1*b, b+1){
        for j in range(-1*b, b+1){
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
	if (SysCheck = 1){
		ps_load_time1 := 12000
		ps_load_time2 := 6000 
		ps_load_time3 := 9000
	}
	if (SysCheck = 2){
		ps_load_time1 := 37000
		ps_load_time2 := 12000
		ps_load_time3 := 33000
	}
	if (SysCheck = 3){
		ps_load_time1 := 37000
		ps_load_time2 := 12000
		ps_load_time3 := 33000
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


Sleep(ms=1)
{
	global timeBeginPeriodHasAlreadyBeenCalled
	if (timeBeginPeriodHasAlreadyBeenCalled != 1)
	{
		DllCall("Winmm.dll\timeBeginPeriod", UInt, 1)
		timeBeginPeriodHasAlreadyBeenCalled := 1
	}	
	DllCall("Sleep", UInt, ms)
}


GuiClose:
    gosub, PauseLoop
    ExitApp

^Esc::ExitApp