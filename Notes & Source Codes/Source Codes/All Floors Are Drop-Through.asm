
All Floors Are Drop-Through
All floors can be dropped through (and ceilings can be passed through) like standard platforms. Modified from the original code to operate off of Debug Menu on/off selection. Stored as a static overwrite so it can be referenced from a debug menu's line item function.
<https://smashboards.com/threads/all-floors-are-drop-through.513411/>
[DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -

## The original verion of this code:
## NTSC 1.02 --- 0x8004CBD4 ---- 546305EE -> 38600100 # rlwinm r3,r3,0,23,23(00000100) -> li r3, 0x100
## ------------- 0x8004FD24 ---- AB240006 -> 3B200000 # lha r25, 0x0006 (r4) -> li r25, 0

## The original code modifies DataOffset_CheckIfOnDropThroughPlatform and ECB_StoreCeilingID+Type.
## This variation instead makes this change while in the debug menu, using the line menu item's 'target function'.
## Conveniently, the current value is updated before a menu item's target function is executed.

NTSC 1.02 --- 0x80393BAC ----

387A0090 93810020
C862EF60 4CC63242
93810028 C8210020
C8010028 EC211028
93810018 EC001028
C082EF50 C8410018
EC210024 C002EF54
EC421828 EC4400B2
EC420824 EC420032
4BFB1AB5 7FE3FB78
BB210034 8001005C
CBE10050 38210058
7C0803A6 4E800020

 -> 

# This is being stored at the end of Area 5 of USB/MCC region. It's stored as a static overwrite 
# rather than an injected someplace so it can be referenced from a debug menu's line item function.

.macro SetWord address, value
  lis r15, \address@h		# Load the address to modify
  ori r15, r15, \address@l
  lis r16, \value@h		# Load the value change
  ori r16, r16, \value@l
  stw r16, 0(r15)		# Store value to address
.endm

# New code, to execute on menu item Left/Right check
lwz	r15, 0x10(r4)	# Load flag address (the menu item's current value)
lwz	r16, 0(r15)	# Load flag value
cmpwi	r16, 0
beq	TURN_OFF

# Turn On
SetWord 0x8004CBD4, 0x38600100
SetWord 0x8004FD24, 0x3B200000
b END

TURN_OFF:
SetWord 0x8004CBD4, 0x546305EE
SetWord 0x8004FD24, 0xAB240006

END:
blr

------------- 0x802288E8 ---- 54630529 -> 00000000 # Debug Menu flag