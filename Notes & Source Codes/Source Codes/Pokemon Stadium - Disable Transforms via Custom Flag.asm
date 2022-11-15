
Pokemon Stadium - Disable Transforms via Custom Flag, v2
Essentially checks two flags to determine whether to transform:
 - Flag set by the Debug Menu's "Freeze Pokemon Stadium" option
 - Custom Stage Flag (80) or a fixed-transformation stage
[Achilles, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x801D45F0 --- 3803FFFF -> Branch

# Check for the debug menu flag (non-zero indicates enabled)
lis r14, 0x8040
lwz r14, -0x45E0(r14) # Flag (word) at 0x803FBA20
cmpwi r14, 0
bne+ Freeze

# Check the Custom Stage Flag value (part of the Stage Swap Engine code)
lis r14, 0x8040
lbz r14, -0x5D1B(r14) # Load byte at 0x803fa2e5
rlwinm. r0, r14, 0, 24, 24
beq- Exit
rlwinm. r0, r14, 0, 25, 28
beq- Freeze

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