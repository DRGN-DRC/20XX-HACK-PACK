

Hold B for Height (Mario/Dr. Mario/Luigi/ICies - SDRC)
Hold B instead of mashing B to gain height with down or side B moves.
[UnclePunch, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x800e253c --- 801F0668 -> Branch	# Mario & Dr. Mario

# Check if current character is Mario
lwz r15, 4(r4)		# r4 is the current player data table pointer; load internal character ID
cmpwi	r15, 0
bne+	CheckDoc

# Check if SDR Mario is enabled
lis r15, 0x803C57D5@h
lbz r15, 0x803C57D5@l(r15)	# load PlMr._at
cmpwi	r15, 0x73
bne+	OrigLine
b SdrLine

CheckDoc:
# Check if current character is Dr. Mario
cmpwi	r15, 0x15
bne+	OrigLine

# Check if SDR Dr. Mario is enabled
lis	r15, 0x803D15DD@h
lbz	r15, 0x803D15DD@l(r15)	# load PlDr._at
cmpwi	r15, 0x73
bne+	OrigLine

SdrLine: # Modified SDR line
lwz r0, 0x65C(r31)
b END

OrigLine:
lwz r0, 0x668(r31)	# original code line
END:
b 0

1.02 ----- 0x80144ab0 --- 801F0668 -> Branch	# Luigi

# Check if SDR Luigi is enabled
lis	r15, 0x803D08AD@h
lbz	r15, 0x803D08AD@l(r15)	# load PlLg._at
cmpwi	r15, 0x73
bne+	OrigLine

# Modified SDR line
lwz r0, 0x65C(r31)
b END

OrigLine:
lwz r0, 0x668(r31)	# original code line
END:
b 0

1.02 ----- 0x80120554 --- 801F0668 -> Branch	# ICies

# Check if SDR Popo is enabled
lis	r15, 0x803D		# 0x803CD615
lbz	r15, -0x29EB(r15)	# load PlPp._at
cmpwi	r15, 0x73
bne+	OrigLine

# Modified SDR line
lwz r0, 0x65C(r31)
b END

OrigLine:
lwz r0, 0x668(r31)	# original code line
END:
b 0

1.02 ----- 0x80120414 --- 801F0668 -> Branch	# ICies

# Check if SDR Popo is enabled
lis	r15, 0x803D		# 0x803CD615
lbz	r15, -0x29EB(r15)	# load PlPp._at
cmpwi	r15, 0x73
bne+	OrigLine

# Modified SDR line
lwz r0, 0x65C(r31)
b END

OrigLine:
lwz r0, 0x668(r31)	# original code line
END:
b 0


	-==-


Ice Climbers - Popo and Nana Can Share Ledge (SDRC)
[UnclePunch, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x80082EA4 --- 809E0734 -> Branch

# Check if SDR Popo is enabled
lis	r15, 0x803D		# 0x803CD615
lbz	r15, -0x29EB(r15)	# load PlPp._at
cmpwi	r15, 0x73
bne+ 	END

# Orig SDR code
lbz r3, 12(r31)
lbz r4, 8735(r30)
rlwinm r4, r4, 29, 31, 31
lis r12, 0x8003
ori r12, r12, 0x418C
mtctr r12
bctrl 
cmpwi r3, 0x0
beq- END
lwz r3, 44(r3)
cmpw r3, r30
bne- END
lis r12, 0x8008
ori r12, r12, 0x2EC0
mtctr r12
bctr

END:
lwz r4, 1844(r30)
b 0

1.02 ----- 0x80082ED8 --- 809E0730 -> Branch

# Check if SDR Popo is enabled
lis	r15, 0x803D		# 0x803CD615
lbz	r15, -0x29EB(r15)	# load PlPp._at
cmpwi	r15, 0x73
bne+ 	END

# Orig SDR code
lbz r3, 12(r31)
lbz r4, 8735(r30)
rlwinm r4, r4, 29, 31, 31
lis r12, 0x8003
ori r12, r12, 0x418C
mtctr r12
bctrl 
cmpwi r3, 0x0
beq- END
lwz r3, 44(r3)
cmpw r3, r30
bne- END
lis r12, 0x8008
ori r12, r12, 0x2EF4
mtctr r12
bctr

END:
lwz r4, 1840(r30)
b 0


	-==-


Nana Direction Update Bug Fix (SDRC)
Allows ICs to dash-dance together
<https://smashboards.com/threads/misc-character-codes.446554/>
[tauKhan, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x800b0ae8 --- D0030018 -> Branch

# Check if SDR Popo is enabled
lis	r15, 0x803D		# 0x803CD615
lbz	r15, -0x29EB(r15)	# load PlPp._at
cmpwi	r15, 0x73
bne+ 	OrigLine

# Orig SDR code
loc_0x0:
  addi r6, r4, 0x444
  addi r3, r3, 0x1C
  cmplw r3, r6
  bne- loc_0x14
  addi r3, r4, 0xFC

loc_0x14:
  stfs f0, 24(r3)
  lwz r3, 1092(r4)
  lwz r6, 1092(r4)
  b 8

OrigLine:
stfs f0,24(r3)	# original code line
END:
b 0


	-==-


Nana is Always Level 9 (SDRC)
Conditionally set during match start if SDR is active for Popo
[glook, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x8011EF3C --- 7C0802A6 -> Branch

# Injecting into FighterOnLoad_Popo
.macro setWord reg1, reg2, address, word
  lis \reg1, \word@h
  ori \reg1, \reg1, \word@l
  lis \reg2, \address@h
  ori \reg2, \reg2, \address@l
  stw \reg1, 0(\reg2)
.endm

# Check if SDR Popo is enabled
lis	r15, 0x803D		# 0x803CD615
lbz	r15, -0x29EB(r15)	# load PlPp._at
cmpwi	r15, 0x73
bne+ 	OrigLine

# SDR Popo activated; make SDR changes
setWord r14, r15, 0x801239a8, 0x60000000
b END

OrigLine: # Change lines to vanilla
setWord r14, r15, 0x801239a8, 0x40810008

END:
mflr r0		# original code line
b 0


	-==-



Nana's % is Displayed (SDRC)
Displays above Popo's like in coin battle
[Flies killer, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x8011EF40 --- 90010004 -> Branch

# Injecting into 0x4 of FighterOnLoad_Popo
.macro setWord reg1, reg2, address, word
  lis \reg1, \word@h
  ori \reg1, \reg1, \word@l
  lis \reg2, \address@h
  ori \reg2, \reg2, \address@l
  stw \reg1, 0(\reg2)
.endm

# Check if SDR Popo is enabled
lis	r15, 0x803D		# 0x803CD615
lbz	r15, -0x29EB(r15)	# load PlPp._at
cmpwi	r15, 0x73
bne+ 	OrigLines

# SDR Popo activated; make SDR changes
setWord r14, r15, 0x804ddc28, 0x40c00000
setWord r14, r15, 0x8016597c, 0x480000CC
b END

OrigLines: # Change lines to vanilla
setWord r14, r15, 0x804ddc28, 0x404CCCCD
setWord r14, r15, 0x8016597c, 0x40820074

END:
stw r0,4(r1)		# original code line
b 0

1.02 ----- 0x80165a64 --- 7C0601D6 -> Branch

# Check if SDR Popo is enabled
lis	r15, 0x803D		# 0x803CD615
lbz	r15, -0x29EB(r15)	# load PlPp._at
cmpwi	r15, 0x73
bne+ 	END

loc_0x0:
  lis r17, 0x8046
  ori r17, r17, 0xB6A0
  lbz r17, 0(r17)
  cmpwi r17, 0x0
  bne- loc_0x24
  lis r17, 0x8045
  ori r17, r17, 0x30E2
  li r16, 0xE90
  b loc_0x30

loc_0x24:
  lis r17, 0x804A
  ori r17, r17, 0x13CE
  li r16, 0x50

loc_0x30:
  mr r19, r26

loc_0x34:
  cmpwi r19, 0x0
  beq- loc_0x48
  subi r19, r19, 0x1
  add r17, r17, r16
  b loc_0x34

loc_0x48:
  lhz r0, 0(r17)
  lis r17, 0x8016
  ori r17, r17, 0x5AA4
  mtctr r17
  bctr 
  b 8		# Skip original code line

END:
  mullw r0,r6,r0 	# Original code line
  b 0

1.02 ----- 0x802f65cc --- 881D0003 -> Branch

# Check if SDR Popo is enabled
lis	r15, 0x803D		# 0x803CD615
lbz	r15, -0x29EB(r15)	# load PlPp._at
cmpwi	r15, 0x73
bne+ 	OrigLine

loc_0x0:
  mulli r15, r31, 0xE90
  lis r16, 0x8045
  ori r16, r16, 0x3080
  add r16, r15, r16
  lbz r17, 7(r16)
  cmpwi r17, 0xE
  bne- loc_0x24
  li r0, 0x80
  b END

loc_0x24:
  li r0, 0x0
  b END

OrigLine:
  lbz r0,3(r29) 	# Original code line
END:				# Original code doesn't include orig code line
  b 0


	-==-


GaW Can L-Cancel Aerials Rewrite w/GFX (SDRC)
Differs from the Magus code in that item GFX are preserved on landing
[UnclePunch, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x8014b964 --- 3C608015 -> Branch

# Collision_GaW_Bair
# Check if SDR Game & Watch is enabled
lis	r15, 0x803D28ED@h
lbz	r15, 0x803D28ED@l(r15)	# load PlGw._at
cmpwi	r15, 0x73
bne+ 	OrigLine

lwz r5, -20812(r13)
lwz r4, 228(r5)
lbz r3, 1663(r31)
cmpw r3, r4
bge- OrigLine
mr r3, r30
lis r12, 0x8006
ori r12, r12, 0xF484
mtctr r12
bctrl 
lfs f0, -29976(r2)
fadds f0, f0, f1
lfs f1, 232(r5)
lfs f2, 512(r31)
fdivs f1, f2, f1
fdivs f1, f0, f1
mr r3, r30
lis r12, 0x8006
ori r12, r12, 0xF190
mtctr r12
bctrl 

OrigLine:
lis r3, 0x8015	# Orig code line
b 0

1.02 ----- 0x8014bac0 --- 3C608015 -> Branch

# Collision_GaW_UAir
# Check if SDR Game & Watch is enabled
lis	r15, 0x803D28ED@h
lbz	r15, 0x803D28ED@l(r15)	# load PlGw._at
cmpwi	r15, 0x73
bne+ 	OrigLine

lwz r5, -20812(r13)
lwz r4, 228(r5)
lbz r3, 1663(r31)
cmpw r3, r4
bge- OrigLine
mr r3, r30
lis r12, 0x8006
ori r12, r12, 0xF484
mtctr r12
bctrl 
lfs f0, -29976(r2)
fadds f0, f0, f1
lfs f1, 232(r5)
lfs f2, 516(r31)
fdivs f1, f2, f1
fdivs f1, f0, f1
mr r3, r30
lis r12, 0x8006
ori r12, r12, 0xF190
mtctr r12
bctrl 

OrigLine:
lis r3, 0x8015	# Orig code line
b 0

1.02 ----- 0x8014b808 --- 3C608015 -> Branch

# Collision_GaW_Nair
# Check if SDR Game & Watch is enabled
lis	r15, 0x803D28ED@h
lbz	r15, 0x803D28ED@l(r15)	# load PlGw._at
cmpwi	r15, 0x73
bne+ 	OrigLine

lwz r5, -20812(r13)
lwz r4, 228(r5)
lbz r3, 1663(r31)
cmpw r3, r4
bge- OrigLine
mr r3, r30
lis r12, 0x8006
ori r12, r12, 0xF484
mtctr r12
bctrl 
lfs f0, -29976(r2)
fadds f0, f0, f1
lfs f1, 232(r5)
lfs f2, 504(r31)
fdivs f1, f2, f1
fdivs f1, f0, f1
mr r3, r30
lis r12, 0x8006
ori r12, r12, 0xF190
mtctr r12
bctrl 

OrigLine:
lis r3, 0x8015	# Orig code line
b 0


	-==-


Cannot Escape Kirby Throws (SDRC)
<https://smashboards.com/threads/disable-escaping-from-kirby-throws-and-kirbycide.454066/post-22748043>
[UnclePunch, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x800EE680 --- 7C0802A6 -> Branch

# Performs overwrites in Kirby's OnLoad
.macro setWord reg1, reg2, address, word
  lis \reg1, \word@h
  ori \reg1, \reg1, \word@l
  lis \reg2, \address@h
  ori \reg2, \reg2, \address@l
  stw \reg1, 0(\reg2)
.endm

# Check if SDR Kirby is enabled
lis	r15, 0x803D	# 0x803CA30D
lbz	r15, -0x5CF3(r15)	# load PlKb._at
cmpwi	r15, 0x73
bne+ 	OrigLine

# SDR Kirby activated; make SDR changes
setWord r14, r15, 0x800DE490, 0x48000010
b END

OrigLine: # Change lines to vanilla
setWord r14, r15, 0x800DE490, 0x40820010

END:
mflr r0		# original code line
b 0


	-==-


Mewtwo SDR Init (SDRC)
Contains SDR changes for the following features:
- Mewtwos Side-b works as a throw
- Fix's mewtwo's confusion reflect bubble
Conditionally set during match start if SDR is active for Mewtwo.
<https://smashboards.com/threads/sd-remix-3-3-full-with-slippi-rollback-released.324620/post-21724293>
<https://smashboards.com/threads/sd-remix-3-3-full-with-slippi-rollback-released.324620/post-21724263>
[UnclePunch, jjhoho, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 ---- 0x141A28 ----- 7C0802A6 -> Branch

# Performs overwrites in Mewtwo's OnLoad
.macro setWord reg1, reg2, address, word
  lis \reg1, \word@h
  ori \reg1, \reg1, \word@l
  lis \reg2, \address@h
  ori \reg2, \reg2, \address@l
  stw \reg1, 0(\reg2)
.endm

# Check if SDR Mewtwo is enabled
lis	r15, 0x803D0D85@h
lbz	r15, 0x803D0D85@l(r15)	# load PlMt._at
cmpwi	r15, 0x73
bne+ 	OrigLines

# SDR Mewtwo activated; make SDR changes
setWord r14, r15, 0x80146940, 0x60000000 # Side-B works as throw
setWord r14, r15, 0x801468ac, 0x60000000 # Side-B works as throw
setWord r14, r15, 0x80146c58, 0x60000000 # Confusion reflect fix
b END

OrigLines: # Change lines to vanilla
setWord r14, r15, 0x80146940, 0x4BF49E41 # Side-B works as throw
setWord r14, r15, 0x801468ac, 0x4BF49ED5 # Side-B works as throw
setWord r14, r15, 0x80146c58, 0x981F2218 # Confusion reflect fix

END:
mflr r0		# original code line
b 0


	-==-


GW Pan Momentum Not Applied (SDRC)
[UnclePunch, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x8014A37C --- 7C0802A6 -> Branch

# Performs overwrites in GaW's OnLoad
.macro setWord reg1, reg2, address, word
  lis \reg1, \word@h
  ori \reg1, \reg1, \word@l
  lis \reg2, \address@h
  ori \reg2, \reg2, \address@l
  stw \reg1, 0(\reg2)
.endm

# Check if SDR Game & Watch is enabled
lis	r15, 0x803D28ED@h
lbz	r15, 0x803D28ED@l(r15)	# load PlGw._at
cmpwi	r15, 0x73
bne+ 	OrigLine

# SDR GaW activated; make SDR changes
setWord r14, r15, 0x8014e6e8, 0x60000000
b END

OrigLine: # Change lines to vanilla
setWord r14, r15, 0x8014e6e8, 0xD0250084

END:
mflr r0		# original code line
b 0


	-==-


Individual Powershield Ratios (SDRC)
originally a plco offset, now customizable
[mer, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x8009397c --- C00902A8 -> Branch


# r31 = Pointer to current Player Character Data struct
lis r14, 0x803C1F40@h		# Load table address; points to 'Pl__.dat' strings
ori r14, r14, 0x803C1F40@l
lwz r15, 4(r31)			# Load current internal character ID
mulli r15, r15, 8		# r15 is now an offset into the pointer table
add r14, r14, r15
lwz r15, 0(r14)			# Load pointer to the 'Pl__.dat' file string
lbz r14, 5(r15)			# Load "s"/"d"/"p" character (first of extension)
cmpwi r14, 0x73			# check if "s"
bne+ OrigLine

loc_0x0:
  b loc_0x88

loc_0x4:
  blrl 

  # Float table indexed by internal character ID
  .float .85	# Mario
  .float .75
  .float .75
  .float 1.0	# DK
  .float .75
  .float 1.0	# Bowser
  .float .75
  .float .75
  .float .90	# Ness
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .90	# Game & Watch
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75
  .float .75

loc_0x88:
  bl loc_0x4
  mflr r6
  lbz r7, 7(r8)		# Loading internal character ID
  mulli r7, r7, 0x4
  lfsx f0, r7, r6
  b END

OrigLine:
lfs f0,680(r9)		# Original code line; loads float of .75 into f0
END:
b 0


	-==-


Ness Yoyo Goes Over Ledge (SDRC)
Affects charging of D-Smash and U-Smash
[UnclePunch, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x8011480C --- 7C0802A6 -> Branch

# Performs overwrites in Ness' OnLoad
.macro setWord reg1, reg2, address, word
  lis \reg1, \word@h
  ori \reg1, \reg1, \word@l
  lis \reg2, \address@h
  ori \reg2, \reg2, \address@l
  stw \reg1, 0(\reg2)
.endm

# Check if SDR Ness is enabled
lis	r15, 0x803D	# 0x803CCAD5
lbz	r15, -0x352B(r15)	# load PlNs._at
cmpwi	r15, 0x73
bne+ 	OrigLines

# SDR Ness activated; make SDR changes
setWord r14, r15, 0x80116698, 0x60000000	# D-Smash
setWord r14, r15, 0x80115e34, 0x60000000	# U-Smash
b END

OrigLines: # Change lines to vanilla
setWord r14, r15, 0x80116698, 0x4182000C	# D-Smash
setWord r14, r15, 0x80115e34, 0x4182000C	# U-Smash

END:
mflr r0		# original code line
b 0


	-==-


Ness & GaW Can Absorb All Projectiles And Items (SDRC)
Missiles and turnips no longer a problem
[UnclePunch, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x8007956C --- 546007FF -> Branch

# Injecting into Hitbox_ProjectileHitboxAndFighterHitbox
# Check if current character is Ness
lwz r15, 4(r27)		# Loading current player internal character ID
cmpwi	r15, 0x8
bne+	CheckGaw

# Current character is Ness. Check if SDR Ness is enabled
lis	r15, 0x803D	# 0x803CCAD5
lbz	r15, -0x352B(r15)	# load PlNs._at
cmpwi	r15, 0x73
bne+	OrigLine
b SdrLine

CheckGaw:
# Check if current character is Game & Watch
cmpwi	r15, 0x18
bne+	OrigLine

# Check if SDR Game & Watch is enabled
lis	r15,0x803D28ED@h
lbz	r15,0x803D28ED@l(r15)	# load PlGw._at
cmpwi	r15, 0x73
bne+	OrigLine

SdrLine:
crandc 2, 2, 2		# Should result in the beq following this funtion to NOT branch
b END

OrigLine:
rlwinm. r0,r3,0,31,31	# Orig code line
END:
b 0

1.02 ----- 0x8007962C --- 5400CFFF -> Branch

# Injecting into Hitbox_ProjectileHitboxAndFighterHitbox
# Check if current character is Ness
lwz r15, 4(r27)		# Loading current player internal character ID
cmpwi	r15, 0x8
bne+	CheckGaw

# Current character is Ness. Check if SDR Ness is enabled
lis	r15, 0x803D	# 0x803CCAD5
lbz	r15, -0x352B(r15)	# load PlNs._at
cmpwi	r15, 0x73
bne+	OrigLine
b SdrLine

CheckGaw:
# Check if current character is Game & Watch
cmpwi	r15, 0x18
bne+	OrigLine

# Check if SDR Game & Watch is enabled
lis	r15,0x803D28ED@h
lbz	r15,0x803D28ED@l(r15)	# load PlGw._at
cmpwi	r15, 0x73
bne+	OrigLine

SdrLine:
crandc 2, 2, 2		# Should result in the beq following this funtion to NOT branch
b END

OrigLine:
rlwinm. r0,r0,25,31,31	# Orig code line
END:
b 0

1.02 ----- 0x8026a49c --- 8183002C -> Branch

# Injecting into ItemThink_Shield/Damage
# Check if current character is Ness
mr r15, r0
lwz r15, 0x2C(r15)	# Load pointer to current Player Character Data struct
lwz r15, 4(r15)		# Loading current player internal character ID
cmpwi	r15, 0x8
bne+	CheckGaw

# Current character is Ness. Check if SDR Ness is enabled
lis	r15, 0x803D	# 0x803CCAD5
lbz	r15, -0x352B(r15)	# load PlNs._at
cmpwi	r15, 0x73
bne+	OrigLine
b SdrLines

CheckGaw:
# Check if current character is Game & Watch
cmpwi	r15, 0x18
bne+	OrigLine

# Check if SDR Game & Watch is enabled
lis	r15,0x803D28ED@h
lbz	r15,0x803D28ED@l(r15)	# load PlGw._at
cmpwi	r15, 0x73
bne+	OrigLine

SdrLines:
lis r12,0x802B
ori r12,r12,0x5FE8
b END

OrigLine:
lwz r12, 0x2C(r3)	# Orig code line
END:
b 0


	-==-


Link and Young Link Grab Timer Fix (SDRC)
Allows Link's and Y.Link's grabbox to be controlled by an async timer rather than the DOL.
<https://smashboards.com/threads/sd-remix-3-3-full-with-slippi-rollback-released.324620/post-21743177>
[UnclePunch, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x802A7718 ---- 4BDD38E1 -> Branch

# Check if current character is Link
lwz r15, 4(r28)		# Loading current player internal character ID
cmpwi	r15, 0x6
bne+	CheckYoungLink

# Current character is Link. Check if SDR Link is enabled
lis	r15, 0x803D	# 0x803C80BD
lbz	r15, -0x7F43(r15)	# load PlLk._at
cmpwi	r15, 0x73
bne+	OrigLine
b END		# Do nothing and exit

CheckYoungLink:
# Check if current character is Young Link
cmpwi	r15, 0x14
bne+	OrigLine

# Check if SDR Young Link is enabled
lis	r15, 0x803D1245@h
lbz	r15, 0x803D1245@l(r15)	# load PlCl._at
cmpwi	r15, 0x73
bne+	OrigLine
b END		# Do nothing and exit

OrigLine:
bl 0x8007AFF8		# Original code line (kind of); bl to Hitbox_Deactivate_All
END:
b 0


	-==-


Brawl Bury Mechanics V1.0.3 (SDRC)
Only active when SDR DK is enabled
<https://smashboards.com/threads/brawl-style-bury-mechanics-get-knocked-out-of-bury-if-hit-by-a-strong-knockback-move.514405/>
[Odante, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x8008ECBC ---- 40820018 -> Branch

# Injecting into Damage_BranchToDamageHandler
# Address: 8008ecbc

.macro branch reg, address
  lis \reg, \address @h
  ori \reg,\reg,\address @l
  mtctr \reg
  bctr
.endm

.set REG_FighterData, 29
.set EffectType_Grounded, 0x9
.set EffectType_Normal, 0

# f0 - contains the knockback caused by the current damage

# Check if in bury
beq+ NotInBury_Exit # if not in bury, exit

/*
# Check if character is SDR enabled
# Found pointers to Player Entity Struct for character being hit, not the one doing the hitting!
# r31 = Pointer to current Player Character Data struct
lis r14, 0x803C1F40@h		# Load table address; points to 'Pl__.dat' strings
ori r14, r14, 0x803C1F40@l
lwz r15, 4(r31)			# Load current internal character ID
mulli r15, r15, 8		# r15 is now an offset into the pointer table
lwz r15, r15(r14)		# Load pointer to the 'Pl__.dat' file string
lbz r14, 5(r15)			# Load "s"/"d"/"p" character (first of extension)
cmpwi r14, 0x73			# check if "s"
bne+ NotInBury_Exit
*/

# Check if SDR DK is enabled
lis	r15, 0x803D	# 0x803CBDFD
lbz	r15, -0x4203(r15)	# load PlDk._at
cmpwi	r15, 0x73
bne+	OriginalBuryCheck_Exit

# If in bury, check if knockback is strong enough to unbury the player
# Free to use r3 here but must restore after

# Load the hit's knockback/force_applied
lfs f0, 0x1850(REG_FighterData)

# Load our maximum knockback unit constant
# Free to use r3 here
bl Constants
mflr r3
lfs f1,MaxKnockbackUnits(r3)

# If knockback unit is greater than and not equals to MaxKnockbackUnits,
# skip the damage bury check
fcmpo cr0,f0,f1
ble OriginalBuryCheck_Exit # not enough knockback to unbury, so exit to original bury check

# Otherwise, unbury the player/skip the bury check
# Check if the hit is another Grounded effect
lwz    r3, 0x1860(REG_FighterData) # the effect type of the hit
cmpwi r3, EffectType_Grounded # if effect type is grounded
bne Unbury # if not grounded, just unbury the player

# Set the effect type of the hit to Normal
ResetEffectType:
li r3, EffectType_Normal
stw r3, 0x1860(REG_FighterData)

Unbury:
lbz    r3, 0x2220(REG_FighterData) # restore r3
b NotInBury_Exit

OriginalBuryCheck_Exit:
branch r12, 0x8008ecd4

Constants:
blrl
.set MaxKnockbackUnits,0x0
.float 100 # units of knockback
.align 2

NotInBury_Exit:
b 0


-==-


PK Flash Explodes on Stage Collision (SDRC)
Should affect both Ness and Kirby
[PKFreeZZy, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
##1.02 ----- 0x803F6B94 --- 802AAEE4 -> 802AAD48
##1.02 ----- 0x803F6B98 --- 802AB140 -> 802AB128
##1.02 ----- 0x803F6B9C --- 802AB2A4 -> 802AB29C

1.02 ----- 0x80269384 --- 801E0004 -> Branch

/*
# Skip if not PK Flash
# r27 is currently the item data table struct pointer
lwz r15, 0x10(r27)
cmpwi r15, 0x44
bne+	OrigLine

# Check if current character is Ness
lwz r15, 0x518(r27)	# Load pointer to owner player entity (GObj struct)
lwz r15, 0x2C(r15)	# Load the current character data table struct pointer
lwz r15, 4(r15)		# Loading current player internal character ID
cmpwi	r15, 0x8
bne+	CheckKirby

# Current character is Ness. Check if SDR Ness is enabled
lis	r15, 0x803D	# 0x803CCAD5
lbz	r15, -0x352B(r15)	# load PlNs._at
cmpwi	r15, 0x73
bne+	OrigLine
b SdrLine

CheckKirby:
# Check if current character is Kirby
cmpwi	r15, 0x4
bne+	OrigLine

# Check if SDR Kirby is enabled
lis	r15, 0x803D	# 0x803CA30D
lbz	r15, -0x5CF3(r15)	# load PlKb._at
cmpwi	r15, 0x73
bne+ 	OrigLine

SdrLine:
lis r0, 0x802AAD48@h
ori r0, r0, 0x802AAD48@l
b END

OrigLine:
lwz r0,4(r30)		# Original code line
END:
b 0

1.02 ----- 0x80269394 --- 801E0008 -> Branch

# Skip if not PK Flash
# r27 is currently the item data table struct pointer
lwz r15, 0x10(r27)
cmpwi r15, 0x44
bne+	OrigLine

# Check if current character is Ness
lwz r15, 0x518(r27)	# Load pointer to owner player entity (GObj struct)
lwz r15, 0x2C(r15)	# Load the current character data table struct pointer
lwz r15, 4(r15)		# Loading current player internal character ID
cmpwi	r15, 0x8
bne+	CheckKirby

# Current character is Ness. Check if SDR Ness is enabled
lis	r15, 0x803D	# 0x803CCAD5
lbz	r15, -0x352B(r15)	# load PlNs._at
cmpwi	r15, 0x73
bne+	OrigLine
b SdrLine

CheckKirby:
# Check if current character is Kirby
cmpwi	r15, 0x4
bne+	OrigLine

# Check if SDR Kirby is enabled
lis	r15, 0x803D	# 0x803CA30D
lbz	r15, -0x5CF3(r15)	# load PlKb._at
cmpwi	r15, 0x73
bne+ 	OrigLine

SdrLine:
lis r0, 0x802AB128@h
ori r0, r0, 0x802AB128@l
b END

OrigLine:
lwz r0,8(r30)		# Original code line
END:
b 0

1.02 ----- 0x8026939C --- 801E000C -> Branch

# Skip if not PK Flash
# r27 is currently the item data table struct pointer
lwz r15, 0x10(r27)
cmpwi r15, 0x44
bne+	OrigLine

# Check if current character is Ness
lwz r15, 0x518(r27)	# Load pointer to owner player entity (GObj struct)
lwz r15, 0x2C(r15)	# Load the current character data table struct pointer
lwz r15, 4(r15)		# Loading current player internal character ID
cmpwi	r15, 0x8
bne+	CheckKirby

# Current character is Ness. Check if SDR Ness is enabled
lis	r15, 0x803D	# 0x803CCAD5
lbz	r15, -0x352B(r15)	# load PlNs._at
cmpwi	r15, 0x73
bne+	OrigLine
b SdrLine

CheckKirby:
# Check if current character is Kirby
cmpwi	r15, 0x4
bne+	OrigLine

# Check if SDR Kirby is enabled
lis	r15, 0x803D	# 0x803CA30D
lbz	r15, -0x5CF3(r15)	# load PlKb._at
cmpwi	r15, 0x73
bne+ 	OrigLine

SdrLine:
lis r0, 0x802AB29C@h
ori r0, r0, 0x802AB29C@l
b END

OrigLine:
lwz r0,0xC(r30)		# Original code line
END:
b 0
*/





/*
# Injecting into ItemStateChange(r3=ItemGObj,r4=ItemState,r5=Flags)
# Check if current character is Ness
lwz r15, 0x518(r27)	# Load pointer to owner player entity (GObj struct)
lwz r15, 0x2C(r15)	# Load the current character data table struct pointer
lwz r15, 4(r15)		# Loading current player internal character ID
cmpwi	r15, 0x8
bne+	CheckKirby

# Current character is Ness. Check if SDR Ness is enabled
lis	r15, 0x803D	# 0x803CCAD5
lbz	r15, -0x352B(r15)	# load PlNs._at
cmpwi	r15, 0x73
bne+	OrigLines
b SdrLines

CheckKirby:
# Check if current character is Kirby
cmpwi	r15, 0x4
bne+	OrigLines

# Check if SDR Kirby is enabled
lis	r15, 0x803D	# 0x803CA30D
lbz	r15, -0x5CF3(r15)	# load PlKb._at
cmpwi	r15, 0x73
bne+ 	OrigLines

SdrLines:
lis r15, 0x803F6B90@h				# Load the reference address to store the values
ori r15, r15, 0x803F6B90@l

# Store the SDR code lines
lis r14, 0x802AAD48@h
ori r14, r14, 0x802AAD48@l
stw r14, 4(r15)
lis r14, 0x802AB128@h
ori r14, r14, 0x802AB128@l
stw r14, 8(r15)
lis r14, 0x802AB29C@h
ori r14, r14, 0x802AB29C@l
b END

OrigLines:
lis r15, 0x803F6B90@h				# Load the reference address to store the values
ori r15, r15, 0x803F6B90@l

# Store the original game code lines
lis r14, 0x802AAEE4@h
ori r14, r14, 0x802AAEE4@l
stw r14, 4(r15)
lis r14, 0x802AB140@h
ori r14, r14, 0x802AB140@l
stw r14, 8(r15)
lis r14, 0x802AB2A4@h
ori r14, r14, 0x802AB2A4@l

END:
stw 	r14, 0xC(r15)

# Flush instruction cache
mr r3, r8	# New file address
mr r4, r6	# New file size
bl <data.flush_IC>

lwz r0,4(r30)		# Original code line
b 0
*/

# Injecting into ItemStateChange(r3=ItemGObj,r4=ItemState,r5=Flags)
# Check if about to read the data to be modified
# (Don't want to simply change the values, as we don't know what else might read them!)
lis r14, 0x803F6B90@h				# Load the reference address to the values in question
ori r14, r14, 0x803F6B90@l
cmpw r30, r14
bne+	OrigLine

# Check if current character is Ness
lwz r15, 0x518(r27)	# Load pointer to owner player entity (GObj struct)
lwz r15, 0x2C(r15)	# Load the current character data table struct pointer
lwz r15, 4(r15)		# Loading current player internal character ID
cmpwi	r15, 0x8
bne+	CheckKirby

# Current character is Ness. Check if SDR Ness is enabled
lis	r15, 0x803D	# 0x803CCAD5
lbz	r15, -0x352B(r15)	# load PlNs._at
cmpwi	r15, 0x73
bne+	OrigLine
b SdrLines

CheckKirby:
# Check if current character is Kirby
cmpwi	r15, 0x4
bne+	OrigLine

# Check if SDR Kirby is enabled
lis	r15, 0x803D	# 0x803CA30D
lbz	r15, -0x5CF3(r15)	# load PlKb._at
cmpwi	r15, 0x73
bne+ 	OrigLine

SdrLines:
# Recreate lines 80269384 through 8026939c, but with our values
lis r15, 0x802AAD48@h
ori r15, r15, 0x802AAD48@l
stw r15, 0xD14(r27)
li r4, 0
addi r3, r26, 0
lis r15, 0x802AB128@h
ori r15, r15, 0x802AB128@l
stw r15, 0xD18(r27)
lis r15, 0x802AB29C@h
ori r15, r15, 0x802AB29C@l
stw r15, 0xD1C(r27)

# Return to normal execution in ItemStateChange
lis r15, 0x802693a4@h
ori r15, r15, 0x802693a4@l
mtctr r15
bctr

OrigLine:
lwz r0, 4(r30)		# Original code line
b 0


##1.02 ----- 0x803F6B94 --- 802AAEE4 -> 802AAD48
##1.02 ----- 0x803F6B98 --- 802AB140 -> 802AB128
##1.02 ----- 0x803F6B9C --- 802AB2A4 -> 802AB29C

	-==-


PK Flash Explodes on Interrupt (SDRC)
Should affect SDR Ness and Kirby
[PKFreZZy, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
##1.02 ----- 0x802AAD8C --- 28000000 -> 60000000
##1.02 ----- 0x802AAD90 --- 41820088 -> 60000000

1.02 ----- 0x802AAD90 --- 41820088 -> Branch

# Skip if not PK Flash
# r6 is currently the item data table struct pointer
lwz r15, 0x10(r6)
cmpwi r15, 0x44
beq-	CheckNess
cmpwi r15, 0x91
beq-	CheckKirby
b OrigLine

CheckNess:
# Check if SDR Ness is enabled
lis	r15, 0x803D	# 0x803CCAD5
lbz	r15, -0x352B(r15)	# load PlNs._at
cmpwi	r15, 0x73
bne+	OrigLine
b DisableBranch

CheckKirby:
# Check if SDR Kirby is enabled
lis	r15, 0x803D	# 0x803CA30D
lbz	r15, -0x5CF3(r15)	# load PlKb._at
cmpwi	r15, 0x73
bne+ 	OrigLine

DisableBranch:		# In effect, nops the beq that follows the injection site
crandc 2, 2, 2		# Clears the eq bit in cr0
b END

OrigLine:
cmplwi r0, 0		# Original code line
END:
b 0


	-==-


ROA-Style WD (alternate version + SDRC)
This makes wavedashes easier, by widening the window during which a WD can occur; similar to as they are in Rivals of Aether.
Differences from UnclePunch's original code:
-- Gives higher priority to R+A grab
-- Compatible with tauKhan's Extended SH Jump Input Release Window code
<https://smashboards.com/threads/wavedash-out-of-jumpsquat-roa-style.454197/post-24565408>
[UnclePunch, tauKhan, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x800cb634 --- 2C030000 -> Branch

# Check if the universal flag is set (from debug menu option)
lis r15, 0x8023	# 0x802288F8
lwz r15, -0x7708(r15)
cmpwi r15, 0
bne- Main		# Code is ON if the flag is non-zero

# Check if the current character is SDR-enabled
# r31 = Pointer to current Player Character Data struct
lis r15, 0x803C1F40@h		# Load table address; points to 'Pl__.dat' strings
ori r15, r15, 0x803C1F40@l
lwz r4, 0x2C(r31)		# Load pointer to player/fighter data table
lwz	r4, 4(r4)			# Load current internal character ID
mulli r4, r4, 8			# r4 is now an offset into the pointer table
add r15, r15, r4
lwz r4, 0(r15)			# Load pointer to the 'Pl__.dat' file string
lbz r15, 5(r4)			# Load "s"/"d"/"p" character (first of extension)
cmpwi r15, 0x73			# check if "s"
bne+ END

Main:
  cmpwi r3, 0x0
  bne- END
  lwz r30, 44(r31)
  lwz r0, 1640(r30)
  rlwinm. r0, r0, 0, 25, 26
  beq- END
  lfs f1, 1572(r30)
  lfs f0, -26472(r2)
  fcmpo cr0, f1, f0
  ble- loc_0x44
  mr r3, r31
  lis r12, 0x8009
  ori r12, r12, 0x9A9C
  mtctr r12
  bctrl 
  cmpwi r31, 0x0
  b END

loc_0x44:
  mr r3, r30
  lis r12, 0x8007
  ori r12, r12, 0xD9D4
  mtctr r12
  bctrl 
  lis r12, 0x8032
  ori r12, r12, 0x6240
  mtctr r12
  bctrl 
  lwz r3, -20812(r13)
  lfs f0, 824(r3)
  fmuls f0, f0, f1
  lfs f1, 828(r3)
  fmuls f0, f1, f0
  stfs f0, 128(r30)
  mr r3, r31
  lis r12, 0x8009
  ori r12, r12, 0x9D70
  mtctr r12
  bctrl 
  cmpwi r31, 0x0

END:
cmpwi r3,0	# orig code line
b 0


	-==-

!


Static Player Block offsets:
  P1	   P2		P3		 P4
80453080 80453F10 80454DA0 80455C30 	80456AC0 80457950 
pointers to Player Entities (+0xB0):
80453130 80453FC0 80454E50 80455CE0

													   v address of P1 struct
Static Player Block [+0xB0; pointer to]
	Player Entity Struct [+0x2C; pointer to]		80C633C0		80CA5380
		Player Character Data							80C63420		80CA53E0

					8006b82c	(PlayerThink_Physics)
						800e253c









8006ad10	Main character loop	Function	
			^ Top-level character update; runs once per character per frame in game loop




****************************
* C Falcon Down B Textures *
****************************


80c8abe0


040e3eac 4e800020 # orig code?




inject @ 800e3eac (CFalcon/Ganon_DownB_TextureDisplay)
- r3 = external data offset start

lwz	r5,0x2c(r3)	# load internal data offset	(Player Char. Data?)	in testing, r3 = 80c75300; r5 will then be 80c75360
lwz	r4,0x4(r5)	# load internal char id
cmpwi	r4,2		# is this C. Falcon? (Ganon shares code)
bne-	END
lwz	r4,0x10(r5)	# load Action state ID
cmpwi r4,0x165	# grounded down-b state only
bne-	END

lis	r4,0x803c
lbz	r4,0x759d(r4)	# load PlCa._at
cmpwi	r4,0x73
bne-	END

blr	#skip this function if SD Remix
END:
mflr	r0


********************************
* C. Falcon / Ganon SDR Side-B *
********************************
800cc730 = AS_Fall
80096900 = AS_FallSpecial

inject @ 
800e39d0 - aerial side-b miss
800e3aec - aerial side-b hit
800e3cd0 - side-b off edge


lwz	r4,0x2c(r3)	# load internal data offset
lwz	r4,4(r4)	# load internal char ID
cmpwi	r4,2		# is C Falc?
beq-	FALCON
GANON:
lis	r4,0x803d
lbz	r4,0x2cdd(r4)	# load PlGn._at
cmpwi	r4,0x73
bne-	FALLSPECIAL
b	FALL

FALCON:
lis	r4,0x803c
lbz	r4,0x759d(r4)	# load PlCa._at
cmpwi	r4,0x73
bne-	FALLSPECIAL
FALL:
lis	r4,0x800c
ori	r4,r4,0xc730
b	END_END

FALLSPECIAL:
lis	r4,0x8009
ori	r4,r4,0x6900
END_END:
mtlr	r4
blrl


********************************************
* PlCo.dat File Loading - SD Remix Changes *
********************************************

80067abc   FileLoad_PlCo.dat


Perform SD Remix Changes if SDR Character is Chosen

inject @ 80067af0 - stw r0,-0x514c(r13)
- r0 = 0x9fe0 in PlCo.dat at this point

DEFAULT:
stw	 r0,-0x514c(r13)

mr	r16,r0			# move PlCo pointer to r16
SD_REMIX_DK:	
lis	r14,0x803d	
lbz	r14,-0x4203(r14)	# 803cbdfd
cmpwi	r14,0x73		# is PlDk.sat ?
bne-	SD_REMIX_KIRBY	# if not, ignore and keep orig value
lis	r15,0x40c0	
stw	r15,0x600(r16)	
lis	r15,0x3f66	
ori	r15,r15,0x6666	
stw	r15,0x60c(r16)	
li	r15,1	
stw	r15,0x620(r16)	

	
SD_REMIX_KIRBY:	
lis	r14,0x803d	
lbz	r14,-0x5cf3(r14)	# 803ca30d
cmpwi	r14,0x73		# is PlKb.sat?
bne-	SHIELD_COLORS	# if not, ignore and keep orig value
lis	r14,0xcb18	
ori	r14,r14,0x9680	
stw	r14,0x3c8(r16)	


SHIELD_COLORS:
li	r14,4
mtctr	r14
lis	r14,0x803f
ori	r14,r14,0xa2d8	# -0x10 from P1 custom shield on/off
addi	r16,r16,0x2ED4	# get -0x4 from P1 shield color 
SHIELD_COLOR_LOOP:
addi	r16,r16,4		# get to this player's shield color
lwzu	r15,-0x10(r14)	# load custom shield on/off flag
cmpwi	r15,0
beq- SHIELD_COLOR_COMPARE
lwz 	r15,-4(r14)		# load Red value
stb	r15,0(r16)		# store Red value
lwz	r15,-8(r14)		# load Blue value
stb	r15,1(r16)		# store Blue value
lwz	r15,-0xc(r14)		# load Green value
stb	r15,2(r16)		# store Green value

SHIELD_COLOR_COMPARE:
bdnz+ SHIELD_COLOR_LOOP


END:



**********************************************************************
* C. Falcon SDR - Escape (Airdodge) Interrupt During UpA SpecialFall *
**********************************************************************

inject @ 800e4f2c - bl 0x80096900

lis	r6,0x8009
ori	r6,r6,0x6900
mtlr	r6
li	r6,0
blrl		# put char in SpecialFall, default code line
lwz r3,0x2c(r30)	# load internal data offset
lwz	r4,0x4(r3)	# load internal char ID
cmpwi	r4,2		# is C Falc?
bne-	END
lis	r4,0x803c
lbz	r4,0x759d(r4)	# load PlCa._at
cmpwi	r4,0x73		#	PlCa.sat?
bne-	END
#SDR c. falcon
lis	r4,0x8009
ori	r4,r4,0x9a58	# load Interrupt_Escape
stw	r4,0x219C(r3)	# store as new interrupt function
END:



Add airdodge interrupt to Falcon Up-B
-  needs tested

inject @ 800e4f58	- lwz	r31,0x2c(r3)

lwz r4,0x2c(r3)	# load internal char offset		in testing, r3 is 80c8abe0; r4 will then be 80c8ac40
lwz	r31,0x4(r4)	# load internal char ID
cmpwi	r31,2		# is C Falc?
bne-	END
lis	r31,0x803c
lbz	r31,0x759d(r31)	# load PlCa._at
cmpwi	r31,0x73	# PlCa.sat?
bne-	END

lis	r31,0x8009
ori	r31,r31,0x9a58	# 80099a58 = Interrupt_EscapeAir
mtlr	r31
mr	r31,r3
blrl
cmpwi	r3,1
bne-	CONTINUE
lis	r3,0x800e
ori	r3,r3,0x4fc8	# branch to end of this function
mtctr	r3
bctr

CONTINUE:
mr	r3,r31

END:
lwz	r31,0x2c(r3)





Characters:  (external/internal/name)
----------------------------------
00 02 falcon
01 03 donkey
02 01 fox
03 18 game&watch
04 04 kirby
05 05 bowser
06 06 link
07 11 luigi
08 00 mario
09 12 marth
0A 10 mewtwo
0B 08 ness
0C 09 peach
0D 0C pikachu
0E 0A/0B ice climbers (A=popo)
0F 0F jigglypuff
10 0D samus
11 0E yoshi
12 13 zelda
13 07 shiek
14 16 falco
15 14 y. link
16 15 drmario
17 1A roy
18 17 pichu
19 19 ganondorf
1A 1B master hand
1B 1D male wireframe
1C 1E female wireframe
1D 1F giga bowser
1E 1C crazy hand
1F 20 sandbag
20 0A popo (ice climbers)


charAbbrList = [ # By External Character ID
	'Ca',	# 0x0
	'Dk',
	'Fx',
	'Gw',
	'Kb',
	'Kp',
	'Lk',
	'Lg',
	'Mr',	# 0x8
	'Ms',
	'Mt',
	'Ns',
	'Pe',
	'Pk',
	'Pp',	# Both ICies
	'Pr',
	'Ss',	# 0x10
	'Ys',
	'Zd',
	'Sk',
	'Fc',
	'Cl',
	'Dr',
	'Fe',
	'Pc',	# 0x18
	'Gn',
	'Mh',
	'Bo',
	'Gl',
	'Gk',
	'Ch',
	'Sb',
	'Pp'	# Sopo; 0x20
]