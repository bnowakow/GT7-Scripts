GoTo EndRace_Tokyo_Def

Race_Tokyo()
{
  SetTimer, CheckTyresOverheating, 1000

  ;;;;;;;;;;;;;;;;;;;;;; LAP 1 to 12 ;;;;;;;;;;;;;;;;;;;;;;

  ;ToolTip, TEMPLATE, 100, 100, Screen

  ToolTip, Accel_On(100), 100, 100, Screen
  Accel_On(100)
  Nitrous_On()

  loop, 15{
    Press_X(delay:=200)
    Press_Up(delay:=200)
  }
  Sleep, 12000
  loop{

    ToolTip, Looking for chicane, 100, 100, Screen
    loop {
      gosub, CheckChicane

      if( Chicane_complete = true)
        break
      Sleep(100)
    }
    Sleep(1550)
    Nitrous_Off()
    Accel_Off()
    Turn_Left(1500,15)
    ToolTip, Nitrous Accel_On, 100, 100, Screen
    Accel_On(100)
    Nitrous_On()
    gosub, ResetChicane
    Sleep(30000)
    ToolTip, Looking for hairpin, 100, 100, Screen
      loop
    {
      gosub, CheckHairpin

      /*
  		if (tyres_overheating)
  		{
  			  ToolTip, Running Unstuck Routine - fingers crossed, 100, 100, Screen
          Goto, Unstuck
          return
      }
      */

      ;Turn_Left(300, 30)
      if( hairpinCount = 1 )
        break
      Sleep(100)
    }
    Sleep(1000)
    Turn_Left(3000, 25)
    Turn_Left(1000, 40)
    Sleep(4000)
    Turn_Left(1000, 20)
    loop
    {
      gosub, CheckHairpin

      /*
  		if (tyres_overheating)
  		{
  			  ToolTip, Running Unstuck Routine - fingers crossed, 100, 100, Screen
          Goto, Unstuck
          return
      }
      */

      Press_X(delay:=200)
      Press_Up(delay:=200)
      ;Turn_Left(300, 30)
      if( hairpinCount = 2 ){
        gosub, ResetHairpin
        break
      }
      Sleep(100)
    }
    Turn_Right(6000, 85)
    Turn_Right(15000, 75)
    Sleep, 20000

  }
}

EndRace_Tokyo_Def:
