;----------------------------------------------------------------------
; // START TOKYO RACE SCRIPT
;----------------------------------------------------------------------

GoTo EndRace_Tokyo_Def
Race_Tokyo()
{
	; VARIABLES
	lapcounter := 0
	lap_marker := new TurnContainer(550, 70)
	;----------------------------------------------------------------------
	;---------------------------- // LAP 01 -------------------------------
	;----------------------------------------------------------------------

	;----------------------------------------------------------------------
	; /1/ CHANGE FUEL MAP TO (LEAN 5) BEFORE RACE STARTS
	;----------------------------------------------------------------------

	Sleep(1000)
	ToolTip, /1/ Changing to Lean (5) //, 22, 70, Screen
	loop 4 {
		Press_Up(delay:=200)
		sleep, 200
	}
	Sleep(6000)

	;----------------------------------------------------------------------
	; /2/ ACTIVATE ACCELERATION (100%) AND SHIFT TO 7TH GEAR
	;----------------------------------------------------------------------

	ToolTip, /2/ Acceleration ON & Shifting to 7th gear //, 22, 70, Screen
	Accel_On(100)
	;Nitrous_On()
	loop 3 {
		Press_X(delay:=200)
		sleep, 200
	}

	;----------------------------------------------------------------------
	; /3/ TRIGGER FORCED 5 SECOND PENALTY
	;----------------------------------------------------------------------

	ToolTip, /3/ Triggering 5 sec. penalty //, 22, 70, Screen
	Sleep(1000)
	Turn_Left(1000,10)

	;----------------------------------------------------------------------
	; /4/ CHECK IF WE GOT THE 5 SEC PENALTY
	;----------------------------------------------------------------------

	/*
	loop {
      gosub, CheckPenalty

      if( Penalty_triggered = true)
        break
      Sleep(100)
    }
					ToolTip, /4/ PENALTY RECEIVED //, 22, 70, Screen
	Sleep(5000)
	*/

	;----------------------------------------------------------------------
	; /5/ WAIT, THEN STEERING TO THE LEFT SIDE TO:
	; /5/ OVERTAKE CARS LEFT, GRIND WALL, TAKE T1 FROM LEFT
	;----------------------------------------------------------------------

	ToolTip, 5.1 // Hugging left wall from straight to chicane //, 22, 70, Screen
	Turn_Left(38000,36)

	ToolTip, 5.2 // Hugging right wall from chicane to hairpin //, 22, 70, Screen
	Turn_Right(40000,72)

	;----------------------------------------------------------------------
	;---------------------------- // LAP 02-12 ----------------------------
	;----------------------------------------------------------------------

	;----------------------------------------------------------------------
	; /6/ START THE BIG LOOP
	;----------------------------------------------------------------------

	loop
	{

		;----------------------------------------------------------------------
		; /7/ TRIGGER FORCED 5 SECOND PENALTY
		;----------------------------------------------------------------------

		if (lapcounter > 0)
		{
			Sleep(10000)
			ToolTip, /7.1/ Triggering 5 sec. penalty after tunnel //, 22, 70, Screen
			Turn_Left(1000,10)
			Sleep(8000)
			ToolTip, /7.2/ HALF Acceleration for 3 sec //, 22, 70, Screen
			Accel_On(60)
			Sleep(3000)
			ToolTip, /7/ FULL Acceleration //, 22, 70, Screen
			Accel_On(100)
			Turn_Left(2000,10)
			ToolTip, /7/ Boom //, 22, 70, Screen
			;Nitrous_ON()
			Turn_Left(4000,10)
		}

		;----------------------------------------------------------------------
		; /8/ Hug right wall through chicance
		;----------------------------------------------------------------------
		if (lapcounter > 0)
		{
			ToolTip, /8/ Hugging right wall from chicane to hairpin //, 22, 70, Screen
			Turn_Right(40000,75)
		}

	/*
	;----------------------------------------------------------------------
	; /9/ START THE CHICANE SEARCH LOOP
	;----------------------------------------------------------------------
					ToolTip, /9/ Turn right through chicane //, 22, 70, Screen
	Turn_Right(15000,75)
    ToolTip, /9/ Looking for Chicane //, 22, 70, Screen
    loop {
      gosub, CheckChicane

      if( Chicane_complete = true)
        break
      Sleep(100)
    }

	;----------------------------------------------------------------------
	; /10/ IF CHICANE FOUND:
	; /10/ WAIT, THEN:
	; /10/ ACCELERATION & NITRO OFF, TURN RIGHT, ACCELERATION & NITRO ON, WAIT
	;----------------------------------------------------------------------

	Sleep(1550)
					ToolTip, /10/ Acceleration & Nitro OFF //, 22, 70, Screen
    Nitrous_Off()
    Accel_Off()
					ToolTip, /10/ Turning left //, 22, 70, Screen
	Turn_Left(1500,15)
					ToolTip, /10/ Acceleration & Nitro ON //, 22, 70, Screen
	Accel_On(100)
    Nitrous_On()
    gosub, ResetChicane

		*/

		;----------------------------------------------------------------------
		; /11/ START THE HAIRPIN SEARCH LOOP
		;----------------------------------------------------------------------

		ToolTip, /11/ Looking for hairpin, 22, 70, Screen

		color_player := 0xDE6E70
		hairpin_complete := false
		hairpinX := 506
		hairpinY := 72
		hairpinCount := 0
		hairpinTolerance := 10

		loop
		{

			tc := BitGrab(hairpinX, hairpinY,2)

			for i, c in tc
			{
				td := Distance(c, color_player)
				if (td < 9 ){
					hairpin_complete := true
					hairpinCount += 1
					ToolTip, /11/ Hairpin Found, 22, 70, Screen
					break
				}
			}
			;Turn_Left(300, 30)
			if( hairpinCount = 1 )
				break
			Sleep(100)
		}

		;----------------------------------------------------------------------
		; /12/ IF HAIRPIN (1) FOUND:
		; /12/ WAIT, THEN:
		; /12/ HUG THE LEFT WALL TO GET 90° BUMPS
		;----------------------------------------------------------------------

		;ToolTip, /12/ Turning left for corner bumps //, 22, 70, Screen
		;Turn_Left(20000, 25)

		if (lapcounter = 0)
		{

			ToolTip, /12/ Hairpin - turn right 5000 70 //, 22, 70, Screen
			Turn_Right(5000,70)
			ToolTip, /12/ Hairpin - turn right 12000 60 //, 22, 70, Screen
			Turn_Right(12000,65)
		}

		if (lapcounter > 0)
		{

			ToolTip, /12/ Hairpin - turn right 5000 70 //, 22, 70, Screen
			Turn_Right(5000,70)
			ToolTip, /12/ Hairpin - turn right 12000 60 //, 22, 70, Screen
			Turn_Right(12000,65)
		}

		Sleep(5000)

		hairpinCount := 0
		;----------------------------------------------------------------------
		; /13/ HUG THE RIGHT WALL TO AVOID THE PIT ENTRANCE
		;----------------------------------------------------------------------

		Sleep(5000)
		ToolTip, /13/ Sayonara pit o/, 22, 70, Screen
		;Turn_Right(20000, 65)
		;Turn_Left(10000, 40)

		;----------------------------------------------------------------------
		; /55/ CLOSE LOOP LAP 1-12
		;----------------------------------------------------------------------

		Turn_Right(5000, 65)
		CheckTurn(lap_marker.startX, lap_marker.startY)
		lapcounter++
		ToolTip, /55/ LAP %lapcounter%, 22, 70, Screen
	}

	;----------------------------------------------------------------------
	; /99/ CLOSE RACE SCRIPT
	;----------------------------------------------------------------------

}
EndRace_Tokyo_Def:
