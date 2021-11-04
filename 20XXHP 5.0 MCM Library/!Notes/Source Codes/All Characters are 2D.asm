

	-==-


All Characters are 2D
Makes all characters the same thickness as G&W. Toggleable in the Debug Menu.
<https://smashboards.com/threads/all-characters-are-2d.452667/>
[DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x80068FE0 ---- 2C00001B -> Branch

# Check for the debug menu flag (non-zero indicates enabled)
lis r15, 0x8023
lwz r15, -0x770C(r15)
cmpwi r15, 0
beq+ OrigCodeLine 		# Not enabled; branch to orig code line

# Modified code line (set internal stage ID to 0x1B, for Flat Zone)
li r0, 0x1B
b End

OrigCodeLine:
lwz r0,136(r3)	  # Orig code line (load internal stage ID)

End:
b 0