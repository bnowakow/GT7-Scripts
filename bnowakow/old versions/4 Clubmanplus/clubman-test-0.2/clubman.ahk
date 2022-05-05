
; https://github.com/berban/Gdip

#HotkeyInterval 99000000
#KeyHistory 0
#MaxHotkeysPerInterval 99000000
#NoEnv
#Persistent
#SingleInstance Force
#Include Lib\Gdip.ahk

CoordMode, Pixel, Client
CoordMode, ToolTip, Client
DetectHiddenWindows, On
ListLines Off
Process, priority, , High
SendMode Input
SetBatchLines, -1
SetDefaultMouseSpeed, 0
SetFormat, Float, 0.2
; SetFormat, IntegerFast, Hex
SetKeyDelay, 50
SetMouseDelay, -1
SetWorkingDir %A_ScriptDir%

; Variables
races_clean := 0
races_clean_percent := 0
races_completed := 0
races_completed_check := 0
credits_total := 0
credits_average := 0

time_start := A_TickCount
time_current := A_TickCount

window_width := 640
window_height := 360

; GUI
Gui, New, -MaximizeBox -Resize, ClubmanPlus 0.2
Gui, Font, S10
Gui, Add, Button, w150 h40 Default gStart, Start
Gui, Add, Button, w150 h40 x+10 gReset, Reset
Gui, Show
return

; GUI events
GuiClose:
    Gosub, Release_All
    SetTimer, Health, Off
    SetTimer, Summary, Off
    OutputDebug % "Clubman> Terminated"
ExitApp

; GUI buttons
Start:
    hwnd := 0

    Gosub, Release_All
    Gosub, GrabWindow

    if (hwnd = 0) {
        MsgBox, % "PS Remote Play not found"
        return
    }

    SetTimer, Health, 600000
    SetTimer, Summary, 3600000
    time_start := A_TickCount

    ; ** AFK Loop
    Loop {

        ; ** RACE
        OutputDebug % "Clubman> Race: Waiting for position GUI to show"
        while (!IsColor(hwnd, 0xFFFFFF, TuneCoordinateX(90), TuneCoordinateY(90), 4, 75)) {
            Gosub, Press_X
            Sleep, 500
        }
        OutputDebug % "Clubman> Race: Starting race"
        Gosub, Hold_X
        Gosub, Hold_Down
        OutputDebug % "Clubman> Race: Racing until position GUI disappears"
        while (IsColor(hwnd, 0xFFFFFF, TuneCoordinateX(90), TuneCoordinateY(90), 4, 75)) {
            Sleep, 500
        }
        OutputDebug % "Clubman> Race: Race ended, releasing all buttons"
        Gosub, Release_All

        ; ** GO TO LEADERBOARDS
        OutputDebug % "Clubman> End race: Waiting for continue X icon to show"
        while (!IsColor(hwnd, 0xDEDCDA, TuneCoordinateX(475), TuneCoordinateY(563), 4, 10)) {
            Sleep, 500
        }
        OutputDebug % "Clubman> End race: Press X to continue"
        while (IsColor(hwnd, 0xDEDCDA, TuneCoordinateX(475), TuneCoordinateY(563), 4, 10)) {
            Gosub, Press_X
            Sleep, 1000
        }
        OutputDebug % "Clubman> End race: Transitioning to leaderboard"

        ; ** LEADERBOARD
        Loop {
            OutputDebug % "Clubman> Leaderboard: Checking positions"

            if (IsColor(hwnd, 0xBADD3E, TuneCoordinateX(675), TuneCoordinateY(169), 10, 10)) {
                OutputDebug % "Clubman> Leaderboard: 1st position"
                Gosub, Press_X
                break
            }
            else if (IsColor(hwnd, 0xBADD3E, TuneCoordinateX(675), TuneCoordinateY(198), 10, 10)) {
                OutputDebug % "Clubman> Leaderboard: 2nd position"
                Gosub, Press_X
                break
            }
            else if (IsColor(hwnd, 0xBADD3E, TuneCoordinateX(675), TuneCoordinateY(227), 10, 10)) {
                OutputDebug % "Clubman> Leaderboard: 3rd position"
                Gosub, Press_X
                break
            }
            else if (IsColor(hwnd, 0xBADD3E, TuneCoordinateX(675), TuneCoordinateY(256), 10, 10)) {
                OutputDebug % "Clubman> Leaderboard: 4th position"
                Gosub, Press_X
                break
            }
            else if (IsColor(hwnd, 0xBADD3E, TuneCoordinateX(675), TuneCoordinateY(285), 10, 10)) {
                OutputDebug % "Clubman> Leaderboard: 5th position"
                Gosub, Press_X
                break
            }
            else {
                Sleep, 500
            }
        }

        ; ** REWARDS
        OutputDebug % "Clubman> Rewards: Waiting for Rewards screen to load (checking money earnt)"
        while (!IsColor(hwnd, 0xBE140F, TuneCoordinateX(850), TuneCoordinateY(236), 10, 50)) {
            Gosub, Press_X
            Sleep, 500
        }
        OutputDebug % "Clubman> Rewards: Found Rewards screen"
        races_completed++

        Loop 100 {
            if (IsColor(hwnd, 0x5C90FB, TuneCoordinateX(486), TuneCoordinateY(311), 4, 20)) {
                OutputDebug % "Clubman> Rewards: Clean bonus"
                races_clean++
                PixelSearch(TuneCoordinateX(486), TuneCoordinateY(311), 1, hwnd, "clean")
                break
            }

            if (A_Index == 100) {
                OutputDebug % "Clubman> Rewards: No clean bonus"
                PixelSearch(TuneCoordinateX(486), TuneCoordinateY(311), 1, hwnd, "no-clean")
            }
        }

        ; ** REPLAY
        OutputDebug % "Clubman> Replay: Waiting for Replay screen to load (checking exit button)"
        while (!IsColor(hwnd, 0xFFFFFF, TuneCoordinateX(920), TuneCoordinateY(555), 4, 10)) {
            Gosub, Press_X
            Sleep, 500
        }
        OutputDebug % "Clubman> Replay: Pressing the Exit button"
        while (IsColor(hwnd, 0xFFFFFF, TuneCoordinateX(920), TuneCoordinateY(555), 4, 10)) {
            Gosub, Press_X
            Sleep, 500
        }
        OutputDebug % "Clubman> Replay: Leaving the Replay screen"

        ; ** RACE RESULTS
        OutputDebug % "Clubman> Race Result: Waiting for Race Result screen to load (checking cursor)"
        while (!IsColor(hwnd, 0xBB1C1A, TuneCoordinateX(664), TuneCoordinateY(540), 5, 10)) {
            Sleep, 500
        }
        OutputDebug % "Clubman> Race Result: Moving cursor to the Retry button"
        while (!IsColor(hwnd, 0xFFFFFF, TuneCoordinateX(525), TuneCoordinateY(550), 4, 10)) {
            Gosub, Press_Right
            Sleep, 500
        }
        OutputDebug % "Clubman> Race Result: Pressing the Retry button"
        while (IsColor(hwnd, 0xFFFFFF, TuneCoordinateX(525), TuneCoordinateY(550), 4, 10)) {
            Gosub, Press_X
            Sleep, 500
        }

        ; ** RACE START
        OutputDebug % "Clubman> Race Start: Waiting for Race Start screen to load (checking cursor)"
        while (!IsColor(hwnd, 0xFFFFFF, TuneCoordinateX(300), TuneCoordinateY(550), 4, 10)) {
            Sleep, 500
        }
        OutputDebug % "Clubman> Race Start: Pressing the Start button"
        while (IsColor(hwnd, 0xFFFFFF, TuneCoordinateX(300), TuneCoordinateY(550), 4, 10)) {
            Gosub, Press_X
            Sleep, 500
        }

        OutputDebug % "--- Summary ---"
        credits_total := (races_completed * 0.07 + races_clean * 0.035)
        races_clean_percent := (races_clean / races_completed) * 100
        time_current := A_TickCount
        credits_average := credits_total / (time_current - time_start) * 3600000

        OutputDebug % "Clubman> Summary: Races " races_completed
        OutputDebug % "Clubman> Summary: Races Clean " races_clean
        OutputDebug % "Clubman> Summary: Races Clean Rate " races_clean_percent "%"
        OutputDebug % "Clubman> Summary: Earnings " credits_total "M"
        OutputDebug % "Clubman> Summary: Earnings Rate " credits_average "M/Hr"
        OutputDebug % "---------------"
    }
return

; -------------------
; Coordinate tuning
; -------------------
TuneCoordinateX(coord) {
    ; 3840 because I used a 4K 16:9 monitor to get the values
Return Round((A_ScreenWidth * coord) / 3840)
}

TuneCoordinateY(coord) {
    ; 2160 because I used a 4K 16:9 monitor to get the values
Return Round((A_ScreenHeight * coord) / 2160)
}

Reset:
    ; Gosub, GrabWindow

    ; ; PixelSearch(TuneCoordinateX(850), TuneCoordinateY(236), 10, WinExist("PS Remote Play"), "test1")
    ; bolas := IsColor(hwnd, 0xBE140F, TuneCoordinateX(850), TuneCoordinateY(236), 10, 50)
    ; OutputDebug % "Clubman> is color " bolas

    ; OutputDebug % "Clubman> d1 " ColorDistance(0xBE140F, 0x87281D)
    ; OutputDebug % "Clubman> d2 " ColorDistance(0xBE140F, 0x6C1F16)
    ; OutputDebug % "Clubman> d2 " ColorDistance(0xBE140F, 0x862A1F)

    ; Gosub, GrabWindow

    ; X := (A_ScreenWidth / 2) + 1 ; X = 677 (On  1024) or 805 (On 1280)
    ; Y := A_ScreenHeight - 25 ; Y = 743 (On 768) or 999 (On 1024)

    ; OutputDebug % "Clubman> X " TuneCoordinateX(90)
    ; OutputDebug % "Clubman> Y " TuneCoordinateY(90)

    ; PixelSearch(90, 90, 10, WinExist("PS Remote Play"), "test1")
    ; PixelSearch(675, 256, 10, WinExist("PS Remote Play"), "l4")
    ; PixelSearch(675, 227, 10, WinExist("PS Remote Play"), "l3")
    ; PixelSearch(675, 198, 10, WinExist("PS Remote Play"), "l2")
    ; PixelSearch(675, 169, 10, WinExist("PS Remote Play"), "l1")
return

; -------------------
; Health Check
; -------------------
Health:
    FormatTime, current_date,, % "yyMMdd-HHmm-ss"
    OutputDebug % "Clubman> Health: Checking health at " current_date
    OutputDebug % "Clubman> Health: Races completed " races_completed
    OutputDebug % "Clubman> Health: Races completed last time " races_completed_check

    if (races_completed_check >= races_completed) {
        OutputDebug % "Clubman> Health: Error dectected, sending notification"
        SendNotification("ClubmanPlus", "Something went wrong", 2, "persistent")
    } else {
        OutputDebug % "Clubman> Health: Running healthy"
        races_completed_check := races_completed
    }
Return

; -------------------
; Summary Check
; -------------------
Summary:
    OutputDebug % "Clubman> Summary: Sending summary notification"
    message := ""
    message := message "Races " races_clean " / " races_completed " (" races_clean_percent ")`n"
    message := message "Earnings " credits_total "M (" credits_average "M/Hr)"
    SendNotification("ClubmanPlus", message, 0, "cashregister")
Return

; -------------------
; Send Notification
; -------------------
SendNotification(title, message, level, sound) {

    IniRead, token, %A_ScriptDir%\clubman.ini, pushover, token
    IniRead, user, %A_ScriptDir%\clubman.ini, pushover, user_key

    retries := 60
    expires := 3600

    url := "https://api.pushover.net/1/messages.json"
    param := "token=" token "&user=" user "&title=" title "&message=" message "&sound=" sound "&priority=" level

    if (level == 2) {
        param := param "&retry=" retries "&expire=" expires
    }

    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("POST", url)
    WebRequest.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    WebRequest.Send(param)
Return
}

; -------------------
; Grab Window
; -------------------
GrabWindow:
    OutputDebug % "Clubman> Looking for window"
    hwnd := WinExist("PS Remote Play")

    if (hwnd > 0) {
        OutputDebug % "Clubman> Window found: " hwnd
        WinMove, ahk_id %hwnd%,, 0, 0, %window_width%, %window_height%
        WinActivate, ahk_id %hwnd%
        ControlFocus,, ahk_id %hwnd%
    }
return

; -------------------
; Is Color
; -------------------
IsColor(hwnd, target_color, x, y, b, tolerance) {
    for i, c in PixelSearch(x, y, b, hwnd) {
        if (ColorDistance(c, target_color) <= tolerance) {
            Return True
        }
    }
Return False
}

; -------------------
; Color Distance
; -------------------
ColorDistance( c1, c2 ) {
    r1 := c1 >> 16
    g1 := c1 >> 8 & 255
    b1 := c1 & 255
    r2 := c2 >> 16
    g2 := c2 >> 8 & 255
    b2 := c2 & 255
return Sqrt( (r1-r2)**2 + (g1-g2)**2 + (b1-b2)**2 )
}

; -------------------
; Pixel Search
; -------------------
PixelSearch(x, y, b, hwnd, debugsave := "") {
    WinGetPos,,, width, height, ahk_id %hwnd%

    pToken := Gdip_Startup()
    hbm := CreateDIBSection(width, height),
    hdc := CreateCompatibleDC(),
    obm := SelectObject(hdc, hbm)

    RegExMatch(A_OsVersion, "\d+", version)
    PrintWindow(hwnd, hdc, version >= 8 ? 2 : 0)

    pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
    SelectObject(hdc, obm),
    DeleteObject(hbm),
    DeleteDC(hdc)

    pixs := []
    Loop % b*2 + 1 {
        i := (-1 * b) + (A_Index - 1)
        Loop % b*2 + 1 {
            j := (-1 * b) + (A_Index - 1)
            pixs.Push(Gdip_GetPixel(pBitmap, x+i, y+j) & 0x00FFFFFF)
        }
    }

    if (debugsave != "") {
        FormatTime, current_date,, % "yyMMdd-HHmm-ss"
        filename := A_ScriptDir . "\" . current_date . "-" . debugsave . ".bmp"

        ; debugbitmap:=Gdip_CloneBitmapArea(pBitmap, x-b, y-b, b*2, b*2)
        ; Gdip_SaveBitmapToFile(debugbitmap, filename)
        Gdip_SaveBitmapToFile(pBitmap, filename)
        Gdip_DisposeImage(debugbitmap)
        ; Run % filename
    }

    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
return pixs
}

; -------------------
; Release All
; -------------------
Release_All:
    Gosub, Release_X
    Gosub, Release_O
return

; -------------------
; Press x
; -------------------
Press_X:
    Gosub, Hold_X
    Gosub, Release_x
return

Hold_X:
    ControlSend,, {Enter down}, ahk_id %hwnd%
return

Release_X:
    ControlSend,, {Enter up}, ahk_id %hwnd%
return

; -------------------
; Press O
; -------------------
Press_O:
    Gosub, Hold_O
    Gosub, Release_O
return

Hold_O:
    ControlSend,, {Esc down}, ahk_id %hwnd%
return

Release_O:
    ControlSend,, {Esc up}, ahk_id %hwnd%
return

; -------------------
; Press Right
; -------------------
Press_Right:
    Gosub, Hold_Right
    Gosub, Release_Right
return

Hold_Right:
    ControlSend,, {Right down}, ahk_id %hwnd%
return

Release_Right:
    ControlSend,, {Right up}, ahk_id %hwnd%
return

; -------------------
; Press Left
; -------------------
Press_Left:
    Gosub, Hold_Left
    Gosub, Release_Left
return

Hold_Left:
    ControlSend,, {Left down}, ahk_id %hwnd%
return

Release_Left:
    ControlSend,, {Left up}, ahk_id %hwnd%
return

; -------------------
; Press Up
; -------------------
Press_Up:
    Gosub, Hold_Up
    Gosub, Release_Up
return

Hold_Up:
    ControlSend,, {Up down}, ahk_id %hwnd%
return

Release_Up:
    ControlSend,, {Up up}, ahk_id %hwnd%
return

; -------------------
; Press Down
; -------------------
Press_Down:
    Gosub, Hold_Down
    Gosub, Release_Down
return

Hold_Down:
    ControlSend,, {Down down}, ahk_id %hwnd%
return

Release_Down:
    ControlSend,, {Down up}, ahk_id %hwnd%
return

; Hotkeys
^Esc::ExitApp
