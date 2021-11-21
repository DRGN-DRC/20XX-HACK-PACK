

	-==-

Nana Respawns After 20 Seconds
<https://smashboards.com/threads/nana-respawns-after-20-seconds.453938/>
[UnclePunch, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
##NTSC 1.02 --- 0x800D5378 ---- 408200C4 -> 60000000
NTSC 1.02 --- 0x8011EF58 ---- 38600001 -> Branch

# Injecting into FighterOnLoad_Popo (avoiding extra checks mid-match)
.macro setWord reg1, reg2, address, word
  lis \reg1, \word@h
  ori \reg1, \reg1, \word@l
  lis \reg2, \address@h
  ori \reg2, \reg2, \address@l
  stw \reg1, 0(\reg2)
.endm

# Check if the Debug Menu flag is set
lis r15, 0x8023		# 0x802289BC
lwz r15, -0x7644(r15)
cmpwi r15, 0
beq+ 	OrigLine

# Enable code
setWord r14, r15, 0x800D5378, 0x60000000
b END

OrigLine: # Change line to vanilla
setWord r14, r15, 0x800D5378, 0x408200C4

END:
li r3,1		# original code line
b 0

------------- 0x8006A37C ---- 8803221F -> Branch

.macro branchl reg, address
lis \reg, \address @h
ori \reg,\reg,\address @l
mtctr \reg
bctrl
.endm

.macro branch reg, address
lis \reg, \address @h
ori \reg,\reg,\address @l
mtctr \reg
bctr
.endm

.macro load reg, address
lis \reg, \address @h
ori \reg, \reg, \address @l
.endm

.macro loadf regf,reg,address
lis \reg, \address @h
ori \reg, \reg, \address @l
stw \reg,-0x4(sp)
lfs \regf,-0x4(sp)
.endm

.macro backup
stwu    r1,-0x100(r1)    # make space for 12 registers
stmw    r20,8(r1)    # push r20-r31 onto the stack
mflr r0
stw r0,0xFC(sp)
.endm

.macro restore
lwz r0,0xFC(sp)
mtlr r0
lmw    r20,8(r1)    # pop r20-r31 off the stack
addi    r1,r1,0x100    # release the space
.endm

.macro intToFloat reg,reg2
xoris    \reg,\reg,0x8000
lis    r18,0x4330
lfd    f16,-0x7470(rtoc)    # load magic number
stw    r18,0(r2)
stw    \reg,4(r2)
lfd    \reg2,0(r2)
fsubs    \reg2,\reg2,f16
.endm

.set ActionStateChange,0x800693ac
.set HSD_Randi,0x80380580
.set HSD_Randf,0x80380528
.set Wait,0x8008a348
.set Fall,0x800cc730

.set entity,31
.set player,30
.set playerdata,31

# Check if the Debug Menu flag is set
mr    r31,r3
lis r3, 0x8023		# 0x802289BC
lwz r3, -0x7644(r3)
cmpwi r3, 0
beq+ 	exit

lbz    r3, 0x221F (playerdata)

#Check If Dead
rlwinm.    r0, r3, 26, 31, 31
beq    exit

#Check If Subchar
rlwinm    r0, r3, 29, 31, 31
beq    exit

#Check If Follower
lbz    r3,0xC(playerdata)            #get slot
branchl    r12,0x80032330            #get external character ID
load    r4,0x803bcde0            #pdLoadCommonData table
mulli    r0, r3, 3            #struct length
add    r3,r4,r0            #get characters entry
lbz    r0, 0x2 (r3)            #get subchar functionality
cmpwi    r0,0x0            #if not a follower, exit
bne    exit

#Check If Frame 1 of Follower Sleep
lwz    r3,0x894(playerdata)
load    r4,0xbf800000
cmpw    r3,r4
bne    EveryFrame

FrameOne:
li    r3,1200        #20 seconds
stw    r3,0x2354(playerdata)
li    r3,0x0
stw    r3,0x894(playerdata)

EveryFrame:
#Subtract Frame
lwz    r3,0x2354(playerdata)
subi    r3,r3,0x1
stw    r3,0x2354(playerdata)

#Check If Timer is Up
cmpwi    r3,0x0
bne    exit

#Get Respawn Location
lbz    r3,0xC(playerdata)
addi    r4,sp,0xC0
addi    r5,sp,0xD0
branchl    r12,0x80167638

#Store Respawn Location
lbz    r3,0xC(playerdata)
addi    r4,sp,0xC0
branchl    r12,0x80032d80

#Get Camera Top Limit
branchl    r12,0x80224a80

#Store As Respawn Y
stfs    f1,0xC4(sp)

#Store Coordinates
lbz    r3,0xC(playerdata)
addi    r4,sp,0xC0
branchl    r12,0x80032768

#Temp Remove Follower Bit
li    r3,0x0
lbz    r0, 0x221F (playerdata)
rlwimi    r0, r3, 3, 28, 28
stb    r0, 0x221F (playerdata)

#Respawn Nana
mr    r3,player
branchl    r12,0x800d4ff4

#Set Follower Bit Back
li    r3,0x1
lbz    r0, 0x221F (playerdata)
rlwimi    r0, r3, 3, 28, 28
stb    r0, 0x221F (playerdata)

exit:
mr    r3,r31
lbz    r0, 0x221F (r3)            #original codeline
b 0

------------- 0x802289BC ----

A0A30004

 -> 

# Debug Menu Flag
00000000
