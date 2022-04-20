#Include Races\PanAm.ahk
#Include Races\Tokyo.ahk
#Include Races\DaytonaSundayCup600.ahk


GoTo EndRaceDef

Race:

	Switch RaceChoice
	{


		case "DaytonaSundayCup600":
			t := 135000
			MenuSelection := 1
			Race_DAYTONASUNDAYCUP600()
			return
		case "PanAm":
			t := 210000
			MenuSelection := 0
			Race_PANAM()
			return
		case "Tokyo":
			MenuSelection := 1
			Race_Tokyo()
			return
	}

	return

SettingsSheet:

	Gui, 4: Show, AutoSize, Settings Sheet
	;/////////////////////////////////////////////////////////
	; Add images to your setup here and in the Src folder
	;
	;/////////////////////////////////////////////////////////
	Switch RaceChoice
	{
		case "DaytonaSundayCup600":
			assist_1 = %A_ScriptDir%\Setups\PanAm\Assist1.jpg
			assist_2 = %A_ScriptDir%\Setups\PanAm\Assist2.jpg
			tune_1 = %A_ScriptDir%\Setups\PanAm\CarSetup.jpg
			tune_2 = %A_ScriptDir%\Setups\PanAm\CarGearRatio.jpg
			controls = %A_ScriptDir%\Setups\PanAm\Controller.jpg
			return

		case "PanAm":

			assist_1 = %A_ScriptDir%\Setups\PanAm\Assist1.jpg
			assist_2 = %A_ScriptDir%\Setups\PanAm\Assist2.jpg
			tune_1 = %A_ScriptDir%\Setups\PanAm\CarSetup.jpg
			tune_2 = %A_ScriptDir%\Setups\PanAm\CarGearRatio.jpg
			controls = %A_ScriptDir%\Setups\PanAm\Controller.jpg
			return
		Case "Tokyo":

			assist_1 = %A_ScriptDir%\Setups\Tokyo\tokyo_assists_1.JPG
			assist_2 = %A_ScriptDir%\Setups\Tokyo\tokyo_assists_2.jpg
			tune_1 = %A_ScriptDir%\Setups\Tokyo\tokyo_tune_1.jpg
			tune_2 = %A_ScriptDir%\Setups\Tokyo\tokyo_tune_2.jpg
			controls = %A_ScriptDir%\Setups\Tokyo\tokyo_controls.jpg
			;FileInstall, tokyo_assists_1.jpg, %assist_1%, 1


			return
	}


	return

Assists1:
	GuiControl, 4:,  CurrentPic, %assist_1%
	gosub, Guisizer
	return

Assists2:
	GuiControl, 4:,  CurrentPic, %assist_2%
	gosub, Guisizer
	return

Tune1:
	GuiControl, 4:,  CurrentPic, %tune_1%
	gosub, Guisizer
	return

Tune2:
	GuiControl, 4:,  CurrentPic, %tune_2%
	gosub, Guisizer
	return

ControllerSetting:
	GuiControl, 4:,  CurrentPic, %controls%
	gosub, Guisizer
	return

Guisizer:
	GuiControl, 4: Move, CurrentPic, % "x" 10 "y" 40 "w"  1200 . " h" . 800
	Gui, 4: Show, AutoSize, Settings Sheet
	return

EndRaceDef:
