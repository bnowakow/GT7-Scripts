GoTo EndRace_PANAM_Def

Race_PANAM()
{

	turn1 := new TurnContainer(619, 112+remote_play_offsetY, 630, 95+remote_play_offsetY)
	turn2 := new TurnContainer(544, 45+remote_play_offsetY, 511, 52+remote_play_offsetY)
	turn3 := new TurnContainer(492, 84+remote_play_offsetY, 506, 111+remote_play_offsetY)
	lap_marker := new TurnContainer(560, 112+remote_play_offsetY)

	;	race_start_delay := 17400		; this is for PS5. It may vary for PS4.
	Switch SysCheck {
	Case 1:
		race_start_delay := 19200
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

	Sleep (race_start_delay)
	controller.Axes.LX.SetState(62)		/* before turn 1, to avoid queue of cars */

	Loop {
		; Turn 1
		; Tooltip
		
		turn_one_end_found := false
		if (CheckTurn(turn1.startX, turn1.startY, 3100))
		{
			turn_one_end_found := true
			ToolTipper("Turn 1 start found")
		
			/*
			if( A_Index != 1){
				Nitrous_Off()
				Accel_On(75)

			}
			*/
			controller.Axes.LX.SetState(18-3*%A_Index%)
		}
		;Sleep(500)
		Accel_On(100)
	
		
		turn_one_end_found := false
		turn_one_end_found := true ; debug TODO check if wheels are curved
		if (CheckTurn(turn1.endX, turn1.endY, 2300))
		{
			turn_one_end_found := true
			ToolTipper("Turn 1 end found")

			Nitrous_On()
			controller.Axes.LX.SetState(75)
		}
			sleep(2000)
		if (turn_one_end_found)
		{
			controller.Axes.LX.SetState(65)
		}
			sleep(2500)
		if (turn_one_end_found)
		{
			controller.Axes.LX.SetState(62)
		}
			sleep(2000)
		
		turn_two_start_found := false
		; Turn 2
		if( A_Index = 1 || A_Index = 6){
			if (CheckTurn(turn2.startX, turn2.startY, 3900))
			{
				turn_two_start_found := true
			}
		}
		else{
			if (CheckTurn(545, turn2.startY)) {
				turn_two_start_found := true
			}
		}
		if (turn_two_start_found)
		{
			ToolTipper("Turn 2 start found")
			controller.Axes.LX.SetState(18.3)
		}

		turn_two_end_found := false
		turn_two_end_found := true ; debug TODO check if wheels are curved
		if (CheckTurn(turn2.endX, turn2.endY, 2500))
		{
			turn_two_end_found := true
			ToolTipper("Turn 2 end found")
			controller.Axes.LX.SetState(50)
		}
		
		if( A_Index = 1 || A_Index = 6){
			if (turn_two_end_found)
			{
				controller.Axes.LX.SetState(75)
			}
			sleep(2000)

			if (turn_two_end_found)
			{
				controller.Axes.LX.SetState(65)
			}
			sleep(500)
		}
		else{
			if (turn_two_end_found)
			{
				Turn_Left(500, 28)
			}
		}
		

		; Turn 3
		if (CheckTurn(turn3.startX, turn3.startY))
		{
			Nitrous_Off()
			ToolTipper("Turn 3 start found")
			controller.Axes.LX.SetState(12)
		}
		
		turn_three_end_found := false
		turn_three_end_found := true ; debug TODO check if wheels are curved
		if (CheckTurn(turn3.endX, turn3.endY))
		{
			turn_three_end_found := true
			Nitrous_On()
			ToolTipper("Turn 3 end found")
			controller.Axes.LX.SetState(42)
		}

			sleep(500)
		if (turn_three_end_found)
		{
			controller.Axes.LX.SetState(58)
		}
		sleep(2000)

		if (turn_three_end_found)
		{
			controller.Axes.LX.SetState(62)
		}
		sleep(2000)
		
		CheckTurn(lap_marker.startX, lap_marker.startY)
		ToolTipper("Lap Complete")

		sleep(4000)
	} until A_TickCount > t_racefinishtime
	controller.Axes.LX.SetState(50)
	; ToolTip, Out of Loop, 100, 100, screen

	loop {
		;ToolTip, Racing, 100, 100, Screen
		break_point := false
		c1 := BitGrab(pix1x, pix1y+remote_play_offsetY, box_size)
		for i, c in c1
		{
			d1 := Distance(c, color_check1)
			;ToolTipper( d1 " " pix1y+remote_play_offsetY " " pix1x " " c)
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
