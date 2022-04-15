/************************************************
  Rules for adding a mod

  Your mod file should only be included here
  In your mod file, make a flag variable such as

  __enable<modName>_mod__ := 0

  and put the following at the beggining of each subroutine of your mod file

  if (__enable<modName>_mod__ = 0){
    return
  }

  This will allow users to disable and enable the mod

  If your mod is dependent on another mod and there is an error while running,
  try switching the order around on the #Include

  Add the mod's name and variable name to the _mod objects below
*************************************************
*/

#Include Mod\Maintenance.ahk

#Include Mod\CheckTyres.ahk
#Include Mod\CheckStuck.ahk
#Include Mod\Hairpin.ahk
#Include Mod\Chicane.ahk
#Include Mod\CheckTurn.ahk
#Include Mod\RemotePlaySizer.ahk

_mod_names :=
( LTrim Join
[
    "Check Tyres",
    "Maintenance",
	  "Check Stuck",
    "Check Hairpin",
    "Chicane",
    "Check Turns",
    "Remote Play Enlarge",
    "Debug Mode"
]
)

_mod_vars =
( LTrim Join|
  __enableCheckTyres_mod__
  __enableMaintenance_mod__
  __enableCheckStuck_mod__
  __enableHairpin_mod__
  __enableChicane_mod__
  __enableTurn_mod__
  __enableRemotePlaySizer_mod__
  debug_mode
)


GoTo EndModsDef

SaveMods:
  Gui, 3:Submit
  Loop, Parse, _mod_vars, |
  {
    IniWrite, % %A_LoopField%, config.ini, Mods, % A_LoopField
  }
return

EndModsDef:
