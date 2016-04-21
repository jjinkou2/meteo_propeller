CON
  _clkmode        = xtal1 + pll16x              'Use crystal * 16
  _xinfreq        = 5_000_000                   '5MHz * 16 = 80 MHz

  CR              = 13
  LF              = 10

  weatherParamCount = 5

OBJ

  PC            : "Parallax Serial Terminal Extended"


CON
' weather structure
  We_Tmin = 0                 ' temperature Min
  We_Tmax = 1                 ' temperature Max
  We_Day  = 2                 ' pointer to day
  We_Condition = 6            ' pointer to condition
  We_Icon = 10                 ' pointer to Icon

VAR
' DayWeather ptr
  byte ToDayWeather[14]
  byte Tomorrow[14]

PUB Main

   PC.Start(115_200)                           ' Start Parallax Serial Terminal
   PC.clear

    InsertDayRec(@ToDayWeather,12,40,string ("Auj"), string("Conditions bonnes"),string("Wind.gif"))
    InsertDayRec(@Tomorrow,5,10,string ("Dem"), string("Conditions pluvieuses"),string("Rain.gif"))

    Print_ptrDayWeather(ToDayWeather)
    Print_ptrDayWeather(Tomorrow)

PUB InsertDayRec(ptrDayWeather, Tmin, Tmax,ptrDay,ptrCondition,ptrIcon)
  byte[ptrDayWeather][We_Tmin]:=Tmin
  {long[ptrDayWeather+We_Tmax]:=Tmax
  long[ptrDayWeather+We_Day]:=ptrDay
  long[ptrDayWeather+We_Condition]:=ptrCondition
  long[ptrDayWeather+We_Icon]:=ptrIcon
}
PUB Print_ptrDayWeather (ptrDayWeather)
{    PC.str(string(CR,CR))
    PC.str(string("Day: "))
    PC.str( long[ptrDayWeather][2] )
}
    PC.str(string(CR))
    PC.str(string("Tmin: "))
    PC.dec( byte[ptrDayWeather][We_Tmin] )
{
    PC.str(string(CR))
    PC.str(string("TMax: "))
    PC.dec( long[ptrDayWeather][1] )

    PC.str(string(CR))
    PC.str(string("Condition: "))
    PC.str( long[ptrDayWeather][3] )

    PC.str(string(CR))
    PC.str(string("Icon: "))
    PC.str( long[ptrDayWeather][4] )
}

