GoTo EndRace_PANAM_Def

Race_PANAM()
{
	; Turn Containers are in the CheckTurn.ahk
	turn1 := new TurnContainer(629, 109, 630, 95)
	turn2 := new TurnContainer(539, 44, 511, 52)
	turn3 := new TurnContainer(490, 89, 502, 111)
	lap_marker := new TurnContainer(560, 112)
	race_start_delay := 17400		; this is for PS5. It may vary for PS4.
	if (SysCheck = 1) {
		race_start_delay := 17400
	}

	if (SysCheck = 2) {
		race_start_delay := 18400
		ToolTipper("Found PS4", 250, 45)
	}

	if (SysCheck = 3) {
		race_start_delay := 18400
	}

	CheckForOilChange := Mod(30 - A_Index, 30)
	SetFormat, IntegerFast, d
	CheckForMaintenance := Mod(180 - A_Index, 180)
	SetFormat, IntegerFast, d

	if (__enableCheckTyres_mod__ != 0){
		ToolTipper("Oil: " CheckForOilChange " race(s) remaining`nEngine: " CheckForMaintenance " race(s) remaining", 250, 45)
	}

	t_ExpectedRaceTime := 210000
	t_RaceStartTime := A_TickCount
	t_RaceFinishTime := t_RaceStartTime + t_ExpectedRaceTime
	ToolTip, t_ExpectedRaceTime = %t_ExpectedRaceTime%`nt_RaceStartTime = %t_RaceStartTime%`nt_RaceFinishTime = %t_RaceFinishTime%, 100, 100, screen

	race_complete := false

	; Press X to start the race
	;Tooltip
	gosub, PressX

	; Hold Acceleration and manage turning
	Nitrous_On()
	Accel_On(100)
	;SetTimer, CheckTyresOverheating, 1000

	; Retry race if time is taking more than 5.5 mins
	; (assume something went wrong with race)
	;SetTimer, RetryRace, 330000

	Sleep (race_start_delay)
	Turn_Right(4000, 68)		/* before turn 1, to avoid queue of cars */

	Loop {
		; Turn 1
		Tooltip
		CheckTurn(turn1.startX, turn1.startY)
		Tooltip, Turn 1 start found, 100, 100, screen
		controller.Axes.LX.SetState(10)
		CheckTurn(turn1.endX, turn1.endY)
		Tooltip, Turn 1 end found, 100, 100, screen
		Nitrous_On()
		controller.Axes.LX.SetState(75)
		sleep(1500)
		controller.Axes.LX.SetState(65)

		sleep(5000)

		; Turn 2
		CheckTurn(turn2.startX, turn2.startY)
		Tooltip, Turn 2 start found, 100, 100, screen
		controller.Axes.LX.SetState(20)
		CheckTurn(turn2.endX, turn2.endY)
		Tooltip, Turn 2 end found, 100, 100, screen
		controller.Axes.LX.SetState(75)
		sleep(2000)
		controller.Axes.LX.SetState(65)

		sleep(500)

		; Turn 3
		CheckTurn(turn3.startX, turn3.startY)
		Nitrous_Off()
		Tooltip, Turn 3 start found, 100, 100, screen
		controller.Axes.LX.SetState(0)
		CheckTurn(turn3.endX, turn3.endY)
		Nitrous_On()
		Tooltip, Turn 3 end found, 100, 100, screen
		controller.Axes.LX.SetState(75)
		sleep(2000)
		controller.Axes.LX.SetState(65)

		sleep(2000)

		CheckTurn(lap_marker.startX, lap_marker.startY)
		Tooltip, Lap Complete, 100, 100, screen

		sleep(5000)
	} until A_TickCount > t_racefinishtime

	ToolTip, Out of Loop, 100, 100, screen

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

		controller.Dpad.SetState("Right")
		Sleep, 50
		controller.Dpad.SetState("None")

		Sleep, 100
	}
	ToolTipper("Race End")
	gosub, PauseLoop
	Sleep, 500
	return
}

Race_PANAM_Complete() {
	race_complete := true
	return
}

EndRace_PANAM_Def: