;----------------------------------------------------------------------
; // START TOKYO RACE SCRIPT
;----------------------------------------------------------------------

GoTo EndRace_Tokyo_Def
Race_Tokyo()
{
	; VARIABLES
	lapcounter := 0

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



 	;----------------------------------------------------------------------
	;---------------------------- // LAP 02-12 ----------------------------
	;----------------------------------------------------------------------

	;----------------------------------------------------------------------
	; /6/ START THE BIG LOOP
	;----------------------------------------------------------------------
	Turn_Left(12000,36)

	loop
	{

	;----------------------------------------------------------------------
	; /7/ TRIGGER FORCED 5 SECOND PENALTY
	;----------------------------------------------------------------------

	if (lapcounter > 0)
	{
				ToolTip, /7.1/ Triggering 5 sec. penalty after tunnel //, 22, 70, Screen
				ToolTip, /7.2/ HALF Acceleration for 3 sec //, 22, 70, Screen
	}

					ToolTip, 5.1 // Hugging left wall from straight to chicane //, 22, 70, Screen
	Turn_Left(26000,36)

						ToolTip, 5.2 // Hugging right wall from chicane to hairpin //, 22, 70, Screen
	Turn_Right(33000,72)

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


					ToolTip, /12/ Hairpin - turn right 5700 70 //, 100, 100, Screen

	Turn_Right(5700,70)
	Accel_On(75)
					ToolTip, /12/ Hairpin - turn right 12000 60 //, 100, 100, Screen
	Turn_Right(5000,70 + lapcounter)
	Sleep(1000)
	Turn_Right(5000,65)
	Accel_On(100)
					ToolTip, /12/ Sleep //, 100, 100, Screen
	Sleep(3000)
	controller.Axes.LX.SetState(65)



	loop
  	{

    tc := BitGrab(hairpinX, hairpinY,2)

    for i, c in tc
    {
        td := Distance(c, color_player)
        if (td < 20 ){
            hairpin_complete := true
            hairpinCount += 1
            ToolTip, /11/ Hairpin Found, 100, 100, Screen
            break
        }
    }
	  ;Turn_Left(300, 30)
      if( hairpinCount = 2 )
        break
      Sleep(100)
  	}
		ToolTip, LX 65, 22, 70, Screen

		if (lapcounter = 4){
			controller.Axes.LX.SetState(35)
		}
		else {
			controller.Axes.LX.SetState(65)
		}


		Sleep(4650)

	hairpinCount := 0
	;----------------------------------------------------------------------
	; /13/ HUG THE RIGHT WALL TO AVOID THE PIT ENTRANCE
	;----------------------------------------------------------------------

	ToolTip, Left 300 - Right 300, 100, 100, Screen


	;Turn_Right(300,65)

	;----------------------------------------------------------------------
	; /7/ TRIGGER FORCED 5 SECOND PENALTY
	;----------------------------------------------------------------------

	if (lapcounter = 4){
		;----------------------------------------------------------------------
		; /20/ MAKE PIT STOP CHANGE TIRES
		;----------------------------------------------------------------------
		ToolTip, Heading to pit, 100, 100, Screen
		;Turn_Right(800, 60)
		controller.Axes.LX.SetState(0)
		Accel_On()
		Brake_off()
		Sleep, 17000
		Turn_Left(5000, 20)
		ToolTip, Changing tires, 100, 100, Screen
		Press_Up()
		loop, 5{
			Press_Left()
		}
		Press_X()
		Press_Down()
		Press_X()
		controller.Axes.LX.SetState(50)
		Sleep, 12000
		ToolTip, Leaving Pit, 100, 100, Screen
		loop 4 {
	    Press_X(delay:=200)
		sleep, 200
		}
	}
	else {
		Accel_Off()
		Brake_on(100)
		Turn_Left(950, 40)
		Sleep(3000)

		controller.Axes.LX.SetState(70)
		Brake_off()
		Nitrous_On()
		Accel_On(100)
		Sleep(3000)
		Turn_Right(2000, 90)
		Turn_Right(11000, 65)
		Sleep(3000)

		Nitrous_Off()
	}
 	;----------------------------------------------------------------------
	; /55/ CLOSE LOOP LAP 1-12
	;----------------------------------------------------------------------

	lapcounter++
	ToolTip, /55/ LAP %lapcounter%, 100, 100, Screen
	}

;----------------------------------------------------------------------
; /99/ CLOSE RACE SCRIPT
;----------------------------------------------------------------------

}
EndRace_Tokyo_Def:
