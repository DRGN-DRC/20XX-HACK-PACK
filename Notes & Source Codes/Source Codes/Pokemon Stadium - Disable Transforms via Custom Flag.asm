
Pokemon Stadium - Disable Transforms via Custom Flag, v2
Primarily checks two flags to determine whether to transform:
 - Stage Swap Engine flags for a frozen or a fixed-transformation stage
 - Flag set by the Debug Menu's "Freeze Pokemon Stadium" option
[Achilles, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x801D45F0 --- 3803FFFF -> Branch

# Check the Custom Stage Flag value (part of the Stage Swap Engine code)
lis r14, 0x8040
lbz r14, -0x5D1B(r14) # Load byte at 0x803fa2e5
rlwinm. r0, r14, 0, 24, 28 # Check if no custom stage flags from SSE (mask of 000000F8)
bne- ProcessFlags

# No SSE flags. Check for the debug menu flag (non-zero indicates frozen)
# This essentially means the debug menu flag is ONLY referred to if the 
# standard randomized custom stages (GrP0.usd, GrP1, etc.) on page 1 is selected.
lis r14, 0x8040
lwz r14, -0x45E0(r14) # Flag (word) at 0x803FBA20
cmpwi r14, 0
bne+ Freeze

ProcessFlags:
rlwinm. r0, r14, 0, 24, 24 # does flag include 0x80? (i.e. frozen stadium from 2nd page)
beq- Exit
rlwinm. r0, r14, 0, 25, 28 # does flag include a fixed trans stage?
beq- Freeze # Branch if no fixed transformation stage (i.e. 08, 10, 20, 40)

# Check if it's the start of the match
lis r14, 0x8047
lwz r14, -18748(r14) # Load match frame count (word at 0x8046B6C4)
cmpwi r14, 0x0 # Frame 0?
beq- Exit

Freeze:
li r3, 0xFF

Exit:
subi r0, r3, 0x1
b 0