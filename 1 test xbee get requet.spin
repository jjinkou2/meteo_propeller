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
  SizeBUFFERXML   = 1500

  
Var
  long stack[50]                ' stack space for second cog
  byte xmlBuffer[SizeBUFFERXML] ' xmldata
  byte TMin[2]                  ' temperature Min
  byte TMax[2]                  ' temperature Min
  byte txtTst[2]
  
OBJ

  PC    : "Parallax Serial Terminal Extended"
  XB    : "XBee_Object_1"                              ' XBee communication methods
  STR   : "Strings2"
  PSR   : "Parser"
  
PUB Start

  XB.Start(XB_Rx, XB_Tx, 0, XB_Baud)          ' Propeller Comms - RX,TX, Mode, Baud
  XB.Delay(1000)                              ' One second delay
  PC.Start(PC_Baud)                           ' Start Parallax Serial Terminal
  PC.clear
  
  bytefill(@xmlBuffer, 0, SizeBUFFERXML)          ' Clear Buff to 0
  'bytefill(@tmpBuffer, 0, SizeBUFFERXML)          ' Clear Buff to 0

  'cognew(XB_to_PC,@stack)       ' Start cog for XBee--> PC comms
  waitcnt(clkfreq *2 + cnt)      ' attente pour appui sur enable a enlever au finish


  'PC.str (@xmltxt)
  'XB.str(string("GET  http://api.previmeteo.com/ceb69a13b07d44939f998680180d9c9e/ig/api?weather=paris,FR&hl=fr",CR,LF,CR,LF))                     ' Send a string

  'XB.Delay(500)                     ' One second delay
  'PC.str(string(CR,LF))

  ParseXml


Pub ParseXml | i, tmpBuffer ',j,index,Temperature[2], tmpBuffer,tmpBuffer1

  i:=ParseXml_Temp (@xmltxt,string("low data="),@TMin[0])

  tmpBuffer := Str.substr(xmltxt,i,strsize(xmltxt)-i)
 ' PC.str(string(CR,LF,"tmpBuffer= "))
  'PC.str(tmpBuffer)

  i:=ParseXml_Temp (tmpBuffer,string("high data="),@TMax[0])
  tmpBuffer := Str.substr(tmpBuffer,i,strsize(xmltxt)-i)
  PC.str(string(CR,LF,"tmpBuffer_2= "))
  PC.str(tmpBuffer)
 


  ' pretty print data
  PC.str(string(CR,LF,"Min="))
  PC.dec (TMin[0])
  PC.str(string(CR,LF,"Max="))
  PC.dec (TMax[0])

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
Pub ParseXml_Temp (xmlTmpBuffer,strField,Tmprtr) | i,j,k,index,Temperature[2], tmpBuffer
{{
Exemple
xmbuffer = "<test> <low data="8"> </test>"
ParseXml_Temp (xmlbuffer,"low data=")
output : 8 (decimal)
}}

  PC.str(string(CR,LF,"tmpxml= "))
  PC.str(xmlTmpBuffer)

  k:=  STR.strpos(xmlTmpBuffer,strField,0)
  
  tmpBuffer:=STR.StrStr(xmlTmpBuffer,strField,0)

  PC.str(string(CR,LF,"tmpBuf= "))
  PC.str(tmpBuffer)
   
  PC.str(string(CR,LF,"field= "))
  PC.str(strField)

  i := STR.strpos(tmpBuffer,string(34),0)
  j := STR.strpos(tmpBuffer,string(34),i+1)
  index := 0
  PC.str(string(CR,LF,"i="))
  PC.dec (i)
  PC.str(string(CR,LF,"j="))
  PC.dec (j)


  repeat while index + i + 1 < j
    Temperature[index] := byte[tmpBuffer][index+i+1]
    index++
  Temperature[index]:=0
  
  index:=0
  repeat while index<3
    PC.str(string(CR,LF,"Temperature["))
    PC.dec(index)
    PC.str(string("]="))
    PC.dec(Temperature[index])
    index++

  'PC.str(string(CR,LF,"Temperature = "))
  'PC.str(@Temperature)
  'PC.str(PSR.asc2val(@Temperature))
  'txtTst:= string("14")
  'PC.char(txtTst)
   
  byte[Tmprtr] := PSR.asc2val(@Temperature)
'  PC.str(string(CR,LF,"tmpxml_2= "))
 ' PC.str(xmlTmpBuffer)
 ' PC.str(string(CR,LF,"field_2= "))
 ' PC.str(strField)

  return j+k    
  'return  PSR.asc2val(@Temperature)


Dat

  xmltxt      byte  "<xml_api_reply version=",34,"1",34,">  <weather module_id=",34,"0",34," tab_id=",34,"0",34,">          <forecast_information>                  <!-- Some inner tags containing data about the city found, time and unit-stuff -->                      <city data=",34,"Paris, FR",34,"/>                      <postal_code data=",34,34,"/>                        <latitude_e6 data=",34,34,"/>                        <longitude_e6 data=",34,34,"/>                       <forecast_date data=",34,"2016-04-11",34,"/>                    <current_date_time data=",34,"2016-04-11 11:11:37 +0200",34,"/>                 <unit_system data=",34,"fr",34,"/>              </forecast_information>         <current_conditions>                    <!-- Some inner tags containing data of current weather -->                     <condition data=",34,"Risque de Pluie",34,"/>                   <temp_f data=",34,"52",34,"/>                   <temp_c data=",34,"11",34,"/>                   <humidity data=",34,"Humidité: 88%",34,"/>                      <icon data=",34,"/images/weather/chance_of_rain.gif",34,"/>                     <wind_condition data=",34,"Vent: SE de 7 km/h",34,"/>           </current_conditions><forecast_conditions>                      <!-- Some inner tags containing data about future weather -->                   <day_of_week data=",34,"Auj",34,"/>                     <low data=",34,"38",34,"/>                       <high data=",34,"14",34,"/>                     <icon data=",34,"/images/weather/mist.gif",34,"/>                       <condition data=",34,"Pluie Fine",34,"/>                        </forecast_conditions><forecast_conditions>                     <!-- Some inner tags containing data about future weather -->                   <day_of_week data=",34,"Mar",34,"/>                     <low data=",34,"6",34,"/>                       <high data=",34,"14",34,"/>                     <icon data=",34,"/images/weather/mist.gif",34,"/>                       <condition data=",34,"Pluie Fine",34,"/>                        </forecast_conditions><forecast_conditions>                     <!-- Some inner tags containing data about future weather -->                   <day_of_week data=",34,"Mer",34,"/>                     <low data=",34,"8",34,"/>                       <high data=",34,"16",34,"/>                     <icon data=",34,"/images/weather/mist.gif",34,"/>                       <condition data=",34,"Pluie Fine",34,"/>                        </forecast_conditions><forecast_conditions>                     <!-- Some inner tags containing data about future weather -->                   <day_of_week data=",34,"Jeu",34,"/>                     <low data=",34,"7",34,"/>                       <high data=",34,"14",34,"/>                     <icon data=",34,"/images/weather/rain.gif",34,"/>                       <condition data=",34,"Pluie",34,"/>                     </forecast_conditions></weather></xml_api_reply>",0     