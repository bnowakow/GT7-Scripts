__enableTurn_mod__ := 0

;Color:	C95A51 (Red=C9 Green=5A Blue=51)

; Class TurnContainer
;   Simple container for constants
;   Store the starting points to look for a turn on the minimap
;   You can also store the end points
class TurnContainer
{
  __New(startX, startY, endX := 0, endY := 0)
  {
    this.startX := startX
    this.startY := startY
    this.endX := endX
    this.endY := endY
  }
}

; below isn't used yet
TurnTolerance := 10

GoTo EndTurnDef

CheckTurn(x,y, b_size := 1)
{
  color_player := 0xDE6E70
  if (__enableTurn_mod__ = 0){
    return
  }

  turn_complete := false

  loop {
    tc := BitGrab(x, y, b_size)

    for i, c in tc
    {
      td := Distance(c, color_player)
      ToolTipper("Turn" td)
      if (td < 20 ){
        turn_complete := true

        break
      }
    }

  } until turn_complete = true
  ToolTipper("Turn Found")

  return
}

ResetTurn:
  turn_complete := false
return

EndTurnDef:
