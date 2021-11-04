# Inject at 0x25FE58

.include "CommonMCM.s"

backupall

# Load the Stage Swap Table binary file
lis r3, <<SwapTableFileString>>@h
ori r3, r3, <<SwapTableFileString>>@l
li r4, 0 # Setting this to store the file into OSHeap1/HSD[0] (the Object Heap)
bl <DVD.read>

# r4 now has the SST file's address. store it after the file string
lis r3, <<SwapTableFileString>>@h
ori r3, r3, <<SwapTableFileString>>@l
stw r4, 0x14(r3)

restoreall

stb r3, -0x49AA(r13) # Original code line
b 0