__enableHairpin_mod__ := 0

;Screen:	506, 69 (less often used)
;Color:	C95A51 (Red=C9 Green=5A Blue=51)

;Screen:	588, 88 (less often used)

color_player := 0xDE6E70
hairpin_complete := false
hairpinX := 506
hairpinY := 72
hairpinCount := 0
hairpinTolerance := 10

GoTo EndHairpinDef

CheckHairpin:

  if (__enableHairpin_mod__ = 0){
    return
  }

  tc := BitGrab(hairpinX, hairpinY,3)

  for i, c in tc
  {
    td := Distance(c, color_player)
    if (td < 20 ){
      hairpin_complete := true
      hairpinCount += 1
      ToolTip, Hairpin Found current state: %hairpinCount%, 100, 100, Screen

      break
    }
  }
return

ResetHairpin:
  hairpinCount := 0
return

EndHairpinDef:
