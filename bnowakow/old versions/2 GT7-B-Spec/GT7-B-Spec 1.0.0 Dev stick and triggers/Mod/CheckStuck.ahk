__enableCheckStuck_mod__ := 0

GoTo EndCheckStuckDef

CheckStuck:

    if (__enableCheckStuck_mod__ = 0){
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

Unstuck:

    if (__enableCheckStuck_mod__ = 0){
        return
    }
    controller.Buttons.RS.SetState(false)
    Sleep 200
    Turn_Left(4000, 0) 
    tyres_overheating := false
    controller.Buttons.RS.SetState(true)
    ToolTip, Unstuck done - hope it worked., 100, 100, Screen
return

EndCheckStuckDef: