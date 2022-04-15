;----------------------------------------------------------------------
; // START TOKYO RACE SCRIPT
;----------------------------------------------------------------------

GoTo EndRace_Tokyo_Def
Race_Tokyo()
{

	; // PIT STOP MANAGER

	; PIT IN LAP (index 0 - Example: Lapping in Lap 5 is VALUE 4)
	pitlap := 5

	; CHANGE TIRES TO:
	; 0 = RACING HARD 
	; 1 = INTERMEDIATES
	tires := 1

	; VARIABLES
	lapcounter := 0
	pitstop := 0
	outlap := 0

	;----------------------------------------------------------------------
	;---------------------------- // LAP 01 -------------------------------
	;----------------------------------------------------------------------

	;----------------------------------------------------------------------
	; 01 // CHANGE FUEL MAP TO (LEAN 5) BEFORE RACE STARTS
	;----------------------------------------------------------------------

	Sleep(1000)
	ToolTip, [LAP: 01][PITSTOPS: 0] 01 // Changing to Lean (5), 25, 250, Screen
	loop 4 {
		Press_Up(delay:=200)
		sleep, 200
	}
	Sleep(6000)

	;----------------------------------------------------------------------
	; 02 // ACTIVATE ACCELERATION (100%) AND SHIFT TO 7TH GEAR
	;----------------------------------------------------------------------

	ToolTip, [LAP: 01][PITSTOPS: 0] 02 // Acceleration ON & Shifting to 7th gear, 25, 250, Screen
	Accel_On(100)
	;Nitrous_On()
	loop 3 {
		Press_X(delay:=200)
		sleep, 200
	}

	;----------------------------------------------------------------------
	; 03 // TRIGGER FORCED 5 SECOND PENALTY
	;----------------------------------------------------------------------

	ToolTip, [LAP: 01][PITSTOPS: 0] 03 // Triggering 5 sec. penalty, 25, 250, Screen
	Sleep(1000)
	Turn_Left(1000,10)

	Turn_Left(13000,36)

	;----------------------------------------------------------------------
	;---------------------------- // LAP 02-12 ----------------------------
	;----------------------------------------------------------------------

	;----------------------------------------------------------------------
	; 04 // START THE BIG LOOP
	;----------------------------------------------------------------------

	loop
	{

		;----------------------------------------------------------------------
		; 05 // TRIGGER FORCED 5 SECOND PENALTY AND HUG WALLS UNTIL HAIRPIN
		;----------------------------------------------------------------------

		; // FIRST LAP
		if (lapcounter = 0){
			ToolTip, [LAP: 01][PITSTOPS: 0] 05.1 // Hugging left wall from straight to turn 1, 25, 250, Screen
			Turn_Left(25000,36)

			ToolTip, [LAP: 01][PITSTOPS: 0] 05.2 // Hugging right wall from chicane to hairpin, 25, 250, Screen
			Turn_Right(20000,72)
		}

		; // LAP 02+ UNTIL WE DID A PITSTOP
		if (lapcounter > 0) and (pitstop = 0){
			ToolTip, [LAP: 02+][PITSTOPS: 0] 05.3 // Hugging left wall from straight to turn 1, 25, 250, Screen
			Turn_Left(28000,36)

			ToolTip, [LAP: 02+][PITSTOPS: 0] 05.4 // Hugging right wall from chicane to hairpin, 25, 250, Screen
			Turn_Right(25000,72)
		}

		; // OUTLAP AFTER PITSTOP
		if (outlap = 1){
			ToolTip, [OUTLAP][LAP: 02+][PITSTOPS: 1] 05.5 // Hugging left wall from straight to turn 1, 25, 250, Screen
			Turn_Left(34000,36)

			ToolTip, [OUTLAP][LAP: 02+][PITSTOPS: 1] 05.6 // Hugging right wall from chicane to hairpin, 25, 250, Screen
			Turn_Right(35000,72)
		} 

		; // LAPS AFTER PITSTOP AND OUTLAP
		if (lapcounter > 0) and (pitstop = 1) and (outlap = 0) {
			ToolTip, [LAP: 02+][PITSTOPS: 1] 05.7 // Hugging left wall from straight to turn 1, 25, 250, Screen
			Turn_Left(30000,36)

			ToolTip, [LAP: 02+][PITSTOPS: 1] 05.8 // Hugging right wall from chicane to hairpin, 25, 250, Screen
			Turn_Right(24000,72)

		}
		outlap := 0
		;----------------------------------------------------------------------
		; 06 // LOOKING FOR HAIRPIN -1-
		;----------------------------------------------------------------------

		ToolTip, // 06 Looking for hairpin -1-, 25, 250, Screen

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
					ToolTip, 06 // Hairpin -1- found, 25, 250, Screen
					break
				}
			}
			;Turn_Left(300, 30)
			if( hairpinCount = 1 )
				break
			Sleep(100)
		}

		;----------------------------------------------------------------------
		; 07 // IF HAIRPIN -1- FOUND:
		; 07 // WAIT, THEN:
		; 07 // HUG LEFT WALL THEN RIGHT UNTIL PEN LINE
		;----------------------------------------------------------------------

		; // LAP 01 TIMINGS
		if (lapcounter = 0) {
			ToolTip, [LAP: 01][PITSTOPS: 0] 07.1 // Hairpin - turn right 5700 70, 25, 250, Screen
			Turn_Right(5700,70)
			ToolTip, [LAP: 01][PITSTOPS: 0] 07.2 // Hairpin - turn right 12000 65, 25, 250, Screen
			Turn_Right(12000,65)
			controller.Axes.LX.SetState(65)

		}

		; // LAP 02 TIMINGS
		if (lapcounter = 1) and (pitstop = 0) {
			ToolTip, [LAP: 02][PITSTOPS: 0] 07.3 // Hairpin - turn right 5700 70, 25, 250, Screen
			Turn_Right(5700,70)
			ToolTip, [LAP: 02][PITSTOPS: 0] 07.4 // Hairpin - turn right 12000 65, 25, 250, Screen
			Turn_Right(12000,65)
			controller.Axes.LX.SetState(65)

		}

		; // LAP 03 TIMINGS
		if (lapcounter = 2) and (pitstop = 0) {
			ToolTip, [LAP: 03][PITSTOPS: 0] 07.5 // Hairpin - turn right 5700 70 - SLEEP 800, 25, 250, Screen
			Turn_Right(5700,70)

			;Sleep(800)
			ToolTip, [LAP: 03][PITSTOPS: 0] 07.6 // Hairpin - turn right 12000 65 , 25, 250, Screen

			Accel_On(55)
			Turn_Right(6000,65)
			Accel_On(100)
			Turn_Right(6000,65)

			;OLD 
			;Turn_Right(12000,65)

			controller.Axes.LX.SetState(65)

		}

		; // LAP 04 TIMINGS
		if (lapcounter = 3) and (pitstop = 0) {
			ToolTip, [LAP: 04][PITSTOPS: 0] 07.7 // Hairpin - turn right 5700 70 - SLEEP 1500, 25, 250, Screen
			Turn_Right(5700,70)
			;Sleep(1500)
			ToolTip, [LAP: 04][PITSTOPS: 0] 07.8 // Hairpin - turn right 12000 65, 25, 250, Screen

			Accel_On(55)
			Turn_Right(6000,65)
			Accel_On(100)
			Turn_Right(6000,65)

			;OLD 
			;Turn_Right(12000,65)

			controller.Axes.LX.SetState(65)

		}

		; // LAP 05 TIMINGS
		if (lapcounter = 4) and (pitstop = 0) {
			ToolTip, [LAP: 05][PITSTOPS: 0] 07.9 // Hairpin - turn right 5700 70 - SLEEP 2000, 25, 250, Screen
			Turn_Right(5700,70)
			;Sleep(2000)
			ToolTip, [LAP: 05][PITSTOPS: 0] 07.10 // Hairpin - turn right 12000 65, 25, 250, Screen

			Accel_On(55)
			Turn_Right(6000,65)
			Accel_On(100)
			Turn_Right(6000,65)

			;OLD 
			;Turn_Right(12000,65)
			controller.Axes.LX.SetState(65)

		}

		; // LAP 06 TIMINGS
		if (lapcounter = 5)

		{
			ToolTip, [LAP: 06][PITSTOPS: 0] 07.11 // Hairpin - turn right 5700 70 - SLEEP 2400, 25, 250, Screen
			Accel_On(55)
			Turn_Right(5700,70)
			;Sleep(2400)
			ToolTip, [LAP: 06][PITSTOPS: 0] 07.12 // Hairpin - turn right 12000 65, 25, 250, Screen

			Turn_Right(6000,65)
			Accel_On(100)
			Turn_Right(6000,65)

			;OLD 
			;Turn_Right(12000,65)
			controller.Axes.LX.SetState(65)

		}	

		; // LAP 07 TIMINGS
		if (lapcounter = 6) {
			ToolTip, [LAP: 07][PITSTOPS: 1] 07.13 // Hairpin - turn right 5700 70, 25, 250, Screen
			Accel_On(55)
			Turn_Right(5700,70)
			ToolTip, [LAP: 07][PITSTOPS: 1] 07.14 // Hairpin - turn right 12000 65, 25, 250, Screen
			Turn_Right(6000,65)
			Accel_On(100)
			Turn_Right(6000,65)
			controller.Axes.LX.SetState(65)

		}

		; // LAP 08 TIMINGS
		if (lapcounter = 7) {
			ToolTip, [LAP: 08][PITSTOPS: 1] 07.15 // Hairpin - turn right 5700 70, 25, 250, Screen
			Accel_On(55)
			Turn_Right(5700,70)
			ToolTip, [LAP: 08][PITSTOPS: 1] 07.16 // Hairpin - turn right 12000 65, 25, 250, Screen
			Turn_Right(6000,65)
			Accel_On(100)
			Turn_Right(6000,65)
			controller.Axes.LX.SetState(65)

		}
		; // LAP 09 TIMINGS
		if (lapcounter = 8) {
			ToolTip, [LAP: 09][PITSTOPS: 1] 07.17 // Hairpin - turn right 5700 70 - SLEEP 800, 25, 250, Screen
			Turn_Right(5700,70)
			ToolTip, [LAP: 09][PITSTOPS: 1] 07.18 // Hairpin - turn right 12000 65, 25, 250, Screen
			;Sleep(800)

			Accel_On(55)
			Turn_Right(6000,65)
			Accel_On(100)
			Turn_Right(6000,65)

			;OLD 
			;Turn_Right(12000,65)
			controller.Axes.LX.SetState(65)

		}

		; // LAP 10 TIMINGS
		if (lapcounter = 9) {
			ToolTip, [LAP: 10][PITSTOPS: 1] 07.19 // Hairpin - turn right 5700 70 - SLEEP 1500, 25, 250, Screen
			Turn_Right(5700,70)
			;Sleep(1500)
			ToolTip, [LAP: 10][PITSTOPS: 1] 07.20 // Hairpin - turn right 12000 65, 25, 250, Screen
			Turn_Right(12000,65)
			controller.Axes.LX.SetState(65)

		}

		; // LAP 11 TIMINGS
		if (lapcounter = 10) {
			ToolTip, [LAP: 11][PITSTOPS: 1] 07.21 // Hairpin - turn right 5700 70 - SLEEP 2000, 25, 250, Screen
			Turn_Right(5700,70)
			;Sleep(2000)
			ToolTip, [LAP: 11][PITSTOPS: 1] 07.22 // Hairpin - turn right 12000 65, 25, 250, Screen

			Accel_On(55)
			Turn_Right(6000,65)
			Accel_On(100)
			Turn_Right(6000,65)

			;OLD 
			;Turn_Right(12000,65)
			controller.Axes.LX.SetState(65)

		}

		; // LAP 12 TIMINGS
		if (lapcounter = 11) {
			ToolTip, [LAP: 12][PITSTOPS: 1] 07.23 // Hairpin - turn right 5700 70 - SLEEP 2400, 25, 250, Screen
			Accel_On(55)
			Turn_Right(5700,70)
			;Sleep(2400)
			ToolTip, [LAP: 12][PITSTOPS: 1] 07.24 // Hairpin - turn right 12000 65, 25, 250, Screen

			Turn_Right(6000,65)
			Accel_On(100)
			Turn_Right(6000,65)

			;OLD 
			;Turn_Right(12000,65)

			; // DRIVE IT HOME BABY
			Turn_Right(30000,65)
		}

		;----------------------------------------------------------------------
		; 08 // LOOKING FOR HAIRPIN -2-
		;----------------------------------------------------------------------

		ToolTip, 08.1 // Looking for hairpin -2-, 25, 250, Screen
			loop
		{

			tc := BitGrab(hairpinX, hairpinY,2)

			for i, c in tc
			{
				td := Distance(c, color_player)
				if (td < 20 ){
					hairpin_complete := true
					hairpinCount += 1
					ToolTip, 08.2 // Hairpin Found, 25, 250, Screen
					break
				}
			}

			;Turn_Left(300, 30)
			if( hairpinCount = 2 )
				break
			Sleep(100)
		}

		controller.Axes.LX.SetState(65)

		hairpinCount := 0

		;----------------------------------------------------------------------
		; 09 // IF HAIRPIN -2- FOUND:
		; 09 // START CHECK FOR LAPCOUNTER FOR PIT, IF TRUE START PIT ROUTINE
		; 09 // ELSE SETUP FORCED PEN TRIGGER
		;----------------------------------------------------------------------

		Turn_Left(1000, 40)
		;Turn_Right(300,65)

		if (pitlap = lapcounter){
			controller.Axes.LX.SetState(35)

			ToolTip, [LAP: 02+][PITSTOPS: 0] 09.1 // Pitstop starting, 25, 250, Screen	
			Turn_Right(1000, 60)
			controller.Axes.LX.SetState(40)
			Sleep (5000)
			controller.Axes.LX.SetState(0)
			Sleep (20000)
			Press_Up()
			Sleep (100)

			if (tires = 0) {
				; // RACING HARD
				ToolTip, 09.2 // CHANGING TO RACING HARD, 25, 250, Screen	
				loop, 5{
					Press_Left()
				}
			}

			if (tires = 1) {
				; // INTERMEDIATES
				ToolTip, 09.3 // CHANGING TO INTERMEDIATES, 25, 250, Screen	
				Press_Right()
			}

			Press_X()

			; REFILL
			;Press_Down()
			;Press_X()
			controller.Axes.LX.SetState(50)

			Sleep, 18000
			ToolTip, [LAP: 02+][PITSTOPS: 0] 09.4 // // LEAVING PIT - TRIGGER PEN & SHIFTING TO 7TH GEAR, 25, 250, Screen
			Turn_Left(3000,0)
			controller.Axes.LX.SetState(20)
			loop 4 {
				Press_X(delay:=200)
				sleep, 200
			}

			pitstop := 1
			outlap := 1

		}
		else {
			controller.Axes.LX.SetState(65)

	/*
	; //NEW PEN TRIGGER LOGIC, NEEDS TESTING/TIMINGS
	Turn_Left(2000,30)
	controller.Axes.LX.SetState(0)
		
					ToolTip, 09.4 // Triggering 5 sec. penalty, 25, 250, Screen
	Sleep, 3000
	controller.Axes.LX.SetState(59)
	Sleep, 15000
	
			*/

			; // PEN TRIGGER LOGIC (UNSTABLE)

			Sleep(5000)
			Turn_Left(1000, 40)
			Brake_on(100)
			Accel_Off()
			Sleep(3000)

			ToolTip, 09.5 // Triggering 5 sec. penalty, 25, 250, Screen
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
		; 55 // CLOSE LOOP LAP 1-12
		;----------------------------------------------------------------------

		lapcounter++

	}

	;----------------------------------------------------------------------
	; 99 // CLOSE RACE SCRIPT
	;----------------------------------------------------------------------

}
EndRace_Tokyo_Def:
