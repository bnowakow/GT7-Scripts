GoTo EndRace_DAYTONASUNDAYCUP600_Def

Race_DAYTONASUNDAYCUP600()
{
  controller.Buttons.Cross.SetState(true)
	controller.Buttons.RS.SetState(true)
	DllCall("Sleep", "UInt", 8200)
	controller.Axes.LX.SetState(65)

  t0 := A_TickCount
	tf := t0+t
	loop 	{
		 DllCall("Sleep", "UInt", 500)
     ;timeleft := Format("{:d}", (tf-A_TickCount)/1000)
		 ;timeref := Format("{:d}", 20000101000000)
		 ;timeref += timeleft, seconds
		 ;progress := Format("{:d}", (((t/1000)-(tf-A_TickCount)/1000))/(t/100000))
		 ;progress := Format("{:d}", (t-(tf-A_TickCount)))
		 ;FormatTime, timeleftfull, %timeref%, H:mm.ss
      ;   GuiControl,, ST, Time Left : %timeleftfull%
      ;   GuiControl,, MyProgress, %progress%
	} until A_TickCount >= tf

	;GuiControl,, MyProgress, 0
	controller.Buttons.Cross.SetState(false)
	controller.Dpad.SetState("None")
  controller.Axes.LX.SetState(50)
  controller.Buttons.RS.SetState(false)
  return
}
EndRace_DAYTONASUNDAYCUP600_Def:
