{{
************************
* XML Get Attrib v0.1
************************
* Created by Laurent Pose
* Created 28/04/2016 (April 28, 2016)
* See end of file for terms of use.
************************
*

* v0.1  - 15/04/15 - Creation
************************

â”Œ---------------------------------------------------------------------------------------------------â”
| This Obj finds XML attributes and put them into a list of string                                  |
| suppose you have an xml text that provides informations inside attributes like                    |
|                                                                                                   |
|                 <test>                                                                            |
|                    <Day data="Auj">                                                               |
|                    <Day data="Tom">                                                               |
|                 </test>"                                                                          |
|                                                                                                   |
|  GetXMLATTRIBs will extract all attributes values. Results are stored into an array of strings.   |
|                                                                                                   |
|  Days  = "Auj\0Tom\0"                                                                             |
|                                                                                                   |
â””---------------------------------------------------------------------------------------------------â”˜

           â”Œ--> get starting position
â”Œâ”€â”€â”€â”€â”€â”€â”€-â” â”‚                                                                    â”Œ---> Days
â”‚ xmltxt â”‚-â”˜         ï‚¢                                                          â”‚
â””â”€â”€â”€â”€â”€â”€-â”€â”˜ â”‚                     â”Œ--store in global value--â”  dispatch function â”‚
           â””--> ParseXMLTxt ---> |     Values_Array        â”‚--------------------â”¼---> Conditions
                                 â””-------------------------â”˜   GetXMLAttribs    â”‚
                                                                                â”‚
                                                                                â””---> Icons

NOTE: This file uses a modified version of OBJ string. I added a string copy function

}}

CON
  LENSTRING       = 80                          ' Max lenght for each extracted value
  NBVALUE         = 3                           ' Look for only 3 values
  LENDAY          = 4

VAR

  byte Values_Array[NBVALUE*LENSTRING]           ' stores NBVALUE values string

OBJ
  STR           : "Strings2.2"
  PC            : "Parallax Serial Terminal Extended"

PUB GetXMLAttribs (DestAttribs,len,ptrXML,strAttrib,startIdx):found | i
{{
Return a list of attributes from xml beginning at 'start'
PARAM:
  output:
  - DestAttribs                return list of attributes
  - return                     0 = found,  -1 = not found

  input:
  - len                        Lenght of the attributes
  - ptrXML                     xml string to look into
  - strAttrib                  field to look for
  - startIdx                    start address


Exemple
    LenDayStr = 4
    byte Days[3*LenDayStr]   ' 3 days
    xmbuffer = "<test> <Day data="Auj"> <Day data="Tom"></test>"
    GetXMLAttribs (@Days,3,@xmltxt,string("day_of_week data="))

    output : Days  = "Auj\0Tom\0"
             result = 0

}}

  if (ParseXml_Str(ptrXML,strAttrib,startIdx)==true)
    repeat i from 0 to NBVALUE-1
        STR.strcopy(DestAttribs+i*len,@Values_Array[i*LENSTRING],0, len)   ' 2 possibilities of addressing
    return true
  else
    return false

Pub ParseXml_Str (strAddr,strField,startIdx):found | i,j,k,strBuffer

{{
Return a string array containing all the values beginning at 'start'
All the values are saved into the global array : Values_Array

PARAM:
  - strAddr                     xml string to look into
  - strField                    field to look for
  - startIdx                    start address
  - found                       0 = found,  -1 = not found

Extraction is limited to NBVALUE

Exemple

    xmbuffer = "<test> <Day data="Auj"> <Day data="Tom"></test>"
    result := ParseXml_Temp (xmlbuffer,"Day data=",1)

    output : TokenAdr  = [pointer to "Day" , pointer to "Tom"]
             result = 0

}}

  i := 0                                        ' index of first quote : <field="value"/>
  j := 0                                        ' index of last  quote

  strBuffer := STR.StrStr(strAddr,strField,startIdx) ' cut the string until field (some field could have been in the header)
                                                ' we removed the header
                                                ' return false if not found
  k := 0

  repeat while (k < NBVALUE) 'or (strBuffer <> FALSE)
 ' repeat while (k<3)
    i := STR.strpos(strBuffer,string(34),0)+1   ' find letter inside 1rst quote : "->A<-uj"
    j := STR.strpos(strBuffer,string(34),i)-1   ' find last letter : "Au->j<-"

    STR.strcopy(@Values_Array[k*LENSTRING],strBuffer,i, j-i+1)

    ' prepare next loop
    strBuffer := STR.StrStr(strBuffer,strField,j)   ' cut the string until field
    k++
    ' repeat end


  ' End of function =>  result
  if (strBuffer==false) and  (k==NBVALUE)
    found := false                                   ' No field inside xml
  else
    found := true


