#Persistent
#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#Include Lib\Gdip.ahk
#Include Lib\AHK-ViGEm-Bus.ahk
#Include Lib\__utility__.ahk
#Include Lib\__controller_functions__.ahk
#Include Mod\TokyoDetections.ahk
#Include Races\Tokyo.ahk

hModule := DllCall("LoadLibrary", "Str", A_LineFile "\..\Lib\SuperSleep.dll", "Ptr")
SuperSleep := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", A_LineFile "\..\Lib\SuperSleep.dll", "Ptr"), "AStr", "super_sleep", "Ptr")

ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SendMode Input

SetWorkingDir %A_ScriptDir%
DetectHiddenWindows, On
#Persistent

Global script_start := A_TickCount
Global remote_play_offsetY := 71
Global racecounter := 0
Global resetcounter := 0
Global color_pitstop1 := 0xFFFFFF
Global color_restart := 0x6D5223
Global hairpin_delay := 0

Global TelegramBotToken  := ""
Global TelegramChatID := ""
Global location := ""
Global TokyoLapCount := 1



SetFormat, integerfast, d
ps_win_width := 640
ps_win_height := 360
IniRead, hairpin_delay, config.ini, Vars, hairpin_delay, 0
IniRead, color_pitstop1, config.ini, Vars, color_pitstop1, 0
IniRead, RaceCounterTotal, config.ini, Stats, racecountertotal, 0
IniRead, ResetCounterTotal, config.ini, Stats, resetcountertotal, 0
IniRead, TelegramBotToken, config.ini, API, TelegramBotToken, 0
IniRead, TelegramChatID, config.ini, API, TelegramChatID, 0
SetFormat, FloatFast, 0.2
creditcountertotal := 835000*racecountertotal/1000000

Global controller := new ViGEmDS4()
controller.SubscribeFeedback(Func("OnFeedback"))
OnFeedback(largeMotor, smallMotor, lightbarColor){
}

;- GUI 1 (MAIN) -------------------------------------------------------------------------------------------------
Icon = Assets\GT7_Tokyo.ico
Menu, Tray, Icon, %Icon%
Gui, -Caption
Gui, Add, Picture, x0 y0 w650 h207 , Assets\tokyo_gui.png
Gui, Add, Button, x222 y82 w410 h80 default gButtonStart, START
Gui, Add, Progress, x0 y54 w641 h12 RaceProgress vRaceProgress -Smooth, 0
Gui, Font, S8 CDefault Bold, Verdana
Gui, Add, Text, x440 y3 w160 h20 RaceCounterTotal +BackgroundTrans, // ALL TIME
Gui, Font, ,
Gui, Add, Text, x440 y23 w160 h20 RaceCounterTotal vracecountertotal +BackgroundTrans, Races completed: %racecountertotal%
Gui, Add, Text, x440 y38 w160 h20 ResetCounterTotal vresetcountertotal +BackgroundTrans, Races failed: %resetcountertotal%
Gui, Add, Text, x550 y38 w160 h20 CreditCounterTotal vcreditcountertotal +BackgroundTrans, Credits: %creditcountertotal% M
Gui, Font, S8 CDefault Bold, Verdana
Gui, Add, Text, x220 y3 w300 h20 RaceSession vracesession +BackgroundTrans, // SESSION
Gui, Font, ,
Gui, Add, Text, x220 y23 w160 h20 RaceCounterSession vracecountersession +BackgroundTrans, Races completed: 0
Gui, Add, Text, x220 y38 w160 h20 ResetCounterSession vresetcountersession +BackgroundTrans, Races failed: 0
Gui, Add, Text, x330 y23 w160 h20 CreditCounterSession vcreditcountersession +BackgroundTrans, Credits: 0
Gui, Add, Text, x330 y38 w160 h20 CreditAVG vcreditavg +BackgroundTrans, Avg./h: 0
Gui, Add, Text, x10 y38 w150 h20 CounterLap vcurrentlap +BackgroundTrans, Current Lap: 0/12
Gui, Add, Text, x10 y23 w150 h20 CurrentLoop vcurrentloop +BackgroundTrans, Current Location: -
Gui, Add, Button, x222 y172 w300 h20 default gGUIReset, Reset
Gui, Add, Button, x531 y172 w101 h20 default gGUIClose, Exit
Gui, Add, Button, x12 y82 w200 h20 default gMachineSettingsWindow, Settings: Machine/Setup
Gui, Add, Button, x12 y112 w200 h20 default gIngameSettingsWindow, Settings: Ingame (wip)
Gui, Add, Button, x12 y142 w200 h20 default gRiskRewardWindow, Settings: Risk/Reward (wip)
Gui, Add, Button, x12 y172 w200 h20 default gNotificationsWindow, Settings: Notifications/API
Gui, Font, S8 CDefault Bold, Verdana
Gui, Add, Text, x10 y3 w620 h20 +BackgroundTrans, // TOKYO CONTROL CENTER
Gui, Add, Statusbar, -Theme Backgroundeeeeee ;#eeeeee, no typo
SB_SetParts(80,270,190)
SB_SetText(" beta 9.2 ",1)
SB_SetText(" by problemz.",4)
Gui, Show, x8 y532 h225 w640, GT7 Tokyo // by problemz
guicontrol,, CurrentLoop, Press START, go go!
;- GUI 2 (MACHINE/SETUP) ----------------------------------------------------------------------------------------
Gui, 2: Add, Picture, x0 y0 w650 h210 , Assets\tokyo_gui.png
Gui, 2: Add, Text, x10 y14 w200 h20 +BackgroundTrans , Hairpin Turn Delay:
Gui, 2: Font, ,
Gui, 2: Add, Text, x170 y14 w200 h20 +BackgroundTrans , (ms)
Gui, 2: Add, Slider, x220 y10 w300 h51 vsliderhairpindelay  Range0-800 Thick40 +ToolTip TickInterval50 gSliderMove,%hairpin_delay%
Gui, 2: Add, Edit, x106 y11 w60 vtxthairpindelay gtextchanged, %hairpin_delay%
Gui, 2: Add, Text, x10 y40 w200 h20 +BackgroundTrans , Lower = slower PC // Higher = faster PC
Gui, 2: Add, Button, x530 y11 w100 h51 +BackgroundTrans gSaveToIni, Save

Gui, 2: Add, Button, x10 y80 w200 h40 gPit1Color, Stuck in pit `n(Only click when at tire selection menu)
;- GUI 3 (INGAME) -----------------------------------------------------------------------------------------------
Gui, 3: Add, Picture, x0 y0 w650 h177 , Assets\tokyo_gui.png
;- GUI 4 (RISK/REWARD) ------------------------------------------------------------------------------------------
Gui, 4: Add, Picture, x0 y0 w650 h177 , Assets\tokyo_gui.png
;- GUI 5 (NOTIFICATIONS/API) ------------------------------------------------------------------------------------
Gui, 5: Add, Picture, x0 y0 w650 h400 , Assets\tokyo_gui.png
Gui, 5: Add, Text, x10 y14 w205 h20 +BackgroundTrans , Telegram Bot Token:
Gui, 5: Add, Edit, x116 y11 w400 vTelegramBotToken Password, %TelegramBotToken%
Gui, 5: Add, Text, x10 y44 w205 h20 +BackgroundTrans , Telegram Chat ID:
Gui, 5: Add, Edit, x116 y41 w400 vTelegramChatID Password, %TelegramChatID%
Gui, 5: Add, Button, x530 y11 w100 h51 +BackgroundTrans gSaveToIni, Save
Return

MachineSettingsWindow:

if (GetKeyState("LShift", "P") AND GetKeyState("LAlt", "P")){
	goto, MouseColor
	}
	else{
	Gui, 2: Show, x6 y757 w639 h133, Settings: Machine/Setup 
	}
  
return

IngameSettingsWindow:
  Gui, 3: Show, x6 y757 w639 h35, Settings: Ingame
return

RiskRewardWindow:
  Gui, 4: Show, x6 y757 w639 h35, Settings: Risk/Reward
return

NotificationsWindow:
  Gui, 5: Show, x6 y757 w639 h70, Settings: Notifications/API
return

SliderMove: 
Gui, Submit, nohide
GuiControl,, txthairpindelay, %sliderhairpindelay%
Return

SaveToIni:
  Gui, Submit, Hide
  IniWrite, %txthairpindelay%, config.ini,Vars, hairpin_delay
  IniWrite, %TelegramBotToken%, config.ini,API, TelegramBotToken
  IniWrite, %TelegramChatID%, config.ini,API, TelegramChatID
return

TextChanged:
 guiControlGet, txtvar,, txthairpindelay
	if (txtvar > 800)
	{
		GuiControl,, txthairpindelay, 800
	}
	
  GuiControl,, sliderhairpindelay, %txtvar%
  return 

Pit1Color:
	MsgBox, 4,, Do you really wanna set a new Pitstop color?
	IfMsgBox Yes
	{
	gosub, GrabRemotePlay
	color_pitstop1 := PixelColorSimple(199, 315+remote_play_offsetY)
	IniWrite, %color_pitstop1%, config.ini,Vars, color_pitstop1
	}
	return
	
ButtonStart:
  SetTimer, UpdateTimer, 1000
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
  loop {
    Press_X()
    Race_Tokyo()
  }

PixelTuning:
  x_ratio := ps_win_width/640
  y_ratio := ps_win_height/360
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
    WinMove, ahk_id %id%,, 0, 0, 640, 540
  
  ControlFocus,, ahk_class %remotePlay_class%
  WinActivate, ahk_id %id%
  GetClientSize(remotePlay_id5, ps_win_width, ps_win_height)
  gosub, PixelTuning
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

ResetRace:

	FormatTime, TGTime,, MM/dd hh:mm:ss
	FileAppend, %TGTime%: Race failed - Lap %TokyoLapCount% - %location%.`n, log.txt
	url := "https://api.telegram.org/bot" TelegramBotToken "/sendMessage?text=" TGTime ": Race failed - Lap " TokyoLapCount " - " location ".&chat_id=" TelegramChatID
	hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	hObject.Open("GET",url)
	hObject.Send()

	SB_SetText(" - RESET INITIATED -",2)
	guicontrol,, CurrentLoop, Something went wrong, reseting.
	controller.Axes.LX.SetState(50)
    Press_Options()
	Sleep(1000)
	Press_Right()
	Sleep(500)
	Press_X()
	controller.Axes.LX.SetState(65)
	IniRead, ResetCounterTotal, config.ini, Stats, resetcountertotal, 0
	SetFormat, integerfast, d
	resetcounter++
	resetcountertotal++
    IniWrite, %resetcountertotal%, config.ini,Stats, ResetCounterTotal
	guicontrol,, ResetCounterTotal, Races failed: %resetcountertotal%
	guicontrol,, ResetCounterSession, Races failed: %resetcounter%
	guicontrol,, RaceProgress, 0
	Race_Tokyo()
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
ExitApp
^Esc::ExitApp

GUIReset:
if (GetKeyState("LShift", "P") AND GetKeyState("LAlt", "P")){
	MsgBox, 4,, Reset all data?	
	IfMsgBox Yes
	{
		IniWrite, 0, config.ini,Stats, RaceCounterTotal
		IniWrite, 0, config.ini,Stats, ResetCounterTotal
	}
}
Sleep(500)
gosub, PauseLoop
Reload





