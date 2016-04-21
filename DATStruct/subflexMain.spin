CON
  _clkmode        = xtal1 + pll16x              'Use crystal * 16
  _xinfreq        = 5_000_000                   '5MHz * 16 = 80 MHz


OBJ

  PC    : "Parallax Serial Terminal Extended"

  subf  :   "SubFlexTest"

VAR
  long    ret_struct[ subf#RET_STRUCT_SIZE ]

PUB main
  PC.Start(115_200)                           ' Start Parallax Serial Terminal
  subf.doSomething( @ret_struct, 10 )

  PC.dec( ret_struct[ subf#XPOS ] )
  PC.dec( ret_struct[ subf#YPOS ] )
  PC.dec( ret_struct[ subf#WIDTH ] )
