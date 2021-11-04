
Stage Swap Engine (v2.0)
Responsible for checking the current stage select screen and loading the appropriate pre-defined or random stage, as defined by the Stage Swap Info Table.

v2.0 of this code relocates the Stage Swap Table from the DOL to a file in the disc filesystem, and fixes random byte overwrites (when using 0xFF byte replacement mode).
[Achilles, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
<SwapTableFileString> ALL
# "StageSwapTable.bin" string (need a known address for this)
53746167 65537761
70546162 6C652E62
696E0000 00000000

NTSC 1.02 ---- 0x258720 ----- 8804000B -> Branch

# Main Logic; looks up data from the
# Stage Swap Table and prepares file loading

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
#.set swap_t.loc, 0x803fbc20	# RAM loc for first entry (but first two external IDs unused)
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

# Get the Stage Swap Table's address; should now be in the Object Heap (OSHeap1/HSD[0])
lis r3, <<SwapTableFileString>>@h
ori r3, r3, <<SwapTableFileString>>@l
lwz r4, 0x14(r3)	# Pointer to the table is stored after the filename string

# r4 now has the SST file's address

mulli	r23,r21,swap_t.len
#adr_load r22, swap_t.loc
subi r22,r4,0x50 # offset the table address (accounting for two entries never used, and 0x10 for file header)
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
bne- TEXTURE_SWAP_END
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

# Stage File Patches
809E0010 80840004
81C40000 3DE00006
61EFE64B 7C0E7800
4082002C 3DC00003
61CE20E8 7DC47214
3DE0C3BB 91EE0000
91EE0004 3DE043BB
91EE0008 91EE000C
4800013C 3DE00009
61EF5335 7C0E7800
408200E8 3E008040
89F0A2E5 55EF0631
418200A0 3DE04040
3A200000 6230F488
7DE4812E 6230F4CC
7DE4812E 6230F4D0
7DE4812E 6230F590
7DE4812E 3E000001
62100088 7DE4812E
3E000001 62100608
7DE4812E 3DE04248
6230F4D8 7DE4812E
3E000005 62101B90
7E24812E 3E200005
3DE0C3AA 61EF91EC
62301F20 7DE4812E
3DE043AA 61EF91EC
62301F60 7DE4812E
3DE0C3D0 61EF91EC
62301FA0 7DE4812E
3DE043D0 61EF91EC
62301FE0 7DE4812E
3DE08040 81CFA3A4
2C0E0000 41820028
81CFA3A0 99C47974
99C47B84 81CFA39C
99C47975 99C47B85
81CFA398 99C47976
99C47B86 48000048
3DE00016 61EF4B20
7C0E7800 40820038
3E008040 89F0A2E5
55EF0679 41820028
3DE00003 61EFDB88
7C8F2214 39E00000
91E40000 91E40004
91E40010 91E40014
91E40018 807E0014
48000000

-------------- 0x25FE58 ----- 986DB656 -> Branch

# Stage Swap Table Loader
.include "CommonMCM.s"

backupall

# Load the Stage Swap Table binary file
lis r3, <<SwapTableFileString>>@h
ori r3, r3, <<SwapTableFileString>>@l
li r4, 0 # Setting this to store the file into OSHeap1/HSD[0] (the Object Heap)
bl <DVD.read>

# r4 now has the SST file's address. store it after the file string
lis r3, <<SwapTableFileString>>@h
ori r3, r3, <<SwapTableFileString>>@l
stw r4, 0x14(r3)

restoreall

stb r3, -0x49AA(r13) # Original code line
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