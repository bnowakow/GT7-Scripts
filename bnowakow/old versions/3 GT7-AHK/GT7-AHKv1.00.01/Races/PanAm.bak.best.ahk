
GoTo EndRace_PANAM_Def

Race_PANAM()
{
  ; Turn Containers are in the CheckTurn.ahk
	turn1 := new TurnContainer(629, 109, 630, 95)
	turn2 := new TurnContainer(539, 44, 511, 52)
	turn3 := new TurnContainer(490, 89, 502, 111)
	lap_marker := new TurnContainer(560, 112)

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

	Loop, 6 {
		; Turn 1
		Tooltip
		CheckTurn(turn1.startX, turn1.startY)
		Tooltip, Turn 1 start found, 100, 100, screen
		controller.Axes.LX.SetState(15)
		CheckTurn(turn1.endX, turn1.endY)
		Tooltip, Turn 1 end found, 100, 100, screen
		Nitrous_On()
		controller.Axes.LX.SetState(80)
		sleep(1500)
		controller.Axes.LX.SetState(65)

		; Turn 2
		CheckTurn(turn2.startX, turn2.startY)
		Tooltip, Turn 2 start found, 100, 100, screen
		controller.Axes.LX.SetState(20)
		CheckTurn(turn2.endX, turn2.endY)
		Tooltip, Turn 2 end found, 100, 100, screen
		controller.Axes.LX.SetState(75)
		sleep(2000)
		controller.Axes.LX.SetState(65)

		; Turn 3
		CheckTurn(turn3.startX, turn3.startY)
		Nitrous_Off()
		Tooltip, Turn 3 start found, 100, 100, screen
		controller.Axes.LX.SetState(0)
		CheckTurn(turn3.endX, turn3.endY, 2)
		Nitrous_On()
		Tooltip, Turn 3 end found, 100, 100, screen
		controller.Axes.LX.SetState(75)
		sleep(2000)
		controller.Axes.LX.SetState(65)
		
		CheckTurn(lap_marker.startX, lap_marker.startY)
		Tooltip, Lap Complete, 100, 100, screen
	}


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
