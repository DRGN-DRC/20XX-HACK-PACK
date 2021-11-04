_GProc:

prolog rGObj, rData, rStatic, cr
  mr rGObj, r3                   # rGObj   = the GObj driving this GProc
  lwz rData, GObj.xData(rGObj)   # rData   = GObj instantiated data (in heap)
  lwz rStatic, 0x0(rData)        # rStatic = static read-only data inside of file

  # <-- write proc here

_GProc_return:
epilog
blr
