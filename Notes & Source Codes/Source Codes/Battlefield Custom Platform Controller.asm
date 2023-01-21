

Battlefield Custom Platform Controller, v2
Updates Battlefield for the Custom Platform 1|2|3 variations if playing on one of those stages. Adjustments are made to the model as well as collisions when the file is loaded.
Version 1 of this code used hardcoded offsets for edits, while v2 traverses the file structures to find edit points, making it compatible with more heavily-edited stages.
[DRGN, Achilles]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x80018134 ---- 809E0010 -> Branch

# Injects into Preload_AllocateAndLoadFile
# At this point, 0x10(r30) contains a pointer to stage info

.macro backup
stwu	r1,-68(r1)	# make space for 12 registers
stmw	r20,8(r1)	# push r20-r31 onto the stack
mflr r0
stw r0,64(sp)
.endm

.macro restore
lwz r0,64(sp)
mtlr r0
lmw	r20,8(r1)		# pop r20-r31 off the stack
addi	r1,r1,68	# release the space
.endm

.macro loadNextSibling outputReg, fileAddressReg, inputReg
# Loads the next sibling of a joint object
lwz \inputReg, 0xC(\inputReg)
addi \inputReg, \inputReg, 0x20 # Account for file header offset (not included in file data offset)
add \outputReg, \fileAddressReg, \inputReg
.endm

# Check what stage is being loaded
lis r5, 0x804A
lwz r5, -0x18B0(r5)	# Load stage ID (internal ID) at 8049E750 (8049e6c8 + 0x88)
cmpwi r5, 0x24			# Check if Battlefield
bne+	END

# Check if this is a Custom Platforms BF
lis r5, 0x803F
ori r5, r5, 0xA2E5 # Load the SSE Custom Stage Flag
lbz r5, 0(r5)
rlwinm. r5, r5, 26, 30, 31 # Turn r5 into the current Custom 1|2|3 stage index (1-indexed)
beq+ END

# It's Battlefield. Back-up registers (we're gonna need some more!)
backup
mr r31, r5

# Gonna need the area table and collisions, so we'll search for the coll_data symbol
lis r29, 0x636F
ori r29, r29, 0x6C6C # Load bytes for the ASCII string "coll"
lwz	r4,0x10(r30) # Loads a pointer to stage info
lwz	r4,0x4(r4)	# r4 now holds the address of the start of stage file info

# Get the offset of the nodes/symbols tables
lwz r28, 4(r4) # Get file data size (excludes header & relocation table)
addi r28, r28, 0x20
lwz r5, 8(r4) # load RT entry count
mulli r5, r5, 4 # r5 is now the size of the RT table
add r28, r28, r5 # r28 is now the start of the root/ref nodes tables

# Get root nodes/symbols count (limit for search loop) and the string table offset
lwz r5, 0xC(r4) # Get root nodes count
lwz r27, 0x10(r4) # Get reference nodes count
add r5, r27, r5 # total symbols
mulli r26, r5, 8 # size of the nodes/symbols table
add r26, r28, r26 # start of the string table
add r26, r4, r26 # Make r26 an address rather than a relative file offset

# Loop through the nodes to find the target symbol
add r28, r4, r28 # Make r28 an address rather than a relative file offset
mr r5, r28 # Save for later for the second loop through the nodes table
SymbolsSearchStart:
lwz r27, 4(r28) # Load string table offset
lwzx r27, r26, r27 # Load first 4 bytes of the current string
cmpw r27, r29
beq- SymbolFound
addi r28, r28, 8
cmpw r28, r26
bge- Restore # Failsafe; searched the whole symbol table and didn't find the target string, so just exit
b SymbolsSearchStart

SymbolFound: # Load the offset for this node/symbol's file structure offset
lwz r28, 0(r28)
addi r28, r28, 0x20
add r29, r4, r28 # r29 is now the absolute address for this node's struct

# Get the address of its area table
mr r21, r29 # Save the address of the coll_data struct for later
lwz r29, 0x24(r29) # Load the pointer for the area table
addi r29, r29, 0x20 # Adjust for header
add r29, r4, r29 # r29 is now the address of the area table

# Update the area table coordinates
addi r29, r29, 0x14 # Adjust address to the area coordinates
lis	r28,0xc3bb
stw	r28,0(r29)
stw	r28,4(r29)
lis	r28,0x43bb
stw	r28,8(r29)
stw	r28,0xc(r29)

# Update platform model coordinates
# Get the offset of the map_head struct
mr r28, r5 # Set r28 back to the start address of the root/ref nodes tables
MapHeadSearchStartPrelude:
lis r29, 0x6D61
ori r29, r29, 0x705F # Load bytes for the ASCII string "map_"
MapHeadSearchStart:
lwz r27, 4(r28) # Load string table offset
lwzx r27, r26, r27 # Load first 4 bytes of the current string
cmpw r27, r29
beq- MapHeadPartiallyFound
addi r28, r28, 8
cmpw r28, r26
bge- Restore # Failsafe; searched the whole symbol table and didn't find the target string, so just exit
b MapHeadSearchStart
MapHeadPartiallyFound: # Matched "map_"; attempt to match the rest
lis r29, 0x6865
ori r29, r29, 0x6164 # Load bytes for the ASCII string "head"
lwz r27, 4(r28)
addi r27, r27, 4
lwzx r27, r26, r27 # Load next 4 bytes of string
cmpw r27, r29
bne+ MapHeadSearchStartPrelude

# The full map_head string was found
lwz r28, 0(r28)
addi r28, r28, 0x20
add r29, r4, r28 # r29 is now the absolute address for this node's struct

# Get the address for the Left platform
lwz r5, 8(r29) # Load pointer to the GObj array
addi r5, r5, 0x20
add r5, r4, r5
lwz r5, 0x138(r5) # Load the root joint of the 7th GObj (main stage model)
addi r5, r5, 0x20
add r5, r4, r5
lwz r5, 8(r5) # Load child joint
addi r5, r5, 0x20
add r5, r4, r5
loadNextSibling r5, r4, r5 # Load first sibling
loadNextSibling r5, r4, r5 # Load second sibling
loadNextSibling r5, r4, r5 # Load third sibling (left platform!)

mr r25, r5 # Save for later

# Calculate address for stored platform values from the Debug Menu
lis r29, 0x803F
ori r29, r29, 0xA82C # r29 is now the base value to jump into the values table
mulli r28, r31, 0x24 # Offset into platform values table (stride over stages)
add r29, r28, r29 # r29 is now the address for the start of this stage's platform values

# Load float of .8 into f18 (default stage model scaling and denominator for coordinate and size scaling)
lis r30, 0x3F4C
ori r30, r30, 0xCCCD # Load float for .8 (0x3F4CCCCD)
stw r30, -12(r1)
lfs f18, -12(r1)

# Init platform index (0-indexed)
li r28, 0x0

LoopOverPlatforms:
  # Load values from the Debug Menu
  mulli r27, r28, 0xC # Make r27 a relative offset for this platform's values
  add r27, r27, r29
  lfs f17, 0(r27) # Load new platform vertical offset (set by Debug Menu)
  #lwz r26, 0(r27)
  lfs f15, 8(r27) # Load new platform scaling (size multiplier)
  lfs f16, 4(r27) # Load new platform horizontal offset

# Check if Platform 1 (Top platform)
cmpwi r28, 0x0
bne- CheckIfPlatform2

# Is top platform. Get the address to its joint struct (r5 is currently the left platform)
loadNextSibling r5, r4, r5 # Load right platform address
loadNextSibling r23, r4, r5 # Load top platform address
b UpdatePlatformModel

CheckIfPlatform2: # (Left platform)
  cmpwi r28, 0x1
  bne- IsPlatform3
  mr r23, r25 # Load left plat joint address
  b UpdatePlatformModel

IsPlatform3: # (Right platform)
  mr r5, r25 # Load left plat joint address
  loadNextSibling r23, r4, r5
  b UpdatePlatformModel

UpdatePlatformModel:
  # Scale the values up (x/.8)
  fdiv f15, f15, f18
  fdiv f16, f16, f18
  fdiv f17, f17, f18

  # Update horizontal, vertical and x scale for this joint/platform
  stfs f15, 0x20(r23) # scale X
  stfs f16, 0x2C(r23) # horizontal offset
  stfs f17, 0x30(r23) # vertical offset

  # Load address for the spot table
  lwz r27, 0(r21)
  add r27, r27, r4
  addi r23, r27, 0x20
  cmpwi r28, 0x0
  bne- DecideSidePlatOffsetUpdate
  b UpdateCollisionPoints

DecideSidePlatOffsetUpdate:
# Check if updating the offset for left or right platform
  cmpwi r28, 0x1
  bne- SetOffsetForRightPlat

# Set offset for the left platform
  addi r23, r23, 0xB8 # Offset to points 24/25
  b UpdateCollisionPoints

SetOffsetForRightPlat:
  addi r23, r23, 0xA8 # Offset to points 22/23

UpdateCollisionPoints:
  # Transfer the platform vertical offset to a register
  stfs f17, -12(r1)
  lwz r26, -12(r1)

  # Calculate left/right point coordinates from platform position
  lis r22, 0x41BC
  stw r22, -8(r1)
  lfs f14, -8(r1) # Load float of 23.5 (half of default platform width)
  fmuls f14, f14, f15 # determine half of platform width (23.5 * x scaling)
  fadd f17, f14, f16 # above + horizontal offset
  stfs f17, -12(r1)
  lwz r22, -12(r1) # right point calculated
  fneg f14, f14
  fadd f17, f14, f16 # horizontal offset
  stfs f17, -12(r1)
  lwz r24, -12(r1) # left point calculated

  # Store the new coordinates to the spot table
  stw r24, 0(r23) # Store left point x
  stw r22, 8(r23) # Store right point x
  stw r26, 4(r23) # Store left point y
  stw r26, 0xC(r23) # Store right point y

# Iterate platform loop
addi r28, r28, 0x1 # Increment platform index
cmpwi r28, 0x3 # Check if this is the last platform to update
blt- LoopOverPlatforms

# Restore registers
Restore:
restore

END:
lwz	r4, 0x0010 (r30)	# default code line
b 0

------------- 0x803FA840 ----

00000000 803FA810 803FA81C 803FA828
803FA834 56657279 68696768 00000000
804D58D0 804D58D8 804D58E0 804D58E4
804D58EC 803FA854 3C205275 6C65203E
00000000 54696D65 284D696E 2920203A
00000000 54696D65 28536563 2920203A
00000000 53746F63 6B28636E 7429203A
00000000 44616D61 67655261 74696F3A
00000000 56696272 6174696F 6E205365

 -> 

# Custom platform values.
# Needs to be in a static location
# for the Debug Menu to write to.
# Note that these are only default
# values and are overwritten by
# any memory card save data.
424620504c4154464f524d5300000000
4259999A000000003F4CCCCD41D9999A
C21B33333F4CCCCD41D9999A421B3333
3F4CCCCD4259999A000000003F4CCCCD
41D9999AC21B33333F4CCCCD41D9999A
421B33333F4CCCCD4259999A00000000
3F4CCCCD41D9999AC21B33333F4CCCCD
41D9999A421B33333F4CCCCD00000000
00000000000000000000000000000000