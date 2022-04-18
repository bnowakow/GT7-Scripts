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
    this.endX   := endX
    this.endY   := endY
  }
}

; below isn't used yet
TurnTolerance := 10

GoTo EndTurnDef

CheckTurn(x,y, timeout := 3400, b_size := 2)
{
    check_turn_start_tick_count := A_TickCount
    ;ToolTipper("A_TickCount at the begining of CheckTurn " A_TickCount, 100, 150)

    ; below is only to simulate constant timeouts
    ; debug start
    /*
    loop {
        check_turn_now_tick_count := A_TickCount
        check_turn_tick_count_from_start_to_now := check_turn_now_tick_count - check_turn_start_tick_count
        if (check_turn_tick_count_from_start_to_now > timeout) {
            ToolTipper("DEBUG Turn Check Timeout exceeded " A_TickCount, 100, 200)
            return false
        }
        sleep(500)
    }
    */
    ; debug end
    
    color_player := 0xDE6E70
    if (__enableTurn_mod__ = 0){
      return
    }

    turn_complete := false

    loop {
      tc := BitGrab(x, y, b_size)
      ;ToolTipper("debug until loop")
      for i, c in tc
      {
        
        
        check_turn_now_tick_count := A_TickCount
        check_turn_tick_count_from_start_to_now := check_turn_now_tick_count - check_turn_start_tick_count
        if (check_turn_tick_count_from_start_to_now > timeout) {
            ToolTipper("Turn Check Timeout exceeded", 100, 200)
            return false
        }
        ;ToolTipper("debug i loop")

        td := Distance(c, color_player)
        ; ToolTipper("Turn" td)
        if (td < 20 ){
            turn_complete := true

            break
        }
      }

      check_turn_now_tick_count := A_TickCount
      check_turn_tick_count_from_start_to_now := check_turn_now_tick_count - check_turn_start_tick_count
      if (check_turn_tick_count_from_start_to_now > timeout) {
            ToolTipper("Turn Check Timeout exceeded", 100, 200)
            return false
      }
    } until (turn_complete = true)
    check_turn_found_tick_count := A_TickCount
    check_turn_tick_count_from_start_to_found := check_turn_found_tick_count - check_turn_start_tick_count
    ToolTipper("tickCount from start to end " check_turn_tick_count_from_start_to_found, 100, 250)
    ; Sleep, 100000 ; debug
    ;ToolTipper("Turn Found")

    return true
}

ResetTurn:
  turn_complete := false
  return

EndTurnDef:
