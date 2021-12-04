

Reload SSS with D-Pad Up/Down
Checks for D-pad Up/Down inputs, and reloads the current scene with a different SSS file.
[Punkline, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 ---- 0x2586DC ----- 540005AD -> Branch

# 803f0a20	address of 'u' character in ascii string for "MnSlMap.usd"
# 803FA2E4 	sss page id (needs to be updated)
# 80335B74	update scene code (dynamic; will change)

# Load the byte describing which SSS is active
lis r11, 0x803F
ori r11, r11, 0x0A20 # r11 = address of 'u' character in ascii string for "MnSlMap.usd"
lbz r3, 0(r11)
cmpwi r3, 0x34
beq CHECK_DPAD_UP # Skip checking for D-pad down if on the 4th SSS

# Check for D-Pad Down  (r0 contains the current player's button input)
andi. r12, r0, 4
beq CHECK_DPAD_UP # D-Pad Down not pressed
addi r3, r3, 1 # increment the SSS byte
b CHANGE_SSS

CHECK_DPAD_UP:
cmpwi r3, 0x31
beq END # Skip checking for D-pad up if on the 1st SSS; done checking input
# Check for D-Pad Up
andi. r12, r0, 8
beq END
subi r3, r3, 1 # decrement the SSS byte

CHANGE_SSS:
# Update the index byte in "MnSlMap._sd", for the new SSS file name
stb r3, 0(r11)
# Update the SSS page ID byte
lis r11, 0x803F
ori r11, r11, 0xA2E4
stb r3, 0(r11)

# Reload the scene
li r12,2
lis r11, 0x80479D35+0x10000@h
stb r12, -0x49F1(r13)
stb r12, 0x80479D35-0x10000@l(r11)
# trigger ID (2) is stored in r13 global
# target scene ID + 1 (2) is stored in

END:
andi. r0,r0,512
.long 0 # Return branch


# v Unused / Scratchpad


# # Load the byte describing which SSS is active
# lis r11, 0x803F
# ori r11, r11, 0x0A20 # r11 = address of 'u' character in ascii string for "MnSlMap.usd"
# lbz r3, 0(r11)
# cmpwi r3, 0x34
# beq CHECK_DPAD_UP # Skip checking for D-pad down if on the 4th SSS

# # Check for D-Pad Down  (r0 contains the current player's button input)
# andi. r12, r0, 4
# beq CHECK_DPAD_UP # D-Pad Down not pressed
# addi r3, r3, 1 # increment the SSS byte
# b CHANGE_SSS

# CHECK_DPAD_UP:
# cmpwi r3, 0x31
# beq END # Skip checking for D-pad up if on the 1st SSS; done checking input
# # Check for D-Pad Up
# andi. r12, r0, 8
# beq END
# subi r3, r3, 1 # decrement the SSS byte

# CHANGE_SSS:
# # Update the index byte in "MnSlMap._sd", for the new SSS file name
# stb r3, 0(r11)

# # Reload the scene
# li r12,2
# lis r11, 0x80479D35+0x10000@h
# stb r12, -0x49F1(r13)
# stb r12, 0x80479D35-0x10000@l(r11)
# # trigger ID (2) is stored in r13 global
# # target scene ID + 1 (2) is stored in

# # Update the SSS page ID byte
# lis r11, 0x803F
# ori r11, r11, 0xA2E4
# stb r3, 0(r11)

# END:
# andi. r0,r0,512
# .long 0 # Return branch



# v Unfinished code for saving the cursor position:



# # Load the byte describing which SSS is active
#   lis r11, 0x803F
#   #ori r11, r10, 0xA2E4  # r11 = 20XX data
#   ori r11, r11, 0x0A20 # r11 = address of 'u' character in ascii string for "MnSlMap.usd"
#   lbz r3, 0 (r11)
#   cmpwi r3, 0x34
#   beq CHECK_DPAD_UP # Skip checking for D-pad down if on the 4th SSS

#   # Check for D-Pad Down  (r0 contains the current player's button input)
#   andi. r12, r0, 4
#   beq CHECK_DPAD_UP # D-Pad Up not pressed
#   addi r3, r3, 1 # increment the SSS byte
#   b CHANGE_SSS

# CHECK_DPAD_UP:
#   cmpwi r3, 0x31
#   beq END # Skip checking for D-pad up if on the 1st SSS; done checking input
#   # Check for D-Pad Up
#   andi. r12, r0, 8
#   beq END
#   subi r3, r3, 1 # decrement the SSS byte

# CHANGE_SSS:
#   # Change the index byte in "MnSlMap._sd", for the new SSS file name
#   #stb r3, 3(r11)
#   stb r3, 0(r11)

#   # Save the current cursor position
#   lis r11, 0x8000
#   lwz r12, 0x3304(r11) # load cursor x position to 80003304
#   lwz r3, 0x3308(r11) # load cursor y position to 80003308

#   # Restore the current cursor position
#   lis r16,0x8000
#   lwz r21,0x38(r31) # load cursor x position
#   stw r21,0x3304(r16) # store cursor x position to 80003304
#   lwz r21,0x3c(r31) # load cursor y position
#   stw r21,0x3308(r16) # store cursor y position to 80003308

#   lis r21,0x8047
#   ori r21,r21,0x9d64
#   stw r22,0(r21)

# # ------------------ ^ skipped code goes here


#   _reload_scene:
#   li r12, 2
#   lis r11, 0x80479D35+0x10000@h
#   stb r12, -0x49F1(r13)
#   stb r12, 0x80479D35-0x10000@l(r11)
#   # trigger ID (2) is stored in r13 global
#   # target scene ID + 1 (2) is stored in

# END:
# andi. r0, r0, 0x200 # Original instruction equivalent
# .long 0


# <SSS_XY_transition_memory>
# 00000000 00000000






# # -- skipped for now ---

#   # old code:

#   # Load the current cursor position
#   lis r11, 0x8000
#   lwz r12, 0x3304(r11) # load cursor x position to 80003304
#   lwz r3, 0x3308(r11) # load cursor y position to 80003308
#   cmpwi r12,0
#   bne-  KEEP_STORING
#   cmpwi r3,0
#   beq-  START

# KEEP_STORING:
#   stw r12,0x1c(sp)  # load cursor x position
#   stw r3,0x20(sp)  # load cursor y position
#   li  r12,0
#   stw r12,0x3304(r11)
#   stw r12,0x3308(r11)
  


# # rewrite uses standalone func for storage, and saves a couple of lines:
#   lis r8, <<SSS_XY_transition_memory>>@h
#   ori r9, r8, <<SSS_XY_transition_memory>>@l
#   # r9 = SSS XY transition memory
  
#   psq_l f12, 0(r9), 0, 0  # f12 = cursor XY pair 
#   ps_sub f11, f12, f12    # f11 = 0, 0 pair
#   ps_cmpo0 cr0, f12, f11
#   bne- _store_XY        # if X != 0
#   ps_cmpo1 cr0, f12, f11
#   beq- _reload_scene      # or Y != 0

#     _store_XY:
#     psq_st f12, 0x1C(sp), 0, 0 # store XY in stack
#     psq_st f11, 0x00(r9), 0, 0 # nullify XY in memory   
