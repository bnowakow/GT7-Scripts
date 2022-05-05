GoTo EndRace_PANAM_Def

Race_PANAM()
{
	turn1 := new TurnContainer(619, 112+remote_play_offsetY, 630, 95+remote_play_offsetY)
	turn2 := new TurnContainer(544, 45+remote_play_offsetY, 511, 52+remote_play_offsetY)
	turn3 := new TurnContainer(492, 85+remote_play_offsetY, 506, 111+remote_play_offsetY)
	lap_marker := new TurnContainer(560, 112+remote_play_offsetY)

	Switch SysCheck {
	Case 1:
		race_start_delay := 19200
	Case 2:
		race_start_delay := 18200
	Case 3:
		race_start_delay := 18200
	}

	CheckForOilChange := Mod(abs(90 - A_Index), 90)
	SetFormat, IntegerFast, d
	CheckForMaintenance := Mod(abs(270 - A_Index), 270)
	SetFormat, IntegerFast, d

	if (__enableMaintenance_mod__ != 0){
		ToolTipper("Oil: " CheckForOilChange " race(s) remaining`nEngine: " CheckForMaintenance " race(s) remaining", 250, 45)
	}

	t_ExpectedRaceTime := 195000
	t_RaceStartTime := A_TickCount
	t_RaceFinishTime := t_RaceStartTime + t_ExpectedRaceTime
	;ToolTipper("t_ExpectedRaceTime = " t_ExpectedRaceTime "`nt_RaceStartTime = " t_RaceStartTime "`nt_RaceFinishTime = " t_RaceFinishTime)

	race_complete := false

	; Press X to start the race
	;Tooltip
	Press_X()

	; Hold Acceleration and manage turning
	Nitrous_On()
	Accel_On(100)
	;SetTimer, CheckTyresOverheating, 1000

	; Retry race if time is taking more than 5.5 mins
	; (assume something went wrong with race)
	SetTimer, RetryRace, 330000
	
	;Sleep(race_start_delay)
	;controller.Axes.LX.SetState(62)		/* before turn 1, to avoid queue of cars */
	Sleep (race_start_delay-2800)
	controller.Axes.LX.SetState(65)		;straighten car
	Sleep(400)							
	controller.Axes.LX.SetState(50)		;straighten wheel
	sleep(4200)							;pause before turning right after Focus
	controller.Axes.LX.SetState(65)		;turn right after Focus
	sleep(1000)							;pause before straightening out for turn
	controller.Axes.LX.SetState(45)		;prep for turn
	

	Loop {
		t1start := CheckTurnQuick(turn1.startX, turn1.startY, 0xDE6E70)
		t2start := CheckTurnQuick(turn2.startX, turn2.startY, 0xDE6E70)
		t3start := CheckTurnQuick(turn3.startX, turn3.startY, 0xDE6E70)
		lap_start_end := CheckTurnQuick(lap_marker.startX, lap_marker.startY, 0xDE6E70)
		race_running1 := CheckTurnQuick(320, 110, 0x000000)
		race_running2 := CheckTurnQuick(45, 453, 0x000000)
		race_running3 := CheckTurnQuick(635, 455, 0x000000)
		; Tooltip, T1s = %t1start%`nT2s = %t2start%`nT3s = %t3start%`nLap Start-End = %lap_start_end%`nRace running1 = %race_running1%`nRace running2 = %race_running2%`nRace running3 = %race_running3%, 100, 100, screen

		if t1start
		{
			Tooltip, Turn 1 start, 100, 100, screen
			controller.Axes.LX.SetState(18-3*%A_Index%)
			Accel_On(85)
			Nitrous_Off()
			sleep(2600)
			Accel_On(100)
			Nitrous_On()
			controller.Axes.LX.SetState(65)
			sleep(2000)
			controller.Axes.LX.SetState(62)
			Accel_On(100)
			Nitrous_On()
			sleep(6000)
			Tooltip, complete T1 instructions, 100, 100, screen
		}
		
		if t2start
		{
			Tooltip, Turn 2 start, 100, 100, screen
			controller.Axes.LX.SetState(19) ;Default 19
			sleep(1500)
			controller.Axes.LX.SetState(26)
			sleep(1700)
			controller.Axes.LX.SetState(58)
			;sleep(750)
			;controller.Axes.LX.SetState(58)
			Accel_On(100)
			Nitrous_On()
			sleep(2000)
			Tooltip, complete T2 instructions, 100, 100, screen
		}
		
		if t3start
		{
			Tooltip, Turn 3 start, 100, 100, screen
			Nitrous_Off()
			controller.Axes.LX.SetState(10)
			sleep(1200)
			Nitrous_On()
			sleep(1800)
			controller.Axes.LX.SetState(50)
			sleep(750)
			controller.Axes.LX.SetState(55)
			sleep(750)
			controller.Axes.LX.SetState(62)
			Accel_On(100)
			Nitrous_On()
			sleep(3500)
			Tooltip, complete T3 instructions, 100, 100, screen
		}
		
		If lap_start_end {
			ToolTipper("Lap Complete")
			Tooltip, Lap start-end, 100, 100, screen
			controller.Axes.LX.SetState(63)
			Accel_On(100)
			Nitrous_On()
			sleep(3500)
		}
		
		If (race_running1 = 0 and race_running2 = 0 and race_running3 = 0)
		{
			Tooltip, Exiting loop, 100, 100, screen
			goto RaceComplete
		}
	}

RaceComplete:
	ToolTip, Out of loop 2, 100, 100, Screen
	gosub, PauseLoop
	Press_X()
	loop 
	{
		break_point := false
		c1 := BitGrab(pix1x, pix1y+remote_play_offsetY, box_size)
		for i, c in c1
		{
			d1 := Distance(c, color_check1)
			;ToolTipper( d1 " " pix1y+remote_play_offsetY " " pix1x " " c)
			if (d1 < tolerance )
			{
				break_point := true
				break
			}
		}
		if (break_point)
			break
		controller.Dpad.SetState("Right")
		Sleep, 50
		controller.Dpad.SetState("None")
		Sleep, 100
	}
	ToolTipper("Race End")
	Sleep, 500
	return
}


;Race_PANAM_Complete() {
;	race_complete := true
;	return
;}


EndRace_PANAM_Def:
