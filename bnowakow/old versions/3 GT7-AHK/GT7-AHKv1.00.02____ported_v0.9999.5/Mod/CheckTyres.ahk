__enableCheckTyres_mod__ := 0

color_tyre_overheat := 0xD42304
tyres_overheating := false
tyreX := 166
tyreY := 364

GoTo EndCheckTyresDef

CheckTyresOverheating:

  if (__enableCheckTyres_mod__ = 0){
    return
  }

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

  if (__enableCheckTyres_mod__ = 0){
    return
  }

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
