.ifndef melee.library.included; .include "melee"; .endif
melee.module HSDObj
.if module.included == 0

# --- Class Info Tables -------------------------------------------------------------------------
# Info table descriptor:
HSD.info.xCB_InfoInit    = 0x00
# this callback pointer is called when the first object of its kind (per scene) is needed
# - info tables are instantiated in-place from known absolute addresses in the DOL

HSD.info.xStatus         = 0x04
# This will be flagged as 1, if the class is currently instantiated in the scene
# - some scenes that don't use certain objects may not bother instantiating a type of HSD Object

HSD.info.xLibName        = 0x08
HSD.info.xClassName      = 0x0C
HSD.info.xSize           = 0x10
HSD.info.xInfoSize       = 0x14
# The 'Names' are pointers to strings that describe a name for this info table
# The 'Size' refers to the number of bytes needed to make an object instance of this class
# The 'InfoSize' refers to the size of THIS info table -- reflecting the size of CBList

HSD.info.xParent         = 0x18
HSD.info.xSibling        = 0x1C
HSD.info.xChild          = 0x20
# Siblings may be instantiated in any order on a per-scene basis
# All classes that inherit from another class will point to it as their 'parent'
# - this allows child definitions to default to their parent's callbacks

HSD.info.xActiveCount    = 0x24
HSD.info.xAllocatedCount = 0x28
# The 'Active' count reflects the number of currently instantiated objects are in the scene
# The 'Allocated' count instead counts the number of memory fragments dedicated to this Obj type

HSD.info.xCB_ObjAlloc    = 0x2C
HSD.info.xCB_ObjInit     = 0x30
HSD.info.xCB_ObjDestroy  = 0x34
HSD.info.xCB_ObjAmnesia  = 0x38
# All HSD classes have these base method callbacks, for memory management purposes
# - they often just default to a parent routine for generic handling, but can be customized

HSD.info.xCBList_Base    = 0x3C
# The 'CBList' is a list of callback method pointers that spans the rest of the info table
# - if a table has no custom callbacks, then .xCBList_Base will be the end of structure
#   - otherwise, any number of custom callbacks may follow as part of the CBList pointer array
#   - the actual number will be reflected in the .xInfoSize param




# --- Class (Head) -------------------------------------------------------------------------------
HSD.hsdClass_info_head = 0x80407590
HSD.info.Class = HSD.hsdClass_info_head
# All class instances point back to their class info table at offset 0x0
# - all classes inherit this as a parent

# Instance:
HSD.Class.xInfo = 0x0
# - all HSD Object instances with an info table have this offset in their attribute structure
# - Obj classes that don't inherit this are still objects, they just have no info table
#   - Examples are AObjs, FObjs, and RObjs -- all of which have no info table




# --- DObj ---------------------------------------------------------------------------------------
HSD.hsd_DObj_info     = 0x80405450
HSD.refract_DObj_info = 0x803bb218
HSD.info.DObj         = HSD.hsd_DObj_info
# Varitions of a class inherit the basic 'hsd_' version
# - this makes 'HSD.info.*' able to check inheritence tree for matching class types, by address

# DObj Descriptors:
DDesc.xName           = 0x0
DDesc.xSibling        = 0x4
DDesc.xMDesc          = 0x8
DDesc.xPDesc          = 0xC
# Descriptors are static definitions of an object that may be instantiated
# - files keep these in 'archives' for loading into RAM

# DObj Instances:
DObj.xInfo            = HSD.Class.xInfo
DObj.xSibling         = 0x04
DObj.xNext            = 0x04  # alias for sibling
DObj.xMObj            = 0x08
DObj.xPObj            = 0x0C
DObj.xUnk             = 0x10
DObj.xFlags           = 0x14
# Instantiated objects usually have a similar structure to their file descriptors
# - often times, these will contain extra variables that can only be maintained in a 'live' object




# --- PObj ---------------------------------------------------------------------------------------
HSD.hsd_PObj_info     = 0x80406398
HSD.ft_PObj_info      = 0x803C0998
HSD.refract_PObj_info = 0x803bb25c
HSD.info.PObj         = HSD.hsd_PObj_info

# PObj Descriptor:
PDesc.xName           = 0x00
PDesc.xSibling        = 0x04
PDesc.xVtxAttr        = 0x08
PDesc.xFlags          = 0x0C
PDesc.xDisplayCount   = 0x0E
PDesc.xDisplayData    = 0x10
PDesc.xInfluenceMtx   = 0x14

# PObj Instance:
PObj.xInfo            = HSD.Class.xInfo
PObj.xSibling         = 0x04
PObj.xVtxAttr         = 0x08
PObj.xFlags           = 0x0C
PObj.xDisplayCount    = 0x0E
PObj.xDisplayData     = 0x10
PObj.xInfluenceMtx    = 0x14

# PObj Flags:
PObj.mParam           = 3<<12; PObj.bParam     = 19
PObj.Param.Skin       = 0
PObj.Param.ShapeAnim  = 1
PObj.Param.Envelope   = 2
PObj.mCullFront       = 1<<14; PObj.bCullFront = 17
PObj.mCullBack        = 1<<15; PObj.bCullBack  = 16
# Flags are usually shared by Instances and Descriptors, if present in both

# PObj VtxAttr Struct:
VtxAttr.xGXAttr       = 0x00
VtxAttr.xGXAttrType   = 0x04
VtxAttr.xGXCompCnt    = 0x08
VtxAttr.xGXCompType   = 0x0C
VtxAttr.xFrac         = 0x10
VtxAttr.xStride       = 0x12
VtxAttr.xData         = 0x14
# These are pointed to by PObj.xVtxAttr, for describing a vertex attribute




# --- MObj ---------------------------------------------------------------------------------------
HSD.hsd_MObj_info       = 0x80405E28
HSD.it_MObj_info        = 0x803F1F90
HSD.ft_MObj_info        = 0x803C6980
HSD.gr_MObj_info        = 0x803e0a20
HSD.info.MObj           = HSD.hsd_MObj_info

# MObj Descriptor:
MDesc.xName             = 0x00
MDesc.xRenderFlags      = 0x04
MDesc.xTDsec            = 0x08
MDesc.xColorDesc        = 0x0C
MDesc.xRender           = 0x10
MDesc.xPixelProc        = 0x14

# MObj RenderFlags:
MObj.mUser              = 1<<31; MObj.bUser              = 0
MObj.mXLU               = 1<<30; MObj.bXLU               = 1
MObj.mNoUpdate          = 1<<29; MObj.bNoUpdate          = 2
MObj.mDFNone            = 1<<28; MObj.bDFNone            = 3
MObj.mZModeAlways       = 1<<27; MObj.bZModeAlways       = 4
MObj.mShadow            = 1<<26; MObj.bShadow            = 5
MObj.mAlphaVtx          = 1<<14; MObj.bAlphaVtx          = 17
MObj.mAlphaMat          = 1<<13; MObj.bAlphaMat          = 18
MObj.mToon              = 1<<12; MObj.bToon              = 19
MObj.mTex7              = 1<<11; MObj.bTex7              = 20
MObj.mTex6              = 1<<10; MObj.bTex6              = 21
MObj.mTex5              = 1<<9;  MObj.bTex5              = 22
MObj.mTex4              = 1<<8;  MObj.bTex4              = 23
MObj.mTex3              = 1<<7;  MObj.bTex3              = 24
MObj.mTex2              = 1<<6;  MObj.bTex2              = 25
MObj.mTex1              = 1<<5;  MObj.bTex1              = 26
MObj.mTex0              = 1<<4;  MObj.bTex0              = 27
MObj.mSpecular          = 1<<3;  MObj.bSpecular          = 28
MObj.mDiffuse           = 1<<2;  MObj.bDiffuse           = 29
MObj.mDiffuseVtx        = 1<<1;  MObj.bDiffuseVtx        = 30
MObj.mDiffuseMat        = 1<<0;  MObj.bDiffuseMat        = 31


# MObj ColorDesc:
ColorDesc.xDiffusion    = 0x00
ColorDesc.xAmbience     = 0x04
ColorDesc.xSpecular     = 0x08
ColorDesc.xTransparency = 0x0C
ColorDesc.xShininess    = 0x10

# MObj PixelProc:
PixelProc.xFlags        = 0x0
PixelProc.xRef0         = 0x1
PixelProc.xRef1         = 0x2
PixelProc.xDestAlpha    = 0x3
PixelProc.xBlendType    = 0x4
PixelProc.xSourceFactor = 0x5
PixelProc.xDestFactor   = 0x6
PixelProc.xBlendOp      = 0x7
PixelProc.xZCmp         = 0x8
PixelProc.xAlphaCmp0    = 0x9
PixelProc.xAlphaOp      = 0xa
PixelProc.xAlphaCmp1    = 0xb

# MObj PixelProc Flags:
PixelProc.mDither       = 1<<6; PixelProc.bDither       = 25
PixelProc.mZUpdate      = 1<<5; PixelProc.bZUpdate      = 26
PixelProc.mZCmp         = 1<<4; PixelProc.bZCmp         = 27
PixelProc.mZTexture     = 1<<3; PixelProc.bZTexture     = 28
PixelProc.mDestAlpha    = 1<<2; PixelProc.bDestAlpha    = 29
PixelProc.mAlphaUpdate  = 1<<1; PixelProc.bAlphaUpdate  = 30
PixelProc.mColorUpdate  = 1<<0; PixelProc.bColorUpdate  = 31


# MObj Instance:
MObj.xInfo              = HSD.Class.xInfo
MObj.xRenderFlags       = 0x04
MObj.xTObj              = 0x08
MObj.xColor             = 0x0C
MObj.xRender            = 0x10
MObj.xAObj              = 0x14
MObj.xTEvDesc           = 0x18
MObj.xTExp              = 0x1C

# MObj TevDesc:
# MObj TExp List:





# --- Object (Head) ------------------------------------------------------------------------------
HSD.hsd_Obj_info_head = 0x804072A8
HSD.info.Obj          = HSD.hsd_Obj_info_head
# This header extension seems to create an Object ID used for referencing some object instances
# - they can be seen used sometimes with JObjs <> RObjs
# - Obj classes that don't inherit this are still objects -- they just lack the head parameter

# Instance:
HSD.Obj.xObjID        = 0x4




# --- TObj ---------------------------------------------------------------------------------------
HSD.hsd_TObj_info       = 0x80405570
HSD.info.TObj           = HSD.hsd_TObj_info

# TObj Descriptor:
TDesc.xName             = 0x00
TDesc.xNext             = 0x04
TDesc.xGXTexMapID       = 0x08
TDesc.xGXTexGenSrc      = 0x0C
TDesc.xRotX             = 0x10
TDesc.xRotY             = 0x14
TDesc.xRotZ             = 0x18
TDesc.xScaleX           = 0x1C
TDesc.xScaleY           = 0x20
TDesc.xScaleZ           = 0x24
TDesc.xTransX           = 0x28
TDesc.xTransY           = 0x2C
TDesc.xTransZ           = 0x30
TDesc.xWrapS            = 0x34
TDesc.xWrapT            = 0x38
TDesc.xRepeatS          = 0x3C
TDesc.xRepeatT          = 0x3D
TDesc.xFlags            = 0x40
TDesc.xBlending         = 0x44
TDesc.xGXTexFilter      = 0x48
TDesc.xImageDesc        = 0x4C
TDesc.xTlutDesc         = 0x50
TDesc.xTexLODDesc       = 0x54
TDesc.xTevDesc          = 0x58

# TObj Instance:
TObj.xInfo              = HSD.Class.xInfo
TObj.xObjID             = HSD.Obj.xObjID
TObj.xNext              = 0x08
TObj.xGXTexGenSrc       = 0x10
TObj.xRotX              = 0x1C
TObj.xRotY              = 0x20
TObj.xRotZ              = 0x24
TObj.xScaleX            = 0x28
TObj.xScaleY            = 0x2C
TObj.xScaleZ            = 0x30
TObj.xTransX            = 0x34
TObj.xTransY            = 0x38
TObj.xTransZ            = 0x3C
TObj.xWrapS             = 0x40
TObj.xWrapT             = 0x44
TObj.xRepeatS           = 0x48
TObj.xRepeatT           = 0x49
TObj.xFlags             = 0x4C
TObj.xBlending          = 0x50
TObj.xGXTexFilter       = 0x54
TObj.xImageDesc         = 0x58
TObj.xTlutDesc          = 0x5C
TObj.xTexLODDesc        = 0x60
TObj.xAObj              = 0x64
TObj.xImageArray        = 0x68
TObj.xTlutArray         = 0x6C
TObj.xImageIndex        = 0x70
TObj.xTevDesc           = 0xA8

# TObj Flags:
TObj.mCoord             = 7<<0;    TObj.bCoord = 29
TObj.Coord.UV           = 0
TObj.Coord.Reflection   = 1
TObj.Coord.Hilight      = 2
TObj.Coord.Shadow       = 3
TObj.Coord.Toon         = 4
TObj.Coord.Gradation    = 5

TObj.LightMap.mDiffuse  = 1<<4;    TObj.LightMap.bDiffuse  = 28
TObj.LightMap.mSpecular = 1<<5;    TObj.LightMap.bSpecular = 27
TObj.LightMap.mAmbient  = 1<<6;    TObj.LightMap.bAmbient  = 26
TObj.LightMap.mExt      = 1<<7;    TObj.LightMap.bExt      = 25
TObj.LightMap.mShadow   = 1<<8;    TObj.LightMap.bShadow   = 24

TObj.mColorMap          = 0xF<<16; TObj.bColorMap = 12
TObj.ColorMap.None      = 0
TObj.ColorMap.AlphaMask = 1
TObj.ColorMap.RGBMask   = 2
TObj.ColorMap.Blend     = 3
TObj.ColorMap.Modulate  = 4
TObj.ColorMap.Replace   = 5
TObj.ColorMap.Pass      = 6
TObj.ColorMap.Add       = 7
TObj.ColorMap.Sub       = 8

TObj.mAlphaMap          = 7<<20;   TObj.bAlphaMap = 9
TObj.AlphaMap.None      = 0
TObj.AlphaMap.Mask      = 1
TObj.AlphaMap.Blend     = 2
TObj.AlphaMap.Modulate  = 3
TObj.AlphaMap.Replace   = 4
TObj.AlphaMap.Pass      = 5
TObj.AlphaMap.Add       = 6
TObj.AlphaMap.Sub       = 7

TObj.mBump              = 1<<24;
TObj.mMtxDirty          = 1<<31;

# ImageDesc:
ImageDesc.xPixels       = 0x00
ImageDesc.xWidth        = 0x04
ImageDesc.xHeight       = 0x06
ImageDesc.xType         = 0x08
ImageDesc.xMipmap       = 0x0C
ImageDesc.xMinLOD       = 0x10
ImageDesc.xMaxLOD       = 0x14

# TlutDesc:
TlutDesc.xPalette       = 0x0
TlutDesc.xType          = 0x4
TlutDesc.xName          = 0x8
TlutDesc.xCount         = 0xC

# TexLODDesc:
# TObjTevDesc:




# --- JObj ---------------------------------------------------------------------------------------
HSD.hsd_JObj_info     = 0x80406708
HSD.ft_intp_JObj_info = 0x803C0948
HSD.ft_JObj_info      = 0x803C08F8

# JObj Descriptor:
JDesc.xName           = 0x00  # for grouping (?)
JDesc.xFlags          = 0x04  # see JObj flag bool and mask definitions
JDesc.xChild          = 0x08  # another JObj that's influenced by this one
JDesc.xSibling        = 0x0C  # another JObj that's influenced by the same parent as this one
JDesc.xDObj           = 0x10  # display resources, for model mesh
JDesc.xRotX           = 0x14  #
JDesc.xRotY           = 0x18  # Rotation XYZ
JDesc.xRotZ           = 0x1C  #
JDesc.xScaleX         = 0x20  #
JDesc.xScalyY         = 0x24  # Scale XYZ
JDesc.xScaleZ         = 0x28  #
JDesc.xTransX         = 0x2C  #
JDesc.xTransY         = 0x30  # Translation XYZ
JDesc.xTransZ         = 0x34  #
JDesc.xMtx            = 0x38  # Default matrix (?)
JDesc.xRObj           = 0x3C  # Default RObj (?)

# JObj Instance:
JObj.xInfo            = HSD.Class.xInfo
JObj.xObjID           = HSD.Obj.xObjID
JObj.xSibling         = 0x08
JObj.xParent          = 0x0C
JObj.xChild           = 0x10
JObj.xFlags           = 0x14
JObj.xDObj            = 0x18
JObj.xRotX            = 0x1C
JObj.xRotY            = 0x20
JObj.xRotZ            = 0x24
JObj.xRotQ            = 0x28
JObj.xScaleX          = 0x2C
JObj.xScaleY          = 0x30
JObj.xScaleZ          = 0x34
JObj.xTransX          = 0x38
JObj.xTransY          = 0x3C
JObj.xTransZ          = 0x40
JObj.xStart_MTX       = 0x44 # 3x4
JObj.xMtxX0           = 0x44 # top 3 rows of a 4x4 transformation mtx -- (last row is all 1.0)
JObj.xMtxX1           = 0x48 # - these create a 'model view' for vertex transformations
JObj.xMtxX2           = 0x4C
JObj.xMtxX3           = 0x50
JObj.xMtxY0           = 0x54
JObj.xMtxY1           = 0x58
JObj.xMtxY2           = 0x5C
JObj.xMtxY3           = 0x60
JObj.xMtxZ0           = 0x64
JObj.xMtxZ1           = 0x68
JObj.xMtxZ2           = 0x6C
JObj.xMtxZ3           = 0x70
JObj.xVec             = 0x74
JObj.xMtx             = 0x78
JObj.xAObj            = 0x7C
JObj.xRObj            = 0x80
JObj.xJDesc           = 0x84
JObj.xMtxX            = JObj.xMtxX3
JObj.xMtxY            = JObj.xMtxY3
JObj.xMtxZ            = JObj.xMtxZ3
# last field in each row is an absolute position for model -> camera

# Flags:
JObj.mPad0              = 1<<31; JObj.bPad0              = 0
JObj.mRootTexEdge       = 1<<30; JObj.bRootTexEdge       = 1
JObj.mRootXLU           = 1<<29; JObj.bRootXLU           = 2
JObj.mRootOPA           = 1<<28; JObj.bRootOPA           = 3
JObj.mPad4              = 1<<27; JObj.bPad4              = 4
JObj.mPad5              = 1<<26; JObj.bPad5              = 5
JObj.mMtxIndependSrt    = 1<<25; JObj.bMtxIndependSrt    = 6
JObj.mMtxIndependParent = 1<<24; JObj.bMtxIndependParent = 7
JObj.mUserDef           = 1<<23; JObj.bUserDef           = 8
JObj.mJoint2            = 1<<22
JObj.mJoint1            = 1<<21
JObj.mEffector          = 3<<21
JObj.Joint1   = 1
JObj.Joint2   = 2
JObj.Effector = 3
JObj.mPad12             = 1<<20; JObj.bPad12             = 11
JObj.mXLU               = 1<<19; JObj.bXLU               = 12
JObj.mOPA               = 1<<18; JObj.bOPA               = 13
JObj.mUseQuaternion     = 1<<17; JObj.bUseQuaternion     = 14
JObj.mSpecular          = 1<<16; JObj.bSpecular          = 15
JObj.mFlipIK            = 1<<15; JObj.bFlipIK            = 16
JObj.mSpline            = 1<<14; JObj.bSpline            = 17
JObj.mPBillboard        = 1<<13; JObj.bPBillboard        = 18
JObj.mInstance          = 1<<12; JObj.bInstance          = 19
JObj.mBillboard         = 7<<9;
JObj.Billboard  = 1
JObj.VBillboard = 2
JObj.HBillboard = 3
JObj.RBillboard = 4
JObj.mTexgen            = 1<<8;  JObj.bTexgen            = 23
JObj.mLighting          = 1<<7;  JObj.bLighting          = 24
JObj.mMtxDirty          = 1<<6;  JObj.bMtxDirty          = 25
JObj.mPTCL              = 1<<5;  JObj.bPTCL              = 26
JObj.mHidden            = 1<<4;  JObj.bHidden            = 27
JObj.mClassicalScaling  = 1<<3;  JObj.bClassicalScaling  = 28
JObj.mEnvelopeModel     = 1<<2;  JObj.bEnvelopeModel     = 29
JObj.mSkeletonRoot      = 1<<1;  JObj.bSkeletonRoot      = 30
JObj.mSkeleton          = 1<<0;  JObj.bSkeleton          = 31




# --- LObj
HSD.hsd_LObj_info           = 0x804060C0
HSD.info.LObj               = HSD.hsd_LObj_info

# LObj Descriptor:
LDesc.xName                 = 0x00
LDesc.xSibling              = 0x04
LDesc.xFlags                = 0x08
LDesc.xAttn                 = 0x0A
LDesc.xColor                = 0x0C
LDesc.xR                    = 0x0C
LDesc.xG                    = 0x0D
LDesc.xB                    = 0x0E
LDesc.xA                    = 0x0F
LDesc.xPosition             = 0x10  # WObj Descriptor
LDesc.xInterest             = 0x14  # WObj Descriptor
LDesc.xPoint                = 0x18  # PointDesc or SpotDesc


# LObj Instance:
LObj.xInfo                  = HSD.Class.xInfo
LObj.xObjID                 = HSD.Obj.xObjID
LObj.xFlags                 = 0x08
LObj.xAttn                  = 0x0A
LObj.xNext                  = 0x0C
LObj.xColor                 = 0x10
LObj.xR                     = 0x10
LObj.xG                     = 0x11
LObj.xB                     = 0x12
LObj.xA                     = 0x13
LObj.xHW_Color              = 0x14
LObj.xPosition              = 0x18  # WObj
LObj.xInterest              = 0x1C  # WObj

# for 'attn' (attenuation) LObj types...
LObj.xA0                    = 0x20
LObj.xA1                    = 0x24
LObj.xA2                    = 0x28
LObj.xK0                    = 0x2C
LObj.xK1                    = 0x30
LObj.xK2                    = 0x34

# for 'spot' types...
LObj.xCutoff                = 0x20
LObj.xFuncID                = 0x24
LObj.xRefBrightness         = 0x28
LObj.xRefDistance           = 0x2C
LObj.xDistanceFuncId        = 0x30

LObj.xGXLightID             = 0x4C
LObj.xStart_GXLightObj      = 0x50

LObj.xGXLightID_Spec        = 0x90
LObj.xStart_GXLightObj_Spec = 0x94

# LObj Flags:
LObj.mType                  = 0x3<<0
LObj.Ambient                = 0
LObj.Infinite               = 1
LObj.Point                  = 2
LObj.Spot                   = 3
LObj.mDiffuse               = 1<<2
LObj.mSpecular              = 1<<3
LObj.mAlpha                 = 1<<4
LObj.mHidden                = 1<<5
LObj.mRaw                   = 1<<6
LObj.mDiffDirty             = 1<<7
LObj.mSpecDirty             = 1<<8
LObj.mLightAttn             = 1<<0

# GXLightObj:



# --- Fog ----------------------------------------------------------------------------------------
HSD.hsd_Fog_info    = 0x80407078
HSD.info.Fog        = HSD.hsd_Fog_info

# Fog Descriptor:
FogDesc.xType       = 0x00
FogDesc.xFogAdjDesc = 0x04
FogDesc.xZNear      = 0x08
FogDesc.xZFar       = 0x0C
FogDesc.xColor      = 0x10
FogDesc.xR          = 0x10
FogDesc.xG          = 0x11
FogDesc.xB          = 0x12
FogDesc.xA          = 0x13

# Fog Instance:
Fog.xInfo           = HSD.Class.xInfo
Fog.xObjID          = HSD.Obj.xObjID
Fog.xType           = 0x08
Fog.xFogAdjDesc     = 0x0C
Fog.xZNear          = 0x10
Fog.xZFar           = 0x14
Fog.xColor          = 0x18
Fog.xR              = 0x18
Fog.xG              = 0x19
Fog.xB              = 0x1A
Fog.xA              = 0x1B
Fog.xAObj           = 0x1C




# --- FogAdj -------------------------------------------------------------------------------------
HSD.hsd_FogAdj_info = 0x804070b4
HSD.info.FogAdj = HSD.hsd_FogAdj_info

# FogAdjDesc:
FogAdjDesc.xCenter = 0x00
FogAdjDesc.xWidth = 0x04
FogAdjDesc.xStart_MTX = 0x08

# FogAdj Instance:
FogAdj.xInfo = HSD.Class.xInfo
FogAdj.xObjID = HSD.Obj.xObjID

FogAdj.xCenter = 0x8
FogAdj.xWidth = 0xC
FogAdj.xStart_MTX = 0x10  # these are unchecked




# --- WObj ---------------------------------------------------------------------------------------
HSD.hsd_WObj_info = 0x80406FD0
HSD.info.WObj = HSD.hsd_WObj_info

# WObj Descriptor:
WDesc.xName  = 0x00
WDesc.xX     = 0x04
WDesc.xY     = 0x08
WDesc.xZ     = 0x0C
WDesc.xRDesc = 0x10

# WObj Instance:
WObj.xInfo   = HSD.Class.xInfo
WObj.xObjID  = HSD.Obj.xObjID
WObj.xFlags  = 0x08
WObj.xX      = 0x0C
WObj.xY      = 0x10
WObj.xZ      = 0x14
WObj.xAObj   = 0x18
WObj.xRObj   = 0x1C





# --- CObj ---------------------------------------------------------------------------------------
HSD.hsd_CObj_info     = 0x80406220
HSD.info.CObj         = HSD.hsd_CObj_info

# CObj Descriptor:
CDesc.xName           = 0x00
CDesc.xFlags          = 0x04
CDesc.xProjType       = 0x06
CDesc.xViewportLeft   = 0x08
CDesc.xViewportRight  = 0x0A
CDesc.xViewportTop    = 0x0C
CDesc.xViewportBottom = 0x0E
CDesc.xScissorLeft    = 0x10
CDesc.xScissorRight   = 0x12
CDesc.xScissorTop     = 0x14
CDesc.xScissorBottom  = 0x16
CDesc.xEyePosition    = 0x18  # WObj Eye Position
CDesc.xInterest       = 0x1C  # WObj Interest
CDesc.xRoll           = 0x20
CDesc.xUpVector       = 0x24
CDesc.xNear           = 0x28
CDesc.xFar            = 0x2C
CDesc.xTop            = 0x30
CDesc.xFOV            = 0x30
CDesc.xBottom         = 0x34
CDesc.xAspect         = 0x34
CDesc.xProjLeft       = 0x38
CDesc.xProjRight      = 0x3C

# CObj Instance:
CObj.xInfo            = HSD.Class.xInfo
CObj.xObjID           = HSD.Obj.xObjID
CObj.xFlags           = 0x08
CObj.xViewportLeft    = 0x0C
CObj.xViewportRight   = 0x10
CObj.xViewportTop     = 0x14
CObj.xViewportBottom  = 0x18
CObj.xScissorLeft     = 0x1C
CObj.xScissorRight    = 0x1A
CObj.xScissorTop      = 0x20
CObj.xScissorBottom   = 0x22
CObj.xEyePosition     = 0x24
CObj.xInterest        = 0x28
CObj.xRoll            = 0x2C
CObj.xPitch           = 0x30
CObj.xYaw             = 0x34
CObj.xNear            = 0x38
CObj.xFar             = 0x3C
CObj.xTop             = 0x40
CObj.xFOV             = 0x40
CObj.xBottom          = 0x44
CObj.xAspect          = 0x44
CObj.xProjLeft        = 0x48
CObj.xProjRight       = 0x4C
CObj.xProjType        = 0x50
CObj.xStart_MTX       = 0x54
CObj.xAObj            = 0x84
CObj.xProjMTX         = 0x88




# --- RObj ----------------------------------------------------------------------------------------
# known instance structure:
RObj.xFlags = 0x04
RObj.xJObj  = 0x08
RObj.xAObj  = 0x18




# --- AObjs ---------------------------------------------------------------------------------------
# AObj Descriptor:
ADesc.xFlags            = 0x00
ADesc.xEndFrame         = 0x04
ADesc.xFDesc            = 0x08
ADesc.xAnimJoint        = 0x0C

# AObj Instance:
AObj.xFlags             = 0x00
AObj.xFrame             = 0x04
AObj.xRewindFrame       = 0x08
AObj.xEndFrame          = 0x0C
AObj.xFrameRate         = 0x10
AObj.xFObj              = 0x14
AObj.xObj               = 0x18

# AObj Flags:
AObj.mNoAnim            = 1<<26
AObj.mAnimLoop          = 1<<27
AObj.mNoUpdate          = 1<<28
AObj.mFirstPlay         = 1<<29
AObj.mAnimRewinded      = 1<<30

# Figatree:
Figatree.xType          = 0x00
Figatree.xFrameCount    = 0x08
Figatree.xKeyframeData  = 0x0C
Figatree.xTrackInfo     = 0x10

# Cmpatree:
Cmpatree.xType          = 0x00
Cmpatree.xMatAnimJoint  = 0x04

# Track Info:
TrackInfo.xLength       = 0x00
TrackInfo.xType         = 0x04
TrackInfo.xScale        = 0x05
TrackInfo.xSlope        = 0x06
TrackInfo.xData         = 0x08

# AnimJoint:
AnimJoint.xChild        = 0x00
AnimJoint.xSibling      = 0x04
AnimJoint.xADesc        = 0x08
AnimJoint.xRObjAnim     = 0x0C
AnimJoint.xFlags        = 0x10

# MatAnimJoint:
MatAnimJoint.xChild     = 0x00
MatAnimJoint.xSibling   = 0x04
MatAnimJoint.xMatAnim   = 0x08

# MatAnim:
MatAnim.xSibling        = 0x00
MatAnim.xADesc          = 0x04
MatAnim.xTexAnim        = 0x08
MatAnim.xRenderAnim     = 0x0C

# TexAnim:
TexAnim.xSibling        = 0x00
TexAnim.xGXTexMapID     = 0x04
TexAnim.xADesc          = 0x08
TexAnim.xImageDesc      = 0x0C
TexAnim.xTLutDesc       = 0x10
TexAnim.xImageDescCount = 0x14
TexAnim.xTlutDescCount  = 0x16




# --- FObjs

# FObj Descriptor:
FDesc.xNext       = 0x00
FDesc.xLength     = 0x04
FDesc.xStartFrame = 0x08
FDesc.xType       = 0x0C
FDesc.xScale      = 0x0D
FDesc.xSlope      = 0x0E
FDesc.xData       = 0x10

# FObj Instance:
FObj.xNext        = 0x00
FObj.xParse       = 0x04
FObj.xStart       = 0x08
FObj.xLength      = 0x0C
FObj.xFlags       = 0x10



# --- SObjs

# SObj Descriptor:
SDesc.xModelSet       = 0x00
SDesc.xCamera         = 0x04
SDesc.xLights         = 0x08
SDesc.xFog            = 0x0C

# SObjs Instance:
SObj.xNext            = 0x04
SObj.xPrev            = 0x08
SObj.xGObj            = 0x0C
SObj.xTexture         = 0x44
SObj.xStart_GXTexObj0 = 0x50
SObj.xStart_GXTlutObj = 0x70
SObj.xStart_GXTexObj1 = 0x7C




.endif
