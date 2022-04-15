#Include Races\PanAm.ahk
#Include Races\Tokyo.ahk

GoTo EndRaceDef

Race:

	Switch RaceChoice
	{
	case "PanAm":
		Race_PANAM()
	return
case "Tokyo":
	Race_Tokyo()
return
}

return

EndRaceDef:
