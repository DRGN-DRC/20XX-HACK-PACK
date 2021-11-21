
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
lis r15, 0x8000
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
bl 0x803456A8	# Branchl to OSReport to print above string

# Print Date/Time (args order different from vanilla)
bl	0x8000AFBC		# Some kind of get-time pre-function
addi	r4, sp, 8
bl	0x801692E8	# GetTimeAndDateOnStack
lbz	r4, 0x000A (sp)		# Get month
addi	r3, r31, 284
lbz	r5, 0x000B (sp)		# Get day
crclr	6
lhz	r6, 0x0008 (sp)		# Get year
bl	0x803456A8			# Branchl to OSReport to print Date
lbz	r4, 0x000C (sp)
addi	r3, r31, 324
lbz	r5, 0x000D (sp)
crclr	6
lbz	r6, 0x000E (sp)
bl	0x803456A8			# Branchl to OSReport to print Time

# Print a single line for spacing
subi	r3, r13, 0x77B8
crclr	6
bl	0x803456A8			# Branchl to OSReport

# Print 'Press LRAStart for restart'
lis r3, <<OSR_ResetInstructionsString>>@h
ori r3, r3, <<OSR_ResetInstructionsString>>@l
crclr	6
bl	0x803456A8			# Branchl to OSReport

# Return to normal execution
b 0x80160154

# Putting this injection in the vanilla code space; 
# nop remaining vanilla instructions for clarity.
# number of nops = (154 - 74 - len of this function) / 4
nop
nop
nop
nop
nop
nop
