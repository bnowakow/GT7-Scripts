
GoTo EndRace_PANAM_Def

Race_PANAM()
{
  ; Turn Containers are in the CheckTurn.ahk
  ; turn1 := new TurnContainer(_, _, 627, 94)

  turn2 := new TurnContainer(531, 42)
  turn3 := new TurnContainer(490, 95)
  lap_marker := new TurnContainer(566, 112)

  ; Press X to start the race
  Tooltip
  gosub, PressX
  ; Hold Acceleration and manage turning
  Nitrous_On()
  Accel_On(100)
  Sleep, 8200
    ;SetTimer, CheckTyresOverheating, 1000

  CheckForOilChange := Mod(30 - A_Index, 30)
  SetFormat, IntegerFast, d
  CheckForMaintenance := Mod(180 - A_Index, 180)
  SetFormat, IntegerFast, d
  ;ToolTip, Oil: %CheckForOilChange% race(s) remaining`nEngine: %CheckForMaintenance% race(s) remaining, 250, 45, Screen
  ToolTipper("Oil: " CheckForOilChange " race(s) remaining`nEngine: " CheckForMaintenance " race(s) remaining", 250, 45)
  race_complete := false
  ;SetTimer, RaceComplete, 213000

  ; Retry race if time is taking more than 5.5 mins
  ; (assume something went wrong with race)
  ;SetTimer, RetryRace, 330000

  ;Lap 1
    Sleep(1000)
    Turn_Right(2800, 75)		/* before turn 1, to avoid queue of cars */
    Sleep(1000)
    Turn_Left(2000,0)			/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 75)
    Turn_Right(8800, 65)

    CheckTurn(turn2.startX, turn2.startY)

    Turn_Left(1500,0)			/* turn 2 */
    ToolTip
    Sleep(1000)
    Turn_Right(3000, 65)

    CheckTurn(turn3.startX, turn3.startY)


    Nitrous_Off()
    Turn_Left(2000,0)			/* turn 3 */
    Nitrous_On()
    Sleep(900)
    ToolTip
    Turn_Right(3700, 65)

    ;Lap 2
    Turn_Right(7400, 65)
    Sleep(800)
    Turn_Left(950,0)		/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 70)
    Turn_Right(8800, 65)

    CheckTurn(turn2.startX, turn2.startY)

    Turn_Left(1450,0)		/* turn 2 */
    Sleep(1000)
    Turn_Right(3000, 65)

    CheckTurn(turn3.startX, turn3.startY)

    Nitrous_Off()
    Turn_Left(2000,0)		/* turn 3 */
    Nitrous_On()
    Sleep(900)
    controller.Axes.LX.SetState(67)
    Sleep(4000)
    CheckTurn(lap_marker.startX, lap_marker.startY)

    ;;;;;;;
    ;Lap 3;
    ;;;;;;;
    Turn_Right(5000, 65)
    Sleep(1000)
    Turn_Left(1000,0)		/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 75)
    Turn_Right(8800, 65)

    CheckTurn(turn2.startX, turn2.startY)

    Turn_Left(1000,0) 		/* turn 2 */
    Sleep(500)
    Turn_Right(3000, 65)

    CheckTurn(turn3.startX, turn3.startY)

    Nitrous_Off()
    Turn_Left(2000,0)		/* turn 3 */
    Nitrous_On()
    Sleep(1000)
    controller.Axes.LX.SetState(67)
    Sleep(4000)
    CheckTurn(lap_marker.startX, lap_marker.startY)

    ;;;;;;;
    ;Lap 4;
    ;;;;;;;
    Turn_Right(5000, 65)
    Sleep(1000)
    Turn_Left(1000,0)		/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 75)
    Turn_Right(8800, 65)

    CheckTurn(turn2.startX, turn2.startY)

    Turn_Left(1000,0) 		/* turn 2 */
    Sleep(500)
    Turn_Right(3000, 65)

    CheckTurn(turn3.startX, turn3.startY)

    Nitrous_Off()
    Turn_Left(2000,0)		/* turn 3 */
    Nitrous_On()
    Sleep(1000)
    controller.Axes.LX.SetState(67)
    Sleep(4000)
    CheckTurn(lap_marker.startX, lap_marker.startY)

    ;;;;;;;
    ;Lap 5;
    ;;;;;;;
    Turn_Right(5000, 65)
    Sleep(1000)
    Turn_Left(1000,0)		/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 75)
    Turn_Right(8800, 65)

    CheckTurn(turn2.startX, turn2.startY)

    Turn_Left(1000,0) 		/* turn 2 */
    Sleep(500)
    Turn_Right(3000, 65)

    CheckTurn(turn3.startX, turn3.startY)

    Nitrous_Off()
    Turn_Left(2000,0)		/* turn 3 */
    Nitrous_On()
    Sleep(1000)
    controller.Axes.LX.SetState(67)
    Sleep(4000)
    CheckTurn(lap_marker.startX, lap_marker.startY)

    ;;;;;;;
    ;Lap 6;
    ;;;;;;;
    Turn_Right(5000, 65)
    Sleep(1000)
    Turn_Left(1000,0)		/* turn 1 */
    Sleep(1000)
    Turn_Right(2000, 75)
    Turn_Right(8800, 65)

    CheckTurn(turn2.startX, turn2.startY)

    Turn_Left(1000,0) 		/* turn 2 */
    Sleep(500)
    Turn_Right(3000, 65)

    CheckTurn(turn3.startX, turn3.startY)

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

      controller.Dpad.SetState("Right")
      Sleep, 50
      controller.Dpad.SetState("None")

      Sleep, 100
    }
  ToolTipper("Found color 1")
  ;SetTimer, RetryRace, off
  gosub, PauseLoop
  Sleep, 500
  return
}

Race_PANAM_Complete()
{
  race_complete := true
  return
}

EndRace_PANAM_Def:
