
Link - Buffed Hylian Shield
This combines two of UnclePunch's shield codes, along with some conditional code to only enable this if its debug menu flag at 802289C0 is set.
Mods included:
- Link's Shield Blocks Melee Attacks
- Link Shield Always Active
<https://smashboards.com/threads/links-shield-blocks-melee-attacks-other-shield-codes.450150/>
[UnclePunch, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x800EAE44 ---- 7C0802A6 -> Branch

# Injecting into Link's OnLoad function 
# (avoiding extra checks mid-match)
.macro setWord reg1, reg2, address, word
  lis \reg1, \word@h
  ori \reg1, \reg1, \word@l
  lis \reg2, \address@h
  ori \reg2, \reg2, \address@l
  stw \reg1, 0(\reg2)
.endm

# Check if the Debug Menu flag is set
lis r15, 0x8023		# 0x802289C0
lwz r15, -0x7640(r15)
cmpwi r15, 0
beq+ 	DisableCode

# Enable codes
# Link's Shield Blocks Melee Attacks
setWord r14, r15, 0x800EB3F0, 0x48000028

# Link Shield Always Active 
#setWord r14, r15, 0x80007C44, 0x60000000
#setWord r14, r15, 0x8000A80C, 0x60000000
lis r14, 0x6000
lis r15, 0x80007C44@h
ori r15, r15, 0x80007C44@l
stw r14, 0(r15)
lis r15, 0x8000A80C@h
ori r15, r15, 0x8000A80C@l
stw r14, 0(r15)
b END

DisableCode: # Change lines to vanilla
# Link's Shield Blocks Melee Attacks
setWord r14, r15, 0x800EB3F0, 0x881F221B

# Link Shield Always Active 
setWord r14, r15, 0x80007C44, 0x981F0004
setWord r14, r15, 0x8000A80C, 0x981D0004

END:
mflr r0		# original code line
b 0

------------- 0x8006A19C ---- 800100A4 -> Branch

# Link Shield Always Active
# Check if the Debug Menu flag is set
lis r15, 0x8023		# 0x802289C0
lwz r15, -0x7640(r15)
cmpwi r15, 0
beq+ 	End

Main:
  lwz r14, 44(r30)
  lbz r14, 7(r14)
  cmpwi r14, 0x6
  beq- loc_0x1C
  cmpwi r14, 0x14
  beq- loc_0x1C
  b End

loc_0x1C:
  mr r3, r30
  lis r14, 0x800E
  ori r14, r14, 0xB3BC
  mtctr r14
  bctrl 

End:
  lwz r0, 164(r1)
  b 0

------------- 0x802289C0 ----

7FC4F378

 -> 

# Debug Menu Flag
00000000