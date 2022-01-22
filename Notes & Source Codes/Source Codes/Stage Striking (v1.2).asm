

Stage Striking (v1.2)
- invisible stages
- includes prevention of striked stages from being randomly selected
- could use clean-up, and perhaps re-enable cursor position saving
[Sham Rock, Achilles, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x80003304 ----

00000000 00000000

 -> 

# Cursor position storage area
00000000 00000000

------------- 0x8025A3BC ---- C022C9E8 -> Branch


# Injection point:
#	@8025a3bc
#	lfs	f1, -0x3618 (rtoc)	c022c9e8
#	(1 of 2 scenarios where it breaks after reading the current cursors(804d6cac) content)
#	this line gets executed once per frame on the SSS when the loading cycle hasn´t been initiated yet

# For each player, this injection checks for X/Y/Z
# button presses, and clears/resets stage icons.

# Sham Rock & Achilles' original source code for this can be found in Achilles' Scratchpad.
# The major change in this version is that the D-Pad checks were removed from here and put 
# into the new SSS transitions code, and the cursor position save feature was disabled.

  li r15,1    #counter which players turn ( 1-4 )


# 		v removed
#   load cursor position if first frame after change
#   lis r16,0x8000
#   lwz r21,0x3304(r16) # load cursor x position to 80003304
#   lwz r22,0x3308(r16) # load cursor y position to 80003308
#   cmpwi r21,0
#   bne-  KEEP_STORING
#   cmpwi r22,0
#   beq-  START

# KEEP_STORING:
#   stw r21,0x1c(sp)  # load cursor x position
#   stw r22,0x20(sp)  # load cursor y position
#   li  r21,0
#   stw r21,0x3304(r16)
#   stw r21,0x3308(r16)
# 		^ removed


START:
  lis r16, 0x8046     # aim at current player input (-0xC since r15 is not 0-indexed)
  ori r16,r16, 0xb0fc
  mulli r17,r15,0xc 
  lwzx r17,r17,r16    # load input of current player


# 		v removed
# D-Pad Checks

#   lis r21,0x803f
#   ori r21,r21,0xa2e4
#   lbz r22,0(r21)
#   cmpwi r22,0x34
#   beq- DPAD_UP
#   # D-Pad Down
#   rlwinm. r16,r17,0,13,13
#   beq- DPAD_UP_CHECK
#   addi r22,r22,1
#   b LOAD_CSS

# DPAD_UP_CHECK:
#   cmpwi r22,0x31
#   beq- REG_STAGE_STRIKE
# DPAD_UP:
#   rlwinm. r16,r17,0,12,12
#   beq- REG_STAGE_STRIKE
#   subi r22,r22,1

# LOAD_CSS:
#   # store current cursor position
#   stb r22,0x3(r21)

#   lis r16,0x8000
#   lwz r21,0x38(r31) # load cursor x position
#   stw r21,0x3304(r16) # store cursor x position to 80003304
#   lwz r21,0x3c(r31) # load cursor x position
#   stw r21,0x3308(r16) # store cursor x position to 80003308

#   lis r21,0x8047
#   ori r21,r21,0x9d64
#   stw r22,0(r21)

#   # experimental, play item SFX (same one from SDR)
#   li r3,0xdb  # SFX ID
#   stw r3,-0x4B0C(r13) # load SFX ID to play @ 804D6B94 (custom 20XX flag)
#   lis r3,0x8017
#   ori r3,r3,0x4338
#   mtlr  r3
#   blrl
#   b END_END

# REG_STAGE_STRIKE:
# 		^ this portion removed


  #check: "x" pressed?
  rlwinm. r16,r17,0,5,5   #is X pressed?
  beq- Y_PRESS_CHECK      #no--> go to "check: "y" pressed?" 
  li r17,1      #mode(r17)=lock single
  b SETTINGS        #go to "setting"

  #check: "y" pressed?
Y_PRESS_CHECK:
  rlwinm. r16,r17,0,4,4   #is y pressed?
  beq- Z_PRESS_CHECK      #no--> go to "check: "z" pressed?" 
  li r17,2      #mode(r17)=lock not allowed in random
  b SETTINGS        #go to "setting"

  #check: "z" pressed?
Z_PRESS_CHECK:
  rlwinm. r16,r17,0,11,11   #is z pressed?
  beq- CHECK_NEXT_PLAYER      #no--> go to "next player and again" 
  li r17,3      #mode(r17)=unlock all
          #go to "settings" (happens on it´s own)

SETTINGS: 
  lis r21,0x803f    #@first visual lock start point
  ori r21,r21,0x06d0
      
  lis r22,0x804d    #@cursor
  ori r22,r22,0x6cae

  li r20,0
  li r19,0    #to write in memory later

  li r18,0    #internal counter (00-1c)

  #locking
  #single mode
  cmpwi r17,1   #is it in single lock mode?
  bne- UNLOCK_ALL_CHECK
        #read cursor  (overwrite the internal counter)
  lbz r18,0(r22)
  cmpwi r18,0x1c    #smaller than 1d = cursor is on stage
  bgt-  CHECK_NEXT_PLAYER   #-->"next player and again"
  b ACTUAL_LOCKING    #go to "actual locking"

  #multi mode(unlock all)
UNLOCK_ALL_CHECK:
  cmpwi r17,3   #is it in unlock all mode?
  bne- LOCK_RANDOM_SELECTION    #no-->"lock via random selection"
  li r20, 0x3f
  li r19, 0x02
  b ACTUAL_LOCKING      #go to "actual locking"

  #lock via random selection
LOCK_RANDOM_SELECTION:    
  mulli r16,r18,0x1c  #load how many bits does the "random setting" need to be shifted right
  add r16,r16,r21
  lbz r23,0xA(r16)  #how many to shift right??

  lis r16,0x8045    #where random settings are saved
  ori r16,r16, 0xc388
  lwz r16,0(r16)
  srw r16,r16,r23   #shift right

        #check, is stage legal or not? set r19 & r20 accordingly
  rlwinm. r16,r16,0,31,31 #stage allowed or not?
  beq- ZERO     
  li r19, 2     
  li r20, 0x3f      #yes--> set r19 & r20 to unlock
  b ACTUAL_LOCKING
  ZERO:       #go to "actual locking"
  li r19, 0     
  li r20, 0     #no--> set r19 & r20 to lock

#actual locking
ACTUAL_LOCKING:
  mulli r16,r18,0x1c
  
  lwzx r16,r16,r21  #load starting point of stage

###
  li  r23,0
  cmpwi r19,2
  bne-  INVISIBLE_END
  lis r23,0x0008
  ori r23,r23,0x0008
  cmpwi r18,0x16
  blt-  INVISIBLE_END
  lis r23,0x2000
  ori r23,r23,0x0008
INVISIBLE_END:
  stw r23,0x14(r16) 

####

  mulli r16,r18,0x1c  #load starting point of stage
  addi r16,r16,0x08 #+0x8 offset for locking point
  stbx r19,r16,r21

  li r16,0x1e   #clear out cursor
  stb r16,0(r22)

  cmpwi r17,1   #jumps out when in "single lock" mode
  beq- CHECK_NEXT_PLAYER    #-->addi r15,r15,1

  addi r18,r18,1    #repeat until all stages have been set
  cmpwi r18, 0x1d
  blt- UNLOCK_ALL_CHECK   #-->"locking"/cmpwi r17,3

CHECK_NEXT_PLAYER:
  addi r15,r15,1    #repeat 3 times for player 2-4
  cmpwi r15, 5
  blt- START    #-->lis r16, 0x8046

  END_END:
  lfs f1, -0x3618 (rtoc)  #was there before
  b 0


------------- 0x80259B68 ---- 7C1F002E -> Branch

# Prevents striked stages from 
# being randomly selected (part 1/2)

lwzx	r30,r31,r4

cmpwi r30,0	# this will be 0 if "RANDOM" stage select is ON
beq- END
lis r5,0x8040
ori r5,r5,0x6708	# make sure the struct is initialized
lwz r6,0(r30)
cmpw r6,r5
bne- END
lhz	r30,0x14(r30)
cmpwi r30,0
bne-	END
lis r30,0x8025
ori r30,r30,0x9b8c
mtlr r30
blr
END:
lwzx	r0,r31,r0	# default code line


------------- 0x80259A1C ---- 801C0004 -> Branch

# Prevents striked stages from 
# being randomly selected (part 2/2)

# - actually more like part 1 though...
# - ensures the "already chosen" flag at SSS_stage struct +0x4 gets reset back to 0 if necessary
# - fixes bug in 4.06 with striking down to a single stage, then randomly selecting it twice 
#   in a row and the second time going to Peach's Castle 

lwz r3,0(r28)	# load JObj pointer
cmpwi r3,0	# this will be 0 if "RANDOM" stage select is ON
beq- END
lis r5,0x8040
ori r5,r5,0x6708	# make sure the struct is initialized
lwz r4,0(r3)
cmpw r4,r5
bne- END
lhz	r4,0x14(r3)
cmpwi r4,0
bne-	END
lis r3,0x8025
ori r3,r3,0x9a38
mtlr r3
blr
END:
lwz r0,4(r28)	# default code line