CON
  _clkmode        = xtal1 + pll16x              'Use crystal * 16
  _xinfreq        = 5_000_000                   '5MHz * 16 = 80 MHz


  CR              = 13
  LF              = 10

OBJ

  PC            : "Parallax Serial Terminal Extended"
  gWeather[2]   : "Meteo_field"            ' 3 days of Weather's Data  to save

PUB Main

  PC.Start(115_200)                           ' Start Parallax Serial Terminal
  PC.clear

  waitcnt(clkfreq *2 + cnt)      ' attente pour appui sur enable a enlever au finish


  InsertWeather (0,string ("Auj"),10, 32, string("Conditions bonnes"),string("Wind.gif"))


  printWeather (0)

PUB InsertWeather( pIndex, pDay, pTmin, pTmax, pStrConditionPtr, pStrIconPtr )
{{
DESCRIPTION: Inserts the sent record into the object storage array.
PARMS:       pIndex               - index of record to use.
             pTmin                - Tempr Min
             pTmax
             pHeight              - height in inches of person.
             pStrConditionPtr     - pointer to Condition weather string
             pStrIconPtr          - pointer to Icon string
RETURNS: nothing.
}}

  gWeather[ pIndex ].Day_( pDay )
  gWeather[ pIndex ].Tmin_( pTmin )
  gWeather[ pIndex ].Tmax_( pTmax )
  gWeather[ pIndex ].Condition_( pStrConditionPtr )
  gWeather[ pIndex ].Icon_( pStrIconPtr )

PUB PrintWeather( pIndex )
{{
DESCRIPTION: Prints the requested record to terminal.
PARMS: pIndex - index of record to pretty print to screen.
RETURNS: nothing.
}}


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
