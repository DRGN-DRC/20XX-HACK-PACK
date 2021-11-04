

	-==-


Lagless Fountain of Dreams, v1.1
This version has been updated to always run for GrIz.eat (Luigi's Mansion)
[Dan Salvato, Myougi, Achilles, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x801CBB90 ---- 9421FFF8 -> Branch

.macro overwriteEntry adr, orig, noLag
.long \adr
.long \orig
.long \noLag
.endm

.macro  word_load reg1, reg2, address
lis \reg2, \address @ha
lwz \reg1,\address @l (\reg2)
.endm

.macro  adr_load reg, address
lis \reg, \address @h
ori \reg,\reg,\address @l
.endm

.macro  adr_blrl reg, address
lis \reg, \address @h
ori \reg,\reg,\address @l
mtlr \reg
blrl
.endm

.set tableEnd, 0
.set tableEntryLength, 0xc
.set tableOrig, 4
.set tableNoLag, 8

.set DebugMenu.FoD, 0x803fa3ac
.set OSBootInfo.consoleType, 0x8000002c

stwu sp,-0x8(sp)

# Check if this is Luigi's Mansion
lis r3, 0x803E0E56@h
lbz r3, 0x803E0E56@l(r3)
cmpwi r3, 0x45		# ASCII for capital E
beq- NO_LAG		# Always run for this stage

word_load r3,r3,DebugMenu.FoD
cmpwi r3,0
beq- ORIG
cmpwi r3,1
beq- NO_LAG

word_load r3,r3,OSBootInfo.consoleType
rlwinm. r3,r3,0,3,3	# 0x10000000 --> no lag on Dolphin
bne- NO_LAG

li r4,0
li r6,0
lis r3,0x8045
ori r3,r3,0x3088

PLAYER_LOOP:
mulli r5,r4,0xe90
lwzx r5,r5,r3
cmpwi r5,3
beq+ PLAYER_LOOP_CONTINUE
addi r6,r6,1
PLAYER_LOOP_CONTINUE:
addi r4,r4,1
cmpwi r4,6
bne+ PLAYER_LOOP
cmpwi r6,3	# 3 players or more = lagless
blt+ ORIG
NO_LAG:
# add shadow render flag to "frozen" water ground
# note: The hardcoded subtraction offset could cause problems if
# structure of the FoD file internals were moved
.set StageInfo.GrGroundParam, 0x8049ED78
word_load r6,r6,StageInfo.GrGroundParam
adr_load r5,0x0002ae44
sub r5,r6,r5
lbz r6,0(r5)
ori r6,r6,4	# add shadow render flag
stb r6,0(r5)

li r5,tableNoLag
b CONTINUE
ORIG:
li r5,tableOrig
CONTINUE:

bl TABLE
mflr r3
subi r3,r3,tableEntryLength
LOOP:
lwzu r4,tableEntryLength(r3)
cmpwi r4,tableEnd
beq- END
STORE:
lwzx r6,r5,r3
stw r6,0(r4)
li r0,0
icbi r0,r4
sync
isync
b LOOP

TABLE:
blrl
overwriteEntry 0x801cc8ac, 0xec0007fa, 0xfc000028
overwriteEntry 0x801cbe9c, 0x4bffc29d, 0x60000000
overwriteEntry 0x801cbef0, 0x80840030, 0x60000000
overwriteEntry 0x801cbf54, 0x48000bc5, 0x60000000
overwriteEntry 0x80390838, 0x4bfffe05, 0x60000000
overwriteEntry 0x801cd250, 0x48174f81, 0x60000000
overwriteEntry 0x801ccdcc, 0x387f01d4, 0x480000b4
.long tableEnd

END:
b 0