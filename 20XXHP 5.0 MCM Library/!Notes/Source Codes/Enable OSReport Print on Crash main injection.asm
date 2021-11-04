
# Injecting into main at 0x80160074

# Move detailed versioning info to the title string
# before copying the title to the printout buffer.
lis r15, 0x803FA159@h	# Load address of 20XX versioning in DOL
ori r15, r15, 0x803FA159@l
lbz r4, 0(r15)		# Load major
lbz r5, 1(r15)		# Load minor
lbz r6, 2(r15)		# Load patch

# Store title to printout buffer
bl 0x803456A8	# Branchl to OSReport

# Clear args
li r5, 0
li r6, 0

# Load debug level to printout buffer
lwz	r4, -0x6C98 (r13)
addi	r3, r31, 224
crclr	6
bl 0x803456A8	# Branchl to OSReport

# Write 'Environment' header (no line break)
addi	r3, r31, 240
crclr	6
bl 0x803456A8	# Branchl to OSReport

# Check emulation/hardware environment
lis r3, 0x803D		# Load first part of address to new console type strings
lis r15, 0x8000		# base address 80401618
lwz r15, 0x2C(r15)
rlwinm r15,r15,0,3,3	# Apply mask of 0x10000000; anything with that bit should be emulation
cmplwi r15, 0
beq OnHardware

# On Emulator
ori r3, r3, 0x4BCC
crclr	6
b CallOsReport

OnHardware:
ori r3, r3, 0x4BD6
crclr	6

CallOsReport:
bl 0x803456A8	# Branchl to OSReport

# Return to normal execution
b 0x801600f8