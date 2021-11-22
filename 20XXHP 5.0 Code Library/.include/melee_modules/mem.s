.ifndef melee.library.included; .include "melee"; .endif
melee.module mem
.if module.included == 0
punkpc regs

r13.xOSArenaLo=-0x5a90
# This points to the current top of the ArenaLo stack (ascends from the bottom of RAM, upwards)
# - Arena begins where static data ends -- usually at 0x804EEC00 (following runtime stack)

r13.xOSArenaHi=-0x4330
# This points to the current top of the ArenaHigh stack (descends from top of RAM, downwards)


# Static OS params:
# - OS DVD info
OS.xGamecode      = 0x00
OS.xCompany       = 0x04
OS.xDiskID        = 0x06
OS.xVersion       = 0x07
OS.xStreaming     = 0x08
OS.xStreamBufSize = 0x09

# - OS System Info
OS.xDVDMagicWord       = 0x1C
OS.xMagicWord          = 0x20
OS.xVersion            = 0x24
OS.xPhysicalMemorySize = 0x28
OS.xConsoleType        = 0x2C
OS.xArenaLo            = 0x30
OS.xArenaHi            = 0x34
OS.xFST                = 0x38
OS.xFSTMaxChars        = 0x3C

# - OS Debugger Info
OS.xDebuggerPresent       = 0x40
OS.xDebuggerExceptionMask = 0x44
OS.xDebuggerExceptionHook = 0x48
OS.xDebuggerReturnAddress = 0x4C
OS.xDebuggerHook          = 0x60

# - OS Globals
OS.xPhysicalContext   = 0xC0
OS.xPrevInterruptMask = 0xC4
OS.xThisInterruptMask = 0xC8
OS.xTVMode            = 0xCC
OS.xARAMSize          = 0xD0
OS.xContext           = 0xD4
OS.xDefaultThread     = 0xD8
OS.xHeadThread        = 0xDC
OS.xTailThread        = 0xE0
OS.xThread            = 0xE4
OS.xDebugMonitorSize  = 0xE8
OS.xDebugMonitor      = 0xEC
OS.xConsoleMemorySize = 0xF0
OS.xDVDB12Buffer      = 0xF4
OS.xBUSClockSpeed     = 0xF8
OS.xCPUClockSpeed     = 0xFC

# - Dolphin Globals
OS.xDOLSize    = 0x30d4
OS.xPowerOnTBU = 0x30d8
OS.xPowerOnTBL = 0x30dc


# Memory manager metadata structures:
MemDef.xID       = 0x00
MemDef.xBehavior = 0x04
MemDef.xPrevID   = 0x08
MemDef.xSize     = 0x0C
MemDef.size      = 0x10
MemDef.addr      = 0x803ba380
# These are defined statically in the DOL

MemGlob.xIDMax   = 0x00
MemGlob.xSRAMLo  = 0x10
MemGlob.xSRAMHi  = 0x14
MemGlob.xDRAMLo  = 0x18
MemGlob.xDRAMHi  = 0x1C
MemGlob.size     = 0x20
MemGlob.addr     = 0x80431f90
# These are updated globally, as a header to the MemDesc struct array
# - adding '.size' to this base address will convert it into the base of 'MemDesc.'

MemDesc.xHeapID   = 0x00
MemDesc.xCache    = 0x04
MemDesc.xStart    = 0x08
MemDesc.xSize     = 0x0C
MemDesc.xBehavior = 0x10
MemDesc.xInit     = 0x14
MemDesc.xDisabled = 0x18
MemDesc.size      = 0x1C
MemDesc.addr      = 0x80431fb0
# An array of 'Desc' structs define dynamic memory regions used by the HSD scene system

HeapDesc.xTotal  = 0x00
HeapDesc.xFree   = 0x04
HeapDesc.xAlloc  = 0x08
HeapDesc.size    = 0x0C
r13.xOSHeapDescs = -0x4340
# OSHeaps provide dynamically free-able memory, and is used by HSD for scene-persistent allocs

HeapMeta.xPrev   = 0x00
HeapMeta.xNext   = 0x04
HeapMeta.xSize   = 0x08
HeapMeta.size    = 0x0C

CacheDesc.xNext  = 0x00
CacheDesc.xLow   = 0x04
CacheDesc.xHigh  = 0x08
CacheDesc.xMeta  = 0x0C
CacheDesc.size   = 0x10

CacheMeta.xNext  = 0x00
CacheMeta.xAlloc = 0x04
CacheMeta.xSize  = 0x08
CacheMeta.size   = 0x0C
# (these structs can be navigated to from the above global structs)

data.async_info.xNext    = 0x00
data.async_info.xStatus  = 0x04
data.async_info.xSource  = 0x18
data.async_info.xDest    = 0x1C
data.async_info.xSize    = 0x20
data.async_info.xMainCB  = 0x24  # main is assigned by DMA Queueing function, automatically
data.async_info.xSyncCB  = 0x28  # sync callback is assigned by user
data.async_info.xSyncArg = 0x2C  # arg is passed to sync callback at time of data copy finish
data.async_info.addr = 0x804316c0
data.async_info.size = 0x30
# ARAM Dynamic Memory Access Queue descriptors list pending Async copys to/from ARAM

data.async_glob.xFree    = 0x00
data.async_glob.xAsync   = 0x04
data.async_glob.xSynced  = 0x08
data.async_glob.addr     = 0x804316c0 + 0x1E0
# ARAM DMA globals keep linked lists describing current pending/free async copy descriptors



# --- RETURNS for <mem.alloc>, <mem.allocz>
# args: r3=rSize
# args: r3=rID, rSize  (alternative syntax)
mem.alloc.rAlloc       = r3
mem.alloc.rMeta        = r4
mem.alloc.rAligned     = r5
mem.alloc.rSize        = r6
mem.alloc.rID          = r7
mem.alloc.bIsAvailable = cr1.lt
mem.alloc.bIsARAM      = cr1.gt
mem.alloc.bIsHeap      = cr1.eq


# --- RETURNS for <mem.ID>
# args: r3=rID
mem.ID.rID          = r3
mem.ID.rMem         = r4
mem.ID.rHeap        = r5
mem.ID.rCache       = r6
mem.ID.rStart       = r7
mem.ID.rSize        = r8
mem.ID.rDef         = r9
mem.ID.rDefSize     = r10
mem.ID.bIsAvailable = cr1.lt
mem.ID.bIsARAM      = cr1.gt
mem.ID.bIsHeap      = cr1.eq



# --- RETURNS for <mem.info>
# args: r3=rAddress
# args: r3=rID, rSize   (alternative syntax)
mem.info.rID          = r3
mem.info.rMem         = r4
mem.info.rHeap        = r5
mem.info.rCache       = r6
mem.info.rStart       = r7
mem.info.rAlloc       = r7
mem.info.rSize        = r8
mem.info.rOffset      = r9
mem.info.rMeta        = r10
mem.info.rStatic      = r11
mem.info.rString      = r12
mem.info.bInRegion    = cr1.lt
mem.info.bIsAllocated = cr1.gt
mem.info.bIsHeap      = cr1.eq
mem.info.bIsAvailable = cr1.lt
mem.info.bIsARAM      = cr1.gt
# - rOffset is derived from rStart, but only if r3=rAddress input syntax is used

# special returns for case of rSize being too large for making allocation (bIsAvailable = False):
mem.info.rFCount = r7
mem.info.rFBig   = r8
mem.info.rFTotal = r9
mem.info.rACount = r10
mem.info.rABig   = r11
mem.info.rATotal = r12
# - rF* and rA* represent 'Free' and 'Allocated' params for the given region ID
# - r*Big returns the largest found fragment of free/alloc fragments counted in this region


# --- RETURNS for <mem.static>
mem.static.rArg    = r3
mem.static.rID     = r4
mem.static.rStart  = r5
mem.static.rString = r6

# --- RETURNS for <data.async_info>
data.async_info.rAsync     = r3
data.async_info.rDest      = r4
data.async_info.rSource    = r5
data.async_info.rSize      = r6
data.async_info.rSyncCB    = r7
data.async_info.rSyncArg   = r8
data.async_info.rGlob      = r9
data.async_info.rQuery     = r10
data.async_info.bNotSynced = cr1.lt
data.async_info.bMatch     = cr1.gt
data.async_info.bSynced    = cr1.eq


# --- RETURNS for <log.timestamp>
log.timestamp.rFrame  = r3
log.timestamp.fFrame  = f1
log.timestamp.rTime   = r4
log.timestamp.fTime   = f2
log.timestamp.rBoot   = r5
log.timestamp.fBoot   = f3
log.timestamp.rIDComp = r6
log.timestamp.rChange = r7
log.timestamp.rMajor  = r8
log.timestamp.rMinor  = r9
log.timestamp.rTBU    = r10
log.timestamp.rTBL    = r11


.endif
