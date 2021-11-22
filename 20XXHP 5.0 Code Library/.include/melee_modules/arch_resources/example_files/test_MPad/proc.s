punkpc str

# The default MPad proc only tests onpress DPad buttons:
ifdef test_MPad_DUp.is_str
.if ndef; str test_MPad_DUp "example_files/test_MPad/nop.s"; .endif
ifdef test_MPad_DDown.is_str
.if ndef; str test_MPad_DDown "example_files/test_MPad/nop.s"; .endif
ifdef test_MPad_DLeft.is_str
.if ndef; str test_MPad_DLeft "example_files/test_MPad/nop.s"; .endif
ifdef test_MPad_DRight.is_str
.if ndef; str test_MPad_DRight "example_files/test_MPad/nop.s"; .endif

_GProc:
prolog rGObj, rMPad, rPress, rData, rStatic, cr
  mr rGObj, r3
  lwz rData, GObj.xData(rGObj)
  lwz rStatic, 0x0(rData)        # rStatic = static read-only data inside of file
  load rMPad, MPad.Any
  lwz rPress, MPad.xOnPress(rMPad)
  # saved registers are ready to use

  mtcrf MPad.crf.mDPad, rPress
  bt- MPad.bDUp, _DUp
  bt- MPad.bDDown, _DDown
  bt- MPad.bDLeft, _DLeft

  _DRight:
  test_MPad_DRight.str arch
  b _GProc_return

  _DLeft:
  test_MPad_DLeft.str arch
  b _GProc_return

  _DUp:
  test_MPad_DUp.str arch
  b _GProc_return

  _DDown:
  test_MPad_DDown.str arch
  b _GProc_return

_GProc_return:
epilog
blr
