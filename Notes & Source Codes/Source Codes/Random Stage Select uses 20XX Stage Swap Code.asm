Random Stage Select uses 20XX Stage Swap Code
[Achilles, DRGN]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code
1.02 ----- 0x8025b878 --- 88030000 -> Branch

# SceneThink_SSS injection
3983FFF5 7C832378
7D846378 3D808025
618CBB40 7D8903A6
4E800420 48000000

---------- 0x80235c30 --- BB010030 -> Branch

# Add 'Page _' text upon entering RSSS
# Injects into RandomStageSelect_LoadStageText
.include "CommonMCM.s"

# Allocate memory for a text object
lis	r3, <<PageTextProps>>@h
ori	r3, r3, <<PageTextProps>>@l
lfs 	f1, 0(r3)		# X coord
lfs 	f2, 4(r3)		# Y coord
lfs	f3, -0x3B30 (rtoc)	# Z coord (17.5)
lfs	f4, -0x3B2C (rtoc)	# aspect? (160)
lfs	f5, -0x3B28 (rtoc)	# aspect? (300)
li 	r3, 0			# SIS ID
lbz 	r4, -0x4AEB(r13)	# Text Canvas ID
bl	0x803A5ACC		# Text_AllocateTextObject
lis	r4, <<PageTextProps>>@h
ori	r4, r4, <<PageTextProps>>@l
stw	r3, 0x8(r4)		# store pointer for later use in removing this text

# Adjust text struct properties
li	r4, 1
stb	r4, 0x0048 (r3) # Use kerning
lfs	f1, -0x3B24 (rtoc)
stfs	f1, 0x0024 (r3) # Set X scaling to 0.05209999904036522 (0x3D5566CF)
stfs	f1, 0x0028 (r3) # Y scaling

# Load SIS text data
li 	r4, 37			# SIS index for 'Page x' text (r3 already loaded)
bl 	0x803A6368		# goto Text_CopyPremadeTextDataToStruct

ExitStageLeft:
lmw	r24, 0x0030 (sp)	# Orig code line
b 0

---------- 0x80236be0 --- 7F43D378 -> Branch

# Remove the 'Page _' text
lis	r3, <<PageTextProps>>@h
ori	r3, r3, <<PageTextProps>>@l
lwz	r3, 0x8(r3)
bl	0x803a5cc4	# Text_RemoveText

mr	r3, r26 # original code line
b 0

<PageTextProps> # xCoord, yCoord
40EE6666 C105EB85 # 7.45, -8.37
00000000          # Text struct pointer placeholder