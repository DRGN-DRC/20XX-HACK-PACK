
Battlefield Custom Platform Controller
Old static overwrite form.
[Achilles]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 ----- 0xbcc -------

# Original assembly written by Achilles.
# This source code and comments was recreated by DRGN.

# Check if the stage currently being loaded is Battlefield
lis r14, 0x8048
lhz r14, 1670(r14) # Load halfword at 0x80480686
cmpwi r14, 0x1F # External ID
bne- END

# Check if this is a Custom Platforms BF
lis r14, 0x803F
ori r14, r14, 0xA2E5 # Load the SSE Custom Stage Flag
lbz r23, 0(r14)
rlwinm. r15, r23, 26, 30, 31 # Turn r15 into the current Custom 1|2|3 stage index (1-indexed)
beq- END

# Calculate address for stored platform values
addi r14, r14, 0x547 # r14 is now 803FA82C (base value to jump to values table)
mulli r15, r15, 0x24 # Offset into platform values table (stride over stages)
add r14, r15, r14 # r14 is now the address for the start of this stage's platform values

# Load float of .8 into f18 (default stage model scaling and denominator for coordinate and size scaling)
li r15, 0x0 # Init platform index (0-indexed)
lis r16, 0x3F4C
ori r16, r16, 0xCCCD # Load float for .8 (0x3F4CCCCD)
stw r16, -12(r1)
lfs f18, -12(r1)

LoopOverPlatforms:
  mulli r16, r15, 0xC # Make r16 a relative offset for this platform's values
  add r16, r16, r14
  lfs f17, 0(r16) # Load new platform vertical offset (set by Debug Menu)
  lwz r17, 0(r16)
  lfs f15, 8(r16) # Load new platform scaling (size multiplier)
  lfs f16, 4(r16) # Load new platform horizontal offset
  lis r18, 0x8045
  ori r18, r18, 0x8E88
  lwz r18, 0(r18) # Load word at 80458E88?
  rlwinm. r16, r23, 0, 27, 27 # Check if Custom Stage Flag = Water BG
  beq- NoWaterBackground
  addi r18, r18, 0x744C

# Check if Platform 1 (Top platform)
  cmpwi r15, 0x0
  bne- CheckIfPlatform2
  addi r18, r18, 0x140
  b UpdatePlatformModel

CheckIfPlatform2: (Left platform)
  cmpwi r15, 0x1
  bne- IsPlatform3
  b UpdatePlatformModel

IsPlatform3: (Right platform)
  addi r18, r18, 0xA0
  b UpdatePlatformModel

NoWaterBackground:
  addi r18, r18, 0x518C # Set to offset for second (left) platform
  cmpwi r15, 0x0
  bne- AdjustForSidePlat
  addi r18, r18, 0x320 # Update offset for first (top) platform
  b UpdatePlatformModel

AdjustForSidePlat:
  cmpwi r15, 0x1
  bne- AdjustForRightPlat
  b UpdatePlatformModel

AdjustForRightPlat:
  addi r18, r18, 0x280 # Set to offset for third (right) platform

UpdatePlatformModel:
  # Update horizontal, vertical and x scale for this joint/platform
  fdiv f17, f17, f18
  stfs f17, 16(r18)
  fdiv f21, f16, f18
  stfs f21, 12(r18)
  fdiv f22, f15, f18
  stfs f22, 0(r18)

  # Load the address for storing the collision point values
  lis r18, 0x804D
  lwz r18, 25784(r18) # Update r18 to word at 804D64B8

  # Calculate left/right point coordinates from platform position
  lis r22, 0x41BC
  stw r22, -8(r1)
  lfs f14, -8(r1) # Load float of 23.5 (half of default platform width)
  fmuls f14, f14, f15 # determine half of platform width (23.5 * x scaling)
  fadd f17, f14, f16
  stfs f17, -12(r1)
  lwz r19, -12(r1) # right point calculated
  fneg f14, f14
  fadd f17, f14, f16
  stfs f17, -12(r1)
  lwz r20, -12(r1) # left point calculated

  # Determine which platform to update, and adjust the target address in r18 accordingly
  cmpwi r15, 0x0
  bne- DecideSidePlatOffsetUpdate
  b UpdateCollisionPoints

DecideSidePlatOffsetUpdate:
# Check if updating the offset for left or right platform
  cmpwi r15, 0x1
  bne- SetOffsetForRightPlat

# Set offset for the left platform
  addi r18, r18, 0x228
  b UpdateCollisionPoints

SetOffsetForRightPlat:
  addi r18, r18, 0x1F8

UpdateCollisionPoints:
  stw r20, 8(r18)
  stw r20, 16(r18)
  stw r19, 32(r18)
  stw r19, 40(r18)
  stw r17, 12(r18)
  stw r17, 20(r18)
  stw r17, 36(r18)
  stw r17, 44(r18)

# Iterate platform loop
  addi r15, r15, 0x1 # Increment platform index
  cmpwi r15, 0x3 # Check if this is the last platform to update
  blt- LoopOverPlatforms

END:
  blr 







			# Assembled variations:


! # Same code as below this, but as an injection mod. convert to this later

Battlefield Custom Platform Controller
[Achilles]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 ---- 0x216930 ----- 4E800020 -> Branch

3DC08048 A1CE0686
2C0E001F 40820148
3DC0803F 61CEA2E5
8AEE0000 56EFD7BF
41820134 39CE0547
1DEF0024 7DCF7214
39E00000 3E003F4C
6210CCCD 9201FFF4
C241FFF4 1E0F000C
7E107214 C2300000
82300000 C1F00008
C2100004 3E408045
62528E88 82520000
56F006F7 4182002C
3A52744C 2C0F0000
4082000C 3A520140
4800003C 2C0F0001
40820008 48000030
3A5200A0 48000028
3A52518C 2C0F0000
4082000C 3A520320
48000014 2C0F0001
40820008 48000008
3A520280 FE319024
D2320010 FEB09024
D2B2000C FECF9024
D2D20000 3E40804D
825264B8 3EC041BC
92C1FFF8 C1C1FFF8
EDCE03F2 FE2E802A
D221FFF4 8261FFF4
FDC07050 FE2E802A
D221FFF4 8281FFF4
2C0F0000 40820008
48000018 2C0F0001
4082000C 3A520228
48000008 3A5201F8
92920008 92920010
92720020 92720028
9232000C 92320014
92320024 9232002C
39EF0001 2C0F0003
41A0FEF4 4E800020


	-==-

!
Battlefield Custom Platform Controller
In SO form. IM form in-file. (Original from v4.07++)
[Achilles]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 ----- 0xbcc -------

00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 
00000000 00000000 

 -> 

3DC08048
A1CE06862C0E001F408201483DC0803F
61CEA2E58AEE000056EFD7BF41820134
39CE05471DEF00247DCF721439E00000
3E003F4C6210CCCD9201FFF4C241FFF4
1E0F000C7E107214C230000082300000
C1F00008C21000043E40804562528E88
8252000056F006F74182002C3A52744C
2C0F00004082000C3A5201404800003C
2C0F000140820008480000303A5200A0
480000283A52518C2C0F00004082000C
3A520320480000142C0F000140820008
480000083A520280FE319024D2320010
FEB09024D2B2000CFECF9024D2D20000
3E40804D825264B83EC041BC92C1FFF8
C1C1FFF8EDCE03F2FE2E802AD221FFF4
8261FFF4FDC07050FE2E802AD221FFF4
8281FFF42C0F00004082000848000018
2C0F00014082000C3A52022848000008
3A5201F8929200089292001092720020
927200289232000C9232001492320024
9232002C39EF00012C0F000341A0FEF4
4E800020

-------------- 0x216930 ----- 4E800020 -> 4BDE9E7C