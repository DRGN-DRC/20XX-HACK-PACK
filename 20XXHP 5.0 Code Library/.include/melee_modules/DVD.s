.ifndef melee.library.included; .include "melee"; .endif
melee.module DVD
.if module.included == 0
punkpc regs
melee arch


# --- SDATA offsets
r13.xFSTEntries = -0x4424
r13.xFSTPaths   = -0x4420
r13.xFSTCount   = -0x441C
r13.xDVDAsyncQueue = -0x3ea8



# --- RETURNS for <DVD.file>
# args: r3=rFile  (== rNum, rPath, or rOffset)
DVD.file.rNum    = r3
DVD.file.rPath   = r4
DVD.file.rSize   = r5
DVD.file.rAlign  = r6
DVD.file.rOffset = r7
DVD.file.rFST    = r8
DVD.file.rFile   = r9
DVD.file.bInvalid = cr1.eq

# rFST:
FST.xStr    = 0x0
FST.xOffset = 0x4
FST.xSize   = 0x8
FST.size    = 0xC



# --- RETURNS for <DVD.async_info>
# args: r3=rQuery
DVD.async_info.rAsync     = r3
DVD.async_info.rNum       = r4
DVD.async_info.rQuery     = r5
DVD.async_info.bNotSynced = cr1.lt
DVD.async_info.bMatch     = cr1.gt
DVD.async_info.bSynced    = cr1.eq

# rAsync:
DVD.async_info.xNext      = 0x00
DVD.async_info.xIDX       = 0x04
DVD.async_info.xNum       = 0x08
DVD.async_info.xStart     = 0x0C
DVD.async_info.xDest      = 0x10
DVD.async_info.xSize      = 0x14
DVD.async_info.xFlags     = 0x18
DVD.async_info.xError     = 0x1A
DVD.async_info.xSyncCB    = 0x1C
DVD.async_info.xSyncArg   = 0x20


# --- RETURNS for all variations of <DVD.read*>
# args: r3=rFile, r4=rOut, r5=... (additional args vary by function)
DVD.read.rNum       = r3
DVD.read.rOut       = r4
DVD.read.rStart     = r5
DVD.read.rSize      = r6
DVD.read.rSyncCB    = r7
DVD.read.rArch      = r8
DVD.read.rMeta      = r9
DVD.read.rPath      = r10
DVD.read.rAsync     = r11
DVD.read.bNotSynced = cr1.lt
DVD.read.bInvalid   = cr1.eq


# --- ARGUMENTS for sync callbacks
# --> passed to rSyncCB on asynchronous reads
DVD.sync.rID      = r3
DVD.sync.rSyncArg = r4
DVD.sync.rErrorID = r6

.endif
