Shinesplosion
Toggles on/off Falcon's 'shine' (down-B) move from Achilles' alternate SDR Falcon. Controlled by Debug Menu option; flag at 802289CC.
[Achilles, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x800180f4 ---- 807e0014 -> Branch

# Update PlCa.dat action table entries for Falcon's down-B.
# Injecting into Preload_AllocateAndLoadFile just before file initialization

# Check Debug Menu flag for activation
lis r15, 0x8023
lwz r15, -0x7634(r15)	# flag at 802289CC
cmpwi r15, 0
beq+ END

# Confirm this is PlCa.dat
lis r15, 0x803c7598@h		# Pointer to the 'PlCa.dat' file string
ori r15, r15, 0x803c7598@l
cmpw r25, r15
bne+ END

# File is PlCa. Enable Shinesplosion; copy custom data to PlCa
lwz r4, 16(r30)			# Load cache link node pointer
lwz r4, 4(r4)			# Should now be the address of PlCa
addi r3, r4, 0x7000
addi r3, r3, 0x27E0		# r3 is now the location of data to update (data destination)
lis r4, <<PlCaData>>@h		# Data source
ori r4, r4, <<PlCaData>>@l
li r5, 0x30				# Length of data to update
bl 0x800031f4 # memcpy | r3=destination, r4=source, r5=length

END:
lwz	r3, 0x0014 (r30) 	# Orig instruction
b 0

<PlCaData>
00000D48 000AFB00 00001E84 000277A0		# Custom data to
00000002 00000000 00000000 00000000		# replace actions 311 & 312
00000000 00000000 00000000 00000000

1.02 ----- 0x800e3eac --- 7C0802A6 -> Branch

# Disable Falcon Kick Textures if code is active
# - r3 = external data offset start

# Check Debug Menu flag for activation
lis r15, 0x8023
lwz r15, -0x7634(r15)	# flag at 802289CC
cmpwi r15, 0
beq+ 	END

lwz	r5,0x2c(r3)		# load internal data offset
lwz	r4,0x4(r5)		# load internal char id
cmpwi	r4,2		# is this C. Falcon? (Ganon shares code)
bne-	END
lwz	r4,0x10(r5)		# load Action state ID
cmpwi r4,0x165		# grounded down-b state only
bne-	END

# Skip CFalcon/Ganon_DownB_TextureDisplay function
blr

END:
mflr	r0
b 0

------------- 0x802289CC ---- 7C0501D6 -> 00000000 # Debug Menu Flag