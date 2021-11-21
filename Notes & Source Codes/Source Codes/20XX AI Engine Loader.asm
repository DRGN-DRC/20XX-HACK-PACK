

	-==-


20XX AI Engine Loader
Loads the AI Engine code into the Object Heap (OSHeap 1 / HSD Heap 0) on scene-change. As of 20XX v5, the AI Engine code is stored in the disc filesystem, due to its size, and only loaded during matches.
[DRGN, Punkline]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x8016E91C --- 80010024 -> Branch


.include "CommonMCM.s"
.include "melee"; melee
backupall

# Load the AI Engine binary file
lis r3, <<AiEngineFileString>>@h
ori r3, r3, <<AiEngineFileString>>@l
li r4, 0 # Setting this to store the file into OSHeap1/HSD[0] (the Object Heap)
bl <DVD.read>

# Calculate injection branch for the AI Engine function
# AI Engine injects into PlayerThink_Interrupt
# r4 should currently have the loaded file's address
mr r8, r4	# Save for later
.set injectionSite, 0x8006b008
lis r3, injectionSite@h
ori r3, r3, injectionSite@l
sub r5, r4, r3 # Branch distance is now in r5
oris r5, r5, 0x4800 # Turn this into a branch instruction
stw r5, 0(r3)

# Calculate and place the return branch for the AI Engine
# r6 should currently have the loaded file's size
add r4, r4, r6 # r4 address is now directly after the end of the AI f(x)
sub r5, r3, r4 # New branch distance is now in r5 (needs adjustment)
addi r5, r5, 8 # Adjust distance to 4 bytes past the injection point

# Turn this into a branch back instruction
li r0, 18  # opcode for high end
rlwimi r5, r0, 0xFC000000
stw r5, -4(r4)

# Flush instruction cache for the new branch
lis r3, injectionSite@h
ori r3, r3, injectionSite@l
li r4, 4	# Size of the flush
bl <data.flush_IC>

# Flush instruction cache for the new file
mr r3, r8	# New file address
mr r4, r6	# New file size
bl <data.flush_IC>

# Restore registers
restoreall

# Original instruction and return branch
lwz r0,36(r1)
b 0

<AiEngineFileString>
# "AI_Engine.bin" string (need a known address for this)
41495F45 6E67696E
652E6269 6E00


<AiEngineFileString> # Need a known address for this string
.string "AI_Engine.bin"


# Test break points:
# 8016E730- StartMelee
# 8006b008- AI Engine injection site