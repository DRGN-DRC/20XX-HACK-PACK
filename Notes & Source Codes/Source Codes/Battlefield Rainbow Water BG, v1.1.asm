

Battlefield Rainbow Water BG, v1.1
- checks debug menu flag @803fa310|0x3F7310
- now ignores stages above .7at
[Achilles, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x80219D18 ---- 38600003 -> Branch


# inject @ 80219d18
# - battlefield init function
lis	r14,0x803f
ori	r14,r14,0xa310	# 803fa310 is BF water bg debug menu toggle
lbz 	r17,-0x2b(r14)	#load current custom stage flag @ 803fa2e5 (00000010 = water background for battlefield
lwz	r15,0(r14)
cmpwi	r15,0		#is water bg flag off?
beq-	NO_WATER_BG

# Check the BF file name about to be loaded;
# skip code if extension is greater than .7at
lis r3, 0x803E7E33@h
lbz r3, 0x803E7E33@l(r3)
cmpwi r3, 0x37
bgt- NO_WATER_BG

li	r3,0
rlwimi 	r17,r3,0,27,27	# disregard previous water background flag

cmpwi	r15,1		#is water bg flag always on?
beq- 	EXECUTE_WATER

RANDOM_WATER_BG:
lbz	r16,-0x570D(r13)#load random value (804d5f93)
cmpwi 	r16,127		#if less than 127 (0x7f), execute water ~50% (?)
bge- 	NO_WATER_BG

EXECUTE_WATER:
addi	r17,r17,0x10
stb	r17,-0x2b(r14)	#store water bg flag for customs

lis	r16,0x8021
ori	r16,r16,0x9d0c
mtctr	r16
bctr

NO_WATER_BG:
stb	r17,-0x2b(r14)

END:
li	r3,3		#default code line
b 0