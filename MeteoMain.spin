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

  bytefill(@xmlBuffer, 0, SizeBUFFERXML)          ' Clear Buff to 0

  cognew(XB_to_PC,@stack)       ' Start cog for XBee--> PC comms

  PC.str(string(CR,"Please wait 3s . Retrieving Data....",CR))

  XB.str(@httpget)                     ' Send a string

  XB.Delay(3000)                     ' 5 second delay

  PC.str(string(CR,"xml recu= "))
  PC.str(@xmlbuffer)

  startIdx := STR.StrPos(@xmlbuffer,string("<forecast_conditions>"),0) ' cut the header until the forecast tag

  PC.str(string(CR,CR, "startIdx= "))
  PC.dec(startIdx)


  PC.str(string(CR,CR, "day_of_week position= "))
  PC.dec(STR.StrPos(@xmlbuffer,string("day_of_week data="),startIdx))

  PSR.GetXMLAttribs (@Days,LENDAY,@xmlbuffer,string("day_of_week data="),startIdx)
  PSR.GetXMLAttribs (@Tmin,3,@xmlbuffer,string("low data="),startIdx)
  PSR.GetXMLAttribs (@Tmax,3,@xmlbuffer,string("high data="),startIdx)
  PSR.GetXMLAttribs (@Conditions,LENSTRING,@xmlbuffer,string("<condition data="),startIdx)
  PSR.GetXMLAttribs (@Icons,LENSTRING,@xmlbuffer,string("<icon data="),startIdx)

  PrintAttribs


Pub XB_to_PC  | i , c1

  XB.rxFlush                    ' Empty buffer for data from XB
  c1:=0
  
  repeat  while (XB.rxCheck)==-1    'wait for data
  
  repeat 700                            ' skip 700 bytes of unusefull xml header
    XB.rx
    
  ' Put all data received in Buffer
  repeat i from 0 to  SizeBUFFERXML - 1
     c1:=XB.rx
     if c1==$C3                    ' convert é from http (C3 A9) to ascii (E9)
        xmlBuffer[i]:=$E9
        XB.rx                      ' skip A9
     else
        xmlBuffer[i]:=c1


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

DAT

' http request  
  httpget byte "GET  http://api.previmeteo.com/"
  apikey  byte "ceb69a13b07d44939f998680180d9c9e"
          byte "/ig/api?weather="
  city    byte "paris"
  lang    byte ",FR&hl=fr",CR,LF,CR,LF,0