#To be inserted at 80077254
.macro bl reg, address
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
addi sp,sp,-0x4
mflr r0
stw r0,0(sp)
.endm

.macro restore
lwz r0,0(sp)
mtlr r0
addi sp,sp,0x4
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

.macro getPlayerBlock reg1,reg2
lwz \reg1,0x2c(\reg2)
.endm

.macro getCharID reg
lbz \reg,0x7(player)
.endm

.macro getCostumeID reg
lbz \reg,0x619(player)
.endm

.macro getAS reg
lwz \reg,0x10(player)
.endm

.macro getASFrame reg
lwz \reg,0x894(player)
.endm

.macro getFacing reg
lwz \reg,0x2c(player)
.endm

.macro setFacing reg
stw \reg,0x2c(player)
.endm

.macro invertFacing reg
lfs \reg,0x2c(player)
fneg \reg,\reg
stfs \reg,0x2c(player)
.endm

.macro fsetGroundVelocityX reg
stfs \reg,0xec(player)
.endm

.macro fsetAirVelocityX reg
stfs \reg,0x80(player)
.endm

.macro fsetAirVelocityY reg
stfs \reg,0x84(player)
.endm

.macro fgetGroundVelocityX reg
lfs \reg,0xec(player)
.endm

.macro fgetAirVelocityX reg
lfs \reg,0x80(player)
.endm

.macro fgetAirVelocityY reg
lfs \reg,0x84(player)
.endm

.macro setGroundVelocityX reg
stw \reg,0xec(player)
.endm

.macro setAirVelocityX reg
stw \reg,0x80(player)
.endm

.macro setAirVelocityY reg
stw \reg,0x84(player)
.endm

.macro getGroundVelocityX reg
lwz \reg,0xec(player)
.endm

.macro getAirVelocityX reg
lwz \reg,0x80(player)
.endm

.macro getAirVelocityY reg
lwz \reg,0x84(player)
.endm

.macro getGroundAirState reg
lwz \reg,0xe0(player)
.endm

.macro getPlayerDatAddress reg
lwz \reg,0x108(player)
.endm

.macro getStaticBlock reg, reg2
lbz \reg,0xc(player)			#get player slot (0-3)
li \reg2,0xe90			#static player block length
mullw \reg2,\reg,\reg2			#multiply block length by player number
lis \reg,0x8045			#load in static player block base address
ori \reg,\reg,0x3080			#load in static player block base address
add \reg,\reg,\reg2			#add length to base address to get current player's block
#playerblock address in \reg
.endm

.macro getDpad reg
lbz \reg,0x66b(player)
.endm

.macro getPlayerSlot reg
lbz \reg,0xC(player)
.endm

.macro get reg offset
lwz \reg,\offset(player)
.endm

.set ActionStateChange,0x800693ac
.set HSD_Randi,0x80380580
.set HSD_Randf,0x80380528
.set Wait,0x8008a348
.set Fall,0x800cc730

.set player,26

#checkIfSingleButtonMode
lis	r14,0x8048
lbz	r14,-0x62D0(r14) # load menu controller major
cmpwi	r14,0x2C	# is this single button mode?
bne notTurbo

isTurbo:

lwz r14,0x10(player) #check if its a pummel
cmpwi r14,0xd9
beq exit

li r14,0
stb r14,0x2293(player) #reset turbo counter

lwz r14,0x10(player)			#store move id that hit
sth r14,0x2290(player)

notTurbo:
exit:
stw	r24, 0x1914 (r26)

