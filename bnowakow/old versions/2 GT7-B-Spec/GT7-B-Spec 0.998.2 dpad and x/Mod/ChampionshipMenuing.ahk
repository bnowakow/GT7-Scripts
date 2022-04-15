bEnableChampionshipMenuingMod := 0

GoTo EndChampionshipMenuingDef

Menu_Start_Race:

	if(bEnableChampionshipMenuingMod = 0){
		return
	}

	controller.Dpad.SetState("Down") 
	Sleep, 100
	controller.Dpad.SetState("None") 
	Sleep, 250
	loop, %menu_loops% {
		controller.Dpad.SetState(MenuDirect) 
		Sleep, 100
		controller.Dpad.SetState("None") 
		Sleep, 250
	}
	loop, 2{
		gosub, PressX
		Sleep, 500
	}
	ToolTip, Loading race, 100, 100, Screen
	Sleep, %ps_load_time3%
	gosub, PressX
	Sleep, 1000
	gosub, PressX
	return


Menu_End_Race:

	if(bEnableChampionshipMenuingMod = 0){
		return
	}

    ToolTip, Menuing, 100, 100, Screen
     loop {
        break_point := false
        c2 := BitGrab(pix2x, pix2y, box_size)
        for i, c in c2
        {
            d2 := Distance(c, color_check2)
            if (d2 < tolerance ){
                break_point := true
                break
            }
        }
        if (break_point)
            break
        gosub, PressX
        sleep, %color_2_delay%
    }
	ToolTip, Found color 2, 100, 100, Screen
	Sleep, 1000
	controller.Buttons.Circle.SetState(true)
	Sleep, 200
	controller.Buttons.Circle.SetState(false)
	Sleep, 200
	controller.Dpad.SetState("Right") 
	Sleep, 200
	controller.Dpad.SetState("None") 
	Sleep, 500
	gosub, PressX
	Tooltip
	Sleep, %ps_load_time1%
	gosub, PressX
	Sleep, 1000
	controller.Buttons.Circle.SetState(true)
	Sleep, 200
	controller.Buttons.Circle.SetState(false)
	loop, 2 {
		gosub, PressX
		Sleep, 500
	}
	Sleep, %ps_load_time2% 
	;Conduct Maintenance here.
	if (CheckForMaintenance = 0) {
		gosub, DoMaintenance
	}
	else {
		if (CheckForOilChange = 0) {
			gosub, DoOilChange
		}
	}
	return

EndChampionshipMenuingDef:
