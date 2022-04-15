GoTo EndCheckTyresDef

CheckTyresOverheating:
    tc := BitGrab(tyreX, tyreY, box_size)
    for i, c in tc
    {
        td := Distance(c, color_tyre_overheat)
        if (td < tolerance ){
            tyres_overheating := true
            break
        }
    }
    return

RetryRace:
    Gosub, PauseLoop
    Sleep 500
    tyres_overheating := false
    controller.Buttons.Options.SetState(true)
    Sleep 200
	controller.Buttons.Options.SetState(false)
    Sleep, 500
    controller.Dpad.SetState("Right")
    Sleep, 200
    controller.Dpad.SetState("None")
    Goto, AFKLoop
    return

EndCheckTyresDef:
