_setup:

# this function will execute automatically to setup a GObj when this archive initializes
# - symbols and macros allow for use of some GObj constructor functions

# The following ifdef blocks will default to inputs given at a higher level, if they exist
# - otherwise, they will define the missing defaults
ifdef test_GProc.Class; .if ndef; test_GProc.Class = GDesc.def.Class; .endif
ifdef test_GProc.PLink; .if ndef; test_GProc.PLink = GDesc.def.PLink; .endif
ifdef test_GProc.PPriority; .if ndef; test_GProc.PPriority = GDesc.def.PPriority; .endif
ifdef test_GProc.DataSize; .if ndef; test_GProc.DataSize = 0x40; .endif
ifdef test_GProc.DataType; .if ndef; test_GProc.DataType = GDesc.def.DataType; .endif
ifdef test_GProc.DataDestr; .if ndef; test_GProc.DataDestr = GObj.HSD_MemFree; .endif
ifdef test_GProc.SPriority; .if ndef; test_GProc.SPriority = GDesc.def.SPriority; .endif

prolog rArch, rGObj, rGProc
  mr rArch, arch.init.call.rArch
  addi rGProc, arch.init.call.rSelf, _GProc-_setup
  addi rStatic, arch.init.call.rSelf, _static_data-_setup
  # save arguments, and use rSelf with _setup label to reach GProc callback, and data

  regs (r3), rClass, rPLink, rPPriority
  li rClass, test_GProc.Class
  li rPLink, test_GProc.PLink
  li rPPriority, test_GProc.PPriority
  branchl GObj.new
  mr rGObj, r3
  # setup a new GObj using generic group/class and low priority (defaults for GDesc)

  .if test_GProc.DataSize
    regs (r3), rSize
    li rSize, test_GProc.DataSize
    branchl GObj.HSD_MemAlloc
    # alloc 1kb of memory heap memory

    regs (r3), rThis, rDataType, rDestrCB, rAlloc
    mr rAlloc, r3
    load rDestrCB, GObj.HSD_MemFree
    li rDataType, test_GProc.DataType
    mr rThis, rGObj
    branchl GObj.data_init
    # register alloc to GObj data table

    regs (r3), rAlloc, rSize;  data.zero = 0x8000c160
    lwz rAlloc, GObj.xData(rGObj)
    li rSize, test_GProc.DataSize
    branchl data.zero
  # zero out GObj property data

  lwz r3, GObj.xData(rGObj)
  stw rStatic, 0(r3)
  # store pointer to static data in generated GObj data params

  .endif
  # only construct data table if a size is given

  regs (r3), rThis, rProcCB, rSPriority
  mr rThis, rGObj
  mr rProcCB, rGProc
  li rSPriority, test_GProc.SPriority
  branchl GObj.new_GProc
  # register GProc as a process that will run once per frame in this scene

epilog
blr
