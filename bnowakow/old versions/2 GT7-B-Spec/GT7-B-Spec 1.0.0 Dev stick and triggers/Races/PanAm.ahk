GoTo EndRace_PANAM_Def

Race_PANAM()
{
	; Turn Containers are in the CheckTurn.ahk

	; Testing new set
	turn1 := new TurnContainer(619, 112, 630, 95)
	turn2 := new TurnContainer(544, 46, 511, 52)
	turn3 := new TurnContainer(492, 84, 502, 112)
	lap_marker := new TurnContainer(560, 112)

	Switch SysCheck {
	Case 1:
		race_start_delay := 17400
	Case 2:
		race_start_delay := 18200
	Case 3:
		race_start_delay := 18200
	}

	CheckForOilChange := Mod(30 - A_Index, 30)
	SetFormat, IntegerFast, d
	CheckForMaintenance := Mod(180 - A_Index, 180)
	SetFormat, IntegerFast, d
	if (__enableMaintenance_mod__ != 0){
		ToolTipper("Oil: " CheckForOilChange " race(s) remaining`nEngine: " CheckForMaintenance " race(s) remaining", 250, 45)
	}

	t_ExpectedRaceTime := 205000
	t_RaceStartTime := A_TickCount
	t_RaceFinishTime := t_RaceStartTime + t_ExpectedRaceTime
	; ToolTip, t_ExpectedRaceTime = %t_ExpectedRaceTime%`nt_RaceStartTime = %t_RaceStartTime%`nt_RaceFinishTime = %t_RaceFinishTime%, 100, 100, screen

	race_complete := false

	; Press X to start the race
	; Tooltip
	Press_X()

	; Hold Acceleration and manage turning
	Nitrous_On()
	Accel_On(100)
	;SetTimer, CheckTyresOverheating, 1000

	; Retry race if time is taking more than 5.5 mins
	; (assume something went wrong with race)
	;SetTimer, RetryRace, 330000

	Sleep (race_start_delay)
	controller.Axes.LX.SetState(68)		/* before turn 1, to avoid queue of cars */

	Loop {
		; Turn 1
		; Tooltip
		CheckTurn(turn1.startX, turn1.startY)
		Tooltip, Turn 1 start found, 100, 100, screen
		controller.Axes.LX.SetState(10)
		CheckTurn(turn1.endX, turn1.endY)
		Tooltip, Turn 1 end found, 100, 100, screen
		Nitrous_On()
		controller.Axes.LX.SetState(75)
		sleep(1500)
		controller.Axes.LX.SetState(65)
		sleep(3000)
		controller.Axes.LX.SetState(62)
		sleep(2000)

		; Turn 2
		CheckTurn(turn2.startX, turn2.startY)
		Tooltip, Turn 2 start found, 100, 100, screen
		controller.Axes.LX.SetState(20)
		CheckTurn(turn2.endX, turn2.endY)
		Tooltip, Turn 2 end found, 100, 100, screen
		controller.Axes.LX.SetState(75)
		sleep(2000)
		controller.Axes.LX.SetState(62)
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
		sleep(3000)
		controller.Axes.LX.SetState(65)
		sleep(2000)
		controller.Axes.LX.SetState(62)
		CheckTurn(lap_marker.startX, lap_marker.startY)
		Tooltip, Lap Complete, 100, 100, screen
		sleep(4000)
	} until A_TickCount > t_racefinishtime

	ToolTip, Out of Loop, 100, 100, screen
	Sleep (500)
	Press_X()
	ToolTipper("Race End")
	gosub, PauseLoop
	Sleep (500)
	return
}

Race_PANAM_Complete() {
	race_complete := true
	return
}

EndRace_PANAM_Def: