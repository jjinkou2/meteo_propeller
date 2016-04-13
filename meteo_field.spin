CON
' -----------------------------------------------------------------------------
' CONSTANTS, DEFINES, MACROS, ETC.   
' -----------------------------------------------------------------------------

  ' string processing constants
  MAX_Condition_LENGTH  = 100 ' max length of a condition' text, 99 plus a NULL
  MAX_IconName_LENGTH   = 20
  
Var
  byte Day[3]                   '    
  byte TMin                  ' temperature Min
  byte TMax                  ' temperature Max
  byte Condition[MAX_Condition_LENGTH]
  byte Icon[MAX_IconName_LENGTH]



CON
' -----------------------------------------------------------------------------
' GETTER METHODS FIRST, convention will be to prefix "read" methods with "_"   
' -----------------------------------------------------------------------------
PUB _Day
  return  (@Day) 

PUB _TMin
  return  TMin 

PUB _TMax
  return  TMax

PUB _Condition
  return ( @Condition )

PUB _Icon
  return (@Icon)

CON
' -----------------------------------------------------------------------------
' SETTER METHODS NEXT, convention will be to suffix "write" methods with "_"   
' -----------------------------------------------------------------------------

PUB Day_( pStrPtr )
  bytemove( @name, pStrPtr, strsize( pStrPtr ) + 1)

PUB Tmin_( pTmin )
  Tmin := pTmin
  
PUB Tmax_( pTmax )
  Tmax := pTmax
  
PUB Condition_( pStrPtr )

  if   strsize( pStrPtr ) + 1 <  MAX_Condition_LENGTH
    bytemove( @Condition, pStrPtr, strsize( pStrPtr ) + 1)
  else
    bytemove( @Condition, pStrPtr, MAX_Condition_LENGTH)
  
  

PUB Icon_( pStrPtr )
  if   strsize( pStrPtr ) + 1 <  MAX_IconName_LENGTH
    bytemove( @Icon, pStrPtr, strsize( pStrPtr ) + 1)
  else
    bytemove( @Icon, pStrPtr, MAX_IconName_LENGTH)
