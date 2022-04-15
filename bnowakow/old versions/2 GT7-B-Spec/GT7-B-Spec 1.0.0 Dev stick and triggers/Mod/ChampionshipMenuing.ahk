__enableChampionshipMenuing_mod__ := 0

GoTo EndChampionshipMenuingDef

Menu:
	;ToolTip, Menuing, 100, 100, Screen
	if(__enableChampionshipMenuing_mod__ = 0){
		return
	}

	loop
	{
		break_point := false
		c2 := BitGrab(pix2x, pix2y, box_size)
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

	;	loop, 2{
	;        gosub, PressX
	;        Sleep, 500
	;    }
	Gosub, PressX
	Sleep, 500
	Gosub, PressX

return

EndChampionshipMenuingDef:
