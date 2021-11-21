#To be inserted at 803039a4
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
stwu	r1,-68(r1)	# make space for 12 registers
stmw	r20,8(r1)	# push r20-r31 onto the stack
mflr r0
stw r0,64(sp)
.endm

.macro restore
lwz r0,64(sp)
mtlr r0
lmw	r20,8(r1)	# pop r20-r31 off the stack
addi	r1,r1,68	# release the space
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
.set player,31

#branch r12,0x80f91f50		 #static branch to MnSlChr code

# Debug Menu Player Flag Switcher

lis	r16, 0x803F
ori	r16, r16, 0xBAD4
lwz	r16, 0 (r16)
lis	r15, 0x80F9
ori	r15, r15, 0x1BCC
lis	r19, 0x1234
ori	r19, r19, 0x5678
mulli	r20, r16, 864
subi	r17, r15, 11360
add	r17, r17, r20
loop1:
lwzu	r18, 0x0004 (r17)
cmpw	r18, r19
beq	exit1
stwu	r18, 0x0004 (r15)
b	loop1
exit1:
li	r10, 0

###### First Branch ######

# Debug Menu - Line Tracking
# For auto menu traversal
# Note: this "default code line" was changed 
# with wParam's debug menu control code.

Aloc_0x0:
  lis r14, 0x80BD
  ori r14, r14, 0xCD40
  lwz r15, 8(r14)
  lis r16, 0x803F
  ori r16, r16, 0xA4E0
  cmpw r15, r16
  bne- Aloc_0x50
  lbz r15, -260(r16)
  rlwinm. r8, r15, 0, 25, 25
  bne- Aloc_0xC8
  rlwinm r8, r15, 0, 26, 31
  stb r8, 0(r14)
  rlwinm. r8, r15, 0, 24, 24
  beq- Aloc_0x44
  li r15, 0x100
  lis r8, 0x804C
  stw r15, 8388(r8)

Aloc_0x44:
  li r15, 0x40
  stb r15, -260(r16)
  b Aloc_0xC8

Aloc_0x50:
  lwz r15, 24(r14)
  cmpwi r15, 0x0
  bne- Aloc_0x90
  lbz r15, -259(r16)
  rlwinm. r8, r15, 0, 25, 25
  beq- Aloc_0x84
  rlwinm r8, r15, 0, 26, 31
  stb r8, 0(r14)
  rlwinm. r8, r15, 0, 24, 24
  beq- Aloc_0x84
  li r15, 0x100
  lis r8, 0x804C
  stw r15, 8388(r8)

Aloc_0x84:
  lbz r8, 0(r14)
  stb r8, -259(r16)
  b Aloc_0xC8

Aloc_0x90:
  mr r14, r15
  lbz r15, -258(r16)
  rlwinm. r8, r15, 0, 25, 25
  beq- Aloc_0xBC
  rlwinm r8, r15, 0, 26, 31
  stb r8, 0(r14)
  rlwinm. r8, r15, 0, 24, 24
  beq- Aloc_0xBC
  li r15, 0x100
  lis r8, 0x804C
  stw r15, 8388(r8)

Aloc_0xBC:
  lbz r8, 0(r14)
  stb r8, -258(r16)
  b Aloc_0xC8

Aloc_0xC8:
  li r8, 0x0

#############################


#branch r12,0x80f918c0		#branch to MnSlChr.usd again

# SDR Dynamic Menu Switcher

Zloc_0x0:
  lis r15, 0x80F9
  ori r15, r15, 0x8DC0
  lis r14, 0x803F
  ori r14, r14, 0xA1B0
  lwz r14, 0(r14)
  mulli r14, r14, 0x4
  mr r16, r3
  mr r17, r4
  mr r18, r5
  mr r19, r6
  mflr r21
  lwzx r4, r14, r15
  cmpwi r4, 0x0
  beq- Zloc_0x54
  lis r3, 0x80F9
  ori r3, r3, 0x8A50
  li r5, 0x2F0
  lis r12, 0x8000
  ori r12, r12, 0x31F4
  mtctr r12
  bctrl 

Zloc_0x54:
  mtlr r21
  mr r3, r16
  mr r4, r17
  mr r5, r18
  mr r6, r19
  li r7, 0x8


#############################

Bloc_0x0:
  lis r4, 0x804C
  ori r4, r4, 0x20BC
  mulli r5, r10, 0x44


##############################


#fourth branch; Debug Menu Increased Joystick Deadzone

Cloc_0x0:
  add r9, r4, r5
  lis r3, 0x3F4C
  ori r3, r3, 0xCCCD
  stw r3, 32(r2)
  lfs f15, 32(r2)
  lfs f16, 32(r9)
  fabs f16, f16
  fcmpo cr0, f16, f15
  bge- Cloc_0x48
  li r3, 0x0
  lbz r0, 1(r9)
  rlwimi r0, r3, 2, 29, 29
  rlwimi r0, r3, 3, 28, 28
  stb r0, 1(r9)
  lbz r0, 9(r9)
  rlwimi r0, r3, 2, 29, 29
  rlwimi r0, r3, 3, 28, 28
  stb r0, 9(r9)

Cloc_0x48:
  lfs f16, 36(r9)
  fabs f16, f16
  fcmpo cr0, f16, f15
  bge- Cloc_0x7C
  li r3, 0x0
  lbz r0, 1(r9)
  rlwimi r0, r3, 0, 31, 31
  rlwimi r0, r3, 1, 30, 30
  stb r0, 1(r9)
  lbz r0, 9(r9)
  rlwimi r0, r3, 0, 31, 31
  rlwimi r0, r3, 1, 30, 30
  stb r0, 9(r9)

Cloc_0x7C:
  
  
################################

Dloc_0x0:

  lis	r4, 0x804C
  ori	r4, r4, 0x20BC
  mulli	r5, r10, 68
  add	r9, r4, r5
  lwz r3, 8(r9)
  andi. r3, r3, 0x1F10
  or r8, r8, r3
  lwz r3, 0(r9)
  andi. r0, r3, 0x20
  beq- Dloc_0x2C
  li r7, 0x0

Dloc_0x2C:
  rlwinm r0, r3, 25, 3, 3
  rlwimi r0, r3, 27, 2, 2
  rlwimi r0, r3, 30, 0, 1
  or r8, r8, r0
  rlwinm r0, r3, 12, 0, 3
  or r8, r8, r0
  rlwinm. r0, r3, 8, 0, 3
  beq- Dloc_0x54
  li r7, 0x0
  or r8, r8, r0

Dloc_0x54:
  addi r10, r10, 0x1
  cmpwi r10, 0x4
  blt+ Dloc_0x0
  andis. r0, r8, 0xF000
  beq- Dloc_0x8C
  lbz r3, -18516(r13)
  cmpwi r3, 0x0
  beq- Dloc_0x84
  subi r3, r3, 0x1
  stb r3, -18516(r13)
  rlwinm r8, r8, 0, 4, 31
  b Dloc_0x94

Dloc_0x84:
  stb r7, -18516(r13)
  b Dloc_0x94

Dloc_0x8C:
  li r3, 0x0
  stb r3, -18516(r13)

Dloc_0x94:
  mr r3, r8
  
###############################

branch	r12,0x80fd0230			#branch to MnSlChr.usd again

branch r12,0x80303a4c				#exit if the above branch doesnt handle it

#End of injection, the code in MnSlChr.usd handles the blr











All Players Can Control the Debug Menu (Rewrite)
Executed on every frame of the Debug Menu.
Codes included:
  - Debug Menu Player Flag Switcher
  - Debug Menu Line Tracking
  - Debug Menu SDR Dynamic Menu Switcher
  - Debug Menu Increased Joystick Deadzone
Also branches to "CSS/Debug Menu Big Code Function" in MnSlChr @0x3E3B10.
[wParam, Achilles]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x803039A4 ---- 48C8E5AC -> Branch

3E00803F 6210BAD4 # Debug Menu Player Flag Switcher
82100000 3DE080F9
61EF1BCC 3E601234
62735678 1E900360
3A2FD3A0 7E31A214
86510004 7C129800
4182000C 964F0004
4BFFFFF0 39400000

3DC080BD 61CECD40 # Debug Menu Line Tracking
81EE0008 3E00803F # For auto menu traversal
6210A4E0 7C0F8000 # Note: this "default code line" was changed 
40820038 89F0FEFC # with wParam's debug menu control code.
55E80673 408200A4
55E806BE 990E0000
55E80631 41820010
39E00100 3D00804C
91E820C4 39E00040
99F0FEFC 4800007C
81EE0018 2C0F0000
40820038 89F0FEFD
55E80673 41820020
55E806BE 990E0000
55E80631 41820010
39E00100 3D00804C
91E820C4 890E0000
9910FEFD 4800003C
7DEE7B78 89F0FEFE
55E80673 41820020
55E806BE 990E0000
55E80631 41820010
39E00100 3D00804C
91E820C4 890E0000
9910FEFE 48000004
39000000

3DE080F9 # SDR Dynamic Menu Switcher
61EF8DC0 3DC0803F
61CEA1B0 81CE0000
1DCE0004 7C701B78
7C912378 7CB22B78
7CD33378 7EA802A6
7C8E782E 2C040000
41820020 3C6080F9
60638A50 38A002F0
3D808000 618C31F4
7D8903A6 4E800421
7EA803A6 7E038378
7E248B78 7E459378
7E669B78 38E00008

3C80804C 608420BC
1CAA0044 

7D242A14 # Debug Menu Increased Joystick Deadzone
3C603F4C 6063CCCD
90620020 C1E20020
C2090020 FE008210
FC107840 40800028
38600000 88090001
5060177A 50601F38
98090001 88090009
5060177A 50601F38
98090009 C2090024
FE008210 FC107840
40800028 38600000
88090001 506007FE
50600FBC 98090001
88090009 506007FE
50600FBC 98090009

3C80804C 608420BC
1CAA0044 7D242A14
80690008 70631F10
7D081B78 80690000
70600020 41820008
38E00000 5460C8C6
5060D884 5060F002
7D080378 54606006
7D080378 54604007
4182000C 38E00000
7D080378 394A0001
2C0A0004 4180FFA4
7500F000 41820028
886DB7AC 2C030000
41820014 3863FFFF
986DB7AC 5508013E
48000014 98EDB7AC
4800000C 38600000
986DB7AC 7D034378
3D8080FD 618C0230
7D8903A6 4E800420
3D808030 618C3A4C
7D8903A6 4E800420
60000000 00000000
