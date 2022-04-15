GoTo EndRaceDef

Race:
	; Press X to start the race
	Tooltip
	gosub, PressX
	; Hold Acceleration and manage turning
	controller.Buttons.Cross.SetState(true)
	controller.Dpad.SetState("Down") 
	Sleep, 17500
    ;SetTimer, CheckTyresOverheating, 1000

	CheckForOilChange := Mod(30 - A_Index, 30)
	SetFormat, IntegerFast, d
	CheckForMaintenance := Mod(180 - A_Index, 180)
	SetFormat, IntegerFast, d
	ToolTip, Oil: %CheckForOilChange% race(s) remaining`nEngine: %CheckForMaintenance% race(s) remaining, 250, 45, Screen

	race_complete := false
	SetTimer, RaceComplete, 213000

	; Retry race if time is taking more than 5.5 mins 
	; (assume something went wrong with race)
	SetTimer, RetryRace, 330000

	;Lap 1
    Sleep(1000)
    Turn_Right(2800, 75)		/* before turn 1, to avoid queue of cars */
    Sleep(1000)
    Turn_Left(2000,0)			/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 75)
    Turn_Right(8800, 65)
    Sleep(1000)
    Turn_Left(1500,0)			/* turn 2 */
    Sleep(1000)
    Turn_Right(3000, 65)
    Sleep(1000)
	Nitrous_Off()
    Turn_Left(2000,0)			/* turn 3 */
	Nitrous_On()
    Sleep(900)
    Turn_Right(3700, 65)

    ;Lap 2
    Turn_Right(7400, 65)
    Sleep(800)
    Turn_Left(950,0)		/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 70)
    Turn_Right(8800, 65)
    Sleep(900)
    Turn_Left(1450,0)		/* turn 2 */
    Sleep(1000)
    Turn_Right(3000, 65)
    Sleep(1000)
	Nitrous_Off()
    Turn_Left(2000,0)		/* turn 3 */
	Nitrous_On()
    Sleep(900)
    Turn_Right(3500, 65)

    ;Lap 3
    Turn_Right(7400, 65)
    Sleep(1000)
    Turn_Left(1000,0)		/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 75)
    Turn_Right(8800, 65)
    Sleep(500)
    Turn_Left(1000,0) 		/* turn 2 */
    Sleep(500)
    Turn_Right(3000, 65)
    Sleep(1000)
	Nitrous_Off()
    Turn_Left(2000,0)		/* turn 3 */
	Nitrous_On()
    Sleep(1000)
    Turn_Right(3400, 65)

	;Rest of the race just keep turning right
	controller.Axes.LX.SetState(67)

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
		if (race_complete) {
			controller.Dpad.SetState("Right") 
			Sleep, 50
			controller.Dpad.SetState("None")
		}
        Sleep, 2000
    }
	ToolTip, Found color 1, 100, 100, Screen
	SetTimer, RetryRace, off
	gosub, ResetControllerState
	gosub, ResetVariables
	Sleep, 500
	return


RaceComplete:
	race_complete := true
	return


RetryRace:
	ToolTip, Retry Race, 100, 100, Screen
    WinActivate, ahk_id %id%
    Sleep, 500
    Gosub, ResetControllerState
    Sleep 200
    controller.Buttons.Options.SetState(true)
    Sleep 200
	controller.Buttons.Options.SetState(false)
    Sleep, 200
    controller.Dpad.SetState("Right") 
    Sleep, 200
    controller.Dpad.SetState("None")
	Sleep, 200
    Goto, AFKLoop
    return


EndRaceDef:
