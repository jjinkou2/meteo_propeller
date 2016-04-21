CON
  _clkmode        = xtal1 + pll16x              'Use crystal * 16
  _xinfreq        = 5_000_000                   '5MHz * 16 = 80 MHz

  CR              = 13
  LF              = 10

  weatherParamCount = 5

OBJ

  PC            : "Parallax Serial Terminal Extended"


VAR
' weather structure
  long We_Tmin                  ' temperature Min
  long We_Tmax                  ' temperature Max
  long We_Day                   ' pointer to day
  long We_Condition             ' pointer to condition
  long We_Icon                  ' pointer to Icon

' DayWeather ptr
  long ToDayWeather[weatherParamCount]
  long Tomorrow[weatherParamCount]

PUB Main

   PC.Start(115_200)                           ' Start Parallax Serial Terminal
   PC.clear

    InsertDayRec(@ToDayWeather,12,40,string ("Auj"), string("Conditions bonnes"),string("Wind.gif"))
    InsertDayRec(@Tomorrow,5,10,string ("Dem"), string("Conditions pluvieuses"),string("Rain.gif"))


    Print_ptrDayWeather(ToDayWeather)
    Print_ptrDayWeather(Tomorrow)

PUB InsertDayRec(ptrDayWeather, Tmin, Tmax,ptrDay,ptrCondition,ptrIcon)
    We_Tmin      := Tmin
    We_Tmax      := Tmax
    We_Day       := ptrDay
    We_Condition := ptrCondition
    We_Icon      := ptrIcon
    'long[ptrDayWeather] := @We_Tmin
    longmove(long[ptrDayWeather],@We_Tmin,weatherParamCount)

PUB Print_ptrDayWeather (ptrDayWeather)
    PC.str(string(CR,CR))
    PC.str(string("Day: "))
    PC.str( long[ptrDayWeather][2] )

    PC.str(string(CR))
    PC.str(string("Tmin: "))
    PC.dec( long[ptrDayWeather][0] )

    PC.str(string(CR))
    PC.str(string("TMax: "))
    PC.dec( long[ptrDayWeather][1] )

    PC.str(string(CR))
    PC.str(string("Condition: "))
    PC.str( long[ptrDayWeather][3] )

    PC.str(string(CR))
    PC.str(string("Icon: "))
    PC.str( long[ptrDayWeather][4] )


