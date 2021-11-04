# OnBoot()
# After memory card data has been loaded.
# inject @ 801bfa28 - lwz	r0,0x1c(sp)
# v1.1 removed copying of debug menu struct to mem card, and removal of trophies code
# v1.2 more robust version checking, since I'm updating major version to 5.0

.macro  adr_load reg, address
lis \reg, \address @h
ori \reg,\reg,\address @l
.endm

.macro  byte_store reg1, reg2, address
lis \reg2, \address @ha
stb \reg1,\address @l (\reg2)
.endm

.macro  word_store reg1, reg2, address
lis \reg2, \address @ha
stw \reg1,\address @l (\reg2)
.endm

.macro  word_load reg1, reg2, address
lis \reg2, \address @ha
lwz \reg1,\address @l (\reg2)
.endm

### need to copy memory card contents to debug menu flags!
# check to overwrite current memory card data
lis	r3,0x803f
ori	r3,r3,0xa154	# start of 20XX flags in DOL space
lis	r4,0x8046
ori	r4,r4,0x9b94	# start of 20XX flags space from memory card

# New 5.0+ 20XX version data at 803fa154|0x3F7158 stores as bytes rather than a string.
# Byte1 = null, byte2 = version.major, byte3 = version.minor, byte4 = version.patch

# Compare 20XX tag
lwz	r5, 0(r3)	# load first word of DOL data
lwz	r6, 0(r4)	# load first word of mem card data
cmpw	r6,r5
bne-	END_MEM_CARD

# Check the memory card version type (whether it's the old v4 format or new v5 format)
lbz r5, 4(r4)
cmpwi r5, 0
bne- OLD_VERSION_FORMAT
# Version is >= 5.0; no incompatibilities to check for. Match the mem card version to DOL version
UPDATE_MEMCARD_VERSION:
lwz r5, 4(r3)
stw r5, 4(r4)		# update version in memory card data to that of the DOL
b MEMORY_CARD_LOAD

OLD_VERSION_FORMAT: # Allow memory card data from v4.06 and v4.07
# Check that the major version is 4
lhz r6, 4(r4)
cmpwi r6, 0x342E	# '4.'
bne- END_MEM_CARD
# Check minor version for 06
lhz r6,6(r4)		
cmpwi r6,0x3036		# '06'
beq- UPDATE_MEMCARD_VERSION
lhz r5,6(r4)
cmpwi r5,0x3037		# '07'
beq- UPDATE_MEMCARD_VERSION
b END_MEM_CARD 		# Version is sus

MEMORY_CARD_LOAD:	# Load data from the memory card region to the DOL regions
li r5,0x1558		# Total number of bytes to load for 20XX debug flags
subi r3,r3,4
subi r4,r4,4

MEM_CARD_REPEAT:
MEM_CARD_SKIP_DEBUGMENU:
lis r6,0x803f
ori r6,r6,0xa4cc
cmpw r3,r6
blt- MEM_CARD_SKIP_DEBUGMENU_END
lis r6,0x803f
ori r6,r6,0xa848
cmpw r3,r6
bge- MEM_CARD_SKIP_DEBUGMENU_END
MEM_CARD_SKIP:
addi r3,r3,4

b MEM_CARD_REPEAT
MEM_CARD_SKIP_DEBUGMENU_END:

MEM_CARD_REPEAT_CONTINUE:
lwzu r6,4(r4) # load data from memory card
stwu r6,4(r3) # restore data from memory card to RAM flags
subi r5,r5,4
cmpwi r5,0
bne- MEM_CARD_REPEAT


END_MEM_CARD:
# DbLevel = Master Mode
li r3,0
stw r3,-0x6c98(r13)

# MnSlChr Texture
.set DebugMenu.MnSlChrTexture, 0x803faf70
.set MnSlChrASCII, 0x803f115c
word_load r3,r3,DebugMenu.MnSlChrTexture
addi r3,r3,0x30	# don't go above 9 for now...
byte_store r3,r4,MnSlChrASCII

## SdMenu & SdSlChr._at##
lis	r3,0x8040
lbz	r3,-0x5D1C(r3)	# load current hacked stage byte
lis	r4,0x803f
stb	r3,-0x3A39(r4)	# SdMenu._at @ 803ec5c7
stb	r3,0x11ac(r4)	# SdSlChr._at @ 803f11ac


### Unlock Features ###
lis	r3,0x8017
ori	r3,r3,0x2898
mtlr	r3
blrl


### PAL Mode ###
MODE_INIT:
li r6,0x64	# ASCII 'd' (.dat extension)
lis	r3,0x8040
lwz	r3,-0x5D00(r3)	# load PAL mode flag
cmpwi	r3,0
beq-	MODE_INIT_CONTINUE
#PAL Mode is on...
li	r6,0x70		# ASCII 'p' (.pat extension)
MODE_INIT_CONTINUE:
.set playerFiles, 0x803c1f40
.set playerFiles_plus4, playerFiles + 4
.set playerFiles_minus8, playerFiles - 8
adr_load r3,playerFiles_minus8

CHAR_LOOP:
lwzu	r5,8(r3)	# load player file offset
lhz	r4,0x2(r5)	# load 2 letter char designation
cmpwi	r4,0x4d68	# is this MasterHand?
beq-	MODE_INIT_END
stb	r6,0x5(r5)	# make .pat or .dat
b	CHAR_LOOP
MODE_INIT_END:

COSTUME_INIT:	# set alt costumes off
.set costumeTable, 0x803D51A0
li r3,0	# player counter, external ID


COSTUME_INIT_LOOP:
.set characterIDtable, 0x803bcde0
adr_load r5,characterIDtable
mulli r6,r3,3
add r5,r5,r6
lbz r6,0(r5)
lbz r7,1(r5)	# secondary char
cmpwi r6,0x1b
bge- COSTUME_INIT_COMPARE
COSTUME_INIT_SECONDARY_CHAR:

adr_load r4,costumeTable
mulli r5,r3,4
lbzx r4,r4,r5	# r4 = number of costumes for this player
COSTUME_INIT_LOOP_COSTUME:

adr_load r5,playerFiles_plus4
mulli r6,r6,8
lwzx r5,r5,r6	# r5 = player costume ASCII stuff
COSTUME_INIT_FIND_COSTUME:
lbzu r6,1(r5)
cmpwi r6,0x2e	# check for period, '.'
bne- COSTUME_INIT_FIND_COSTUME
li r6,0x64	# 'd' for .dat

#red falcon check
cmpwi r3,0	# captain falcon?
bne- COSTUME_INIT_RED_FALCON_FALSE
cmpwi r4,4	# red falcon?
bne- COSTUME_INIT_RED_FALCON_FALSE
COSTUME_INIT_RED_FALCON_TRUE:
stb r6,-1(r5)
b COSTUME_INIT_RED_FALCON_END
COSTUME_INIT_RED_FALCON_FALSE:
stb r6,1(r5)
COSTUME_INIT_RED_FALCON_END:

subi r4,r4,1
cmpwi r4,0
bne- COSTUME_INIT_FIND_COSTUME
cmpwi r7,0xff
beq- COSTUME_INIT_SECONDARY_CHECK_END
mr r6,r7
li r7,0xff
b COSTUME_INIT_SECONDARY_CHAR

COSTUME_INIT_SECONDARY_CHECK_END:
COSTUME_INIT_COMPARE:
addi r3,r3,1
cmpwi r3,3	# disable for G&W --> no alt costumes
beq- COSTUME_INIT_COMPARE
cmpwi r3,0x20
blt- COSTUME_INIT_LOOP

METAL_FLAGS:
.set metal_20XX, 0x8000335c
li r4,0
word_store r4,r3,metal_20XX

FORCE_TEAM_MODE:
# force team mode as default for Tag Team Melee (Slo-Mo Melee) and Dual 1v1 (Giant Melee)
lis r3,0x8046
li r4,1	# Teams mode ON
stb r4,-0x49A0(r3)	# Dual 1v1
stb r4,-0x4720(r3)	# Tag Team Melee

END:
lwz	r0,0x1c(sp)		# original code line
b 0