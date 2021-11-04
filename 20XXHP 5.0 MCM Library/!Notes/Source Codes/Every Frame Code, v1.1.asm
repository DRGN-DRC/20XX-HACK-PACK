# The "Every Frame Code", a.k.a. the "CSS/Debug Menu Big Code Function"
# Located in MnSlChr @ 0x3E3B10. Becomes loaded into RAM @ 80FD0230
#
# Handles multiple different per-frame checks, including monitoring for pressing Z on 
# the CSS to swap between vanilla and special characters (such as Sheik, wireframes, etc),
# code updates for debug menu settings, and much more.
#
# Originally created by Achilles1515
# Disassembly, these notes, code comments, and CSS icon swapping functionality added by DRGN
#
# Change log:
#
#	Version 1.1
#		- Added CSS Icon Texture swaps (introduced in 20XX v5.0)
#
#	Version 1.0
#		- Initial release



.macro setPointer reg1, reg2, headerOffset, dataOffset

  lis \reg1, \headerOffset @h			# load address of the image or palette data header
  ori \reg1, \reg1, \headerOffset @l
  lis \reg2, \dataOffset @h			# load address value of the image or palette data
  ori \reg2, \reg2, \dataOffset @l

/*
  # Add the CSS file offset (MnSlChr) to the struct or data offsets
   addis \reg1, \reg1, 0x80BE
   addi \reg1, \reg1, 0x7720
   addi \reg1, \reg1, 0x5000
   addis \reg2, \reg2, 0x80BE
   addi \reg2, \reg2, 0x7720
   addi \reg2, \reg2, 0x5000
*/

  stw \reg2, 0(\reg1)			# set the image data pointer in the header

.endm


loc_0x0:
  lis r15, 0x80F9			# 0x3A4FB0 in the CSS
  ori r15, r15, 0x16D0
  stw r0, 8(r15)
  mflr r0
  stw r0, 12(r15)
  stw r3, 16(r15)
  stw r4, 20(r15)
  stw r5, 24(r15)
  lis r4, 0x8048
  lbz r4, -25296(r4)
  cmpwi r4, 0x6
  beq- loc_0x69C
  li r15, 0x0
  li r16, 0x0
  lis r18, 0x8048
  ori r19, r18, 0x7FD
  stw r15, 1752(r18)
  stw r15, 1756(r18)
  lbz r17, 1992(r18)
  ori r18, r18, 0x6D7
  cmpwi r17, 0x1
  beq- loc_0xA4

loc_0x58:
  addi r15, r15, 0x1
  lbzu r20, 36(r19)
  cmpwi r20, 0x3
  beq- loc_0x70
  stb r16, 4(r19)
  addi r16, r16, 0x1

loc_0x70:
  cmpwi r15, 0x4
  blt- loc_0x58
  b loc_0x1AC

loc_0x7C:
  li r15, 0x0
  li r16, 0x0
  lis r18, 0x8048
  ori r18, r18, 0x801

loc_0x8C:
  addi r15, r15, 0x1
  stbu r16, 36(r18)
  addi r16, r16, 0x1
  cmpwi r15, 0x4
  blt- loc_0x8C
  b loc_0x1AC

loc_0xA4:
  lis r17, 0x8048
  ori r17, r17, 0x6DC
  addi r15, r15, 0x1
  addi r18, r18, 0x1
  lbzu r20, 36(r19)
  lbz r14, 8(r19)
  cmpwi r20, 0x3
  beq- loc_0x7C
  cmpwi r14, 0x0
  bne- loc_0xD8
  li r16, 0x0
  lbz r20, 0(r17)
  b loc_0xF8

loc_0xD8:
  cmpwi r14, 0x1
  bne- loc_0xEC
  li r16, 0x1
  lbzu r20, 1(r17)
  b loc_0xF8

loc_0xEC:
  li r16, 0x2
  lbzu r20, 2(r17)
  b loc_0xF8

loc_0xF8:
  addi r20, r20, 0x1
  cmpwi r20, 0x3
  bge- loc_0x7C
  stb r20, 0(r17)
  stb r16, 0(r18)
  cmpwi r15, 0x4
  blt- loc_0xA4
  li r15, 0x0
  lis r17, 0x8048
  ori r17, r17, 0x6DB
  li r21, 0x0

loc_0x124:
  addi r15, r15, 0x1
  lbzu r20, 1(r17)
  cmpwi r20, 0x1
  bge- loc_0x138
  b loc_0x144

loc_0x138:
  addi r21, r21, 0x1
  cmpwi r21, 0x3
  bge- loc_0x7C

loc_0x144:
  cmpwi r15, 0x3
  blt- loc_0x124
  li r15, 0x0
  addi r17, r17, 0x127
  li r14, 0xFF
  li r20, 0xFF

loc_0x15C:
  addi r15, r15, 0x1
  lbzu r16, 36(r17)
  cmpwi r14, 0xFF
  bne- loc_0x178
  mr r18, r16
  li r14, 0x0
  b loc_0x1A0

loc_0x178:
  cmpw r16, r18
  bne- loc_0x188
  li r14, 0x3
  b loc_0x1A0

loc_0x188:
  cmpwi r20, 0xFF
  bne- loc_0x19C
  li r14, 0x1
  li r20, 0x0
  b loc_0x1A0

loc_0x19C:
  li r14, 0x2

loc_0x1A0:
  stb r14, -4(r17)
  cmpwi r15, 0x4
  blt- loc_0x15C

loc_0x1AC:
  li r16, 0x0					# loop iteration

loc_0x1B0:
  lis r15, 0x804C				# <- loading button input address for P1
  ori r15, r15, 0x1FAC
  mulli r17, r16, 0x44			# relative offset for input address (players are 0x44 apart)
  add r15, r15, r17				# new input address
  lhz r17, 10(r15)
  cmpwi r17, 0x10				# checking if z-button is pressed
  bne- loc_0x300
  addi r16, r16, 0x1
  li r18, 0x0

loc_0x1D4:
  lis r17, 0x804A
  ori r17, r17, 0xBD0
  lwzx r17, r18, r17
  lbz r19, 5(r17)
  cmpw r19, r16
  bne- loc_0x1F8
  lbz r16, 4(r17)
  addi r16, r16, 0x1
  b loc_0x208

loc_0x1F8:
  cmpwi r18, 0xC
  beq- loc_0x1B0
  addi r18, r18, 0x4
  b loc_0x1D4

loc_0x208:
  mulli r17, r16, 0x24
  lis r18, 0x803F
  ori r18, r18, 0xDE6
  lhzx r17, r18, r17
  lis r18, 0x803F
  cmpwi r17, 0xF0F
  bne- checkForBowser
  lbz r17, 0xCC9(r18)
  cmpwi r17, 0x12				# Checking byte 0x803F0CC9 for 0x12 (that the CSS Icon entry is set to Zelda)
  bne- changeToZelda

  # Change to Sheik
  li r19, 0x13
  stb r19, 0xCC9(r18)								# Changes a byte in the CSS Icon Data Array to the alternate character ID
  setPointer r18, r19, 0x80F529B0, 0x80FD4F20		# Changes the pointer in an image data header to the alternate image data location
  b checkForBowser

changeToZelda:
  li r19, 0x12
  stb r19, 0xCC9(r18)								# Changes a byte in the CSS Icon Data Array to the vanilla character ID
  setPointer r18, r19, 0x80F529B0, 0x80C1A3C0		# Changes the pointer in an image data header to the vanilla image data location

checkForBowser:
  cmpwi r17, 0x303
  bne- checkForClimbers
  lis r18, 0x803F
  lbz r17, 0xB79(r18)
  cmpwi r17, 0x5				# Checking byte 0x803F0B79 for 0x5 (that the CSS Icon entry is set to Bowser)
  bne- changeToBowser

  # Change to Giga Bowser
  li r19, 0x1D
  stb r19, 0xB79(r18)								# Changes a byte in the CSS Icon Data Array to the alternate character ID
  setPointer r18, r19, 0x80F39A64, 0x80FD1720		# Changes the pointer in an image data header to the alternate image data location
  b checkForClimbers

changeToBowser:
  li r19, 0x5
  stb r19, 0xB79(r18)								# Changes a byte in the CSS Icon Data Array to the vanilla character ID
  setPointer r18, r19, 0x80F39A64, 0x80C0D220		# Changes the pointer in an image data header to the vanilla image data location

checkForClimbers:
  cmpwi r17, 0xC0C
  bne- checkForFalcon
  lis r18, 0x803F
  lbz r17, 0xC75(r18)
  cmpwi r17, 0xE				# Checking byte 0x803F0C75 for 0xE (that the CSS Icon entry is set to Ice Climbers)
  bne- changeToBothClimbers

  # Change to Sopo
  li r19, 0x20
  stb r19, 0xC75(r18)								# Changes a byte in the CSS Icon Data Array to the alternate character ID
  setPointer r18, r19, 0x80F3A404, 0x80FD4120		# Changes the pointer in an image data header to the alternate image data location
  b checkForFalcon

changeToBothClimbers:
  li r19, 0xE
  stb r19, 0xC75(r18)								# Changes a byte in the CSS Icon Data Array to the vanilla character ID
  setPointer r18, r19, 0x80F3A404, 0x80C0A1C0		# Changes the pointer in an image data header to the vanilla image data location

checkForFalcon:
  cmpwi r17, 0x707
  bne- checkForPeach
  lis r18, 0x803F
  lbz r17, 0xBE9(r18)
  cmpwi r17, 0x0				# Checking byte 0x803F0BE9 for 0x0 (that the CSS Icon entry is set to Falcon)
  bne- changeToFalcon

  # Change to Male Wireframe
  li r19, 0x1B
  stb r19, 0xBE9(r18)								# Changes a byte in the CSS Icon Data Array to the alternate character ID
  setPointer r18, r19, 0x80F39FE4, 0x80FD3320		# Changes the pointer in an image data header to the alternate image data location
  b checkForPeach

changeToFalcon:
  li r19, 0x0
  stb r19, 0xBE9(r18)								# Changes a byte in the CSS Icon Data Array to the vanilla character ID
  setPointer r18, r19, 0x80F39FE4, 0x80C016C0		# Changes the pointer in an image data header to the vanilla image data location

checkForPeach:
  cmpwi r17, 0x404
  bne- checkForPichu
  lis r18, 0x803F
  lbz r17, 0xB95(r18)
  cmpwi r17, 0xC				# Checking byte 0x803F0B95 for 0xC (that the CSS Icon entry is set to Peach)
  bne- changeToPeach

  # Change to Female Wireframe
  li r19, 0x1C
  stb r19, 0xB95(r18)								# Changes a byte in the CSS Icon Data Array to the alternate character ID
  setPointer r18, r19, 0x80F39BC4, 0x80FD2520		# Changes the pointer in an image data header to the alternate image data location
  b checkForPichu

changeToPeach:
  li r19, 0xC
  stb r19, 0xB95(r18)								# Changes a byte in the CSS Icon Data Array to the vanilla character ID
  setPointer r18, r19, 0x80F39BC4, 0x80C132E0		# Changes the pointer in an image data header to the vanilla image data location

checkForPichu:
  cmpwi r17, 0x1212
  bne- checkForPikachu
  lis r18, 0x803F
  lbz r17, 3357(r18)
  cmpwi r17, 0x18				# Checking for Pichu
  bne- changeToPichu

  # Change to Master Hand
  li r19, 0x1A
  stb r19, 3357(r18)								# Changes a byte in the CSS Icon Data Array to the alternate character ID
  setPointer r18, r19, 0x80F3B3E4, 0x80FD5D20		# Changes the pointer in an image data header to the alternate image data location
  b checkForPikachu

changeToPichu:
  li r19, 0x18
  stb r19, 3357(r18)								# Changes a byte in the CSS Icon Data Array to the vanilla character ID
  setPointer r18, r19, 0x80F3B3E4, 0x80C14300		# Changes the pointer in an image data header to the vanilla image data location

checkForPikachu:
  cmpwi r17, 0x1313
  bne- loc_0x2FC
  lis r18, 0x803F
  lbz r17, 3385(r18)
  cmpwi r17, 0xD				# Checking for Pikachu
  bne- changeToPikachu

  # Change to Crazy Hand
  li r19, 0x1E
  stb r19, 3385(r18)								# Changes a byte in the CSS Icon Data Array to the alternate character ID
  setPointer r18, r19, 0x80F3AB04, 0x80FD6B20		# Changes the pointer in an image data header to the alternate image data location
  b loc_0x2FC

changeToPikachu:
  li r19, 0xD
  stb r19, 3385(r18)								# Changes a byte in the CSS Icon Data Array to the vanilla character ID
  setPointer r18, r19, 0x80F3AB04, 0x80C15320		# Changes the pointer in an image data header to the vanilla image data location

loc_0x2FC:
  lis r18, 0x803F
  b loc_0x40C

loc_0x300:
  lis r18, 0x8000
  ori r18, r18, 0x36E0
  lwz r18, 4(r18)
  cmpwi r18, 0x0
  beq- loc_0x3C0
  lis r18, 0x80FA
  ori r18, r18, 0xD0B4
  mulli r19, r16, 0x34
  add r18, r18, r19
  lbz r18, 38(r18)
  cmpwi r18, 0x0
  bne- loc_0x3C0
  lis r19, 0x804A
  ori r19, r19, 0x89B0
  mulli r18, r16, 0xC
  add r19, r19, r18
  lhz r18, 2(r15)
  rlwinm. r18, r18, 0, 27, 27
  beq- loc_0x3C0
  cmpwi r17, 0x1
  bne- loc_0x368
  lbz r18, 2(r19)
  extsb r18, r18
  subi r18, r18, 0x1
  stb r18, 2(r19)
  b loc_0x3BC

loc_0x368:
  cmpwi r17, 0x2
  bne- loc_0x384
  lbz r18, 2(r19)
  extsb r18, r18
  addi r18, r18, 0x1
  stb r18, 2(r19)
  b loc_0x3BC

loc_0x384:
  cmpwi r17, 0x4
  bne- loc_0x3A0
  lbz r18, 3(r19)
  extsb r18, r18
  subi r18, r18, 0x1
  stb r18, 3(r19)
  b loc_0x3BC

loc_0x3A0:
  cmpwi r17, 0x8
  bne- loc_0x3BC
  lbz r18, 3(r19)
  extsb r18, r18
  addi r18, r18, 0x1
  stb r18, 3(r19)
  b loc_0x3BC

loc_0x3BC:
  b loc_0x400

loc_0x3C0:
  rlwinm. r18, r17, 0, 29, 29
  beq- loc_0x400
  lis r17, 0x8000
  ori r17, r17, 0x36E0
  lis r18, 0x80FA
  ori r18, r18, 0xD0B4
  stw r18, 4(r17)
  mulli r16, r16, 0x34
  add r18, r18, r16
  lbz r16, 38(r18)
  li r17, 0xC0
  cmpwi r16, 0x0
  beq- loc_0x3F8
  li r17, 0x0

loc_0x3F8:
  stb r17, 38(r18)
  b loc_0x40C

loc_0x400:
  addi r16, r16, 0x1
  cmpwi r16, 0x4
  bne- loc_0x1B0

loc_0x40C:
  lis r15, 0x8048
  ori r15, r15, 0x820
  li r14, 0x0
  lis r16, 0x803F
  ori r16, r16, 0xBAD8

loc_0x420:
  mulli r17, r14, 0x24
  add r17, r15, r17
  mulli r18, r14, 0x3C
  add r18, r18, r16
  lwz r19, 0(r18)
  stb r19, 7(r17)
  lwz r19, 4(r18)
  stb r19, 14(r17)
  lwz r19, 20(r18)
  stw r19, 32(r17)
  li r21, 0x40
  lwz r19, 36(r18)
  cmpwi r19, 0x0
  beq- loc_0x45C
  addi r21, r21, 0x4

loc_0x45C:
  lwz r19, 40(r18)
  cmpwi r19, 0x0
  beq- loc_0x46C
  addi r21, r21, 0x20

loc_0x46C:
  lwz r19, 44(r18)
  cmpwi r19, 0x0
  beq- loc_0x47C
  addi r21, r21, 0x8

loc_0x47C:
  lwz r19, 48(r18)
  cmpwi r19, 0x0
  beq- loc_0x48C
  addi r21, r21, 0x2

loc_0x48C:
  lwz r19, 52(r18)
  cmpwi r19, 0x0
  beq- loc_0x49C
  addi r21, r21, 0x1

loc_0x49C:
  lbz r19, 0(r17)
  cmpwi r19, 0x1D
  bne- loc_0x4AC
  subi r21, r21, 0x40

loc_0x4AC:
  stb r21, 12(r17)
  lwz r19, 32(r18)
  addi r19, r19, 0x1
  stb r19, 4(r17)
  lwz r19, 8(r18)
  sth r19, 18(r17)
  lwz r19, 56(r18)
  sth r19, 20(r17)
  cmpwi r14, 0x4
  blt- loc_0x534
  lwz r19, 28(r18)
  stb r19, 15(r17)
  bne- loc_0x4E8
  addi r18, r18, 0x78
  b loc_0x4EC

loc_0x4E8:
  addi r18, r18, 0x40

loc_0x4EC:
  lwz r19, 8(r18)
  cmpwi r19, 0x2
  bne- loc_0x4FC
  li r19, 0x3

loc_0x4FC:
  stb r19, 1(r17)
  lwz r19, 0(r18)
  mulli r19, r19, 0x24
  add r19, r19, r15
  lbz r21, 1(r19)
  cmpwi r21, 0x3
  bne- loc_0x51C
  stb r21, 1(r17)

loc_0x51C:
  lbz r19, 0(r19)
  stb r19, 0(r17)
  lwz r19, 16(r18)
  stb r19, 9(r17)
  lwz r19, 24(r18)
  stb r19, 8(r17)

loc_0x534:
  addi r14, r14, 0x1
  cmpwi r14, 0x6
  blt- loc_0x420
  lis r14, 0x803F
  ori r14, r14, 0xA3D4
  lbz r19, 181(r15)
  cmpwi r19, 0x3
  beq- loc_0x55C

loc_0x554:
  li r19, 0x18
  b loc_0x598

loc_0x55C:
  lbz r19, 145(r15)
  cmpwi r19, 0x3
  bne- loc_0x554
  li r19, 0x1C
  lwz r20, -408(r14)
  cmpwi r20, 0x1
  beq- loc_0x598
  lwz r20, -404(r14)
  cmpwi r20, 0x1
  bne- loc_0x594
  lis r20, 0x8048
  lbz r20, 1992(r20)
  cmpwi r20, 0x1
  beq- loc_0x598

loc_0x594:
  li r19, 0x10

loc_0x598:
  stb r19, -96(r15)
  lis r16, 0x8048
  lwz r15, -336(r14)
  cmpwi r15, 0x1
  beq- loc_0x5B4
  lis r17, 0x3F80
  b loc_0x5B8

loc_0x5B4:
  li r17, 0x0

loc_0x5B8:
  stw r17, 2028(r16)
  lwz r15, -608(r14)
  stw r15, 2036(r16)
  lbz r15, -237(r14)
  lis r17, 0x8047
  ori r17, r17, 0x9D64
  cmpwi r15, 0x0
  beq- loc_0x634
  cmpwi r15, 0xFD
  bge- loc_0x640
  lis r20, 0x8045
  ori r20, r20, 0xC388
  lwz r21, 0(r20)
  lbz r18, -240(r14)
  subi r18, r18, 0x30
  mulli r18, r18, 0x4
  subi r19, r14, 0x224
  stwx r21, r19, r18
  stb r15, -240(r14)
  subi r18, r15, 0x30
  mulli r18, r18, 0x4
  lwzx r21, r18, r19
  stw r21, 0(r20)
  li r15, 0x1
  stb r15, 0(r17)
  li r15, 0x0
  stb r15, -237(r14)
  lbz r15, -240(r14)
  lis r16, 0x803F
  stb r15, -14905(r16)
  stb r15, 4524(r16)

loc_0x634:
  lbz r15, -240(r14)
  lis r16, 0x803F
  stb r15, 2592(r16)

loc_0x640:
  lis r14, 0x8048
  lwz r14, -25248(r14)
  cmpwi r14, 0x0
  bne- loc_0x69C
  lis r14, 0x804C				# <- loading button input address for P1
  ori r14, r14, 0x1FAC
  li r15, 0x0
  li r16, 0x0

loc_0x660:
  mulli r17, r15, 0x44
  lwzx r17, r17, r14
  or r16, r17, r16
  addi r15, r15, 0x1
  cmpwi r15, 0x4
  bne- loc_0x660
  rlwinm. r16, r16, 0, 27, 27
  beq- loc_0x69C
  li r16, 0x2
  stb r16, -18858(r13)
  lis r15, 0x8048
  lbz r15, -25296(r15)
  addi r15, r15, 0x1
  lis r16, 0x803F
  stb r15, 2631(r16)

loc_0x69C:
  lis r14, 0x803F
  ori r14, r14, 0xA3D4
  lis r15, 0x8040
  lwz r15, -20624(r15)
  addi r15, r15, 0x30
  lis r16, 0x803F
  stb r15, 4444(r16)
  lwz r15, -4(r14)
  lis r16, 0x3DBA
  ori r16, r16, 0xE148
  cmpwi r15, 0x0
  beq- loc_0x6DC
  cmpwi r15, 0x4
  beq- loc_0x6DC
  lis r16, 0x3DF9
  ori r16, r16, 0x2C60

loc_0x6DC:
  stw r16, -7832(r2)
  lwz r15, 2772(r14)
  lis r16, 0x8026
  ori r16, r16, 0xB748
  lis r17, 0x4182
  ori r17, r17, 0x10
  lis r18, 0x8864
  ori r18, r18, 0xDC8
  cmpwi r15, 0x0
  beq- loc_0x714
  lis r17, 0x4D82
  ori r17, r17, 0x20
  lis r18, 0x4E80
  ori r18, r18, 0x20

loc_0x714:
  stw r17, 0(r16)
  stw r18, 16(r16)
  lis r3, 0x801A
  ori r3, r3, 0x4340
  mtlr r3
  lis r3, 0x8047
  ori r3, r3, 0x9D30
  lbz r3, 0(r3)
  blrl 
  cmpwi r3, 0x1
  beq- loc_0x83C
  lbz r15, -237(r14)
  cmpwi r15, 0xFE
  beq- loc_0x76C
  cmpwi r15, 0xFD
  beq- loc_0x83C
  lwz r15, -132(r14)
  cmpwi r15, 0x0
  beq- loc_0x83C
  lbz r15, -237(r14)
  cmpwi r15, 0xFE
  blt- loc_0x83C

loc_0x76C:
  li r16, 0xFD
  stb r16, -237(r14)
  lis r17, 0x804D
  ori r17, r17, 0x6CF6
  li r16, 0x1
  stb r16, 0(r17)
  cmpwi r15, 0xFE
  beq- loc_0x83C
  li r16, 0x0

loc_0x790:
  lis r15, 0x803F
  ori r15, r15, 0xAED8
  mulli r17, r16, 0x14
  add r17, r17, r15
  lwz r15, 0(r17)
  cmpwi r15, 0x0
  beq- loc_0x830
  li r18, 0x4
  li r3, 0x0

loc_0x7B4:
  lwzx r15, r18, r17
  cmpwi r15, 0x1A
  beq- loc_0x7D0
  addi r3, r3, 0x1
  addi r18, r18, 0x4
  cmpwi r18, 0x14
  blt- loc_0x7B4

loc_0x7D0:
  cmpwi r3, 0x0
  beq- loc_0x830
  lis r18, 0x8038
  ori r18, r18, 0x580
  mtlr r18
  blrl 
  addi r3, r3, 0x1
  mulli r3, r3, 0x4
  lwzx r3, r3, r17
  mulli r15, r16, 0x24
  lis r18, 0x8048
  ori r18, r18, 0x820
  add r15, r15, r18
  stb r3, 0(r15)
  rlwinm r4, r3, 2, 0, 29
  lis r3, 0x803D
  addi r0, r3, 0x51A0
  add r3, r0, r4
  lbz r3, 0(r3)
  lis r18, 0x8038
  ori r18, r18, 0x580
  mtlr r18
  blrl 
  stb r3, 3(r15)

loc_0x830:
  addi r16, r16, 0x1
  cmpwi r16, 0x4
  blt- loc_0x790

loc_0x83C:
  lis r16, 0x8008
  ori r16, r16, 0xD694
  lwz r15, -108(r14)
  cmpwi r15, 0x1
  beq- loc_0x858
  lwz r18, -120(r14)
  b loc_0x85C

loc_0x858:
  li r18, 0x101

loc_0x85C:
  sth r18, 2(r16)
  lwz r15, -124(r14)
  cmpwi r15, 0x1
  bne- loc_0x878
  lis r19, 0xFC00
  ori r19, r19, 0x32
  b loc_0x880

loc_0x878:
  lis r19, 0xEC01
  ori r19, r19, 0x24

loc_0x880:
  stw r19, 16(r16)
  lis r16, 0x804D
  ori r17, r16, 0x8278
  ori r16, r16, 0x8270
  lwz r15, -84(r14)
  cmpwi r15, 0x1
  bne- loc_0x8A4
  li r18, 0x0
  b loc_0x8AC

loc_0x8A4:
  lis r18, 0x3FF9
  ori r18, r18, 0x21FB

loc_0x8AC:
  stw r18, 0(r16)
  lwz r15, -88(r14)
  cmpwi r15, 0x1
  bne- loc_0x8C4
  li r18, 0x0
  b loc_0x8C8

loc_0x8C4:
  lis r18, 0x4330

loc_0x8C8:
  stw r18, 0(r17)
  lis r18, 0x8021
  lwz r15, -36(r14)
  cmpwi r15, 0x1
  bne- loc_0x8E4
  lis r16, 0x6000
  b loc_0x8EC

loc_0x8E4:
  lis r16, 0x4800
  ori r16, r16, 0x59C

loc_0x8EC:
  stw r16, 5188(r18)
  lis r18, 0x801E
  lwz r15, -44(r14)
  cmpwi r15, 0x1
  bne- loc_0x908
  lis r16, 0x6000
  b loc_0x910

loc_0x908:
  lis r16, 0x4800
  ori r16, r16, 0xD1

loc_0x910:
  stw r16, 13128(r18)
  lwz r15, -528(r14)
  lis r16, 0x8027
  ori r16, r16, 0xCF8C
  lis r17, 0x8028
  cmpwi r15, 0x0
  bne- loc_0x940
  li r18, 0x4082
  li r19, 0x0
  lis r20, 0x4080
  ori r20, r20, 0xC
  b loc_0x94C

loc_0x940:
  li r18, 0x4800
  li r19, 0x1
  lis r20, 0x6000

loc_0x94C:
  sth r18, 0(r16)
  sth r19, 25502(r17)
  ori r17, r17, 0x8B28
  stw r20, 0(r17)
  lwz r15, -424(r14)
  lis r16, 0x800D
  lis r17, 0x981F
  ori r17, r17, 0x2220
  cmpwi r15, 0x0
  beq- loc_0x978
  lis r17, 0x6000

loc_0x978:
  stw r17, 8088(r16)
  stw r17, 5628(r16)
  lis r18, 0x8026
  ori r18, r18, 0x9638
  lwz r15, -428(r14)
  cmpwi r15, 0x1
  beq- loc_0x9A0
  lis r17, 0xD01F
  ori r17, r17, 0xD44
  b loc_0x9A4

loc_0x9A0:
  lis r17, 0x6000

loc_0x9A4:
  stw r17, 0(r18)
  lwz r15, -420(r14)
  lis r18, 0x800D
  ori r18, r18, 0x32CC
  cmpwi r15, 0x1
  beq- loc_0x9CC
  lis r19, 0x4800
  ori r17, r19, 0xDED
  ori r19, r19, 0x14D9
  b loc_0x9D8

loc_0x9CC:
  lis r17, 0x4BFF
  ori r17, r17, 0xFF94
  addi r19, r17, 0x24

loc_0x9D8:
  stw r17, 0(r18)
  subi r18, r18, 0x24
  stw r19, 0(r18)
  lwz r15, -416(r14)
  lis r18, 0x800D
  ori r18, r18, 0xEE70
  lis r19, 0x800C
  ori r19, r19, 0xA4CC
  cmpwi r15, 0x1
  beq- loc_0xA14
  lis r16, 0x4BFA
  ori r16, r16, 0x5295
  lis r17, 0x4082
  ori r17, r17, 0x34
  b loc_0xA24

loc_0xA14:
  lis r16, 0x4BFA
  ori r16, r16, 0x5411
  lis r17, 0x4082
  ori r17, r17, 0x58

loc_0xA24:
  stw r16, 0(r18)
  stw r17, 0(r19)
  lwz r15, -396(r14)
  addi r15, r15, 0x30
  lis r17, 0x804D
  stb r15, 14320(r17)
  stb r15, 22404(r17)
  lis r16, 0x803E
  lis r17, 0x8020
  lis r18, 0x7C08
  ori r18, r18, 0x2A6
  lis r19, 0x4800
  ori r19, r19, 0xAD
  lis r3, 0x801A
  ori r3, r3, 0x4340
  mtlr r3
  lis r3, 0x8047
  ori r3, r3, 0x9D30
  lbz r3, 0(r3)
  cmpwi r3, 0x1C
  beq- loc_0xA84
  blrl 
  cmpwi r3, 0x1
  beq- loc_0xAD8

loc_0xA84:
  lis r15, 0x803F
  lbz r15, 2592(r15)
  cmpwi r15, 0x32
  bne- loc_0xAD8
  lis r18, 0x4E80
  ori r18, r18, 0x20
  lis r19, 0x6000
  lwz r15, -128(r14)
  cmpwi r15, 0x0
  bne- loc_0xAB4

loc_0xAAC:
  li r15, 0x31
  b loc_0xADC

loc_0xAB4:
  cmpwi r15, 0x1
  bne- loc_0xAC4

loc_0xABC:
  li r15, 0x32
  b loc_0xADC

loc_0xAC4:
  lis r15, 0x804D
  lbz r15, 24467(r15)
  cmpwi r15, 0x80
  blt- loc_0xAAC
  b loc_0xABC

loc_0xAD8:
  li r15, 0x30

loc_0xADC:
  stb r15, 21210(r16)
  stw r18, 11676(r17)
  stw r19, 11212(r17)
  lis r18, 0x802F
  lwz r15, -400(r14)
  cmpwi r15, 0x1
  beq- loc_0xB04
  lis r17, 0x7C08
  ori r17, r17, 0x2A6
  b loc_0xB0C

loc_0xB04:
  lis r17, 0x4E80
  ori r17, r17, 0x20

loc_0xB0C:
  stw r17, 24144(r18)
  lis r18, 0x8008
  ori r18, r18, 0xCF70
  lwz r15, -592(r14)
  cmpwi r15, 0x1
  beq- loc_0xB30
  lis r17, 0x7C08
  ori r17, r17, 0x2A6
  b loc_0xB38

loc_0xB30:
  lis r17, 0x4E80
  ori r17, r17, 0x20

loc_0xB38:
  stw r17, 0(r18)
  lis r18, 0x8007
  ori r18, r18, 0xD698
  lis r19, 0x8009
  ori r19, r19, 0x694C
  lwz r15, -588(r14)
  cmpwi r15, 0x1
  beq- loc_0xB6C
  lis r16, 0x8003
  ori r16, r16, 0x168
  lis r17, 0x3880
  ori r17, r17, 0x23
  b loc_0xB7C

loc_0xB6C:
  lis r16, 0x3800
  ori r16, r16, 0x1
  lis r17, 0x3880
  ori r17, r17, 0x1D

loc_0xB7C:
  stw r16, 0(r18)
  stw r17, 0(r19)
  lis r18, 0x8009
  ori r18, r18, 0x9894
  lwz r15, -596(r14)
  cmpwi r15, 0x1
  beq- loc_0xBA4
  lis r17, 0x7C08
  ori r17, r17, 0x2A6
  b loc_0xBAC

loc_0xBA4:
  lis r17, 0x4E80
  ori r17, r17, 0x20

loc_0xBAC:
  stw r17, 0(r18)
  lwz r15, -580(r14)
  lis r16, 0x800C
  ori r16, r16, 0xC300
  cmpwi r15, 0x1
  beq- loc_0xBE8
  lis r17, 0x981E
  ori r17, r17, 0x1968
  lis r18, 0x981F
  ori r18, r18, 0x1968
  lis r19, 0x981D
  ori r19, r19, 0x1968
  lis r20, 0x981C
  ori r20, r20, 0x1968
  b loc_0xBF8

loc_0xBE8:
  lis r17, 0x6000
  lis r18, 0x6000
  lis r19, 0x6000
  lis r20, 0x6000

loc_0xBF8:
  stw r17, 0(r16)
  stw r17, -336(r16)
  stw r18, -1976(r16)
  stw r18, -1640(r16)
  stw r19, -1280(r16)
  stw r20, -968(r16)
  lis r18, 0x8037
  lwz r15, 5920(r14)
  cmpwi r15, 0x1
  bne- loc_0xC2C
  lis r16, 0x3880
  ori r16, r16, 0x4C
  b loc_0xC34

loc_0xC2C:
  lis r16, 0x8081
  ori r16, r16, 0x34

loc_0xC34:
  stw r16, 27584(r18)
  lis r16, 0x3800
  lwz r15, 5980(r14)
  cmpwi r15, 0x1
  bne- loc_0xC50
  lis r16, 0x3800
  b loc_0xC58

loc_0xC50:
  lis r16, 0x8001
  ori r16, r16, 0x40

loc_0xC58:
  stw r16, 27604(r18)
  lis r16, 0x3880
  ori r16, r16, 0xD8
  lwz r15, 6040(r14)
  cmpwi r15, 0x1
  bne- loc_0xC74
  b loc_0xC7C

loc_0xC74:
  lis r16, 0x8081
  ori r16, r16, 0x4C

loc_0xC7C:
  stw r16, 27632(r18)
  lis r16, 0x3800
  ori r16, r16, 0x1
  lwz r15, 6100(r14)
  cmpwi r15, 0x1
  bne- loc_0xC98
  b loc_0xCA0

loc_0xC98:
  lis r16, 0x8001
  ori r16, r16, 0x58

loc_0xCA0:
  stw r16, 27652(r18)
  lwz r15, -344(r14)
  lis r16, 0x801C
  lis r17, 0x7C08
  ori r17, r17, 0x2A6
  cmpwi r15, 0x0
  beq- loc_0xCC4
  lis r17, 0x4E80
  ori r17, r17, 0x20

loc_0xCC4:
  stw r17, 16912(r16)
  stw r17, 17068(r16)
  lis r18, 0x8005
  ori r18, r18, 0xFDDC
  lis r17, 0x7C08
  ori r17, r17, 0x2A6
  lwz r15, -604(r14)
  cmpwi r15, 0x0
  beq- loc_0xCF0
  lis r17, 0x4E80
  ori r17, r17, 0x20

loc_0xCF0:
  stw r17, 0(r18)
  lis r18, 0x804D
  lwz r15, -144(r14)
  stb r15, 13987(r18)
  lwz r15, -148(r14)
  stb r15, 13999(r18)
  lwz r15, -152(r14)
  stb r15, 14015(r18)
  lwz r15, -156(r14)
  stb r15, 14007(r18)
  lis r18, 0x8008
  ori r18, r18, 0x924E
  lwz r15, -456(r14)
  cmpwi r15, 0x1
  beq- loc_0xD34
  li r17, 0x3
  b loc_0xD38

loc_0xD34:
  li r17, 0x5

loc_0xD38:
  sth r17, 0(r18)
  lis r16, 0x803D
  ori r16, r16, 0xEBE7
  lis r18, 0x80FA
  ori r18, r18, 0xC1EF
  lbz r17, 1(r16)
  lwz r15, 2808(r14)
  cmpwi r15, 0x1
  beq- loc_0xD68
  cmpwi r17, 0x20
  bgt- loc_0xD8C
  b loc_0xD74

loc_0xD68:
  cmpwi r17, 0x20
  ble- loc_0xD8C
  addi r18, r18, 0x80

loc_0xD74:
  li r19, 0x0

loc_0xD78:
  lbzu r15, 1(r18)
  stbu r15, 1(r16)
  addi r19, r19, 0x1
  cmpwi r19, 0x64
  bne- loc_0xD78

loc_0xD8C:
  lis r15, 0x803B
  ori r15, r15, 0x7864
  lis r16, 0x991A
  ori r16, r16, 0x1AFF
  stw r16, 0(r15)
  lis r16, 0x3333
  ori r16, r16, 0x80FF
  stw r16, 4(r15)
  lis r16, 0x8066
  ori r16, r16, 0xFF
  stw r16, 8(r15)
  lis r16, 0x1A66
  ori r16, r16, 0x1AFF
  stw r16, 12(r15)
  li r16, 0x0
  lis r17, 0x803F
  ori r17, r17, 0xA2D8
  subi r15, r15, 0x4

loc_0xDD4:
  addi r16, r16, 0x1
  addi r15, r15, 0x4
  lwzu r18, -16(r17)
  cmpwi r18, 0x0
  beq- loc_0xE00
  lwz r18, -4(r17)
  stb r18, 0(r15)
  lwz r18, -8(r17)
  stb r18, 1(r15)
  lwz r18, -12(r17)
  stb r18, 2(r15)

loc_0xE00:
  cmpwi r16, 0x4
  bne- loc_0xDD4
  lwz r15, -412(r14)
  lis r16, 0x6000
  cmpwi r15, 0x1
  beq- loc_0xE20
  lis r16, 0x4182
  ori r16, r16, 0x10

loc_0xE20:
  lis r17, 0x8007
  stw r16, 29152(r17)
  stw r16, 29348(r17)
  stw r16, 27208(r17)
  stw r16, 27548(r17)
  stw r16, 31260(r17)
  stw r16, 31600(r17)
  stw r16, 27964(r17)
  stw r16, 30460(r17)
  ori r18, r17, 0x81D4
  stw r16, 0(r18)
  lwz r15, -552(r14)
  lis r16, 0x8000
  ori r16, r16, 0xA008
  li r17, 0x58
  li r18, 0x5C
  li r19, 0x60
  cmpwi r15, 0x0
  beq- loc_0xE78
  li r17, 0x4C
  li r18, 0x50
  li r19, 0x54

loc_0xE78:
  sth r17, 2(r16)
  sth r18, 6(r16)
  sth r19, 18(r16)
  lwz r15, -556(r14)
  lis r16, 0x802F
  ori r16, r16, 0x9A28
  lis r17, 0x8016
  ori r17, r17, 0x4
  cmpwi r15, 0x1
  bne- loc_0xEA8
  lhz r17, -560(r14)
  xoris r17, r17, 15360

loc_0xEA8:
  stw r17, 0(r16)
  lwz r15, -564(r14)
  lis r16, 0x802F
  ori r16, r16, 0x8337
  subi r15, r15, 0x1
  stb r15, 0(r16)
  lwz r15, -112(r14)
  lis r16, 0x801C
  lis r17, 0x8015
  ori r17, r17, 0xED0B
  li r19, 0x36
  li r18, 0x4182
  cmpwi r15, 0x0
  beq- loc_0xEE8
  li r18, 0x4800
  li r19, 0x34

loc_0xEE8:
  sth r18, 10244(r16)
  stb r19, 0(r17)

# Update Mount Olympus stage filename string
  lwz r15, -116(r14)		# Loading flag for Greece Stage Variations (at 803FA360)
  lis r16, 0x803E			# Loading address of FigureGet stage (Mount Olympus) filename string
  ori r16, r16, 0x7D2F
  mr r3, r15
  cmpwi r15, 0x3			# Check if Greece Stage Variation set to RANDOM
  bne- updateGreeceStageName
  lis r17, 0x8038
  ori r17, r17, 0x580
  mtctr r17
  bctrl 

updateGreeceStageName:		# Convert the Greece Stage Variations flag to an ASCII letter and update the file name string
  addi r3, r3, 0x30
  stb r3, 0(r16)

# Update Hex Tracks global counter (at 0x800032F0|0x2F0)
  lis r15, 0x80FD		# This is an entry in the song name pointers table, to index 0x30
  ori r15, r15, 0xA588
  li r16, 0x0

hexTracksCountLoop:		# Loop through the song name pointers table (from the CSS), until reaching a null word
  lwzu r17, 4(r15)
  cmpwi r17, 0x0
  beq- loc_0xF40
  addi r16, r16, 0x1	# Increment custom song count
  b hexTracksCountLoop

loc_0xF40:
  lis r15, 0x8000
  stw r16, 0x32F0(r15)	# Updates the custom song (hexTracks) count at 0x800032F0|0x2F0
  addi r16, r16, 0x31
  lis r15, 0x4330
  stw r15, -16(r1)
  lis r15, 0x8000
  stw r15, -12(r1)
  lfd f15, -16(r1)
  xoris r15, r16, 32768
  stw r15, -12(r1)
  lfd f16, -16(r1)
  fsubs f15, f16, f15
  lis r15, 0x80FA
  ori r15, r15, 0x52A8
  stfs f15, 0(r15)
  lis r15, 0x80FA
  ori r15, r15, 0x7BDC

loc_0xF84:
  li r17, 0x0
  lwzu r16, 4(r15)
  cmpwi r16, 0x0
  beq- loc_0xFB0
  addi r16, r16, 0x58

loc_0xF98:
  addi r17, r17, 0x1
  addi r16, r16, 0x20
  stfs f15, 0(r16)
  cmpwi r17, 0x14
  beq- loc_0xF84
  b loc_0xF98

loc_0xFB0:
  lis r18, 0x801C
  li r16, 0x0
  lis r3, 0x801A
  ori r3, r3, 0x4340
  mtlr r3
  lis r3, 0x8047
  ori r3, r3, 0x9D30
  lbz r3, 0(r3)
  cmpwi r3, 0x1C
  beq- loc_0xFE4
  blrl 
  cmpwi r3, 0x1
  beq- loc_0x1008

loc_0xFE4:
  lis r15, 0x8043
  ori r15, r15, 0x2087

loc_0xFEC:
  lbzu r17, 8(r15)
  cmpwi r17, 0x21
  bne- loc_0x1008
  addi r16, r16, 0x1
  cmpwi r16, 0x6
  blt- loc_0xFEC
  li r16, 0x0

loc_0x1008:
  stb r16, 22443(r18)
  lis r3, 0x801A
  ori r3, r3, 0x4340
  mtlr r3
  lis r3, 0x8047
  ori r3, r3, 0x9D30
  lbz r3, 0(r3)
  cmpwi r3, 0x1C
  beq- loc_0x1038
  blrl 
  cmpwi r3, 0x1
  beq- loc_0x10BC

loc_0x1038:
  lis r15, 0x8020
  ori r15, r15, 0x8A80
  lis r16, 0x3860
  ori r16, r16, 0x6
  stw r16, 0(r15)
  li r18, 0x31
  lis r17, 0x803E
  ori r17, r17, 0x5983
  stb r18, 0(r17)
  lis r17, 0x803E
  ori r17, r17, 0x5847
  lis r18, 0x8040
  lwz r18, -24168(r18)
  cmpwi r18, 0x2
  beq- loc_0x107C
  addi r18, r18, 0x31
  b loc_0x1094

loc_0x107C:
  lbz r18, -22286(r13)
  cmpwi r18, 0x80
  blt- loc_0x1090
  li r18, 0x31
  b loc_0x1094

loc_0x1090:
  li r18, 0x32

loc_0x1094:
  stb r18, 0(r17)
  lis r16, 0x8016
  lis r17, 0x4800
  ori r17, r17, 0xC
  stw r17, 29196(r16)
  lis r16, 0x8020
  ori r16, r16, 0x9090
  lis r17, 0x6000			# Store nop at 0x80209090
  stw r17, 0(r16)
  b loc_0x111C

loc_0x10BC:
  lis r15, 0x8020
  ori r15, r15, 0x8A80
  lis r16, 0x4817
  ori r16, r16, 0x7B01
  stw r16, 0(r15)
  lis r17, 0x803E
  ori r17, r17, 0x5847
  li r18, 0x30
  stb r18, 0(r17)
  lis r17, 0x803E
  ori r17, r17, 0x5983
  stb r18, 0(r17)
  lis r16, 0x803E
  li r17, 0x64
  stb r17, 32047(r16)
  lis r16, 0x8016
  lis r17, 0xC041
  ori r17, r17, 0x20
  stw r17, 29196(r16)
  lis r16, 0x8020
  ori r16, r16, 0x9090
  lis r17, 0x4BE2
  ori r17, r17, 0x8701
  stw r17, 0(r16)

loc_0x111C:
  li r17, 0x0
  lis r16, 0x8040
  stb r17, -23835(r16)
  lis r15, 0x8000
  lis r16, 0x4E54
  ori r16, r16, 0x5343
  lis r17, 0x8040
  lwz r17, -23808(r17)
  cmpwi r17, 0x0
  beq- loc_0x114C
  lis r16, 0x5041
  ori r16, r16, 0x4C00

loc_0x114C:
  stw r16, 20627(r15)
  li r15, 0x1558			# Total number of bytes for storage (between flags start and memcard end)
  lis r16, 0x803F			# Load address for start of 20XX flags, in DOL space
  ori r16, r16, 0xA150
  lis r17, 0x8046			# Load address for start of 20XX flags, in mem card space
  ori r17, r17, 0x9B90

FlagsSaveLoop:
  # Check r16 position; skip copying data between 0x803FA4CC and 0x803FA848
  lis r19, 0x803F			# (^ but still increment r16 address)
  ori r19, r19, 0xA4CC
  cmpw r16, r19
  blt- CopyFlags			# Branch if r16 is less than 0x803FA4CC (still in section 1)
  lis r19, 0x803F
  ori r19, r19, 0xA848
  cmpw r16, r19
  bge- CopyFlags			# Branch if r16 is greater than or equal to 0x803FA848 (in section 2)
  addi r16, r16, 0x4		# Move to the next flag in DOL space
  b FlagsSaveLoop

CopyFlags:
  # Copy data from DOL space to memory card space
  lwzu r18, 4(r16)			# Load address of r16+4 and place in r18 (& update r16)
  stwu r18, 4(r17)			# Store r18 contents into r17+4 (& update r17)
  subi r15, r15, 0x4		# Decriment bytes remaining to save
  cmpwi r15, 0x0			# Break loop once we've copied 0x1558 bytes of data
  bne- FlagsSaveLoop

  lis r15, 0x80F9
  ori r15, r15, 0x16D0
  lwz r0, 12(r15)
  mtlr r0
  lwz r0, 8(r15)
  lwz r3, 16(r15)
  lwz r4, 20(r15)
  lwz r5, 24(r15)
  blr 

