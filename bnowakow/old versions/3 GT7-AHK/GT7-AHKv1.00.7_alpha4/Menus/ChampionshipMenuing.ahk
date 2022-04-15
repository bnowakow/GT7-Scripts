GoTo EndChampionshipMenuingDef

ChampionshipMenu:

	loop
	{
		break_point := false
		c2 := BitGrab(pix2x, pix2y+remote_play_offsetY, box_size)
		for i, c in c2
		{
			d2 := Distance(c, color_check2)
			if (d2 < tolerance )
			{
				break_point := true
				break
			}
		}
		if (break_point)
			break
		Press_X()
		sleep, %color_2_delay%
		sleep, %bm_delay%
	}
	;ToolTip, Found color 2, 100, 100, Screen
	Sleep, 100
	Press_O()
	Sleep, 100
	Press_Right()
	Sleep, 100
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
	CheckForOilChange := Mod(races_for_oil - race_count_oil - 1, races_for_oil)
	SetFormat, IntegerFast, d
	CheckForMaintenance := Mod(races_for_maintenance - race_count_oil - 1, races_for_maintenance)
	SetFormat, IntegerFast, d

	;ToolTipper("CheckForOilChange " CheckForOilChange "`nCheckForMaintenance " CheckForMaintenance, 300, 100)

	ifEqual, CheckForOilChange, 0
	{
		gosub, DoOilChange
		race_count_oil := 0
	}

	ifEqual, CheckForMaintenance, 0
	{
		gosub, DoMaintenance
		race_count_maintenance := 0
	}
	Press_Down()
	Sleep, 50
	loop, %menu_loops%
	{
		controller.Dpad.SetState(MenuDirect)
		Sleep, 50
		controller.Dpad.SetState("None")
		Sleep, 50
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
