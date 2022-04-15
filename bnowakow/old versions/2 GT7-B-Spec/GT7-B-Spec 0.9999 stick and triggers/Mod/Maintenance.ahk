__enableMaintenance_mod__ := 0

GoTo EndMaintenceDef

;This will do only an oil change. will leave user at race menu to resume.
GtAutoNav:
return

DoOilChange:

    if (__enableCheckTyres_mod__ = 0){
      return
    }

    Sleep, 1000
    Press_O()
    Sleep, 2800
    loop, 2 {
        Press_Right(140)
        Sleep, 200
     }
    Press_Down()
    Sleep, 200

    loop, 2 {
		Press_X()
		Sleep, 1000
	}

    Sleep, 2000
    Press_Down(140)
    Sleep, 200
    loop, 2 {
		    Press_X()
		    Sleep, 500
	  }
    Sleep, 7000
    Press_X()
    Sleep, 500

    Press_O()
    Sleep, 200
    Sleep, 3000
    Press_Up(140)
    Sleep, 200
    Press_Left()
    Sleep, 500
    Press_Left()
    Sleep, 500
    Press_X()
    Sleep, 4800
    return


;This will do complete maintenance on the car including oil, engine and body. will leave user at race menu to resume.
DoMaintenance:

    if (__enableCheckTyres_mod__ = 0){
      return
    }

    Sleep, 1000
    controller.Buttons.Circle.SetState(true)
    Sleep, 200
    controller.Buttons.Circle.SetState(false)
    Sleep, 2800
    loop, 2 {
    controller.Dpad.SetState("Right")
        Sleep, 140
        controller.Dpad.SetState("None")
        Sleep, 200
     }
    controller.Dpad.SetState("Down")
    Sleep, 200
    controller.Dpad.SetState("None")
    Sleep, 200

    loop, 2 {
		gosub, PressX
		Sleep, 1000
	}

    Sleep, 2000
    controller.Dpad.SetState("Down")
    Sleep, 140
    controller.Dpad.SetState("None")
    Sleep, 200
    loop, 2 {
		gosub, PressX
		Sleep, 500
	}
    Sleep, 7000
    gosub, PressX
    Sleep, 500

    controller.Dpad.SetState("Down")
    Sleep, 140
    controller.Dpad.SetState("None")
    Sleep, 200
    controller.Dpad.SetState("Down")
    Sleep, 140
    controller.Dpad.SetState("None")
    Sleep, 200
    loop, 2 {
		gosub, PressX
		Sleep, 500
	}
    Sleep, 7000
    gosub, PressX
    Sleep, 500

    controller.Dpad.SetState("Down")
    Sleep, 140
    controller.Dpad.SetState("None")
    Sleep, 200
    controller.Dpad.SetState("Down")
    Sleep, 140
    controller.Dpad.SetState("None")
    Sleep, 200
    controller.Dpad.SetState("Down")
    Sleep, 140
    controller.Dpad.SetState("None")
    Sleep, 200
    loop, 2 {
		gosub, PressX
		Sleep, 500
	}
    Sleep, 8500
    gosub, PressX
    Sleep, 500

   controller.Buttons.Circle.SetState(true)
    Sleep, 200
    controller.Buttons.Circle.SetState(false)
    Sleep, 200
   Sleep, 3000
   controller.Dpad.SetState("Up")
    Sleep, 140
    controller.Dpad.SetState("None")
    Sleep, 200
    controller.Dpad.SetState("Left")
    Sleep, 200
    controller.Dpad.SetState("None")
    Sleep, 500
    controller.Dpad.SetState("Left")
    Sleep, 200
    controller.Dpad.SetState("None")
    Sleep, 500
    gosub, PressX
    Sleep, 4800
    return

EndMaintenceDef:
