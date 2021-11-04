# FSM engine
# - original code by Magus
# - modified For 20XX by Achilles and DRGN
# 
# (1.02) 20XX
# injected @ 80073338
# - r27 = start of external player data offset
# - r30 = start of internal player data offset
# 
# More source code notes at https://smashboards.com/threads/melee-hacks-and-you-new-hackers-start-here-in-the-op.247119/post-14773022

/*lwz r29,0x4(r30)	#r15 holds internal char ID
mulli r29,r29,8	
lis r31,0x803c	
ori r31,r31,0x1f40	
lwzx r31,r31,r29	#r14 holds start of Player's file locations
lbz r31,0x5(r31)	
cmpwi r31,0x73	
bne- END	#if not an SDR char, branch to end
*/

mr r3,r27
lbz r31,0xc(r30) # load player ID number
lis r29,0x8045
ori r29,r29,0x3084
mulli r31,r31,0xE90
add r31,r29,r31
lwz r4,0(r31)
lbz r31,8(r31)	# load primary char or alt char in use flag (01 = alt) 
cmpwi r4,0x13	# match started as Sheik?
beq- 0x1C
cmpwi r4,0x12	# match started as Zelda?
bne+ 0x20
cmpwi r31,1
bne+ 0x18
li r4,0x13
b 0x10
cmpwi r31,1
bne+ 0x08
li r4,0x12
lfs f1,0x894(r30)
fctiwz f1,f1
stfd f1,0(r2)
lwz r5,4(r2)
lwz r6,0x10(r30)
lwz r7,0x14(r30)
ori r7,r7,0x8000

lwz r29,0x4(r30)	#r15 holds internal char ID
mulli r29,r29,8	
lis r31,0x803c	
ori r31,r31,0x1f40	
lwzx r31,r31,r29	#r14 holds start of Player's file locations
lbz r31,0x5(r31)	
cmpwi r31,0x73	# SDR char?
beq- SDR	#
cmpwi r31,0x70	# PAL char?
bne-	END

# Load FSM List address (no longer needs -0x8 adjustment)
PAL:
#lis r31,0x8032
#ori r31,r31,0xEE98
lis r31,<<PAL_FSM_List>>@h
ori r31,r31,<<PAL_FSM_List>>@l
b FSM_LIST_READ
SDR:
#lis r31,0x8000
#ori r31,r31,0x49c8
lis r31,<<SDR_FSM_List>>@h
ori r31,r31,<<SDR_FSM_List>>@l

FSM_LIST_READ:
subi r31, r31, 8
lwzu r29,8(r31)
cmpwi r29,0		# is entry null?
beq- END
rlwinm r28,r29,8,24,31
cmpwi r28,0xFF
beq- 0x14
cmpw r28,r4
beq- 0x0C
bgt- 0x48
b 0xFFFFFFDC
rlwinm r28,r29,16,24,31
cmpw r28,r5
bgt- 0xFFFFFFD0
rlwinm r28,r29,0,16,31
cmpw r28,r6
beq- 0x0C
cmpw r28,r7
bne+ 0xFFFFFFBC
lwz r28,4(r31)
cmpwi r28,-1
beq- 0x18
lfs f1,4(r31)
lis r31,0x8006
ori r31,r31,0xF190
mtlr r31
blrl
END:
lmw r27,20(r1) # default code line
b 0