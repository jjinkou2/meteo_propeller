CON
' -----------------------------------------------------------------------------
' CONSTANTS, DEFINES, MACROS, ETC.   
' -----------------------------------------------------------------------------

  ' string processing constants
  MAX_Str_LENGTH  = 100 ' max length of a condition' text, 99 plus a NULL
  
VAR
  byte Day[4]                   '    
  byte Tmin                  ' temperature Min
  byte Tmax                  ' temperature Max
  byte Condition[MAX_Str_LENGTH]
  byte Icon[MAX_Str_LENGTH]
   


CON
' -----------------------------------------------------------------------------
' GETTER METHODS FIRST, convention will be to prefix "read" methods with "_"   
' -----------------------------------------------------------------------------
PUB _Day
  return  (@Day) 

PUB _Tmin
  return  Tmin 

PUB _Tmax
  return  Tmax

PUB _Condition
  return ( @Condition )

PUB _Icon
  return (@Icon)

CON
' -----------------------------------------------------------------------------
' SETTER METHODS NEXT, convention will be to suffix "write" methods with "_"   
' -----------------------------------------------------------------------------

PUB Day_( pStrPtr )
  if   strsize( pStrPtr ) + 1 =<  4
    bytemove( @Day, pStrPtr, strsize( pStrPtr ) + 1)
  else
    bytemove( @Day, pStrPtr, 4)

PUB Tmin_( pTmin )
  Tmin := pTmin
  
PUB Tmax_( pTmax )
  Tmax := pTmax
  
PUB Condition_( pStrPtr )

  if   strsize( pStrPtr ) + 1 <  MAX_Str_LENGTH
    bytemove( @Condition, pStrPtr, strsize( pStrPtr ) + 1)
  else
    bytemove( @Condition, pStrPtr, MAX_Str_LENGTH)
  
  

PUB Icon_( pStrPtr )
  if   strsize( pStrPtr ) + 1 <  MAX_Str_LENGTH
    bytemove( @Icon, pStrPtr, strsize( pStrPtr ) + 1)
  else
    bytemove( @Icon, pStrPtr, MAX_Str_LENGTH)