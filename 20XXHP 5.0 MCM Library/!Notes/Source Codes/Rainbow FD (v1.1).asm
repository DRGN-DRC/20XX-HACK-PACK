
Rainbow FD (v1.1)
If enabled (checking flag at 803FA3B4), this code is set to run for custom FD stages .0at through .7at, and not for .8at onward (including .gat, etc.) or for the Classic/Advn./All-Star single player modes.
[Achilles, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x8021AAB0 ---- 7C0802A6 -> Branch


loc_0x0:
  # Check if code flag is enabled, probably
  lis r14, 0x803F
  ori r14, r14, 0xA3B4
  lwz r14, 0(r14)
  cmpwi r14, 0x1
  bne- END

  # Check the menu controller (major) for 
  # different game modes (classic/advn./all-star)
  lis r14, 0x8048
  lbz r14, -25296(r14) # 0x9D30
  cmpwi r14, 0x3
  beq- END
  cmpwi r14, 0x4
  beq- END
  cmpwi r14, 0x5
  beq- END

  # Check the current/loaded file;
  # skip code if extension is greater than .7at
  lis r14, 0x803E
  lbz r14, 32651(r14) # 0x7F8B
  cmpwi r14, 0x37
  bgt- END

  li r17, 0x0
  lis r14, 0x8045
  ori r14, r14, 0x8E88
  lwz r14, 0(r14)
  addi r14, r14, 0x4BA4
  lbz r18, 3(r14)
  cmpwi r18, 0x2
  beq- loc_0x84
  cmpwi r18, 0x3
  beq- loc_0x9C
  li r18, 0x1
  lbz r15, 0(r14)
  cmpwi r15, 0xFF
  beq- loc_0xDC
  li r16, 0x1
  b loc_0x12C

loc_0x84:
  li r18, 0x2
  lbzu r15, 1(r14)
  cmpwi r15, 0xFF
  beq- loc_0x104
  li r16, 0x1
  b loc_0x12C

loc_0x9C:
  li r18, 0x3
  lbzu r15, 2(r14)
  cmpwi r15, 0xFF
  beq- loc_0xB4
  li r16, -2
  b loc_0x12C

loc_0xB4:
  lbz r15, -1(r14)
  cmpwi r15, 0x0
  beq- loc_0xD0
  subi r15, r15, 0x1
  stb r15, -1(r14)
  stb r15, 4095(r14)
  b END

loc_0xD0:
  li r18, 0x1
  stb r18, 1(r14)
  b END

loc_0xDC:
  lbz r15, 2(r14)
  cmpwi r15, 0x0
  beq- loc_0xF8
  subi r15, r15, 0x1
  stb r15, 2(r14)
  stb r15, 4098(r14)
  b END

loc_0xF8:
  li r18, 0x2
  stb r18, 3(r14)
  b END

loc_0x104:
  lbz r15, -1(r14)
  cmpwi r15, 0x0
  beq- loc_0x120
  subi r15, r15, 0x1
  stb r15, -1(r14)
  stb r15, 4095(r14)
  b END

loc_0x120:
  li r18, 0x3
  stb r18, 2(r14)
  b END

loc_0x12C:
  addi r15, r15, 0x1
  stb r15, 0(r14)
  stb r15, 4096(r14)
  add r14, r14, r16
  stb r17, 0(r14)
  stb r17, 4096(r14)

END:
  mflr r0
  b 0
