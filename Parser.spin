'' =================================================================================================
''  library for parsing value
'' =================================================================================================

  SizeBUFFERXML   = 1500

OBJ

  PC            : "Parallax Serial Terminal Extended"
  STR           : "Strings2.2"

con
'' Digit conversion
'' =================================================================================================

pub ucase(c) 

'' Convert c to uppercase
'' -- does not modify non-alphas

  if ((c => "a") and (c =< "z"))
    c -= 32

  return c
  
pub asc2val(pntr) | c

'' Returns value of numeric string
'' -- binary (%) and hex ($) must be indicated

  repeat
    c := byte[pntr]
    case c 
      " ":                                                      ' skip leading space(s)    
        pntr++

      "-", "0".."9":                                            ' found decimal value
        return asc2dec(pntr, 11)

      "%":                                                      ' found binary value
        return bin2dec(pntr, 32)

      "$":                                                      ' found hex value
        return hex2dec(pntr, 8)
      
      other:                                                    ' abort on bad character
        return 0


pub asc2dec(spntr, n) | c, value, sign

'' Returns signed value from decimal string
'' -- pntr is pointer to decimal string
'' -- n is maximum number of digits to process

  if (n < 1)                                                    ' if bogus, bail out
    return 0
 
  repeat
    c := byte[spntr]
    case c 
      " ":                                                      ' skip leading space(s)
        spntr++

      "-", "0".."9":                                            ' found value
        if (c == "-")                                           ' sign symbol?
          sign := -1                                            '  yes, set sign
          spntr++                                               '  advance pointer
        else
          sign := 1                                             ' value is positive
        quit

      other:                                                    ' abort on bad character
        return 0
        
  value := 0

  n <#= 10                                                      ' limit chars in value  

  repeat while (n)
    c := byte[spntr++]                                          
    case c
      "0".."9":                                                 ' digit?
        value := (value * 10) + (c - "0")                       '  update value
        n--                                                     '  dec digits count

      "_":
        ' skip

      other:
        quit

  return sign * value     
  

pub bin2dec(spntr, n) | c, value

'' Returns value from {indicated} binary string
'' -- pntr is pointer to binary string
'' -- n is maximum number of digits to process

  if (n < 1)                                                    ' if bogus, bail out
    return 0
 
  repeat
    c := byte[spntr]
    case c 
      " ":                                                      ' skip leading space(s) 
        spntr++

      "%":                                                      ' found indicator
        spntr++                                                 '  move to value
        quit      

      "0".."1":                                                 ' found value
        quit

      other:                                                    ' abort on bad character
        return 0

  value := 0

  n <#= 32                                                      ' limit chars in value

  repeat while (n)                                                                      
    c := byte[spntr++]                                          ' get next character
    case c
      "0".."1":                                                 ' binary digit?
        value := (value << 1) | (c - "0")                       '  update value
        --n                                                     '  dec digits count

      "_":
        ' skip

      other:
        quit
    
  return value


pub hex2dec(pntr, n) | c, value

'' Returns value from {indicated} hex string
'' -- pntr is pointer to binary string
'' -- n is maximum number of digits to process

  if (n < 1)                                                    ' if bogus, bail out
    return 0
 
  repeat
    c := ucase(byte[pntr])
    case c 
      " ":                                                      ' skip leading space(s)
        pntr++

      "$":                                                      ' found indicator
        pntr++                                                  '  move to value
        quit  

      "0".."9", "A".."F":                                       ' found value
        quit
 
      other:                                                    ' abort on bad character
        return 0

  value := 0

  n <#= 8                                                       ' limit field width

  repeat while (n)
    c := ucase(byte[pntr++])
    case c
      "0".."9":                                                 ' digit?
        value := (value << 4) | (c - "0")                       '  update value
        --n                                                     '  dec digits count

      "A".."F":                                                 ' hex digit?
        value := (value << 4) | (c - "A" + 10) 
        --n

      "_":
        ' skip

      other:
        quit 

  return value
  
Con
'' XML Parser
'' =================================================================================================

Pub ParseXml () | i, tmpBuffer, pStrTxtVal 

  i:=ParseXml_Temp (@xmltxt,string("low data="),@TMin)

  tmpBuffer := Str.substr(xmltxt,i,strsize(xmltxt)-i)
  i:=ParseXml_Temp (tmpBuffer,string("high data="),@TMax)

{{  PC.Newline
  PC.str(string("tmpBuffer_1= "))
  PC.str(tmpBuffer)
 }}
  
  'tmpBuffer  := Str.substr(tmpBuffer,i,strsize(tmpBuffer)-i)
  'IconBuffer := ParseXml_strTxt (tmpBuffer,string("icon data="),@NextFieldIdx)

  tmpBuffer  := Str.substr(tmpBuffer,i,strsize(tmpBuffer)-i)
  ConditionBuffer := ParseXml_strTxt (tmpBuffer,string("condition data="),@NextFieldIdx)
  
  
  PC.Newline
  PC.str(string("pStringPtr = "))
  PC.str(@ConditionBuffer)  
  PC.Newline
  PC.str(string("NextFieldIdx = "))
  PC.dec(NextFieldIdx)  
  PC.Newline
  'PC.str(string("tmpBuffer_2= "))
  'PC.str(tmpBuffer)
 ' PC.Newline
  'PC.dec(TMin)
  
Pub ParseXml_Temp (xmlTmpBuffer,strField,Tmprtr) | i,j,k,index,tmpBuffer
{{
Exemple
xmbuffer = "<test> <low data="8"> </test>"
ParseXml_Temp (xmlbuffer,"low data=",@t)
output : t:=8 (decimal) and index of field
}}

  ' init
  k := STR.strpos(xmlTmpBuffer,strField,0)              ' index of field
  tmpBuffer := STR.StrStr(xmlTmpBuffer,strField,0)      ' cut the beginning of the string

  ' search for field
  i := STR.strpos(tmpBuffer,string(34),0)
  j := STR.strpos(tmpBuffer,string(34),i+1)

  bytefill(@txtBuffer,0,gWeather#MAX_Str_LENGTH)
  STR.strcopy(@txtBuffer,strBuffer,i+1, j-i-1)

  index := 0
  repeat while index + i + 1 < j
    TBuffer[index] := byte[tmpBuffer][index+i+1]
    index++
  TBuffer[index]:=0
  
  ' return the temperature 
  byte[Tmprtr] := PSR.asc2val(@TBuffer)           
  return j+k                                      ' used to position for the next field    

Pub ParseXml_strTxt (strAddr,strField,pNxtIdx) | i,j,k,strBuffer
{{
Return a string
PARAM:
  - xmlTmpBuffer                buffer xml to look into
  - strField                    field to look at
  - pNxtIdx                     index  to be used  for the next query 
Exemple
    xmbuffer = "<test> <low data="8"> </test>"
    Texte:= ParseXml_Temp (xmlbuffer,"low data=",@i)
  output : Texte = "8"
  i = 20
}}

  'PC.str(string(CR,LF,"tmpxml= "))
  'PC.str(xmlTmpBuffer)

  k:=  STR.strpos(strAddr,strField,0)
  
  strBuffer:=STR.StrStr(strAddr,strField,0)

  PC.str(string(CR,LF,"tmpBuf = "))
  PC.str(strBuffer)
   
  PC.str(string(CR,LF,"field = "))
  PC.str(strField)

  i := STR.strpos(strBuffer,string(34),0)
  j := STR.strpos(strBuffer,string(34),i+1)

  bytefill(@txtBuffer,0,gWeather#MAX_Str_LENGTH)
  STR.strcopy(@txtBuffer,strBuffer,i+1, j-i-1)

  
  byte[pNxtIdx] := j+k

  return txtBuffer

   