CON
  #0, XPOS, YPOS, WIDTH, HEIGHT
  RET_STRUCT_SIZE = 4

PUB doSomething( retStructAddr, par1 )
  long[ retStructAddr ][ XPOS ] := 10
  long[ retStructAddr ][ YPOS ] := 10
  long[ retStructAddr ][ WIDTH ] := par1*3
  long[ retStructAddr ][ HEIGHT ] := par1*3
