__enableChampionshipMenuing_mod__ := 0

GoTo EndChampionshipMenuingDef

Menu:
	;ToolTip, Menuing, 100, 100, Screen
	if(__enableChampionshipMenuing_mod__ = 0){
		return
	}

	loop {
		break_point := false
		c1 := BitGrab(pix1x, pix1y, box_size)
		for i, c in c1
		{
			d1 := Distance(c, color_check1)
			;Tooltip, Color 1`npix1x = %pix1x% pix1y = %pix1y% color_check1 = %color_check1%`n d1 = %d1%, 100, 100, screen
			if (d1 < tolerance )
			{
				break_point := true
				break
			}
		}
		if (break_point)
			break
		Press_Right()
		sleep, 250
	}
	;ToolTip, Found color 1, 100, 100, Screen

	loop
	{
		break_point := false
		c2 := BitGrab(pix2x, pix2y, box_size)
		for i, c in c2
		{
			d2 := Distance(c, color_check2)
			;Tooltip, Color 2`npix2x = %pix2x% pix2y = %pix2y% color_check2 = %color_check2%`n d2 = %d2%, 100, 100, screen
			if (d2 < tolerance)
			{
				break_point := true
				break
			}
		}
		if (break_point)
			break
		Press_X()
		Sleep, %color_2_delay%
	}
	;ToolTip, Found color 2, 100, 100, Screen
	
	Sleep, 1000	
	Press_O()
	Sleep, 150
	Press_Right()
	Sleep, 150
	Press_X()
	Sleep, %ps_load_time1%
	Press_X()
	Sleep, 1000
	Press_O()
	loop, 2
	{
		Press_X()
		Sleep, 100
	}
	Sleep, %ps_load_time2%

	;Conduct Maintenance here.
	CheckForOilChange := Mod(A_Index, 29)
	CheckForMaintenance := Mod(A_Index, 107)

	;ToolTipper("CheckForOilChange " CheckForOilChange "`nCheckForMaintenance " CheckForMaintenance, 300, 100)

	ifEqual, CheckForOilChange, 0
	{
		gosub, DoOilChange
	}

	ifEqual, CheckForMaintenance, 0
	{
		gosub, DoMaintenance
	}
	Press_Down()
	Sleep, 100
	loop, %menu_loops%
	{
		controller.Dpad.SetState(MenuDirect)
		Sleep, 100
		controller.Dpad.SetState("None")
		Sleep, 100
	}
	loop, 2
	{
		Press_X()
		Sleep, 500
	}
	Sleep, %ps_load_time3%

	Press_X()
	Sleep, 500
	Press_X()
return


EndChampionshipMenuingDef:
