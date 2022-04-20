GoTo EndNormalMenuingDef

NormalMenu:

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
	Sleep, 200
	controller.Dpad.SetState("Right")
	Sleep, 100
	controller.Dpad.SetState("None")
	Sleep, 500
	gosub, PressX
	Sleep, 2000

	return

EndNormalMenuingDef:
