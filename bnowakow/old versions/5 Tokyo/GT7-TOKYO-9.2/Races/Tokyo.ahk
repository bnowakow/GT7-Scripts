GoTo EndRace_Tokyo_Def

Race_Tokyo()
{
	SetFormat, integerfast, d
	TokyoStart:
	;- VARIABLES -----------------------------------------------------------------------------
	SetFormat, integerfast, d
	TokyoLapCount := 1
	maxTime := 200000
	;- COORDINATES: TURNS --------------------------------------------------------------------
	TokyoTurn1 := new TokyoTurnContainer(611, 59+remote_play_offsetY, 622, 69+remote_play_offsetY)
	TokyoTurn2 := new TokyoTurnContainer(618, 70+remote_play_offsetY, 601, 76+remote_play_offsetY)
	TokyoTurn3 := new TokyoTurnContainer(599, 79+remote_play_offsetY, 591, 87+remote_play_offsetY)
	TokyoTurn4 := new TokyoTurnContainer(589, 88+remote_play_offsetY, 571, 96+remote_play_offsetY)
	TokyoTurn5 := new TokyoTurnContainer(567, 96+remote_play_offsetY, 556, 90+remote_play_offsetY)
	TokyoTurn6 := new TokyoTurnContainer(554, 86+remote_play_offsetY, 543, 82+remote_play_offsetY)
	TokyoTurn7 := new TokyoTurnContainer(538, 81+remote_play_offsetY, 530, 75+remote_play_offsetY)
	TokyoTurn8 := new TokyoTurnContainer(530, 75+remote_play_offsetY, 510, 72+remote_play_offsetY)
	;- COORDINATES: PENALTY WARNINGS ---------------------------------------------------------
	TokyoPenWarning := new TokyoTurnContainer(360, 154+remote_play_offsetY, 408, 154+remote_play_offsetY)
	TokyoPenIndicator := new TokyoTurnContainer(366, 132+remote_play_offsetY)
	;- COORDINATES: HAIRPIN TURN -------------------------------------------------------------
	TokyoHairpinTurn := new TokyoTurnContainer(606, 334+remote_play_offsetY)
	;- COORDINATES: PENALTY WARNINGS ---------------------------------------------------------
	TokyoPen := new TokyoTurnContainer(360, 154+remote_play_offsetY, 408, 154+remote_play_offsetY)
	TokyoPenServed := new TokyoTurnContainer(366, 132+remote_play_offsetY)
	;- COORDINATES: HAIRPIN TURN--------------------------------------------------------------
	TokyoHairpinTurn := new TokyoTurnContainer(606, 334+remote_play_offsetY)
	;- MISC ----------------------------------------------------------------------------------
	TokyoPitstop := new TokyoTurnContainer(191, 316+remote_play_offsetY, 580, 383+remote_play_offsetY)
	TokyoPitstopEnter := new TokyoTurnContainer(530, 70+remote_play_offsetY)
	TokyoPitstopDone := new TokyoTurnContainer(57, 329+remote_play_offsetY)
	TokyoRestartRace := new TokyoTurnContainer(405,465+remote_play_offsetY)
	;- RACE START ----------------------------------------------------------------------------
	controller.Axes.LX.SetState(65)
	Sleep(7400)
	
	FormatTime, TGTime,, MM/dd hh:mm:ss
	FileAppend, %TGTime%: Race started.`n, logs.txt
	url := "https://api.telegram.org/bot" TelegramBotToken "/sendMessage?text=" TGTime ": Race started.&chat_id=" TelegramChatID
	hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	hObject.Open("GET",url)
	hObject.Send()
	
	guicontrol,, CurrentLoop, Race started. Good luck!
	guicontrol,, CurrentLap, Current Lap: %TokyoLapCount% /12
	Accel_On(100)
	loop 3 {
		Press_Triangle(delay:=50)
		Sleep(200)
	}
	Sleep(800)
	controller.Axes.LX.SetState(65)
;- 12 LAP LOOP ---------------------------------------------------------------------------
	loop 12 
	{
		location := "Start/Finish"
		guicontrol,, CurrentLoop, Current Location: %location%
		loopStartTime := A_TickCount
		; Turn 1
			location := "T1 Start"
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn1.startX, TokyoTurn1.startY)
			loop 3 {
				Press_Triangle(delay:=50)
				Sleep(200)
			}
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(36)
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			Sleep(1000)
			location := "T1 End"
			CheckTokyoTurn(TokyoTurn1.endX, TokyoTurn1.endY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(35)
			Sleep(1000)
		; Turn 2
			location := "T2 Start"
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn2.startX, TokyoTurn2.startY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(52)
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			Sleep(1000)
			location := "T2 End"
			CheckTokyoTurn(TokyoTurn2.endX, TokyoTurn2.endY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(40)
			Sleep(1000)
		; Turn 3
			location := "T3 Start"
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn3.startX, TokyoTurn3.startY)
			guicontrol,, CurrentLoop, Current Location: %location%
			Sleep(1000)
			controller.Axes.LX.SetState(40)
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)		
			CheckTokyoTurn(TokyoTurn3.endX, TokyoTurn3.endY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(70)
			Sleep(1000)
		; Turn 4
			location := "T4 Start"
			Accel_On(85)
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn4.startX, TokyoTurn4.startY)
			guicontrol,, CurrentLoop, Current Location: %location%
			Sleep(1000)
			controller.Axes.LX.SetState(68)
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn4.endX, TokyoTurn4.endY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(60)
			Accel_On(70)
			Sleep(1000)
		; Turn 5
			location := "T5 Start"
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn5.startX, TokyoTurn5.startY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(42)
			Sleep(1000)
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn5.endX, TokyoTurn5.endY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(63)
			Sleep(1000)
		; Turn 6
			location := "T6 Start"
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn6.startX, TokyoTurn6.startY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(70)
			Sleep(1000)
			Accel_on(75)
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn6.endX, TokyoTurn6.endY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(40)
			Sleep(1000)
		; Turn 7
			location := "T7 Start"
			Accel_On(100)
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn7.startX, TokyoTurn7.startY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(40)
			Sleep(1000)
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn7.endX, TokyoTurn7.endY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(70)
			Sleep(1000)
		; Turn 8
			location := "T8 Start"
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn8.startX, TokyoTurn8.startY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(65)
			Sleep(1000)
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoTurn(TokyoTurn8.endX, TokyoTurn8.endY)
			guicontrol,, CurrentLoop, Current Location: %location%
			controller.Axes.LX.SetState(30)
			Sleep(2000)
			Brake_on(100)
			Sleep(2200)
			Brake_off()
			Accel_On(35)
		; Penalty Warning 1
			location := "Hairpin Entrance"
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoPen1(TokyoPenWarning.startX, TokyoPenWarning.startY)
			guicontrol,, CurrentLoop, Current Location: %location%
			Accel_On(32)
			controller.Axes.LX.SetState(40)
			Sleep(1000)
			; Hairpin Turn
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			location := "Hairpin Turn"
			CheckTokyoHairpinTurn(TokyoHairpinTurn.startX, TokyoHairpinTurn.startY)
			guicontrol,, CurrentLoop, Current Location: %location%
			Sleep(hairpin_delay)
			controller.Axes.LX.SetState(100)
			Sleep(200)
			Accel_Off()
			Sleep(4200)
			Accel_On(45) ;was 40
			controller.Axes.LX.SetState(60)
			Accel_Off()
			Sleep(800)
			controller.Axes.LX.SetState(40)
			Accel_On(50)
			Sleep(5000)
			controller.Axes.LX.SetState(30)
			Sleep(5500)
			Accel_On(80)
			loop 30 { ; failsafe, if we ever get a reset caused by a cone under the car
			Press_Triangle(delay:=100)
			Sleep(200)
			}
			; Penalty Warning 2
			location := "Hairpin exit"
			CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
			CheckTokyoPen2(TokyoPen.endX, TokyoPen.endY)
			guicontrol,, CurrentLoop, Current Location: %location%
			Sleep(1000)
		if (TokyoLapCount <= 11)
		{
				
				location := "Pit entrance"
				Accel_On(53)
				controller.Axes.LX.SetState(30)
				guicontrol,, CurrentLoop, Current Location: %location%
				CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
				CheckTokyoTurn(TokyoPitstopEnter.startX, TokyoPitstopEnter.startY)
				controller.Axes.LX.SetState(0)
				Accel_On(55)
				CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
				CheckTokyoPitstop1(TokyoPitstop.startX, TokyoPitstop.startY)
				location := "In pit"
				guicontrol,, CurrentLoop, Current Location: %location%
				controller.Axes.LX.SetState(50)
				
				if (TokyoLapCount = 1) 
				{
					SetFormat, integerfast, d
					lap01timing := 0
					location := "In pit: Waiting " lap01timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap01timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
				if (TokyoLapCount = 2) 
				{
					SetFormat, integerfast, d
					lap02timing := 0
					location := "In pit: Waiting " lap02timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap02timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
				if (TokyoLapCount = 3)
				{
					SetFormat, integerfast, d
					lap03timing := 0
					location := "In pit: Waiting " lap03timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap03timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
				if (TokyoLapCount = 4)
				{
					SetFormat, integerfast, d
					lap04timing := 0
					location := "In pit: Waiting " lap04timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap04timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
				if (TokyoLapCount = 5)
				{
					SetFormat, integerfast, d
					lap05timing := 20000
					location := "In pit: Waiting " lap05timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap05timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
				if (TokyoLapCount = 6)
				{
					SetFormat, integerfast, d
					lap06timing := 0
					location := "In pit: Waiting " lap06timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap06timing)
					Press_Up()
					Sleep (100)
					Press_X()
				}
				if (TokyoLapCount = 7)
				{
					SetFormat, integerfast, d
					lap07timing := 0
					location := "In pit: Waiting " lap07timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap07timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
					if (TokyoLapCount = 8) 
					{
					SetFormat, integerfast, d
					lap08timing := 0
					location := "In pit: Waiting " lap08timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap08timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
				if (TokyoLapCount = 9) 
				{
					SetFormat, integerfast, d
					lap09timing := 12000
					location := "In pit: Waiting " lap09timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap09timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
				if (TokyoLapCount = 10) 
				{
					SetFormat, integerfast, d
					lap10timing := 20000
					location := "In pit: Waiting " lap10timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap10timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
				if (TokyoLapCount = 11) 
				{
					SetFormat, integerfast, d
					lap11timing := 0
					location := "In pit: Waiting " lap11timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap11timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
				if (TokyoLapCount = 12) 
				{
					SetFormat, integerfast, d
					lap12timing := 0
					location := "In pit: Waiting " lap12timing " Seconds."
					guicontrol,, CurrentLoop, %location%
					Sleep (lap12timing)
					Press_Up()
					Sleep (100)
					Press_X()
					Sleep (100)
					Press_X()
				}
				controller.Axes.LX.SetState(20)
				Accel_On(100)
				CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)	
				CheckTokyoPenReceived(TokyoPenServed.startX, TokyoPenServed.startY)
				location := "Start/Finish"
				guicontrol,, CurrentLoop, Current Location: %location%
				controller.Axes.LX.SetState(38)
				Sleep (500)
				loop 10 {
					Press_Triangle(delay:=200)
					sleep, 200
				}
		}
		else {
				location := "Start/Finish"
				guicontrol,, CurrentLoop, Current Location: %location%
				Accel_On(100)
				controller.Axes.LX.SetState(60)
				CheckMaxTime(maxTime, loopStartTime, TokyoLapCount)
				CheckTokyoPenServed(TokyoPenServed.startX, TokyoPenServed.startY)
				}
				SetFormat, integerfast, d
				TokyoLapCount++
				guicontrol,, CurrentLap, Current Lap: %TokyoLapCount% /12	
				ProgressRace := (100/13)*TokyoLapCount
				guicontrol,, RaceProgress, %ProgressRace%
				
				if(TokyoLapCount = "13") 
				{
					location := "Finish line"
					
					FormatTime, TGTime,, MM/dd hh:mm:ss
					FileAppend, %TGTime% Race finished.`n, logs.txt
					url := "https://api.telegram.org/bot" TelegramBotToken "/sendMessage?text=" TGTime ": Race finished.&chat_id=" TelegramChatID
					hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
					hObject.Open("GET",url)
					hObject.Send()
					
					guicontrol,, CurrentLoop, Current Location: %location%
					guicontrol,, CurrentLap, GG!
					controller.Axes.LX.SetState(50)
					SetFormat, integerfast, d
					racecounter++
					SetFormat, integerfast, d
					racecountertotal++
					
					; // THIS SESSION
					SetFormat, integerfast, d
					SetFormat, FloatFast, 0.2
					creditcountersession := (835000*racecounter)/1000000
					SetFormat, integerfast, d
					SetFormat, FloatFast, 0.2
					creditavg := creditcountersession/(A_TickCount-script_start)*3600000
					guicontrol,, RaceCounterSession, Races completed: %racecounter%
					guicontrol,, ResetCounterSession, Races failed: %resetcounter%
					guicontrol,, CreditCounterSession, Credits: %creditcountersession% M
					guicontrol,, CreditAVGSession, Avg./h: %creditavg% M
					
					; // ALL TIME
					SetFormat, integerfast, d
					SetFormat, FloatFast, 0.2
					creditcountertotal := (835000*racecountertotal)/1000000
					IniWrite, %racecountertotal%, config.ini,Stats, RaceCounterTotal
					IniWrite, %resetcountertotal%, config.ini,Stats, ResetCounterTotal
					guicontrol,, RaceCounterTotal, Races completed: %racecountertotal%
					guicontrol,, ResetCounterTotal, Races failed: %resetcountertotal%	
					guicontrol,, CreditCounterTotal, Credits: %creditcountertotal% M
					UpdateAVG(racecounter, script_start)
					lapcounter =
					ProgressRace =
					guicontrol,, RaceProgress, %ProgressRace%
					loop
					{
						restart_found := false
						c2 := BitGrab(162, 43+remote_play_offsetY, 2)
						for i, c in c2
							{
							d2 := Distance(c, color_restart)
							SB_SetText(" Searching... " d2 " < 50",2)
							if (d2 < 10 )
							{
								SB_SetText(" Found: Restart Color",2)
								restart_found := true
								break
							}
						}
							if (restart_found)
							break
						Press_X()
						Sleep(500)
						
					}
					SB_SetText("Found: Restart Color",2)
					Sleep(260)
					Press_O()
					Sleep(200) 
					Press_Right()
					Sleep(3000)
					Press_X()
					Sleep(4000)
					Press_X()
					Sleep(4000)
					guicontrol,, CurrentLoop, Setting up next race.
					Press_Options()
					Sleep(1000)
					Press_Right()
					Sleep(500)
					Press_X()
					controller.Axes.LX.SetState(50)
					UpdateAVG(racecounter, script_start)
					Goto, TokyoStart
				}
	}
}
EndRace_Tokyo_Def: