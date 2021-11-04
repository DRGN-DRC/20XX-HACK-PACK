# To be injected at 0x263554 | 80266974
# #
# Change log:
#
#	Version 1.1			- DRGN
#		- Added CSS Icon Texture swaps
#
#	Version 1.0			- Achilles1515
#		- Initial release
/*

Original binary (v1.0):

906DB630 3C608040
8063A300 2C030000
41820028 3C608000
606331F4 7C6903A6
3C8080FA 6084A2B0
3C6080C3 606381C0
38A00EA0 4E800421
3C60803F 6063AE58
80830000 2C040000
41820050 3C8080BE
6084D06B 4800002D
3C8080F3 6084572B
48000021 3C8080F3
608455AB 48000015
3C8080F3 6084566B
48000009 4800001C
38A00003 7CA903A6
84A30004 9CA40001
4200FFF8 4E800020
48000000


Original code (v1.0), disassembled:

loc_0x0:
  stw r3, -18896(r13)	# Original code line
  lis r3, 0x8040
  lwz r3, -23808(r3)
  cmpwi r3, 0x0			# Checking byte at 0x8040A300 for 0
  beq- loc_0x38
  lis r3, 0x8000
  ori r3, r3, 0x31F4
  mtctr r3
  lis r4, 0x80FA
  ori r4, r4, 0xA2B0
  lis r3, 0x80C3
  ori r3, r3, 0x81C0
  li r5, 0xEA0
  bctrl 

loc_0x38:
  lis r3, 0x803F
  ori r3, r3, 0xAE58
  lwz r4, 0(r3)
  cmpwi r4, 0x0
  beq- END
  lis r4, 0x80BE
  ori r4, r4, 0xD06B
  bl loc_0x80
  lis r4, 0x80F3
  ori r4, r4, 0x572B
  bl loc_0x80
  lis r4, 0x80F3
  ori r4, r4, 0x55AB
  bl loc_0x80
  lis r4, 0x80F3
  ori r4, r4, 0x566B
  bl loc_0x80
  b END

loc_0x80:
  li r5, 0x3
  mtctr r5

loc_0x88:
  lwzu r5, 4(r3)
  stbu r5, 1(r4)
  bdnz+ loc_0x88
  blr 

END:
  .long 0		# Will be replaced with a branch back to the injection site
*/



# Version 1.1:


.macro setPointer reg1, reg2, headerOffset, dataOffset

  lis \reg1, \headerOffset @h			# load address of the image or palette data header
  ori \reg1, \reg1, \headerOffset @l
  lis \reg2, \dataOffset @h			# load address of the image or palette data
  ori \reg2, \reg2, \dataOffset @l

  stw \reg2, 0(\reg1)			# set the image data pointer in the header

.endm


loc_0x0:
  stw r3, -18896(r13)	# Original code line
  lis r3, 0x8040
  lwz r3, -23808(r3)
  cmpwi r3, 0x0			# Checking byte at 0x8040A300 for 0
  beq- loc_0x38
  lis r3, 0x8000
  ori r3, r3, 0x31F4
  mtctr r3
  lis r4, 0x80FA
  ori r4, r4, 0xA2B0
  lis r3, 0x80C3
  ori r3, r3, 0x81C0
  li r5, 0xEA0
  bctrl 

loc_0x38:
  lis r3, 0x803F
  ori r3, r3, 0xAE58
  lwz r4, 0(r3)
  cmpwi r4, 0x0
  beq- updateCharIcons
  lis r4, 0x80BE
  ori r4, r4, 0xD06B
  bl loc_0x80
  lis r4, 0x80F3
  ori r4, r4, 0x572B
  bl loc_0x80
  lis r4, 0x80F3
  ori r4, r4, 0x55AB
  bl loc_0x80
  lis r4, 0x80F3
  ori r4, r4, 0x566B
  bl loc_0x80
  b updateCharIcons

loc_0x80:
  li r5, 0x3
  mtctr r5

loc_0x88:
  lwzu r5, 4(r3)
  stbu r5, 1(r4)
  bdnz+ loc_0x88
  blr 

updateCharIcons:
  lis r3, 0x803F

  # Zelda icon check and update
  lbz r4, 0xCC9(r3)
  cmpwi r4, 0x12				# Checking byte 0x803F0CC9 for 0x12 (that the CSS Icon entry is set to Zelda)
  beq BowserCheck						# Skip the next line if currently set to Zelda
  setPointer r4, r5, 0x80F529B0, 0x80FD4F20		# Changes the pointer in an image data header to the alternate image data location

BowserCheck:
  lbz r4, 0xB79(r3)
  cmpwi r4, 0x5
  beq ClimbersCheck
  setPointer r4, r5, 0x80F39A64, 0x80FD1720
  
ClimbersCheck:
  lbz r4, 0xC75(r3)
  cmpwi r4, 0xE
  beq FalconCheck
  setPointer r4, r5, 0x80F3A404, 0x80FD4120
  
FalconCheck:
  lbz r4, 0xBE9(r3)
  cmpwi r4, 0x0
  beq PeachCheck
  setPointer r4, r5, 0x80F39FE4, 0x80FD3320
  
PeachCheck:
  lbz r4, 0xB95(r3)
  cmpwi r4, 0xC
  beq PichuCheck
  setPointer r4, r5, 0x80F39BC4, 0x80FD2520
  
PichuCheck:
  lbz r4, 3357(r3)
  cmpwi r4, 0x18
  beq PikachuCheck
  setPointer r4, r5, 0x80F3B3E4, 0x80FD5D20
  
PikachuCheck:
  lbz r4, 3385(r3)
  cmpwi r4, 0xD
  beq END
  setPointer r4, r5, 0x80F3AB04, 0x80FD6B20

END:
  .long 0		# Will be replaced with a branch back to the injection site