__enableChicane_mod__ := 0

;Screen:	506, 69 (less often used)
;Color:	C95A51 (Red=C9 Green=5A Blue=51)

;Screen:	588, 88 (less often used)

color_player := 0xDE6E70
Chicane_complete := false
ChicaneX := 588
ChicaneY := 88

ChicaneTolerance := 10

GoTo EndChicaneDef

CheckChicane:

  if (__enableChicane_mod__ = 0){
    return
  }

  tc := BitGrab(ChicaneX, ChicaneY,2)

  for i, c in tc
  {
    td := Distance(c, color_player)
    if (td < 9 ){
      Chicane_complete := true
      ToolTip, Chicane Found, 100, 100, Screen

      break
    }
  }
return

ResetChicane:
  Chicane_complete := false
return

EndChicaneDef:
