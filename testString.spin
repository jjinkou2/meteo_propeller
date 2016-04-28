CON

  _clkmode        = xtal1 + pll16x              'Use crystal * 16
  _xinfreq        = 5_000_000                   '5MHz * 16 = 80 MHz


  ' Set pins and baud rate for PC comms
  PC_Baud         = 115_200

  CR              = 13
  CS              = 16
OBJ

  PC            : "Parallax Serial Terminal Extended"
  STR           : "Strings2.2"

DAT
  text  byte "ABCDEFGHIJK",0

PUB Main | tmpStr
  PC.Start(115_200)                           ' Start Parallax Serial Terminal
  PC.clear

  PC.str(string(CR,CR,"String: ABCDEFGHIJK"))
  PC.str(string(CR,"Result: "))
  tmpStr := STR.StrStr(string("ABCDEFGHIJK"),string("GH"),0)
  if tmpStr <> FALSE
    PC.str(STR.StrStr(tmpStr,string("IJ"),0))
  else
    PC.str(string("NOT FOUND"))

