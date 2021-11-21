#To be inserted at 800693ac
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

.set player,15

#checkIfSingleButtonMode
lis	r14,0x8048
lbz	r14,-0x62D0(r14) # load menu controller major
cmpwi	r14,0x2C	# is this single button mode?
bne notTurbo

lwz	r15, 0x002C (r3)

checkIfComingFromTurboInterrupt:
lbz r0,0x2292(player)
#cmpwi r0,0x1
rlwinm.	r0, r0, 0, 31, 31
beq exit
#bne exit

checkSameASCancel:
lhz r14,0x2290(player)
cmpw r14,r4
bne checkVelocity
blr

checkVelocity:
lfs f13,0x80(player)
loadf f14,r14,0x40000000
fcmpo cr0,f13,f14
blt checkXInverse
stfs f14,0x80(player)
b checkY
checkXInverse:
fneg f14,f14
fcmpo cr0,f13,f14
bgt checkY
stfs f14,0x80(player)
checkY:
lfs f13,0x84(player)
loadf f14,r14,0x40400000
fcmpo cr0,f13,f14
blt checkYInverse
stfs f14,0x84(player)
checkYInverse:
removeHitlag:
lwz r0,-0x7418(rtoc)
stw r0,0x195C(player)

addi sp,sp,-0x30
stw r3,0x20(sp)
stw r4,0x24(sp)
stw r5,0x8(sp)
stw r6,0xC(sp)
stfs f1,0x10(sp)
stfs f2,0x14(sp)
stfs f3,0x18(sp)
mflr r0
stw r0,0x1c(sp)
bl r14,0x8006a1bc
lwz r3,0x20(sp)
lwz r4,0x24(sp)
lwz r5,0x8(sp)
lwz r6,0xC(sp)
lfs f1,0x10(sp)
lfs f2,0x14(sp)
lfs f3,0x18(sp)
lwz r0,0x1c(sp)
mtlr r0
addi sp,sp,0x30

turbo:
li r0,40
stb r0,0x2293(player)
sth r4,0x2290(player)

exit:
li r0,-1
sth r0,0x2290(player) #reset previous move during normal AS transition

notTurbo:
mflr r0


