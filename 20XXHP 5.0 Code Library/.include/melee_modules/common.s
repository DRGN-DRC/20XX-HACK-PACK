.ifndef melee.library.included; .include "melee"; .endif
melee.module common; .if module.included == 0

#Funtions
.set Text_CreateTextCanvas,0x803a611c
.set Text_CreateTextStruct,0x803a6754
.set Text_InitializeSubtext,0x803a6b98
.set Text_UpdateSubtextSize,0x803a7548
.set Text_RemoveText,0x803a5cc4
.set GObj_Create,0x803901f0
.set HSD_MemAlloc,0x8037f1e4
.set HSD_Free,0x8037f1b0
.set HSD_Randi,0x80380580
.set ZeroAreaLength,0x8000c160
.set strlen,0x80325b04
.set strcpy,0x80325a50
.set memset,0x80003100
.set memcpy,0x800031f4
.set GObj_AddUserData,0x80390b68
.set GObj_AddProc,0x8038fd54
.set Text_ChangeTextColor,0x803a74f0
.set Text_UpdateSubtextContents,0x803a70a0
.set Inputs_GetPlayerRapidHeldInputs,0x801a36c0
.set Inputs_GetPlayerInstantInputs,0x801a36a0
.set Inputs_GetPlayerHeldInputs,0x801a3680
.set SFX_PlayMenuSound_CloseOpenPort,0x80174380
.set SFX_PlayMenuSound_Forward,0x80174338
.set HSD_VISetUserPostRetraceCallback,0x80375934
.set TRK_flush_cache,0x80328f50
.set MenuController_ChangeScreenMinor,0x801a4b60
.set Scene_GetMajorSceneStruct,0x801a50ac
.set Scene_MinorIDToMinorSceneFunctionTable,0x801a4ce0
.set MenuController_WriteToPendingMajor,0x801a42e8
.set MenuController_ChangeScreenMajor,0x801a42d4
.set Text_AllocateTextObject,0x803a5acc
.set Memcard_AllocateSomething,0x8001c550
.set MemoryCard_LoadBannerIconImagesToRAM,0x8001d164
.set PlayerBlock_LoadDataOffsetStart,0x8003418c
.set SinglePlayerModeCheck,0x8016b41c
.set PlayerBlock_LoadSlotType,0x8003248c
.set PlayerBlock_LoadTeamID,0x80033370
.set PlayerBlock_StoreFacingDirectionAgain,0x80033094
.set PlayerBlock_LoadDamage,0x800342b4
.set PlayerBlock_GetCliffhangerStat,0x80040af0
.set GetSSMatchStruct,0x801A5244
.set LoadRulesSettingsPointer4,0x8015cc58
.set HSD_PadRumbleActiveId,0x80378430
.set Rumble_StoreRumbleFlag,0x8015ed4c
.set MatchEnd_GetWinningTeam,0x801654a0
.set PlayerBlock_StoreInitialXYCoords,0x80032768
.set getStageFromRandomStageSelect,0x802599ec
.set Preload_CompareGameCache,0x80018254
.set Nametag_GetAddressForNametagID,0x801A5F8C
.set Deflicker_Toggle,0x8015F500
.set UnlockSram,0x80348DF4
.set MemoryCard_CheckToSaveData,0x8001cc84
.set MemoryCard_WaitForFileToFinishSaving,0x8001b6f8
.set PlayerBlock_LoadMainCharDataOffset,0x80034110
.set PlayerBlock_LoadDataOffset,0x8003418c
.set AS_218_CatchCut,0x800da698
.set SFX_PlaySFXAtFullVolume,0x801C53EC
.set SFX_MenuCommonSound,0x80024030
.set LoadFile_EfData,0x8006737C
.set AS_AnimationFrameUpdateMore,0x8006eba4
.set sprintf,0x80323cf4
.set ScreenDisplay_Adjust,0x8015F588
.set Text_CopyPremadeTextDataToStruct,0x803a6368
.set Snapshot_UpdateFileList,0x80253e90
.set Memcard_FreeSomething,0x8001C5A4
.set Memcard_AllocateSomething,0x8001c550
.set MemoryCard_ReadDataIntoMemory,0x8001bf04
.set Scene_GetMinorSceneData2,0x801a4b9c
.set MemoryCard_LoadData,0x8001bd34
.set OSReport,0x803456a8
.set SpawnPoint_GetXYZFromInputID,0x80224e64
.set RenewInputs_Prefunction,0x800195fc
.set cvt_sll_flt,0x80322da0
.set cvt_fp2unsigned,0x803228c0
.set DevelopText_CreateDataTable,0x80302834
.set DevelopText_Activate,0x80302810
.set DevelopText_AddString,0x80302be4
.set DevelopText_EraseAllText,0x80302bb0
.set DevelopMode_Text_ResetCursorXY,0x80302a3c
.set DevelopText_StoreBGColor,0x80302b90
.set DevelopText_HideBG,0x80302ae0
.set DevelopText_ShowBG,0x80302ad0
.set PlayerBlock_LoadNameTagSlot,0x8003556c
.set Nametag_LoadNametagSlotText,0x8023754c
.set CountPlayers,0x800860c4
.set LoadRulesSettingsPointer1,0x8015cc34
.set CSS_UpdateCSPInfo,0x8025db34

#r13 offsets
.set  OFST_Memcard,-0x77C0 #find it @ 8015ed3c in 102
.set  OFST_PlCo,-0x514C # 0x800679CC
.set  OFST_ExtStageID,-0x6CB8 # 0x80223EEC
.set  CSS_SubSceneID,-0x49AA # 0x80260404
.set  CSS_MinorSceneData,-0x49F0 # 0x802655A0
.set  SSS_Unk1,-0x4A00 # 0x80259724
.set  SSS_Unk2,-0x49F2 # 0x80259730
.set  SSS_HighlightedStage,-0x49F2 # 0x80259730
.set  SSS_MnSlMap,-0x4A0C # DONE
.set  OFST_CommonCObj,-0x4884 #0x80300EE8
.set  OFST_Rand,-0x570C
.set  CSS_MaxPlayers,-0x49AB
.set  OFST_IfAll,0
.set  OFST_MusicVolume,-0x7E1C
.set  OFST_DevTextGObj,-0x4884
.set  GObj_Lists,-0x3E74

#rtoc offsets
.set  OFST_NametagBGScale,-0x1E64

#Misc
.set  OFST_IsLeader,0x2222
.set  Bitflag_IsLeader,0x4
.set  OFST_IsInvisible,0x221E
.set  Bitflag_IsInvisible,0x80
.set  StaticPlayerBlock_Length,0xe90

#Mem Addresses
.set  OFST_ModPrefs,0x1f24
.set  PostRetraceCallback,0x800195fc #*
.set  UnkPadStruct,0x804329f0 #80019A48
.set  OFST_MemcardController,0x80431358 #r31 at 0x8001D244
.set  ExploitReturn,0x80239E9C #*
.set  OFST_NametagStart,0x3000
.set  Nametag_Length,0xd894
.set  HSD_Pad,0x804c1f78 #r31 @ 0x80377DC0
.set  HWInputArray,0x8046b108 #r3 @ 0x80376BB8
.set  InputStruct,0x804c1fac #r6 + 0x8 @ 0x80378858
.set  VSModeCSSData,0x80480820 #r3 + 0x70 @ 0x80260C88 for p1
.set  SceneController,0x80479d30 #r30 @ 0x801A45E0
.set  CSS_WindowGObjs,0x803f0e8c #r30 @ 0x80264FF8
.set  SSS_IconData,0x803f06d0 #r27 @ 0x8025AEB0
.set  Match_StaticMatchData,0x8046b6a0 #r3 @ 0x8016DCE8
.set  Match_EndStruct,0x80479da4 #r3 + 0xC @ 0x8016E9E8
.set  PreloadTable,0x80432078 #done
.set  DeflickerStruct,0x8046b0f0 #r31 @ 0x8015FCF4
.set  ProgressiveStruct,0x8046b0f0 #r31 @ 0x8015FCF4
.set  MemcardFileList,0x80433380 #use func 8001e238 to find it #*
.set  SnapshotData,0x803bacc8 #use func 8001df4c to find it #*
.set  SnapshotLoadThinkStruct,0x804a0a10 #804a0b6c, use func 8025389c to find it #*
.set  MainSaveUnk,0x80433318 # r30 at 8001d24c (102)
.set  MainSaveData,0x803bab74 # r25 at 8001ccb0 (102)
.set  MainSaveString,0x803bac5c # r4 at 8001a564 (102)
.set  StageInfo,0x8049ee10 #r31 @ 0x801C616C
.set  LagReduction_UnkCondition,0x803bf7d4
.set  CSS_DoorStructs,0x803f0dfc
.set  OFST_Rumble,0x1CC0


# punkpc has upgraded versions of legacy 'branch' and 'load' instrucitons:

punkpc branch, load
# 'branch(l)' now accepts an optional register argument, for building the address in
# - also, 'ba' and 'bla' macros are available as aliases for 'branch' and 'branchl'

# 'load' can now load multiple 32-bit ints, or small quoted strings that start with "> "

load.opt = 0
# the param 'load.opt' determines whether or not the load macroinstruction optimizes its inputs
# If set to a non-0 value, then load will reduce loads to 1 instruction, if possible
# - this requires use of a .if statement, which may create errors if inputs are not yet evaluable
#   - by turning '.opt' to 0, we avoid using the .if evaluation, and prevent potential errors
#   - this sacrifices convenience for compatability -- so you may turn it back on if desired

# 'regs' is a prerequisite that gets imported with 'load
# It provides named registers r0...r31, f0...f31, and cr register names, like 'cr7.eq'
# It also provides the 'regs' enumerator tool, for naming registers




# other legacy macros remain intact:

.macro backup
mflr r0
stw r0, 0x4(r1)
stwu	r1,-0x100(r1)	# make space for 12 registers
stmw  r20,0x8(r1)
.endm

.macro restore
lmw  r20,0x8(r1)
lwz r0, 0x104(r1)
addi	r1,r1,0x100	# release the space
mtlr r0
.endm

.macro backupall
mflr r0
stw r0, 0x4(r1)
stwu	r1,-0x100(r1)	# make space for 12 registers
stmw  r3,0x8(r1)
.endm

.macro restoreall
lmw  r3,0x8(r1)
lwz r0, 0x104(r1)
addi	r1,r1,0x100	# release the space
mtlr r0
.endm


.endif
