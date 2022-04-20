#Include Menus\ChampionshipMenuing.ahk
#Include Menus\NormalMenuing.ahk

GoTo EndMenuDef

Menu:
  Switch MenuSelection
  {
    case 0:
      gosub, ChampionshipMenu
      return
    case 1:
      gosub, NormalMenu
      return
  }


	return

EndMenuDef:
