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

' table of forecast weather
  long fcw[NbDays*weatherParamCount]

DAT
  weatherparams     long    10  ' Tmin
                    long    30  ' Tmax
                    long    0   ' Day
                    long    0   ' Condition
                    long    0   ' Icon
PUB Main
    Init
    PrintDayWeather
    InsertDayRec(@DayWeather,12,40,string ("Auj"), string("Conditions bonnes"),string("Wind.gif"))
    InsertWeaRec(0,@fcw,DayWeather)
    PrintForecastWeather(0)

PUB Init
    longmove(@We_Tmin,@weatherparams,weatherParamCount) 'init structure
    We_Day       := @day
    We_Condition := @Condition
    We_Icon      := @Icon

PUB InsertDayRec(ptrDayWeather, Tmin, Tmax,ptrDay,ptrCondition,ptrIcon)
    We_Tmin      := Tmin
    We_Tmax      := Tmax
    We_Day       := ptrDay
    We_Condition := ptrCondition
    We_Icon      := ptrIcon
    longmove(ptrDayWeather,@We_Tmin,weatherParamCount)


PUB InsertWeaRec(Index,ptrDestFcWeather, ptrFromDayWeather):okay
    if Index > 2
        return -1
    else
        'longmove(@We_Tmin,ptrFromDayWeather,weatherParamCount)
        long[ptrDestFcWeather][Index] := ptrFromDayWeather
        return 0

PUB PrintDayWeather
    PC.str(string(CR))
    PC.str(string("Day: "))
    PC.str( gWeather[ pIndex ]._Day )

    PC.str(string(CR))
    PC.str(string("TMin: "))
    PC.dec( gWeather[ pIndex ]._TMin )

    PC.str(string(CR))
    PC.str(string("TMax: "))
    PC.dec( gWeather[ pIndex ]._TMax )

    PC.str(string(CR))
    PC.str(string("Condition: "))
    PC.str( gWeather[ pIndex ]._Condition )

    PC.str(string(CR))
    PC.str(string("Icon: "))
    PC.str( gWeather[ pIndex ]._Icon )

