

	-==-


Samus Shoots Random Item
Controlled by a debug menu flag at 0x802289C8
[UnclePunch]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x802B632C ---- D3E10054 -> Branch

loc_0x0:
  stfs f31, 84(r1)	# orig code line

# Check the debug menu flag
lis r15, 0x8023	# 0x802289C8
lwz r15, -0x7638(r15)
cmpwi r15, 0
beq+ END

loc_0x4:
  li r3, 0x23
  lis r12, 0x8038
  ori r12, r12, 0x580
  mtctr r12
  bctrl 
  mr r31, r3
  cmpwi r3, 0x2
  beq+ loc_0x4
  cmpwi r3, 0x5
  beq+ loc_0x4
  cmpwi r3, 0x8
  beq+ loc_0x4
  cmpwi r3, 0x9
  beq+ loc_0x4
  cmpwi r3, 0xA
  beq+ loc_0x4
  cmpwi r3, 0x12
  beq+ loc_0x4
  cmpwi r3, 0x1A
  beq+ loc_0x4
  cmpwi r3, 0x1B
  beq+ loc_0x4
  cmpwi r3, 0x1C
  beq+ loc_0x4
  cmpwi r3, 0x1D
  beq+ loc_0x4
  cmpwi r3, 0x1F
  beq+ loc_0x4
  cmpwi r3, 0x20
  beq+ loc_0x4
  cmpwi r3, 0x21
  beq+ loc_0x4
  stw r31, 36(r1)

END:
  b 0

------------- 0x802B6370 ---- 7C7F1B79 -> Branch

# Check the debug menu flag
lis r15, 0x8023	# 0x802289C8
lwz r15, -0x7638(r15)
cmpwi r15, 0
beq+ OrigLine

loc_0x0:
  mr r31, r3
  lwz r3, 44(r31)
  lwz r3, 184(r3)
  lwz r12, 20(r3)
  cmpwi r3, 0x0
  beq- loc_0x50
  mtlr r12
  mr r3, r31
  blrl 
  bl loc_0x48
  mflr r3
  lfs f1, 0(r3)
  lwz r3, 44(r31)
  lfs f2, 44(r3)
  fmuls f1, f1, f2
  stfs f1, 64(r3)
  stw r28, 1304(r3)
  b loc_0x50

loc_0x48:
  blrl 

loc_0x4C:
  bge+ cr4, loc_0x4C

loc_0x50:
  lis r12, 0x802B
  ori r12, r12, 0x63D0
  mtctr r12
  bctr 
  b END

OrigLine:
  mr. r31,r3	# orig code line

END:
  b 0
