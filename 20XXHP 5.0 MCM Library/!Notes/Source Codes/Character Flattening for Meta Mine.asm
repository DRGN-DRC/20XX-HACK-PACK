

	-==-


Character Flattening for Meta Mine
Flattens characters when Meta Mine is loaded.

Uses 20XX stage flags set on the fourth SSS.
[DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x80068FE4 ---- 2C00001B -> Branch

# Check if the current stage being loaded is 
# DK's target test stage
# r0 is already the internal stage ID
cmpwi	r0, 0x2B
bne OrigCodeLine

# Check if the 20XX Stage Flags are 0x10
# Stage Flags are at byte 0x803FA2E5
lis r3, 0x803F
ori r3, r3, 0xA2E5
lbz r3, 0(r3)
cmpwi r3, 0x10
bne OrigCodeLine

# Current stage is DK's target test, and the stage 
# flags are set for flattening. Set the beq/bne CR bit
cmpw r3, r3
b End

OrigCodeLine:
cmpwi	r0, 0x1B	  # Orig code line (checks for Flat Zone)

End:
.long 0

