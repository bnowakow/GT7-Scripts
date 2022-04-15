/************************************************
  Rules for adding a mod

  Your mod file should only be included here
  In your mod file, make a flag variable such as

  bEnable<modName>Mod := 0

  and put the following at the beggining of each subroutine of your mod file

  if (bEnable<modName>Mod = 0){
    return
  }

  This will allow users to disable and enable the mod

  If your mod is dependent on another mod and there is an error while running,
  try switching the order around on the #Include

  Add the mod's name and variable name to the _mod objects below
*************************************************
*/

#Include Mod\Maintenance.ahk
#Include Mod\ChampionshipMenuing.ahk
#Include Mod\CheckTyres.ahk

_mod_names :=
( LTrim Join
[
    "Championship Menus",
    "Check Tyres",
    "Maintenance"
]
)

_mod_vars =
( LTrim Join|
  bEnableChampionshipMenuingMod
  bEnableCheckTyresMod
  bEnableMaintenanceMod
)

; Load mod settings
Loop, Parse, _mod_vars, |
{
  IniRead, %A_LoopField%, config.ini, Mods, %A_LoopField%, 0
}

; Mods Gui Setup
Gui, 3: -MaximizeBox
Gui, 3: -MinimizeBox
Gui, 3: Color, c535770, c6272a4
Gui, 3: Font, c11f s9 Bold
;Gui, 3: Add, GroupBox, w200 h100, Mod List


Loop, Parse, _mod_vars, |
{

  if ( %A_LoopField% = 1){
    Gui, 3: Add, Checkbox, Checked v%A_LoopField%, % _mod_names[A_Index]
  }
  else {
    Gui, 3: Add, Checkbox, v%A_LoopField%, % _mod_names[A_Index]
  }

}


Gui, 3: Add, Button, gSaveMods, Save

GoTo EndModsDef
; End of Gui Setup

SaveMods:
	Gui, 3:Submit
	Loop, Parse, _mod_vars, |
	{
		IniWrite, % %A_LoopField%, config.ini, Mods, % A_LoopField
	}
	return

EndModsDef:
