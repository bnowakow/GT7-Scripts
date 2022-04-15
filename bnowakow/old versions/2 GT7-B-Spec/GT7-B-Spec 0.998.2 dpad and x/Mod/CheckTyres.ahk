bEnableCheckTyresMod := 0

GoTo EndCheckTyresDef

CheckTyresOverheating:
    if (bEnableCheckTyresMod = 0){
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

EndCheckTyresDef:
