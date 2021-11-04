loc_0x0:
  lis r14, 0x8048
  lhz r14, 1670(r14)
  cmpwi r14, 0x1F
  bne- loc_0x154
  lis r14, 0x803F
  ori r14, r14, 0xA2E5
  lbz r23, 0(r14)
  rlwinm. r15, r23, 26, 30, 31
  beq- loc_0x154
  addi r14, r14, 0x547
  mulli r15, r15, 0x24
  add r14, r15, r14
  li r15, 0x0
  lis r16, 0x3F4C
  ori r16, r16, 0xCCCD
  stw r16, -12(r1)
  lfs f18, -12(r1)

loc_0x44:
  mulli r16, r15, 0xC
  add r16, r16, r14
  lfs f17, 0(r16)
  lwz r17, 0(r16)
  lfs f15, 8(r16)
  lfs f16, 4(r16)
  lis r18, 0x8045
  ori r18, r18, 0x8E88
  lwz r18, 0(r18)
  rlwinm. r16, r23, 0, 27, 27
  beq- loc_0x98
  addi r18, r18, 0x744C
  cmpwi r15, 0x0
  bne- loc_0x84
  addi r18, r18, 0x140
  b loc_0xBC

loc_0x84:
  cmpwi r15, 0x1
  bne- loc_0x90
  b loc_0xBC

loc_0x90:
  addi r18, r18, 0xA0
  b loc_0xBC

loc_0x98:
  addi r18, r18, 0x518C
  cmpwi r15, 0x0
  bne- loc_0xAC
  addi r18, r18, 0x320
  b loc_0xBC

loc_0xAC:
  cmpwi r15, 0x1
  bne- loc_0xB8
  b loc_0xBC

loc_0xB8:
  addi r18, r18, 0x280

loc_0xBC:
  fdiv f17, f17, f18
  stfs f17, 16(r18)
  fdiv f21, f16, f18
  stfs f21, 12(r18)
  fdiv f22, f15, f18
  stfs f22, 0(r18)
  lis r18, 0x804D
  lwz r18, 25784(r18)
  lis r22, 0x41BC
  stw r22, -8(r1)
  lfs f14, -8(r1)
  fmuls f14, f14, f15
  fadd f17, f14, f16
  stfs f17, -12(r1)
  lwz r19, -12(r1)
  fneg f14, f14
  fadd f17, f14, f16
  stfs f17, -12(r1)
  lwz r20, -12(r1)
  cmpwi r15, 0x0
  bne- loc_0x114
  b loc_0x128

loc_0x114:
  cmpwi r15, 0x1
  bne- loc_0x124
  addi r18, r18, 0x228
  b loc_0x128

loc_0x124:
  addi r18, r18, 0x1F8

loc_0x128:
  stw r20, 8(r18)
  stw r20, 16(r18)
  stw r19, 32(r18)
  stw r19, 40(r18)
  stw r17, 12(r18)
  stw r17, 20(r18)
  stw r17, 36(r18)
  stw r17, 44(r18)
  addi r15, r15, 0x1
  cmpwi r15, 0x3
  blt- loc_0x44

loc_0x154:
  blr 

