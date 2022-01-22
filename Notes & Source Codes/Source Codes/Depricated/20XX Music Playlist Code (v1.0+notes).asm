

20XX Music Playlist Code
Checks whether playlists are set up for certain stages or menus, and plays songs from them if present.
Runs on each major scene transition.
[Achilles]
Version -- DOL Offset ------ Hex to Replace ---------- ASM Code

1.02 ----- 0x800032F0 ------- # DOL Offset 0x2F0

00000000 00000000
00000000 00000000
00000000

 -> 

# The first word below will be set to the number of 
# custom songs available (total hex tracks - 0x31)
00000000435553544F4D20534F4E4720 # CUSTOM SONG NO.
4E4F2E00

1.02 ----- 0x80023f28 --- 7C0802A6 -> Branch

# Injects into the beginning of Music_HandleLoading
# Called on major scene change

codeStart:				# Check the Debug Menu control variable for "Disable All Music" (word at 803FA2F0 | 0x3F72F0),
  lis r4, 0x8040		# and only run this code if it's set to 0
  lwz r4, -23824(r4)
  cmpwi r4, 0x0
  beq- checkForNoSong
  blr

checkForNoSong:
  cmpwi r3, 0x7FFF		# Compare song ID to -1 (No song)
  bne- backupRegisters	# Branch and continue code if above is not -1, otherwise, tell the game to play "00.hps"

  lis r4, 0x803B
  ori r4, r4, 0xC2F0	# Load value 803BC2F0|3B92F0 to r4 (location of ASCII string for Yoshi's Story music file, "27.hps")
  li r3, 0x3030			# ASCII "00"
  sth r3, 0(r4)			# Store halfword in r3 to above address
  li r3, 0x60			# Set the game to play Yoshi's Story music (setting orig game music Id)
  mflr r0
  b END

backupRegisters:		# Backup registers
  mflr r0
  subi r1, r1, 0x40
  stw r0, 24(r1)
  stw r3, 32(r1)
  stw r5, 20(r1)
  lis r14, 0x803F
  ori r14, r14, 0xA8E0	# Load value 803FA8E0 | 0x3F78E0 to r14. This location is a table of 0xB pointers, pointing to ASCII strings (all are __.hps)
  li r20, 0x0														# table musicId order : 01, 27, 1C, 26, 21, 2E, 2B, 0B, 03, 1D, 01
  stw r20, 4(r1)		# Store 0 (word) to memory address r1+4

															# 	Hex Tracks	  01=Menu 1, 27=Yoshi's Story, 1C=Fountain of Dreams
																			# 26=Pokemon Stadium, 21=Dream Land 64, 2E=Battlefield
																			# 2B=Final Destination, 0B=Green Greens, 03=Trophy Stage, 
loopStart:				# Start iterating over pointers in above table 		  1D=Hyrule Temple, 01 (originally "testnz.hps")
  li r5, 0x0
  cmpwi r20, 0xA
  bne- loopProceed		# Branch if r20 is not 0xA

loopFinish:
  lwz r3, 32(r1)		# Load word at r1+0x20 (backed up register). Likely the song the game was originally trying to play
  cmpwi r3, 0x62
  beq- incrementLoop	# Exit this function (since r20 is already 0xA)
  lis r16, 0x8040
  lwz r16, -20844(r16)	# Load Debug Menu "Global Playlist" flag (byte at 803FAE94|0x3F7E94) to r16
  cmpwi r16, 0x0
  beq- incrementLoop	# Exit this function if not using global playlist (flag is 0), since r20 is already 0xA
  cmpwi r3, 0x34		# Check if r3 is 0x34 (ID of Main Menu song?)
  beq- songIsMainMenu
  cmpwi r3, 0x36		# Check if r3 is 0x36 (ID of Main Menu Alternate song?)
  bne- songNotMainMenu

songIsMainMenu:			# Current song should be Main Menu or Main Menu Alt; Check if the main menu uses global playlist as well
  lis r16, 0x8040
  lwz r16, -24196(r16)	# Load Debug Menu "Global Affects Menu" flag (byte at 803FA17C|0x3F717C) to r16
  cmpwi r16, 0x0
  beq- incrementLoop	# Exit this function if not using global playlist for menus (flag is 0), since r20 is already 0xA
  li r16, 0x62
  stw r16, 32(r1)		# Set game's original song ID (r3) to 0x62 (testnz)
  b checkMenuReload

songNotMainMenu:		# Current song is not either original Main Menu song
  li r16, 0x62
  stw r16, 32(r1)		# Set game's original song ID (r3) to 0x62 (testnz)

loopProceed:			# On first loop iteration, check for Debug Menu flags. Else, continue on to analyze playlist
  cmpwi r20, 0x0
  bne- analyzePlaylist	# Branch if r20 is not 0

onFirstIter:
  lis r16, 0x8040		# Continuing here only on first loop iteration
  lwz r16, -20844(r16)	# Load Debug Menu "Global Playlist" flag (byte at 803FAE94|0x3F7E94) to r16
  cmpwi r16, 0x0
  beq- checkMenuReload	# Branch if global playlist flag is Off (0)
  lis r16, 0x8040
  lwz r16, -24196(r16)	# Load Debug Menu "Global Affects Menu" flag (byte at 803FA17C|0x3F717C) to r16
  cmpwi r16, 0x0
  bne- incrementLoop	# Go to next loop iteration if global affects menu flag is set

checkMenuReload:
  lis r16, 0x803C
  lbz r3, 30506(r16)	# Load menu reload flag (byte at 803C772A|0x3C472A to r3)
  cmpwi r3, 0x0
  beq- incrementLoop	# Go to next loop iteration if reload flag is not set (0)
  stb r5, 30506(r16)	# Store r5 as reload flag (to memory address 803C772A|0x3C472A)

analyzePlaylist:		# Loads variables needed for playlist traversal and determining a new song ID. Uses Playlist Type to determine how to move forward
  li r3, 0x0
  lis r4, 0x8000
  lwz r5, 13040(r4)		# Load word at 800032F0 | 0x2F0 to r5 (custom song count). This value is set to 0x97 (in v4.07++) by something after game start
  lis r4, 0x8038
  ori r4, r4, 0x580		# Load address of HSD_Randi (80380580) to r4
  mtctr r4				# Move HSD_Randi address to the count register
  mulli r17, r20, 0x4	# Create an index offset into the ASCII string pointer table. Also used to get an entry from the Playlist Types table
  lwzx r15, r17, r14	# Load word located at memory address [r14+r17] to r15. r14 = 803FA8E0|0x3F78E0 (base address of pointer table)
  cmpwi r15, 0x0
  beq- restoreRegisters	# If r15 is 0, restore registers and exit (not expected. probably just a failsafe)
  addi r16, r14, 0x60	# Set the address for the Playlist Types table, at 803FA940|0x3F7940 in r16 (Each entry may be 1 of 5 types from Debug Menu)
  lwzx r16, r16, r17	# Get Playlist Type for the current playlist ID (Load word located at memory address [r16+r17] to r16)
  cmpwi r16, 0x0
  beq- singleSongPlaylist
  cmpwi r16, 0x1
  beq- randomSongPlaylist
  cmpwi r16, 0x2
  beq- randomVanillaSongs
  cmpwi r16, 0x3
  beq- randomCustomSongs
  li r3, 0x19			# If here, the Playlist Type is 04, 'Random Vanilla+Custom Songs'
  add r3, r3, r5
  bctrl 				# Get a random int (Branch to 80380580, HSD_Randi, and then return back here). r3 is now a random int < r3
  addi r16, r3, 0x18
  b validateSongID

singleSongPlaylist:		# The default, unless changed in Debug Menu
  addi r16, r14, 0xD0	# Set base address for the playlists table in DOL, at 803FA9B0|3F79B0
  mulli r17, r20, 0x60	# Set index into the playlists table (i.e. relative offset to a specific playlist table)
  lwzx r16, r17, r16	# Load word for first song ID in playlist into r16. (Load word at address r16+r17 to r16)
  b validateSongID

randomSongPlaylist:
  addi r16, r14, 0xCC	# Set base address for the playlists table in DOL, at 803FA9B0|3F79B0, minus 4
  mulli r17, r20, 0x60	# Set index into the playlists table (i.e. relative offset to a specific playlist table)
  add r18, r16, r17		# Move to a specific playlist table
  mr r16, r18

traverseToPlaylistEnd:
  lwzu r19, 4(r18)		# Load word at r18+4 into r19, then update r18 with computed address (adding 4 to it in this case)
  cmpwi r19, 0x0
  beq- playlistEndFound	# Exit this loop once the end of the playlist is found (ID of 0)
  addi r3, r3, 0x1		# Starts at 0. Will be used for max value when getting random int
  b traverseToPlaylistEnd

playlistEndFound:
  bctrl 				# Get a random int (Branch to 80380580, HSD_Randi, and then return back here). r3 is now a random int < r3
  addi r16, r16, 0x4	# Move 4 bytes forward in playlist table
  mulli r3, r3, 0x4		# Get relative index for song id in table (4 byte multiple of above int)
  lwzx r16, r16, r3
  b validateSongID

randomVanillaSongs:
  li r3, 0x19
  bctrl 				# Get a random int (Branch to 80380580, HSD_Randi, and then return back here). r3 is now a random int < r3
  addi r16, r3, 0x18
  b validateSongID

randomCustomSongs:		# Set r16 to a random song ID between 0x31 >= and < [lastSongID]
  mr r3, r5				# Set max random int
  bctrl 				# Get a random int (Branch to 80380580, HSD_Randi, and then return back here). r3 is now a random int < r3
  addi r16, r3, 0x31	# Add an ID offset; 0x31 is the first custom song ID

validateSongID:			# If song ID is 0 (NONE; aka Debug Menu Song), make it 1 (Main Menu 1). Then go to ASCII conversion
  cmpwi r16, 0x0
  bne- convertFirstDigit
  li r16, 0x1

convertFirstDigit:		# Convert the int to ASCII (first digit)
  li r17, 0x10
  divw r19, r16, r17	# Divide r16 by 16 (i.e. shift 0x10s digit to 1s digit)
  addi r18, r19, 0x30
  cmpwi r18, 0x3A
  blt- convertSecondDigit
  addi r18, r18, 0x7

convertSecondDigit:		# Convert the int to ASCII (second digit)
  stb r18, 6(r1)		# Store the above first ASCII digit (r18) to the address r1+6
  mulli r19, r19, 0x10
  sub r19, r16, r19
  addi r18, r19, 0x30
  cmpwi r18, 0x3A
  blt- storeMusicID
  addi r18, r18, 0x7

storeMusicID:
  stb r18, 7(r1)		# Store second ASCII digit
  lwz r18, 4(r1)		# Load both ASCII digits to r18 (lower bits)
  sth r18, 0(r15)		# Store both ASCII digits to address in r15		(address of this instruction during testing: 801912e4)

incrementLoop:			# Adds 1 to r20 and starts the next loop iteration
  addi r20, r20, 0x1
  cmpwi r20, 0xB
  blt- loopStart		# Next iteration if r20 is less than 0xB, else exit function

restoreRegisters:		# Restore registers
  lwz r3, 32(r1)
  lwz r5, 20(r1)
  lwz r0, 24(r1)
  addi r1, r1, 0x40

END:
  b 0					# Branch back (exit injection)


# Branches back to 80023F2C


# 803BC308|3B9308 = [ASCII string; __.hps] music file (name only) to use on stage load?