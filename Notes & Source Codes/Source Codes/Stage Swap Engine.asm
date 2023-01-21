

Stage Swap Engine (v3.0)
Responsible for checking the current stage select screen and loading the appropriate pre-defined or random stage, as defined by the Stage Swap Info Table.
This also handles some stage file modifications when the file is loaded.

v2.x of this code relocates the Stage Swap Table from the Code Library to a file in the disc filesystem, and fixes random byte overwrites (when using 0xFF byte replacement mode).
v3.x separates out modifications to Battlefield to the new "Battlefield Custom Platform Controller" code.
[Achilles, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 ---- 0x3F8C70 ----- 

6174696F 5F31203A 00000000 4F666652
6174696F 5F32203A 00000000 4F666652
6174696F 5F33203A 00000000 4F666652
6174696F 5F34203A 00000000 00000000
00000000 803FBC58 00000000 00000000
00000000 00000000 00000000 00000008
00000000 803FBC6C 00000000 803FA2D0
00000000 40400000 3DCCCCCD 00000008
00000000 803FBC7C 00000000 803FA2D4
00000000 40400000 3DCCCCCD 00000008
00000000 803FBC8C 00000000 803FA2D8
00000000 40400000 3DCCCCCD 00000008
00000000 803FBC9C 00000000 803FA2DC
00000000 40400000 3DCCCCCD 00000009
00000000 00000000 00000000 00000000
00000000 00000000 00000000 3C204465
66656E63 65205261 74696F20 3E000000
44656652 6174696F 5F31203A 00000000
44656652 6174696F 5F32203A 00000000
44656652 6174696F 5F33203A 00000000
44656652 6174696F 5F34203A 00000000
00000000 00000000 803FBD6C 00000000
00000000 00000000 00000000 00000000
00000008 00000000 803FBD80 00000000
803FA2E0 00000000 40400000 3DCCCCCD
00000008 00000000 803FBD90 00000000
803FA2E4 00000000 40400000 3DCCCCCD
00000008 00000000 803FBDA0 00000000
803FA2E8 00000000 40400000 3DCCCCCD
00000008 00000000 803FBDB0 00000000
803FA2EC 00000000 40400000 3DCCCCCD
00000009 00000000 00000000 00000000
00000000 00000000 00000000 00000000
43705470 5F537461 79202000 43705470
5F57616C 6B202000 43705470 5F457363
61706500 43705470 5F4A756D 70202000
43705470 5F4E6F72 6D616C00 43705470
5F4D616E 75616C00 43705470 5F4E616E
61202000 43705470 5F446566 656E7369
76650000 43705470 5F537472 7567676C
65000000 43705470 5F467265 616B2000
43705470 5F436F6F 70657261 74650000
43705470 5F53704C 774C696E 6B000000
43705470 5F53704C 7753616D 75730000
43705470 5F4F6E6C 79497465 6D000000
43705470 5F45765A 656C6461 00000000
43705470 5F4E6F41 63740000 43705470
5F416972 00000000 43705470 5F497465
6D000000 803FBE80 803FBE8C 803FBE98
803FBEA4 803FBEB0 803FBEBC 803FBEC8
803FBED4 803FBEE4 803FBEF4 803FBF00
803FBF10 803FBF20 803FBF30 803FBF40
803FBF50 803FBF5C 803FBF68 3C204370
75205479 7065203E 00000000 54797065
5F5F4331 203A0000 54797065 5F5F4332
203A0000 54797065 5F5F4333 203A0000
54797065 5F5F4334 203A0000 00000000
00000000 803FBFBC 00000000 00000000
00000000 00000000 00000000 00000002
00000000 803FBFCC 803FBF74 803FA300
00000000 41900000 00000000 00000002
00000000 803FBFD8 803FBF74 803FA304
00000000 41900000 00000000 00000002
00000000 803FBFE4 803FBF74 803FA308
00000000 41900000 00000000 00000002
00000000 803FBFF0 803FBF74 803FA30C
00000000 41900000 00000000 00000009
00000000 00000000 00000000 00000000
00000000 00000000 00000000 3C204370
75204C65 76656C20 3E000000 4C657665
6C5F4331 203A0000 4C657665 6C5F4332
203A0000 4C657665 6C5F4333 203A0000
4C657665 6C5F4334 203A0000 00000000
00000000 803FC0BC 00000000 00000000
00000000 00000000 00000000 00000003
00000000 803FC0CC 00000000 803FA310
00000000 41100000 3F800000 00000003
00000000 803FC0D8 00000000 803FA314
00000000 41100000 3F800000 00000003
00000000 803FC0E4 00000000 803FA318
00000000 41100000 3F800000 00000003
00000000 803FC0F0 00000000 803FA31C
00000000 41100000 3F800000 00000009
00000000 00000000 00000000 00000000
00000000 00000000 00000000 5265642D
5465616D 00000000 47726565 6E2D5465
616D0000 426C7565 2D546561 6D000000
803FC1BC 803FC1C8 803FC1D4 3C205465
616D2053 656C6563 74203E00 5465616D
5F31203A 00000000 5465616D 5F32203A
00000000 5465616D 5F33203A 00000000
5465616D 5F34203A 00000000 00000000
00000000 803FC1EC 00000000 00000000
00000000 00000000 00000000 00000002

 ->

# Space reservation (todo: move file to arena?)
3C535441 47455357 41502049 4E464F3E
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000

NTSC 1.02 ---- 0x258720 ----- 8804000B -> Branch

# Main Logic; looks up data from the
# Stage Swap Table and prepares file loading

/*
Stage swap data starts @ 803FBC80 in RAM (0x3f8c80 DOL)
- each stage entry is 0x30 in length
- order is external stage ID

AAAAAAAA AAAAAAAA CCCCCCCC DDDDDDDD
EEEEEEEE FFFFFFFF GGGGGGGG HHHHHHHH
IIIIIIII JJJJJJJJ KKKKKKKK LLLLLLLL

MnSlMap means the order is MnSlMap.1sd, .2sd, .3sd, .4sd.

A = stage name text (for human reading purposes)
C = stage swap ID (external), MnSlMap bytes
D = custom stage flags, MnSlMap bytes, gets sent to 803fa2e5
E-H = byte overwrite RAM pointer, MnSlMap words
I = byte overwrite value, MnSlMap bytes
J-L = random byte overwrite values (max 4), MnSlMap words (.2sd to .4sd)

8025a998 00000eb8 8025a998 0 SceneLoad_SSS	<- loaded first. loads MnSlMap file
8025b744 0000010c 8025b744 0 SceneLoad_SSS

803f0a18
*/

# -----------------------
# Main Stage Swap Code -
# Inject @ 8025bb40

# r20 = location to store new external stage ID
# r21 = external stage ID
# r22 = stage swap table entry start for this stage ID
# r23 = 20XX SSS number (.1sd = 0, .2sd = 1, etc.)

#-----
# Texture:
# r24 = Debug Menu texture flag

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

.macro  byte_load reg1, reg2, address
lis \reg2, \address @ha
lbz \reg1,\address @l (\reg2)
.endm

.macro  byte_store reg1, reg2, address
lis \reg2, \address @ha
stb \reg1,\address @l (\reg2)
.endm

.macro  word_load reg1, reg2, address
lis \reg2, \address @ha
lwz \reg1,\address @l (\reg2)
.endm

.macro  word_store reg1, reg2, address
lis \reg2, \address @ha
stw \reg1,\address @l (\reg2)
.endm

.macro  gpr_save
stwu	r1,-64(r1)	# make space for 12 registers
stmw	r20,8(r1)	# push r20-r31 onto the stack
.endm

.macro  gpr_restore
lmw	r20,8(r1)	# pop r20-r31 off the stack
addi	r1,r1,64	# release the space
.endm

.set swap_t.len, 0x30	# swap table index entry length
.set swap_t.loc, 0x803fbc20	# RAM loc for first entry (but first two external IDs unused)
.set swap_t.externalID, 0x8	# external ID swapping
.set swap_t.flag, 0xc	# custom stage flag
.set swap_t.overwrite_pointers, 0x10
.set swap_t.overwrite_byte, 0x20

.set mnslmap.number, 0x803f0a20
.set custom_stage_flag, 0x803fa2e5
.set debug.vs_target, 0x803FA280	# debug menu flag for 20XX VS Target Test

gpr_save

SWAP_START:
mr r20,r3	# original ASM line after this inject is "sth r0,0x1e(r3)"
lbz	r21,0xb(r4)	# default code line - load external stage ID

mulli	r23,r21,swap_t.len
adr_load r22, swap_t.loc
add	r22,r22,r23	# r22 = start of this stage's swap data

byte_load r23, r23, mnslmap.number	#load SSS number from location of MnSlMap.?at
subi	r23,r23,0x31	# convert from ASCII 1-indexed to 0-indexed,
#r23 holds MnSlMap number (1=default)
# MnSlMap.1at = 0, MnSlMap.2at = 1, etc.

addi	r24,r23, swap_t.flag	# add value to get to the custom stage flag byte
lbzx	r24,r24,r22	# load stage flag byte

byte_store r24,r25, custom_stage_flag	# store custom stage flag

addi	r24,r23,swap_t.externalID	# add value to get to stage swap byte
lbzx	r24,r24,r22	# load stage swap byte
cmpwi 	r24,0	# if swap external ID = 0, skip
beq+	SWAP_END

mr	r21,r24	# set as new external stage ID to load

SWAP_DEBUG_TARGET:
cmpwi	r21,0x1a	#Change 0x1a to Debug Target
bne+	SWAP_DEBUG_TARGET_END
word_load r21,r24,debug.vs_target	
addi	r21,r21,0x21
b	SWAP_END
SWAP_DEBUG_TARGET_END:

AERIAL_ARENA:	# note: additional coding is necessary to load aerial arena
cmpwi	r21,0x15	#Change Akaneia to Aerial Arena
bne+	AERIAL_ARENA_END
li	r21,0
AERIAL_ARENA_END:

SWAP_END:

SWAP_BYTE_OVERWRITE:
mulli	r24,r23,0x4	# multiply SSS number by 0x4 (for word length indexing)
addi	r24,r24,swap_t.overwrite_pointers

lwzx	r24,r22,r24	# r24 holds 8-bit overwrite address
cmpwi	r24,0
beq-	SWAP_BYTE_OVERWRITE_END
addi	r25,r23,swap_t.overwrite_byte	# load 8-bit overwrite
lbzx	r25,r25,r22	# load stage overwrite byte
cmpwi	r25,0
beq-	SWAP_BYTE_OVERWRITE_END		# skip writing byte if = 0
cmpwi	r25,0xFF	# FF = flag for using random bytes
bne-	SWAP_BYTE_OVERWRITE_GO

# r24 = pointer to overwrite address

COUNT_RANDOM_BYTES:
cmpwi	r23,0		# no random for MnSlMap.1at
beq-	SWAP_BYTE_OVERWRITE_END
li	r3,0
li	r25,4		# 4 possible random bytes
mtctr	r25
mulli	r25,r23,0x4
addi	r25,r25,swap_t.overwrite_byte	# stage swap table entry offset

COUNT_RANDOM_REPEAT:
lbzx	r26,r25,r22
cmpwi	r26,0
beq-	REPEAT_END
addi	r3,r3,1
REPEAT_COMPARE:
addi	r25,r25,1
bdnz+	COUNT_RANDOM_REPEAT

REPEAT_END:		#r3 = number of random bytes
RNG:
adr_blrl r4, 0x80380580

mulli	r25,r23,0x4	# multiply SSS by 0x4 for word indexing
addi	r26,r3,swap_t.overwrite_byte
add	r26,r26,r25
lbzx	r25,r26,r22	# load random selected overwrite byte

SWAP_BYTE_OVERWRITE_GO:
mr r3,r24
bl BYTE_OVERWRITE_SAVE
stb	r25,0(r24)	# store new overwrite byte
#lis	r26,0x8040
#stw	r24,-0x3DA0(r26)# store stage swap undo flag address
#lbz	r27,0(r24)	# load current byte at address
#stb	r27,-0x3D9C(r26)# store current byte at flag address
#stb	r25,0(r24)	# store new overwrite byte
b END	# skip texture filename changing if byte swapping
SWAP_BYTE_OVERWRITE_END:

TEXTURE_SWAP:
# r20 = location to store new external stage ID
# r21 = external stage ID
# r22 = stage swap table entry start for this stage ID
# r23 = 20XX SSS number (.1sd = 0, .2sd = 1, etc.)

#-----
# Texture:
# r24 = filename string pointer
# r25 = Debug Menu texture flag

mulli r4,r21,12
lis r3,0x803e
ori r3,r3,0x9960
lwzx	r3,r3,r4	# r3 now equals internal stage ID
lis r4,0x803e
subi r4,r4,292
rlwinm r3,r3,2,0,29
lwzx r24,r3,r4	# r24 = pointer to external stage data
lwz	r24,8(r24)	# r24 = pointer to filename ascii
cmpwi r24,0
beq- TEXTURE_SWAP_END

# check for advanced texture hack here based on SSS page?

.set texture.bf, 0x803fa1e8
.set texture.fd, 0x803fa1e4
.set texture.ys, 0x803fa1e0
.set texture.fod, 0x803fa1dc
.set texture.dl, 0x803fa1d8
.set texture.ps, 0x803fa1d4

li r25,0xff	# flag for no Debug Menu texture available
TEXTURE_SWAP_FOD:
cmpwi r21,0x2	# 0x02 = Fountain of Dreams
bne+	TEXTURE_SWAP_FOD_END
word_load r25,r25, texture.fod
TEXTURE_SWAP_FOD_END:
TEXTURE_SWAP_PS:
cmpwi r21,0x3	# 0x03 = Pokemon Stadium
bne+	TEXTURE_SWAP_PS_END
word_load r25,r25, texture.ps
TEXTURE_SWAP_PS_END:
TEXTURE_SWAP_YS:
cmpwi r21,0x8	# 0x08 = Yoshi's Story
bne+	TEXTURE_SWAP_YS_END
word_load r25,r25, texture.ys
TEXTURE_SWAP_YS_END:
TEXTURE_SWAP_DL:
cmpwi r21,0x1c	# 0x1c = Dream Land 64
bne+	TEXTURE_SWAP_DL_END
word_load r25,r25, texture.dl
TEXTURE_SWAP_DL_END:
TEXTURE_SWAP_BF:
cmpwi r21,0x1f	# 0x1f = Battlefield
bne+	TEXTURE_SWAP_BF_END
word_load r25,r25, texture.bf
TEXTURE_SWAP_BF_END:
TEXTURE_SWAP_FD:
cmpwi r21,0x20	# 0x20 = Final Destination
bne+	TEXTURE_SWAP_FD_END
word_load r25,r25, texture.fd
TEXTURE_SWAP_FD_END:

li r31,0	# texture swap counter
cmpwi r25,0xff	# if not 0xFF, then debug menu word flag has been loaded
bne+ TEXTURE_SWAP_GO
b TEXTURE_SWAP_END

TEXTURE_SWAP_GO:
.set texture.random, 0xf	# last in Debug Menu list
mr r26,r25		# r26 = copy of debug menu selection
cmpwi r25,texture.random	# check if random
blt-	TEXTURE_SWAP_SAVE
TEXTURE_SWAP_RANDOM:
li r3,texture.random
adr_blrl r4, 0x80380580 # To HSD_Randi
mr r25,r3

TEXTURE_SWAP_SAVE:
CONVERT_TO_ASCII:
cmpwi r25,0xa
bge- CONVERT_TO_ASCII_LETTER
addi r25,r25,0x30
b CONVERT_TO_ASCII_END
CONVERT_TO_ASCII_LETTER:
addi r25,r25,0x37	# 0x41 ASCII = 0xA
CONVERT_TO_ASCII_END:
mr r3,r24	# move ASCII string start to r3
li r4,0x2e	# ASCII "."
.set strchr, 0x80325878 # strchr function at this address
adr_blrl r5, strchr
cmpwi r3,0
bne+ TEXTURE_SWAP_NAME_CHANGE_FOUND
# if "." is not found in filename, change 5th character (/GrP_)
addi r3,r24,4
b TEXTURE_SWAP_NAME_CHANGE_END
TEXTURE_SWAP_NAME_CHANGE_FOUND:
addi r3,r3,1	# store filename byte after period
TEXTURE_SWAP_NAME_CHANGE_END:

addi r31,r31,1	# increment texture swap counter
cmpwi r31,1	# first pass through?
bne- BYTE_OVERWRITE_FIRST_END
bl BYTE_OVERWRITE_SAVE	# save the original overwrite byte
BYTE_OVERWRITE_FIRST_END:
stb r25,0(r3)

VALIDATE_FILENAME:
# Pokemon Stadium ending needs to be added for the check?? Shit
.set filename_copy, 0x80016204	# r3 input = pointer to filename. Function now called File_AppendExtension
.set DVDConvertPathToEntrynum, 0x8033796c
mr r3,r24	# move ASCII filename start pointer to r3
gpr_save
adr_blrl r4, filename_copy
adr_blrl r4, DVDConvertPathToEntrynum
gpr_restore
cmpwi r3,-1	# -1 = file doesn't exist
# bne+ TEXTURE_SWAP_END
beq- REROLL # Try again for another stage

# File exists. Check if this is a Custom Platforms Battlefield (first check if it's BF at all)
cmpwi r21, 0x1F			# Check if Battlefield
bne+	END

# Check if this is a Custom Platforms variation
lis r26, custom_stage_flag @h
ori r26, r26, custom_stage_flag @l # Load the SSE Custom Stage Flag
lbz r26, 0(r26)
rlwinm. r26, r26, 26, 30, 31 # Turn r26 into the current Custom 1|2|3 stage index (1-indexed)
beq+ END 		# if r26 = 0, it's not a custom plat

# It's a custom platform BF! Make sure we're not using the Animelee stage. X_X
cmpwi r25, 0x44
beq- TEXTURE_SWAP_DEFAULT # Don't use this skin with this feature!
b TEXTURE_SWAP_END

REROLL:
cmpwi r26,texture.random	# is RANDOM selected?
blt- TEXTURE_SWAP_DEFAULT
# random was selected, add in a check for certain # of tries?
b TEXTURE_SWAP_RANDOM

TEXTURE_SWAP_DEFAULT:	# specifically selected Debug Menu is false, then load default
li r25,0
b TEXTURE_SWAP_GO	# branch back up with 0 (DEFAULT) selection

TEXTURE_SWAP_END:
b END

BYTE_OVERWRITE_SAVE:
#.set swap_undo.address, 0x803fc260
#.set swap_undo.byte,
# input r3 = pointer to byte overwrite loc
lis	r5,0x8040
stw	r3,-0x3DA0(r5)# store stage swap undo flag address; 803FC260
lbz	r6,0(r3)	# load current byte at address
stb	r6,-0x3D9C(r5)# store current byte at flag address; 803FC264
blr

END:
sth r21,0x1e(r20)	# store external stage ID
adr_load r20, 0x8025bb48	# skip over next code line
mtlr r20

gpr_restore

blr

-------------- 0x14D10 ------ 807E0014 -> Branch

# Stage File Patches.
# This performs file modifications on a stage file
# when it's loaded, for these custom stage features:
#	- FD for long destination and to set custom Debug Menu colors
#	- Pokemon Stadium for instant transform on fixed-form stages

# Check what stage is being loaded
lis r4, 0x804A
lwz r4, -0x18B0(r4)	# Load stage ID (internal ID) at 8049E750 (8049e6c8 + 0x88)
cmpwi r4, 0x25			# Check if FD
beq- 	IsFD
cmpwi r4, 0x10			# Check if Stadium
bne-	END

# It's Stadium. Check if this is a fixed-transformation stage
lis	r5, 0x8040
lbz	r15, -0x5d1b(r5) # load custom stage flag
rlwinm. r15,r15,0,25,28 # check for a fixed trans stage flag
beq-	END
# Need to get the offset to the stage parameters struct (yakumono_param)
lis r14, 0x7961 # Load bytes for the ASCII string "yaku"
ori r14, r14, 0x6B75

# Need to set up a search for a specific file struture
# Load a pointer to stage info
lwz	r4,0x10(r30)
lwz	r4,0x4(r4)	# r4 now holds the address of the start of stage file info

# Get the offset of the nodes/symbols tables
lwz r15, 4(r4) # Get file data size (excludes header & relocation table)
addi r15, r15, 0x20
lwz r5, 8(r4) # load RT entry count
mulli r5, r5, 4 # r5 is now the size of the RT table
add r15, r15, r5 # r15 is now the start of the root/ref nodes tables

# Get root nodes/symbols count (limit for search loop) and the string table offset
lwz r5, 0xC(r4) # Get root nodes count
lwz r16, 0x10(r4) # Get reference nodes count
add r5, r16, r5 # total symbols
mulli r17, r5, 8 # size of the nodes/symbols table
add r17, r15, r17 # start of the string table
add r17, r4, r17 # Make r17 an address rather than a relative file offset

# Loop through the nodes to find the target symbol
add r15, r4, r15 # Make r15 an address rather than a relative file offset
#mr r5, r15 # Save for later for another loop usage
SymbolsSearchStart:
lwz r16, 4(r15) # Load string table offset
lwzx r16, r17, r16 # Load first 4 bytes of the current string
cmpw r16, r14
beq- SymbolFound
addi r15, r15, 8
cmpw r15, r17
bge- End # Failsafe; searched the whole symbol table and didn't find the target string, so just exit
b SymbolsSearchStart

SymbolFound: # Load the offset for this node/symbol's file structure offset
lwz r15, 0(r15)
addi r15, r15, 0x20
add r14, r4, r15 # r14 is now the absolute address for this node's struct

# Update the stage item data
li	r15,0
stw	r15,0(r14)	# store 0 to timer, Main Stage A
stw	r15,4(r14)	# store 0 to timer, Main Stage B
stw	r15,0x10(r14)	# store 0 to immediately trans
stw	r15,0x14(r14)	# store 0 to drop down/rise up
stw	r15,0x18(r14)	# store 0 to trans stay down timer
b END

### FINAL DESTINATION ###
IsFD: # Make sure this is a specific FD file
lis	r15,0x0009
ori	r15,r15,0x5335	# load FD file length
# Load a pointer to stage info
lwz	r4,0x10(r30)
lwz	r4,0x4(r4)	# r4 now holds the address of the start of stage file info
lwz	r14,0(r4)	# load file length into r14
cmpw	r14,r15
bne- 	END

#FINAL_DESTINATION_LONG:
lis	r16,0x8040
lbz	r15,-0x5d1b(r16)# load custom stage flag
#rlwinm. r15,r15,0,25,25
rlwinm. r15,r15,0,24,24	# (00000080)
beq-	FINAL_DESTINATION_LONG_END
lis r15,0x4040
li	r17,0
ori r16,r17,0xf488
stwx r15,r4,r16
ori r16,r17,0xf4cc
stwx r15,r4,r16
ori r16,r17,0xf4d0
stwx r15,r4,r16
ori r16,r17,0xf590
stwx r15,r4,r16
lis r16,0x0001
ori r16,r16,0x0088
stwx r15,r4,r16
lis r16,0x0001
ori r16,r16,0x0608
stwx r15,r4,r16
lis r15,0x4248
ori r16,r17,0xf4d8
stwx r15,r4,r16
lis r16,0x0005
ori r16,r16,0x1b90
stwx r17,r4,r16	# store 0 = r17
lis r17,0x0005
lis r15,0xc3aa
ori r15,r15,0x91ec
ori r16,r17,0x1f20
stwx r15,r4,r16
lis r15,0x43aa
ori r15,r15,0x91ec
ori r16,r17,0x1f60
stwx r15,r4,r16
lis r15,0xc3d0
ori r15,r15,0x91ec
ori r16,r17,0x1fa0
stwx r15,r4,r16
lis r15,0x43d0
ori r15,r15,0x91ec
ori r16,r17,0x1fe0
stwx r15,r4,r16
FINAL_DESTINATION_LONG_END:

CUSTOM_STAGE_COLOR:
lis	r15,0x8040
lwz	r14,-0x5C5C(r15)# 20XX custom fd color flag @ 803fa3a4
cmpwi	r14,0
beq- 	END
lwz	r14,-0x5C60(r15)# load red
stb	r14,0x7974(r4)	# store red (sides)
stb	r14,0x7b84(r4)	# store red (top)
lwz	r14,-0x5C64(r15)# load green
stb	r14,0x7975(r4)	# store green (sides)
stb	r14,0x7b85(r4)	# store green (top)
lwz	r14,-0x5C68(r15)# load blue
stb	r14,0x7976(r4)	# store blue (sides)
stb	r14,0x7b86(r4)	# store blue (top)

END:
lwz	r3,0x14(r30)	# default code line
b 0

-------------- 0x80160174 ----- 38600004 -> Branch

# Stage Swap Table Loader
# Loads the StageSwapTable file into the DOL during game bootup.
.include "CommonMCM.s"
backupall
b Start

FileName:
blrl
.string "StageSwapTable.bin"
.align 2

Start:
bl FileName
mflr r3
branchl r14, 0x8033796c 	# DVDConvertPathToEntrynum; TOC entryNum now in r3

# Load the stage swap file asyncronously
lis r4, 0x803FBC80@h	# To 0x3F8C80 in the DOL
ori r4, r4, 0x803FBC80@L
li r5, 0
li r6, -1
bl <DVD.read_async>
#bl <DVD.read>
#lis r3, 0x803FBC80@h
#ori r3, r3, 0x803FBC80@l
#li r4, 0x5E0
#bl <data.flush_IC>

# END:
restoreall
li	r3, 4 # Original code line
b 0

-------------- 0x3F9250 -----

00000000 803FC1FC
803FC1E0 803FA2B0
00000000 40400000
00000000 00000002
00000000 803FC208
803FC1E0 803FA2B4

 -> 

# Stage swap undo flag/address storage
5354414745205357415020464C414753
00000000000000000000000000000000
454E4420535441474520535741500000