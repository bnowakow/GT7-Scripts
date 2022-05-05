__enableTokyoDetections_mod__ := 1
IniRead, color_pitstop1, config.ini, Vars, color_pitstop1, 0
IniRead, color_pitstop2, config.ini, Vars, color_pitstop2, 0

class TokyoTurnContainer
{
  __New(startX, startY, endX := 0, endY := 0)
  {
    this.startX := startX
    this.startY := startY
    this.endX   := endX
    this.endY   := endY
  }
}

GoTo EndTokyoDetectionsDef

CheckTokyoMFD(x,y, b_size := 1)
{
    color_dot := 0xD3D2D0
    TokyoMFD := false
    tries := 1000 ; we shouldn't need more than 6 tries, but I have seen it loop passed
    loop {
	
      tc := BitGrab(x, y, b_size)       
		SB_SetText(" Searching... " td " < 5",2)
      for i, c in tc
      {
        td := Distance(c, color_dot)
        
        if (td < 5){
			SB_SetText(" Found: " td " < 5",2)
            TokyoMFD := true
            break
			}
		else {
			; Gonna try to automate the mfd checker, why not right?
			if (tries > 0){
			SB_SetText(" Searching Track/Course Map MFD " td " < 5",2)
			Press_Left()
			Sleep(200) 	
			tries--
			break	
      }
      tries := 1000
      TokyoMFD := true
      break		
		}
  }

    } until TokyoMFD = true
    return
}


CheckTokyoTurn(x,y, b_size := 1)
{
	turnStart := A_TickCount
    color_player := 0xDE6E70
    TokyoTurnComplete := false
    loop {
		SB_SetText(" Searching... " td " < 50",2)
      tc := BitGrab(x, y, b_size)
      for i, c in tc
      {
        td := Distance(c, color_player)
			
        if (td < 50 ){
			SB_SetText(" Found: " td " < 50",2)
            TokyoTurnComplete := true
            break
        }
      }
	; add recovery so we don't kill run looking for turn. Gonna start with a high number, can adjust lower later.
	; added some press down, x's and waits just in case we are in the pit stop
	if (A_TickCount - turnStart > 90000) { 
		Press_Down()
		Sleep(300)
		Press_X()
		Sleep(500)
		Press_X()
		Sleep(7000)
		GoSub, ResetRace
		break
	}

    } until TokyoTurnComplete = true
    return
}

CheckTokyoPen1(x,y, b_size := 1)
{
	pen1Start := A_TickCount

    color_pen := 0xFFC10B
    TokyoPen1 := false
    loop {
	  SB_SetText(" Searching... " td " < 50",2)
      tc := BitGrab(x, y, b_size)
      for i, c in tc
      {
        td := Distance(c, color_pen)
			
        if (td < 50 ){
			SB_SetText(" Found: " td " < 50",2)
            TokyoPen1 := true
            break
        }		
      }
	; add recovery so we don't kill run looking for Pen1. Gonna start with a high number, can adjust lower later.
	; started with 1.5 mins, i had these set to 3:33 on other file and still won.
	if (A_TickCount - pen1Start > 90000) { 
		GoSub, ResetRace
		break
	}

    } until TokyoPen1 = true
    return
}

CheckTokyoHairpinTurn(x,y, b_size := 1)
{
	hairpinStart := A_TickCount

    color_hairpinturn := 0xB3B1B2
    TokyoHairpinTurn := false
    loop {
	  SB_SetText(" Searching... " td " < 5",2)
      tc := BitGrab(x, y, b_size)
      for i, c in tc
      {
        td := Distance(c, color_hairpinturn)
			
        if (td < 5){
			SB_SetText(" Found: " td " < 5",2)
            TokyoHairpinTurn := true
            break
        }
      }
	; add recovery so we don't kill run sitting in hairpin
	; set to 1 minute to start, I had this at 3:33 (200000) on my other file and still won.
	if (A_TickCount - hairpinStart > 90000) { 
		
		GoSub, ResetRace
		break
	}

    } until TokyoHairpinTurn = true
    return
}

CheckTokyoPen2(x,y, b_size := 1)
{
	start := A_TickCount
    color_pen := 0xFFC10B
	RecoveryTried := false
    TokyoPen2 := false
	
    loop {
	  SB_SetText(" Searching... " td " > 60",2)
      tc := BitGrab(x, y, b_size)
      for i, c in tc
      {
        td := Distance(c, color_pen)
			
        if (td > 60 ){
			SB_SetText(" Found: " td " > 60",2)
            TokyoPen2 := true
            break
        }
		
      }
	if (A_TickCount - start > 25000 AND RecoveryTried = false) {
			SB_SetText(" We stuck? Starting recovery try.",2)
			Accel_off()
			controller.Axes.LX.SetState(50)
			loop 7 {
				Press_Square(delay:=50)
				Sleep(100)
				}
			Accel_on(80)
			Sleep(500)
			loop 9 {
				Press_Triangle(delay:=50)
				Sleep(100)
				}
			controller.Axes.LX.SetState(30)
			RecoveryTried := true
		}
		
	if (A_TickCount - start > 60000) {
			gosub, ResetRace
			break
		}

    } until TokyoPen2 = true
    return
}

CheckTokyoPenServed(x,y, b_size := 1)
{
    color_penserved := 0xAE1B1E
    TokyoPenServed := false
    loop {
	  SB_SetText(" Searching... " td " > 60",2)
      tc := BitGrab(x, y, b_size)
      for i, c in tc
      {
        td := Distance(c, color_penserved)
			
        if (td > 60 ){
			SB_SetText(" Found: " td " > 60",2)
            TokyoPenServed := true
            break
        }
      }

    } until TokyoPenServed = true
    return
}

CheckTokyoPenReceived(x,y, b_size := 1)
{
	start := A_TickCount
    color_penreceived := 0xAE1B1E
    TokyoPenReceived := false
    loop {
	  SB_SetText(" Searching... " td " < 40",2)
      tc := BitGrab(x, y, b_size)
      for i, c in tc
      {
        td := Distance(c, color_penreceived)
		
        if (td < 40 ){
			SB_SetText(" Found: " td " < 40",2)
			guicontrol,, CurrentLoop, Pen received
			TokyoPenReceived := true
			break
        }
		if (TokyoLapCount != 6 AND A_TickCount - start > 36000)
		{
			SB_SetText(" Not found in time. Shifting up.",2)
			loop 6 {
				Press_Triangle(delay:=50)
				Sleep(200)
				TokyoPenReceived := true
				break
		}
        break
		}
		if (TokyoLapCount = 6 AND A_TickCount - start > 46000)
		{
			SB_SetText(" Not found in time. Shifting up.",2)
			loop 20 {
				Press_Triangle(delay:=50)
				Sleep(200)
				TokyoPenReceived := true
				break
		}
        break
		}

      }
    } until TokyoPenReceived = true
    return
}

CheckTokyoPitstopDone(x,y, b_size := 1)
{
	 pitstopDoneStart := A_TickCount

    color_pitstopdone := 0xFFFFFF
    TokyoPitstopDone := false
    loop {
	  SB_SetText(" Searching... " td " > 10",2)
      tc := BitGrab(x, y, b_size)
      for i, c in tc
      {
        td := Distance(c, color_pitstopdone)

        if (td > 10 ){
			SB_SetText(" Found: " td " > 10",2)
            TokyoPitstopDone := true
            break
        }
      }
	; add recovery so we don't kill run sitting in pit, havent tested if press down works to get us out
	if (A_TickCount - pitstopDoneStart > 60000) {
		Press_Down()
		Sleep(300)
		Press_X()
		Sleep(500)
		Press_X()
		Sleep(7000)
		GoSub, ResetRace
	}
    } until TokyoPitstopDone = true
    return
}

CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
{
if ( A_TickCount - loopStartTime > maxTime AND TokyoLapCount <= 10) {
				gosub, ResetRace
			}
else if (A_TickCount - loopStartTime > maxTime+90000 AND TokyoLapCount > 10)
	{
	gosub, ResetRace
	}
}

CheckTokyoPitstop1(x,y, b_size := 1)
{
	pitstop1Start := A_TickCount
	
	;color_pitstop1 := 0xFFFFFF
	;color_pitstop1 := 0x818002
    ;color_pitstop1 := 0xFBFB00 ; old color
    TokyoPitstop := false
    loop {
	  SB_SetText(" Searching... " td " < 10",2)
      tc := BitGrab(x, y, b_size)
      for i, c in tc
      {
        td := Distance(c, color_pitstop1)
			
        if (td < 10 ){
			SB_SetText(" Found: " td " < 10",2)
            TokyoPitstop := true
            break
        }
      }
	; add recovery so we don't kill run sitting in pit, havent tested if press down works to get us out
	if (A_TickCount - pitstop1Start > 60000) {
		Press_Down()
		Sleep(300)
		Press_X()
		Sleep(500)
		Press_X()
		Sleep(7000)
		GoSub, ResetRace
	}
	guicontrol,, CurrentLoop, Stuck in pit? Press GUI Button.

    } until TokyoPitstop = true
    return
}
UpdateAVG(racecounter, script_start)
{
	SetFormat, integerfast, d
	creditcountersession := (835000*racecounter)/1000000
	SetFormat, integerfast, d
	SetFormat, FloatFast, 0.2
	creditavg := creditcountersession/(A_TickCount-script_start)*3600000
	guicontrol,, CreditAVG, Avg./h: ~%creditavg% M
	return
}

UpdateTimer()
{
ElapsedTime := A_TickCount - script_start
	 VarSetCapacity(t,256),DllCall("GetDurationFormat","uint",2048,"uint",0,"ptr",0,"int64",ElapsedTime*10000,"wstr","d' day(s) 'h':'mm':'ss","wstr",t,"int",256)
	SB_SetText("Runtime: " t,3)
	return 
}

EndTokyoDetectionsDef: