GoTo EndRaceDef

Race:
; Hold Acceleration and manage turning

	controller.Buttons.Cross.SetState(true)
	controller.Dpad.SetState("Down")
	DllCall("Sleep", "UInt", 7600)
    ;SetTimer, CheckTyresOverheating, 1000

    /*
Screen:	100, 237 (less often used)
Window:	-817, 181 (default)
Client:	-825, 130 (recommended)
Color:	814DA5 (Red=81 Green=4D Blue=A5)

E78883
*/
   /*  Lap 1 total laptime 34000ms
   */
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
     controller.Dpad.SetState("None")
    Turn_Left(2000,0)			/* turn 3 */
     controller.Dpad.SetState("Down")
    Sleep(900)
    Turn_Right(3700, 65)

     ;lap 2

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
    controller.Dpad.SetState("None")
    Turn_Left(2000,0)		/* turn 3 */
    controller.Dpad.SetState("Down")
    Sleep(900)
    Turn_Right(3500, 65)

    ;lap 3

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
    controller.Dpad.SetState("None")
    Turn_Left(2000,0)		/* turn 3 */
    controller.Dpad.SetState("Down")
    Sleep(1000)
    Turn_Right(3400, 65)


    ;lap 4  No left turns anymore; total control time = 35050

    Turn_Right(7600, 65)
    Turn_Right(300, 60)
    Sleep(1800)
    ;Turn_Left(1000,0)			/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 75)
    Turn_Right(9000, 65)
    Sleep(1500)
    ;Turn_Left(1450,0)			/* turn 2 */
    Sleep(1400)
    Turn_Right(3000, 65)
    Sleep(2000)
     controller.Dpad.SetState("None")
    ;Turn_Left(2000,0)			/* turn 3 */
     controller.Dpad.SetState("Down")
    Sleep(2000)
    Turn_Right(3400, 65)

    ; Lap 5

    Turn_Right(7700, 65)
    Turn_Right(300, 60)
    Sleep(1800)
    ;Turn_Left(1000,0)			/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 75)
    Turn_Right(9000, 65)
    Sleep(1500)
    ;Turn_Left(1450,0)			/* turn 2 */
    Sleep(1400)
    Turn_Right(3000, 65)
    Sleep(2000)
     controller.Dpad.SetState("None")
    ;Turn_Left(2000,0)			/* turn 3 */
     controller.Dpad.SetState("Down")
    Sleep(2000)
    Turn_Right(3600, 65)

    ; Lap 6
    Turn_Right(7700, 65)
    Turn_Right(500, 60)
    Sleep(1800)
    ;Turn_Left(1000,0)			/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 75)
    Turn_Right(9000, 65)
    Sleep(1500)
    ;Turn_Left(1450,0)			/* turn 2 */
    Sleep(1500)
    Turn_Right(3000, 65)
    Sleep(2000)
     controller.Dpad.SetState("None")
    ;Turn_Left(2000,0)			/* turn 3 */
     controller.Dpad.SetState("Down")
    Sleep(2000)
    Turn_Right(5000, 65)
    Turn_Right(7000, 60)


/*
; This section detects the end of the race. Can be used to be faster/more accurate at the ending but good timing takes less computer resources
Screen:	218, 359 (less often used)
Window:	222, 357 (default)
Client:	214, 326 (recommended)
Color:	3F1757 (Red=3F Green=17 Blue=57)

Screen:	247, 65 (less often used)
Window:	-129, -376 (default)
Client:	-129, -376 (recommended)
Color:	FD3C37 (Red=FD Green=3C Blue=37)

Screen:	210, 64 (less often used)
Window:	210, 64 (default)
Client:	202, 33 (recommended)
Color:	5091E9 (Red=50 Green=91 Blue=E9)

Screen:	261, 39 (less often used)
Window:	261, 39 (default)
Client:	253, 8 (recommended)
Color:	A774A9 (Red=A7 Green=74 Blue=A9)

Screen:	263, 74 (less often used)
Window:	263, 74 (default)
Client:	255, 43 (recommended)
Color:	FF3632 (Red=FF Green=36 Blue=32)
*/
		controller.Axes.LX.SetState(65)
    loop {
        /*
        if (tyres_overheating) {
            Goto, RetryRace
            return
        }
        */
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
        Sleep, 140
        controller.Dpad.SetState("None")
        Sleep, 200
        /*
        PixelSearch, x, y, pix1x-10, pix1y-10, pix1x+10, pix1y+10, %color_check1%, 32, Fast RGB
            If (ErrorLevel != 0) {
                controller.Dpad.SetState("Right")
				Sleep, 140
				controller.Dpad.SetState("None")
				Sleep, 200
            }
            */
        Sleep, 300

    }

    ;ToolTip, Found color 1, 100, 100, Screen
    controller.Axes.LX.SetState(50)
    controller.Buttons.Cross.SetState(false)
    controller.Dpad.SetState("None")
    return

EndRaceDef:
