CON
  _clkmode        = xtal1 + pll16x              'Use crystal * 16
  _xinfreq        = 5_000_000                   '5MHz * 16 = 80 MHz


  CR              = 13
  LF              = 10

  MAX_Str_LENGTH    = 100 ' max length of a condition' text, 99 plus a NULL
  weatherParamCount = 5
  NbDays            = 3    ' Today + 2 days of forecast weather


OBJ

  PC            : "Parallax Serial Terminal Extended"


VAR
' weather structure
  long We_Tmin                  ' temperature Min
  long We_Tmax                  ' temperature Max
  long We_Day                   ' pointer to day
  long We_Condition             ' pointer to condition
  long We_Icon                  ' pointer to Icon

' String arrays for  weather's pointers
  byte day[4]                   ' string array of day
  byte Condition[MAX_Str_LENGTH] 'string array
  byte Icon[MAX_Str_LENGTH]

' DayWeather ptr
  long DayWeather
  long Demain

' Table of forecast weather
  long fcw[NbDays]

DAT
  weatherparams     long    10  ' Tmin
                    long    30  ' Tmax
                    long    0   ' Day
                    long    0   ' Condition
                    long    0   ' Icon
PUB Main

   PC.Start(115_200)                           ' Start Parallax Serial Terminal
   PC.clear

   {  ' waitcnt(clkfreq *2 + cnt)      ' attente pour appui sur enable a enlever au finish

    PC.Str(string(CR))
    PC.str(string("Weather test"))
    Init
    PrintDayWeather

    PC.Str(string(CR,CR))
    PC.str(string("2nd test"))
}

    InsertDayRec(@DayWeather,12,40,string ("Auj"), string("Conditions bonnes"),string("Wind.gif"))
    'InsertWeaRec(0,fcw,DayWeather)

    InsertDayRec(@Demain,5,10,string ("Dem"), string("Conditions pluvieuses"),string("Rain.gif"))
    'InsertWeaRec(1,fcw,Demain)

    Print_ptrDayWeather(DayWeather)
    Print_ptrDayWeather(Demain)

'    Print_ptrDayWeather(DayWeather)
{    InsertDayRec(long[fcw][0],12,40,string ("Auj"), string("Conditions bonnes"),string("Wind.gif"))
    PC.str(string(CR,CR, "Forecast weather",CR))
    Print_ptrDayWeather(fcw[0])
}
'    PC.str(string(CR,CR))
 '   Print_ptrDayWeather(fcw[1])
    'PrintForecastWeather(0)

PUB Init
    longmove(@We_Tmin,@weatherparams,weatherParamCount) ' init structure
    We_Day       := string("Dam")                       ' 1st possibility
    bytemove(@Condition,string("Bonne"),6)              ' 2nd possibility
    bytemove(@Icon,string("toto"),5)
    We_Condition := @Condition
    We_Icon      := @Icon


PUB InsertDayRec(ptrDayWeather, Tmin, Tmax,ptrDay,ptrCondition,ptrIcon)
    We_Tmin      := Tmin
    We_Tmax      := Tmax
    We_Day       := ptrDay
    We_Condition := ptrCondition
    We_Icon      := ptrIcon
    'long[ptrDayWeather] := @We_Tmin
    longmove(long[ptrDayWeather],@We_Tmin,weatherParamCount)


PUB InsertWeaRec(Index,ptrDestFcWeather, ptrFromDayWeather):okay
    if Index > 2
        return -1
    else
        'longmove(@We_Tmin,ptrFromDayWeather,weatherParamCount)
        ptrDestFcWeather[Index] := ptrFromDayWeather
        return 0

PUB PrintDayWeather
    PC.str(string(CR))
    PC.str(string("Day: "))
    PC.str( We_Day )

    PC.str(string(CR))
    PC.str(string("TMin: "))
    PC.dec( We_Tmin )

    PC.str(string(CR))
    PC.str(string("TMax: "))
    PC.dec( We_Tmax )

    PC.str(string(CR))
    PC.str(string("Condition: "))
    PC.str( We_Condition )

    PC.str(string(CR))
    PC.str(string("Icon: "))
    PC.str( We_Icon )

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


