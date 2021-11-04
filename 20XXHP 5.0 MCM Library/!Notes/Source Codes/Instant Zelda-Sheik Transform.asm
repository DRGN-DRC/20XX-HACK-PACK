

	-==-


Instant Zelda/Shiek Transform
Conditionally enables or disables the code during Zelda's OnLoad function, based on a debug menu flag @802289C4
[UnclePunch, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
#NTSC 1.02 --- 0x80114184 ---- C0429CC8 -> C042A1DC
#------------- 0x80114790 ---- C0429CC8 -> C042A1DC
#------------- 0x80114248 ---- C0429CC8 -> C042A1DC
#------------- 0x8013B510 ---- C042A218 -> C042A1DC
#------------- 0x8013AF04 ---- C042A218 -> C042A1DC
#------------- 0x8013AFC8 ---- C042A218 -> C042A1DC

NTSC 1.02 --- 0x80139334 ---- 7C0802A6 -> Branch

# Load reference address for 8011 line replacements
lis r15 0x8011

# Check if the code should be enabled by checking the debug menu flag
lis	r14, 0x8023		# 0x802289C4
lwz	r14, -0x763C(r14)
cmpwi	r14, 0
beq+ 	OrigLines

# Perform the changes to enable the code
lis r14, 0xC042A1DC@h # Load the replacement instruction
ori r14, r14, 0xC042A1DC@l

# Replace code lines with the instruction above
stw r14, 0x4184(r15)
stw r14, 0x4790(r15)
stw r14, 0x4248(r15)
lis r15 0x8014	# Load reference address for 8013 line replacements
stw r14, -0x4AF0(r15)
stw r14, -0x50FC(r15)
stw r14, -0x5038(r15)
b END

OrigLines: # Set vanilla code
lis r14, 0xC0429CC8@h # Load the vanilla instruction
ori r14, r14, 0xC0429CC8@l

# Replace code lines with the instruction above
stw r14, 0x4184(r15)
stw r14, 0x4790(r15)
stw r14, 0x4248(r15)
lis r15 0x8014	# Load reference address for 8013 line replacements
lis r14, 0xC042A218@h # Load the second vanilla instruction
ori r14, r14, 0xC042A218@l
stw r14, -0x4AF0(r15)
stw r14, -0x50FC(r15)
stw r14, -0x5038(r15)

END:
mflr r0		# orig code line
b 0