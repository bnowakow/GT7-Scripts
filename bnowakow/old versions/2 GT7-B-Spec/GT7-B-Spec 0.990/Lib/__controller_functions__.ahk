
/**********************************************
* Controller methods for simplicity           *
***********************************************/
*/

GoTo EndControllerFunctionsDef

;;;;;;;;;;;; Turning functions
;;;;;;;;;;;;    For holding the stick in a specific position for a period of time
;;;;;;;;;;;;    Note no other button may be pressed or released when these functions are ran

; Set the time you want to turn for in miliseconds and how hard (50, 100), 100 being the most, 50 being neutral
Turn_Right(sleept, inten){
    t := sleept
    controller.Axes.LX.SetState(inten)
    gosub, Turn
    controller.Axes.LX.SetState(50)
}

; Set the time you want to turn for in miliseconds and how hard (0, 50), 0 being the most
Turn_Left(sleept, inten){
    t := sleept
    controller.Axes.LX.SetState(inten)
    gosub, Turn
    controller.Axes.LX.SetState(50)
}

;;;;;;;;;;;; Simple button press functions
;;;;;;;;;;;;    You can pass a delay amount or leave it blank
;;;;;;;;;;;;    Longer delays hold the button longer

; Press X button
Press_X(delay:=200){
  controller.Buttons.Cross.SetState(true)
  DllCall("Sleep", "UInt", delay)
  controller.Buttons.Cross.SetState(false)
  return
}

; Press O button
Press_O(delay:=200){
  controller.Buttons.Circle.SetState(true)
  DllCall("Sleep", "UInt", delay)
  controller.Buttons.Circle.SetState(false)
  return
}

; Press Triangle button
Press_Triangle(delay:=200){
  controller.Buttons.Triangle.SetState(true)
  DllCall("Sleep", "UInt", delay)
  controller.Buttons.Triangle.SetState(false)
  return
}

; Press Square button
Press_Square(delay:=200){
  controller.Buttons.Square.SetState(true)
  DllCall("Sleep", "UInt", delay)
  controller.Buttons.Square.SetState(false)
  return
}

; Press Right on D-pad
Press_Right(delay:=200){
  controller.Dpad.SetState("Right")
  DllCall("Sleep", "UInt", delay)
  controller.Dpad.SetState("None")
  return
}

; Press Left on D-pad
Press_Left(delay:=200){
  controller.Dpad.SetState("Left")
  DllCall("Sleep", "UInt", delay)
  controller.Dpad.SetState("None")
  return
}

; Press Up on D-pad
Press_Up(delay:=200){
  controller.Dpad.SetState("Up")
  DllCall("Sleep", "UInt", delay)
  controller.Dpad.SetState("None")
  return
}

; Press Down on D-pad
Press_Down(delay:=200){
  controller.Dpad.SetState("Down")
  DllCall("Sleep", "UInt", delay)
  controller.Dpad.SetState("None")
  return
}

;;;;;;;;;;; Other functions specific to GT7

; Turn on nitrous
Nitrous_On(){
  controller.Buttons.RS.SetState(true)
}

; Turn off nitrous
Nitrous_Off(){
  controller.Buttons.RS.SetState(false)
}

; Accelerate
Accelerate(power:=100) {
  if (power < 0) {
  power:=0
  }
  if (power > 0) {
    controller.Buttons.R2.SetState(true)
  }
  controller.Axes.RT.SetState(power)
  if (power = 0) {
    controller.Buttons.R2.SetState(false)
  }
}

ResetControllerState() {
	controller.Axes.LT.SetState(0)
	controller.Buttons.L2.SetState(false) 
	controller.Axes.RT.SetState(0)
	controller.Buttons.R2.SetState(false) 
	controller.Dpad.SetState("None") 
    controller.Axes.LX.SetState(50)
    controller.Axes.LY.SetState(50)
	controller.Axes.RX.SetState(50)
	controller.Axes.RY.SetState(50)
	controller.Button.LS.SetState(false)
    controller.Button.RS.SetState(false)
	controller.Buttons.Cross.SetState(false)
	controller.Buttons.Circle.SetState(false)
	controller.Buttons.Square.SetState(false)
	controller.Buttons.Triangle.SetState(false)	
}


; given time t in miliseconds, turn right for that long, with intensity being how much the turn button is held for
Turn:
	t0 := A_TickCount
	tf := t0+t
	loop 	{
        Sleep(100)
	} until  A_TickCount > tf
  return

PressX:
; Just for menuing, does not hold X down
  controller.Buttons.Cross.SetState(true)
  DllCall("Sleep", "UInt", 200)
  controller.Buttons.Cross.SetState(false)
  return

PressO:
; Just for menuing, does not hold O down
  controller.Buttons.Circle.SetState(true)
  DllCall("Sleep", "UInt", 200)
  controller.Buttons.Circle.SetState(false)
  return

PressRight:
; For turning
  controller.Dpad.SetState("Right")
  Sleep, 50
  controller.Dpad.SetState("None")
  return


EndControllerFunctionsDef:
