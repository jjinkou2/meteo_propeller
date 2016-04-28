CON

  _clkmode        = xtal1 + pll16x              'Use crystal * 16
  _xinfreq        = 5_000_000                   '5MHz * 16 = 80 MHz

  ' Set pins and Baud rate for XBee comms
  XB_Rx           = 7                 ' XBee DOUT
  XB_Tx           = 6                 ' XBee Din
  XB_Baud         = 9600

  ' Set pins and baud rate for PC comms
  PC_Baud         = 115_200

  CR              = 13
  LF              = 10

  LENSTRING       = PSR#LENSTRING             ' Max lenght for each extracted value
  LENDAY          = PSR#LENDAY
  NBVALUE         = PSR#NBVALUE               ' Look for only 3 values

  SizeBUFFERXML   = 1500

OBJ

  PC            : "Parallax Serial Terminal Extended"
  XB            : "XBee_Object_1"           'XBee communication methods
  STR           : "Strings2.2"
  PSR           : "Parser"

Var
  long stack[50]                ' stack space for second cog
  byte TMin[NBVALUE*3]                           ' stores temperature in string
  byte TMax[NBVALUE*3]
  byte Days[NBVALUE*LENDAY]
  byte Conditions[NBVALUE*LENSTRING]
  byte Icons[NBVALUE*LENSTRING]

  byte xmlBuffer[SizeBUFFERXML] ' xmldata

PUB Start | startIdx

  XB.Start(XB_Rx, XB_Tx, 0, XB_Baud)          ' Propeller Comms - RX,TX, Mode, Baud
  XB.Delay(1000)                              ' One second delay
  PC.Start(PC_Baud)                           ' Start Parallax Serial Terminal

  'bytefill(@xmlBuffer, 0, SizeBUFFERXML)          ' Clear Buff to 0
  'bytefill(@tmpBuffer, 0, SizeBUFFERXML)          ' Clear Buff to 0

  'cognew(XB_to_PC,@stack)       ' Start cog for XBee--> PC comms
  'XB.str(string("GET  http://api.previmeteo.com/ceb69a13b07d44939f998680180d9c9e/ig/api?weather=paris,FR&hl=fr",CR,LF,CR,LF))                     ' Send a string

  'XB.Delay(500)                     ' One second delay

  startIdx := STR.StrPos(@xmltxt,string("<forecast_conditions>"),0) ' cut the header until the forecast tag

  PSR.GetXMLAttribs (@Days,LENDAY,@xmltxt,string("day_of_week data="),startIdx)
  PSR.GetXMLAttribs (@Tmin,3,@xmltxt,string("low data="),startIdx)
  PSR.GetXMLAttribs (@Tmax,3,@xmltxt,string("high data="),startIdx)
  PSR.GetXMLAttribs (@Conditions,LENSTRING,@xmltxt,string("<condition data="),startIdx)
  PSR.GetXMLAttribs (@Icons,LENSTRING,@xmltxt,string("<icon data="),startIdx)

  PrintAttribs


Pub XB_to_PC  | c, i,tmpBuffer

  XB.rxFlush                    ' Empty buffer for data from XB

  repeat  while (c:= XB.rxCheck)==-1    'wait for data

  ' Put all data received in Buffer
  xmlBuffer[0]:=c
  i:=1
  repeat until i > SizeBUFFERXML
    xmlBuffer[i]:=XB.rx
    i++

  ' parse data
  'PC.str(string (CR,LF,"quoteindex="))
  tmpBuffer:=STR.StrStr(@xmlBuffer,string("low data="),0)

PUB PrintAttribs | i
  repeat i from 0 to NBVALUE-1
        PC.str(string(CR,CR,"Day["))
        PC.dec(i)
        PC.str(string("]="))
        PC.str(@Days[i*LENDAY])

        PC.str(string(CR,"Tmin["))
        PC.dec(i)
        PC.str(string("]="))
        PC.str(@Tmin[i*3])

        PC.str(string(CR,"Tmax["))
        PC.dec(i)
        PC.str(string("]="))
        PC.str(@Tmax[i*3])

        PC.str(string(CR,"Conditions["))
        PC.dec(i)
        PC.str(string("]="))
        PC.str(@Conditions[i*LENSTRING])

        PC.str(string(CR,"Icons["))
        PC.dec(i)
        PC.str(string("]="))
        PC.str(@Icons[i*LENSTRING])
{{
Pub XB_to_PC  | c, i,j, tmpBuffer,tmpBuffer1

  XB.rxFlush                    ' Empty buffer for data from XB

  repeat  while (c:= XB.rxCheck)==-1    'wait for data

  ' Put all data received in Buffer
  xmlBuffer[0]:=c
  i:=1
  repeat until i > SizeBUFFERXML
    xmlBuffer[i]:=XB.rx
    i++
  i:=0

  ' parse data
  'PC.str(string (CR,LF,"quoteindex="))
  tmpBuffer:=STR.StrStr(@xmlBuffer,string("low data="),0)
  PC.str(tmpBuffer)
  i:=STR.strpos(tmpBuffer,string(34),0)
  j:=STR.strpos(tmpBuffer,string(34),i+1)

  TMin[0]:=PSR.asc2val(STR.Parse(tmpBuffer,i+1,j-i-1))

  tmpBuffer1:=STR.StrStr(@tmpBuffer,string("high data="),0)
  PC.str(tmpBuffer1)
  i:=STR.strpos(tmpBuffer1,string(34),0)
  j:=STR.strpos(tmpBuffer1,string(34),i+1)

  TMax[0]:=PSR.asc2val(STR.Parse(tmpBuffer1,i+1,j-i-1))



  ' pretty print data
  PC.str(string(CR,LF,"Min="))
  PC.dec (TMin[0])
  PC.str(string(CR,LF,"Max="))
  PC.dec (TMax[0])
}}

                                                   ' return destination

Dat

  xmltxt      byte  "<xml_api_reply version=",34,"1",34,">"
              byte  "  <weather module_id=",34,"0",34," tab_id=",34,"0",34,">"
              byte  "      <forecast_information>"
              byte  "         <!-- Some inner tags containing data about the city found, time and unit-stuff -->"
              byte  "         <city data=",34,"Paris, FR",34,"/>"
              byte  "         <postal_code data=",34,34,"/>"
              byte  "         <latitude_e6 data=",34,34,"/>"
              byte  "         <longitude_e6 data=",34,34,"/>"
              byte  "         <forecast_date data=",34,"2016-04-11",34,"/>"
              byte  "         <current_date_time data=",34,"2016-04-11 11:11:37 +0200",34,"/>"
              byte  "         <unit_system data=",34,"fr",34,"/>"
              byte  "      </forecast_information>"
              byte  "      <current_conditions>"
              byte  "         <!-- Some inner tags containing data of current weather -->"
              byte  "         <condition data=",34,"Risque de Pluie",34,"/>"
              byte  "         <temp_f data=",34,"52",34,"/>"
              byte  "         <temp_c data=",34,"11",34,"/>"
              byte  "         <humidity data=",34,"Humidit�: 88%",34,"/>"
              byte  "         <icon data=",34,"/images/weather/chance_of_rain.gif",34,"/>"
              byte  "         <wind_condition data=",34,"Vent: SE de 7 km/h",34,"/>"
              byte  "      </current_conditions>"
              byte  "      <forecast_conditions>"
              byte  "         <!-- Some inner tags containing data about future weather -->"
              byte  "         <day_of_week data=",34,"Auj",34,"/>"
              byte  "         <low data=",34,"38",34,"/>"
              byte  "         <high data=",34,"14",34,"/>"
              byte  "         <icon data=",34,"/images/weather/rain.gif",34,"/>"
              byte  "         <condition data=",34,"Pluie  auj Fine",34,"/>"
              byte  "      </forecast_conditions>"
              byte  "      <forecast_conditions>"
              byte  "         <!-- Some inner tags containing data about future weather -->"
              byte  "         <day_of_week data=",34,"Mar",34,"/>"
              byte  "         <low data=",34,"6",34,"/>"
              byte  "         <high data=",34,"14",34,"/>"
              byte  "         <icon data=",34,"/images/weather/mist.gif",34,"/>"
              byte  "         <condition data=",34,"Pluie  mar Fine",34,"/>"
              byte  "      </forecast_conditions>"
              byte  "      <forecast_conditions>"
              byte  "         <!-- Some inner tags containing data about future weather -->"
              byte  "         <day_of_week data=",34,"Mer",34,"/>"
              byte  "         <low data=",34,"8",34,"/>"
              byte  "         <high data=",34,"16",34,"/>"
              byte  "         <icon data=",34,"/images/weather/mist.gif",34,"/>"
              byte  "         <condition data=",34,"Pluie  mer Fine",34,"/>"
              byte  "      </forecast_conditions>"
              byte  "      <forecast_conditions>"
              byte  "         <!-- Some inner tags containing data about future weather -->"
              byte  "         <day_of_week data=",34,"Jeu",34,"/>"
              byte  "         <low data=",34,"7",34,"/>"
              byte  "         <high data=",34,"14",34,"/>"
              byte  "         <icon data=",34,"/images/weather/rain.gif",34,"/>"
              byte  "         <condition data=",34,"Pluie jeu ",34,"/>"
              byte  "      </forecast_conditions>"
              byte  "    </weather>"
              byte  "</xml_api_reply>",0


{{
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
}}
