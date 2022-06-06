

Reload SSS with D-Pad Up/Down (v1.1)
Checks for D-pad Up/Down inputs, and reloads the current scene with a different SSS file.
[Punkline, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 ---- 0x2586DC ----- 540005AD -> Branch

# 803f0a20	address of 'u' character in ascii string for "MnSlMap.usd"
# 803EC5C7	address of 'u' character in ascii string for "SdMenu.usd"
# 803f11ac	address of 'u' character in ascii string for "SdSlChr.usd"
# 803FA2E4	SSS page id
# 80335B74	update scene code (dynamic; will change)
# 803FA1B0	base address for all pages' RSS flags
# 8045C388	SSS flags currently used by the game

# Load the byte describing which SSS is active (current MnSlMap loaded)
lis r11, 0x803F
ori r11, r11, 0x0A20 # r11 = address of 'u' character in ascii string for "MnSlMap.usd"
lbz r3, 0(r11)
cmpwi r3, 0x34
beq CHECK_DPAD_UP # Skip checking for D-pad down if on the 4th SSS

# Check for D-Pad Down  (r0 contains the current player's button input)
andi. r12, r0, 4
beq CHECK_DPAD_UP # D-Pad Down not pressed
addi r4, r3, 1 # increment the SSS byte
b CHANGE_SSS

CHECK_DPAD_UP:
cmpwi r3, 0x31
beq END # Skip checking for D-pad up if on the 1st SSS; done checking input
# Check for D-Pad Up
andi. r12, r0, 8
beq END
subi r4, r3, 1 # decrement the SSS byte

CHANGE_SSS:
# Update the index byte in "MnSlMap._sd", for the new SSS file name
stb r4, 0(r11)
# Update the SSS page ID byte
lis r11, 0x803F
ori r11, r11, 0xA2E4
stb r4, 0(r11)
# Update the SdMenu._sd file string
lis r12, 0x803e
ori r12, r12, 0xc5c7	# load address of the 'u' in the extension
stb r4, 0(r12)
# Update the SdSlChr._sd file string (no longer needed? might be able to depricate)
lis r12, 0x803f
ori r12, r12, 0x11ac	# load address of the 'u' in the extension
stb r4, 0(r12)

# Store RSS flags for the previous page (to all pages' allocation)
subi r11, r11, 0x134	# load base address to all pages' RSS flags (803FA1B0)
lis r12, 0x8045
ori r12, r12, 0xC388	# load address of currenly used RSS flags
lwz r5, 0(r12)			# load current RSS flags
subi r3, r3, 0x30		# convert old SSS page number to 1-index
mulli r3, r3, 0x4		# convert page # to a multiple of 4 byte offset
stwx r5, r11, r3		# store (at r11+r3)

# Load RSS flags for the current/new page (from all pages' allocation)
subi r4, r4, 0x30		# convert new SSS page number to 1-index
mulli r4, r4, 0x4		# convert page # to a multiple of 4 byte offset
lwzx r11, r11, r4		# load new flags from all pages' allocation
stw r11, 0(r12)			# store to 'current' flags location

# Run the Every Frame Code once to update stage file names
#lis r12, 0x80FD
#ori r12, r12, 0x0230
#mtlr r12
#blrl
bl 0x80FD0230

# Reload the scene
li r12,2
lis r11, 0x80479D35+0x10000@h
stb r12, -0x49F1(r13)
stb r12, 0x80479D35-0x10000@l(r11)
# trigger ID (2) is stored in r13 global
# target scene ID + 1 (2) is stored in

END:
andi. r0,r0,512
b 0 # Return branch

------------- 0x803FA2E4 ---- 3F -> 31 # SSS page ID byte



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
