

Apply Half-Frame Lag Reduction on Boot
If playing on console and progressive display is available, prompts the user on-boot if they'd like to enable the code.
<https://smashboards.com/threads/video-lag-reduction-codes-for-console.501438/>
<https://github.com/UnclePunch/Training-Mode/blob/master/ASM/Additional%20Codes/Lag%20Reduction%20Prompt/Main.asm>
[tauKhan, UnclePunch, DRGN]
Revision ---- DOL Offset ---- Hex to Replace ---------- ASM Code -
NTSC 1.02 --- 0x801A4D98 ---- 481EE0E9 -> Branch

# updateFunction	f=0/1 good
3DE08023 81EF8914
2C0F0000 41A20034
8062A6F4 2C030001
4082002C 8062A6F0
2C030002 41820020
386DBD88 3D808034
618CBA14 7D8803A6
4E800021 4BFFFFD4
bl 0x80392e80
48000000

------------- 0x801A5050 ---- 38600000 -> Branch

# updateFunction	f=0/1 good
3DE08023 81EF8914
2C0F0000 41A20050
8062A6F4 2C030001
40820044 8062A6F0
2C030002 40820038
4800001C 8062A6F0
2C030002 41820028
8062A6F4 2C030001
4082001C 386DBD88
3D808034 618CBA14
7D8803A6 4E800021
4BFFFFD4 38600000
48000000

------------- 0x801A4BEC ---- 38800000 -> Branch

# ScenePrep_Common	f=0/1 good
3DE08023 81EF8914
2C0F0000 41A200A0
4800007D 7C0802A6
90010004 9421FFF8
386DBD88 8082A6F0
38840001 9082A6F0
2C040001 40820014
3D808001 618C95FC
7D8803A6 4E800021
8082A6F0 2C040002
40820014 3D808034
618CBB00 7D8803A6
4E800021 38600001
9062A6F4 38604000
38635624 3C808043
B0642A42 8001000C
38210008 7C0803A6
4E800020 7C6802A6
3D808034 618CE894
7D8803A6 4E800021
3C608048 3C80801A
380446F4 38800000
48000000

------------- 0x8034EB60 ---- 386DBD88 -> Branch

# __VIRetraceHandler	f=0/1 good
3DE08023 81EF8914
2C0F0000 41A20030
8062A6F0 2C030001
4080001C 38600000
9062A6F4 3C608043
38804000 388455FC
B0832A42 38600000
9062A6F0 386DBD88
48000000

------------- 0x80158268 ---- C822A6F0 -> Branch

3DE08023 81EF8914
2C0F0000 41A2000C
C82280A0 48000008
C822A6F0 48000000

##------------- 0x80397878 ---- 801E0000 -> Branch

## This edit is already made by the OSReport Print code
##3DE08023 81EF8914
##2C0F0000 41A20008
##b 0x80397A84
##801E0000 48000000

NTSC 1.02 --- 0x801bf930 ---- 38600028 -> Branch

# Main injection. You should only see this if progressive mode is
# enabled (hold B on Boot to get that prompt first).

#To be inserted at 801bf930
.include "CommonMCM.s"

#Parameters
.set  PromptSceneID,8 #0
.set  ExitSceneID,40
.set  PromptCommonSceneID,10
.set  InitialSelection,0

#region Init New Scenes
.set  REG_MinorSceneStruct,31

#Init and backup
  backup

#Init LagPrompt major struct
  li  r3,PromptSceneID
  bl  LagPrompt_MinorSceneStruct
  mflr  r4
  bl  LagPrompt_SceneLoad
  mflr  r5
  bl  InitializeMajorSceneStruct
#Override LagPrompt SceneLoad
  li  r3,PromptCommonSceneID
  bl 0x801a4ce0	# To Scene_MinorIDToMinorSceneFunctionTable
  bl  LagPrompt_SceneLoad
  mflr  r4
  stw r4,0x8(r3)

  b CheckEmulation

#region PointerConvert
PointerConvert:
  lwz r4,0x0(r3)          #Load bl instruction
  rlwinm r5,r4,8,25,29    #extract opcode bits
  cmpwi r5,0x48           #if not a bl instruction, exit
  bne PointerConvert_Exit
  rlwinm  r4,r4,0,6,29  #extract offset bits
  extsh r4,r4
  add r4,r4,r3
  stw r4,0x0(r3)
PointerConvert_Exit:
  blr
#endregion
#region InitializeMajorSceneStruct
InitializeMajorSceneStruct:
.set  REG_MajorScene,31
.set  REG_MinorStruct,30
.set  REG_SceneLoad,29

#Init
  backup
  mr  REG_MajorScene,r3
  mr  REG_MinorStruct,r4
  mr  REG_SceneLoad,r5

#Get major scene struct
  bl 0x801a50ac
GetMajorStruct_Loop:
  lbz	r4, 0x0001 (r3)
  cmpw r4,REG_MajorScene
  beq GetMajorStruct_Exit
  addi  r3,r3,20
  b GetMajorStruct_Loop
GetMajorStruct_Exit:

InitMinorSceneStruct:
.set  REG_MinorStructParse,20
  stw REG_MinorStruct,0x10(r3)
  mr  REG_MinorStructParse,REG_MinorStruct
InitMinorSceneStruct_Loop:
#Check if valid entry
  lbz r3,0x0(REG_MinorStructParse)
  extsb r3,r3
  cmpwi r3,-1
  beq InitMinorSceneStruct_Exit
#Convert Pointers
  addi  r3,REG_MinorStructParse,0x4
  bl  PointerConvert
  addi  r3,REG_MinorStructParse,0x8
  bl  PointerConvert
  addi  REG_MinorStructParse,REG_MinorStructParse,0x18
  b InitMinorSceneStruct_Loop

InitMinorSceneStruct_Exit:
  restore
  blr

#endregion
#endregion

#region LagPrompt

#region LagPrompt_SceneLoad
############################################

#region LagPrompt_SceneLoad_Data
LagPrompt_SceneLoad_TextProperties:
blrl
.set PromptX,0x0
.set PromptY,0x4
.set ZOffset,0x8
.set CanvasScaling,0xC
.set Scale,0x10
.set YesX,0x14
.set YesY,0x18
.set YesScale,0x1C
.set NoX,0x20
.set NoY,0x24
.set NoScale,0x28
.set HighlightColor,0x2C
.set NonHighlightColor,0x30
.float 315     			   #REG_TextGObj X pos
.float 200  					   #REG_TextGObj Y pos
.float 0     		     	 #Z offset
.float 1   				     #Canvas Scaling
.float 1					    	#Text scale
.float 265              #Yes X pos
.float 300              #Yes Y pos
.float 1              #Yes scale
.float 365              #No X pos
.float 300              #No Y pos
.float 1              #No scale
.byte 251,199,57,255		#highlighted color
.byte 170,170,170,255	  #nonhighlighted color

LagPrompt_SceneLoad_TopText:
blrl
.ascii "Are you using HDMI"
.short 0x8148
.byte 0
.align 2

LagPrompt_SceneLoad_Yes:
blrl
.string "Yes"
.align 2

LagPrompt_SceneLoad_No:
blrl
.string "No"
.align 2

#GObj Offsets
  .set OFST_TextGObj,0x0
  .set OFST_Selection,0x4

#endregion
#region LagPrompt_SceneLoad
LagPrompt_SceneLoad:
blrl

#Init
  backup

LagPrompt_SceneLoad_CreateText:
.set REG_GObjData,27
.set REG_GObj,28
.set REG_SubtextID,29
.set REG_TextProp,30
.set REG_TextGObj,31

#GET PROPERTIES TABLE
	bl LagPrompt_SceneLoad_TextProperties
	mflr REG_TextProp

#Create canvas
  li  r3,0
  li  r4,0
  li  r5,9
  li  r6,13
  li  r7,0
  li  r8,14
  li  r9,0
  li  r10,19
  bl 0x803a611c

########################
## Create Text Object ##
########################

#CREATE TEXT OBJECT, RETURN POINTER TO STRUCT IN r3
	li r3,0
	li r4,0
	branchl r12,Text_CreateTextStruct
#BACKUP STRUCT POINTER
	mr REG_TextGObj,r3
  stw REG_TextGObj,0x0(REG_GObjData)
#SET TEXT SPACING TO TIGHT
	li r4,0x1
	stb r4,0x49(REG_TextGObj)
#SET TEXT TO CENTER AROUND X LOCATION
	li r4,0x1
	stb r4,0x4A(REG_TextGObj)
#Store Base Z Offset
	lfs f1,ZOffset(REG_TextProp) #Z offset
	stfs f1,0x8(REG_TextGObj)
#Scale Canvas Down
  lfs f1,CanvasScaling(REG_TextProp)
  stfs f1,0x24(REG_TextGObj)
  stfs f1,0x28(REG_TextGObj)

#Create Prompt
#Initialize Subtext
	mr 	r3,REG_TextGObj		#struct pointer
	bl LagPrompt_SceneLoad_TopText
  mflr  r4
	lfs	f1,PromptX(REG_TextProp)
  lfs	f2,PromptY(REG_TextProp)
	bl 0x803a6b98
  mr  REG_SubtextID,r3
#Change Text Scale
	mr 	r3,REG_TextGObj		#struct pointer
	mr	r4,REG_SubtextID
	lfs 	f1,Scale(REG_TextProp) 		#X offset of REG_TextGObj
	lfs 	f2,Scale(REG_TextProp)	  	#Y offset of REG_TextGObj
	branchl r12,Text_UpdateSubtextSize

#Create Yes
#Initialize Subtext
	mr 	r3,REG_TextGObj		#struct pointer
	bl LagPrompt_SceneLoad_Yes
  mflr  r4
	lfs	f1,YesX(REG_TextProp)
  lfs	f2,YesY(REG_TextProp)
	bl 0x803a6b98
  mr  REG_SubtextID,r3
#Change Text Scale
	mr 	r3,REG_TextGObj		#struct pointer
	mr	r4,REG_SubtextID
	lfs 	f1,YesScale(REG_TextProp) 		#X offset of REG_TextGObj
	lfs 	f2,YesScale(REG_TextProp)	  	#Y offset of REG_TextGObj
	branchl r12,Text_UpdateSubtextSize

#Create No
#Initialize Subtext
	mr 	r3,REG_TextGObj		#struct pointer
	bl LagPrompt_SceneLoad_No
  mflr  r4
	lfs	f1,NoX(REG_TextProp)
  lfs	f2,NoY(REG_TextProp)
	bl 0x803a6b98
  mr  REG_SubtextID,r3
#Change Text Scale
	mr 	r3,REG_TextGObj		#struct pointer
	mr	r4,REG_SubtextID
	lfs 	f1,NoScale(REG_TextProp) 		#X offset of REG_TextGObj
	lfs 	f2,NoScale(REG_TextProp)	  	#Y offset of REG_TextGObj
	branchl r12,Text_UpdateSubtextSize

#Create GObj
  li  r3, 13
  li  r4,14
  li  r5,0
  branchl r12, GObj_Create
  mr  REG_GObj,r3
#Allocate Space
	li	r3,64
	branchl r12,HSD_MemAlloc
	mr	REG_GObjData,r3
#Zero
	li	r4,64
	branchl r12,ZeroAreaLength
#Initialize
	mr	r6,REG_GObjData
	mr	r3,REG_GObj
	li	r4,4
	load	r5,0x8037f1b0
	branchl r12,GObj_AddUserData
#Add Proc
  mr  r3,REG_GObj
  bl  LagPrompt_SceneThink
  mflr  r4      #Function to Run
  li  r5,0      #Priority
  branchl r12, GObj_AddProc

#Store text gobj pointer
  stw REG_TextGObj,OFST_TextGObj(REG_GObjData)
#Init Selection value
  li  r3,InitialSelection
  stb r3,OFST_Selection(REG_GObjData)

#Highlight selection
  mr  r3,REG_TextGObj
  li  r4,InitialSelection+1
  addi  r5,REG_TextProp,HighlightColor
  branchl r12,Text_ChangeTextColor

LagPrompt_SceneLoad_Exit:
  restore
  blr
#endregion

############################################
#endregion
#region LagPrompt_SceneThink
LagPrompt_SceneThink:
blrl

.set REG_TextProp,28
.set REG_Inputs,29
.set REG_GObjData,30
.set REG_GObj,31

#Init
  backup
  mr  REG_GObj,r3
  lwz REG_GObjData,0x2C(REG_GObj)
  bl  LagPrompt_SceneLoad_TextProperties
  mflr  REG_TextProp

#region Adjust Selection
#Adjust Menu Choice
#Get all player inputs
  li  r3,4
  bl 0x801a36c0
  mr  REG_Inputs,r3
#Check for movement to the right
  rlwinm. r0,REG_Inputs,0,0x80
  beq LagPrompt_SceneThink_SkipRight
#Adjust cursor
  lbz r3,OFST_Selection(REG_GObjData)
  addi  r3,r3,1
  stb r3,OFST_Selection(REG_GObjData)
  extsb r3,r3
  cmpwi r3,1
  ble LagPrompt_SceneThink_HighlightSelection
  li  r3,1
  stb r3,OFST_Selection(REG_GObjData)
  b LagPrompt_SceneThink_CheckForA
LagPrompt_SceneThink_SkipRight:
#Check for movement to the left
  rlwinm. r0,REG_Inputs,0,0x40
  beq LagPrompt_SceneThink_CheckForA
#Adjust cursor
  lbz r3,OFST_Selection(REG_GObjData)
  subi  r3,r3,1
  stb r3,OFST_Selection(REG_GObjData)
  extsb r3,r3
  cmpwi r3,0
  bge LagPrompt_SceneThink_HighlightSelection
  li  r3,0
  stb r3,OFST_Selection(REG_GObjData)
  b LagPrompt_SceneThink_CheckForA

LagPrompt_SceneThink_HighlightSelection:
#Unhighlight both options
  lwz r3,OFST_TextGObj(REG_GObjData)
  li  r4,1
  addi  r5,REG_TextProp,NonHighlightColor
  branchl r12,Text_ChangeTextColor
  lwz r3,OFST_TextGObj(REG_GObjData)
  li  r4,2
  addi  r5,REG_TextProp,NonHighlightColor
  branchl r12,Text_ChangeTextColor
#Highlight selection
  lwz r3,OFST_TextGObj(REG_GObjData)
  lbz r4,OFST_Selection(REG_GObjData)
  addi  r4,r4,1
  addi  r5,REG_TextProp,HighlightColor
  branchl r12,Text_ChangeTextColor
#Play SFX
  bl 0x80174380
#endregion
#region Check for Confirmation
LagPrompt_SceneThink_CheckForA:
  li  r3,4
  bl 0x801a36a0
  rlwinm. r0,r4,0,0x100
  bne LagPrompt_SceneThink_Confirmed
  rlwinm. r0,r4,0,0x1000
  bne LagPrompt_SceneThink_Confirmed
  b LagPrompt_SceneThink_Exit
LagPrompt_SceneThink_Confirmed:
#Play Menu Sound
  bl 0x80174338
#If yes, apply lag reduction
  lbz r3,OFST_Selection(REG_GObjData)
  cmpwi r3,0
  bne LagPrompt_SceneThink_ExitScene
#endregion

# Set the flag to enable Half-Frame Lag Reduction
lis r3, 0x8022		# Load address of the HFLR flag
ori r3, r3, 0x8914
li r4, 1
stw r4, 0(r3)

#endregion

LagPrompt_SceneThink_ExitScene:
  bl 0x801a4b60

LagPrompt_SceneThink_Exit:
  restore
  blr
#endregion
#region LagPrompt_SceneDecide
LagPrompt_SceneDecide:
  backup

#Exit Scene
  li  r3,ExitSceneID
  bl 0x801a42e8
#Change Major
  bl 0x801a42d4

LagPrompt_SceneDecide_Exit:
  restore
  blr
############################################
#endregion

#region MinorSceneStruct
LagPrompt_MinorSceneStruct:
blrl
#Lag Prompt
.byte 0                     #Minor Scene ID
.byte 00                    #Amount of persistent heaps
.align 2
.long 0x00000000            #ScenePrep
bl  LagPrompt_SceneDecide   #SceneDecide
.byte PromptCommonSceneID   #Common Minor ID
.align 2
.long 0x00000000            #Minor Data 1
.long 0x00000000            #Minor Data 2
#End
.byte -1
.align 2

#endregion

CheckEmulation:
  lis r3, 0x8000
  lwz r3, 0x2C(r3)
  rlwinm r3,r3,0,3,3	# Apply mask of 0x10000000; anything with that bit should be emulation
  cmplwi r3, 0
  bne ExitScene

CheckProgressive:
#Check if progressive mode is enabled
  bl 0x80349278	# To OSGetProgressiveMode
  cmpwi r3,0
  beq ExitScene

IsProgressive:
#Load LagPrompt
  li	r3, PromptSceneID
  b Injection_Exit

ExitScene:
  li  r3,ExitSceneID

Injection_Exit:
  restore
  b 0