.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module sp, 4
.if module.included == 0;  punkpc regs, enum, enc, lmf, spr, items
  .macro sp_obj.init;  .purgem sp_obj.init;sp.frame = 0;sp.mem_ID = 0;sp.mem_ID$ = 0
    sp.lr.__has_items = 0;stack sp.mem;enc.new sp.chars, 0, 1
    .macro sp_obj,  self,  align,  va:vararg;  enum.new \self, \va
      .irp x,  .mode
        .irp y,  count,  restart;  \self\x \y, sp_obj;.endr;.endr;
      .irp x,  .byte_align;  \self\x = \align;.endr;
      .irp x,  .__items;  items.method \self\x;.endr;
      .irp x,  .restart;  \self\x;.endr;
    .endm;sp_obj sp.sprs, 2, , , (0), +1;sp_obj sp.gprs, 2, , , (31), -1
    sp_obj sp.fprs, 3, , , (31), -1;sp_obj sp.temp, 0, sp., , (0), +0;.purgem sp_obj
    sp.sprs.mode enum_parse_iter, sp.sprs;sp.gprs.mode enum_parse, sp.gprs
    sp.fprs.mode enum_parse, sp.fprs;sp.temp.mode enum_parse, sp.temp
    sp.temp.mode numerical, relative
  .endm;.macro enum.mut.count.sp_obj,  self,  va:vararg;  enum.mut.count.default \self, \va
    .if \self\().count > \self\().high
      \self\().high = \self\().count;.elseif \self\().count < \self\().low;
      \self\().low = \self\().count;.endif;
    \self\().bytes = (\self\().high - \self\().low) << \self\().byte_align
  .endm;.macro enum.mut.restart.sp_obj,  self,  va:vararg;  enum.mut.restart.default \self, \va
    \self\().bytes = 0;\self\().low = \self\().count;\self\().high = \self\().count
    \self\().__has_items = 0
  .endm;.macro enum.mut.enum_parse.sp.temp,  va:vararg;  enum.mut.enum_parse.default \va
    .if sp.temp.bytes > 0
      sp.temp.__has_items = 1;.endif;
  .endm;.macro enum.mut.enum_parse.sp.gprs,  va:vararg
    .ifnb \va;  enum.mut.enum_parse.default \va
      .if sp.gprs.__has_items == 0
        .if sp.gprs.bytes;  sp.gprs.__has_items = 1
          sidx.noalt2 "<stmw sp.gprs.lowest>", sp.mem_ID, "<, sp.gprs.base>", sp.mem_ID, "<(sp)>"
        .endif;.endif;.endif;
  .endm;.macro enum.mut.enum_parse.sp.fprs,  va:vararg
    .ifnb \va;  enum.mut.enum_parse.default \va;.endif;
    .if (sp.fprs.high - sp.fprs.low) > sp.fprs.__has_items
      .rept (sp.fprs.high - sp.fprs.low) - sp.fprs.__has_items
        sidx.noalt "<stfd 32-(sp.fprs.__has_items+1), (sp.fprs.__has_items!<!<sp.fprs.byte_align) + sp.fprs.base>", sp.mem_ID, "<(sp)>"
        sp.fprs.__has_items = sp.fprs.__has_items + 1;.endr;.endif;
  .endm;.macro enum.mut.enum_parse_iter.sp.sprs,  self,  spr,  va:vararg
    enum.mut.count.sp_obj \self, sp.sprs.count + sp.sprs.step
    .rept 1
      .ifc \spr,  cr
        mfcr r0;.exitm;.endif;
      .ifc \spr,  CR
        mfcr r0;.exitm;.endif;
      .ifc \spr,  sr
        mfsr r0;.exitm;.endif;
      .ifc \spr,  SR
        mfsr r0;.exitm;.endif;
      .ifc \spr,  msr
        mfmsr r0;.exitm;.endif;
      .ifc \spr,  MSR
        mfmsr r0;.exitm;.endif;ifdef spr.\spr
      .if ndef
        mfspr r0, \spr;.else;
        mfspr r0, spr.\spr;.endif;.endr;
    sidx.noalt "<stw r0, (sp.sprs.__has_items !<!< sp.sprs.byte_align) + sp.sprs.base>", sp.mem_ID, "<(sp)>"
    sp.sprs.__has_items = sp.sprs.__has_items + 1
    .if sp.prolog;  sp.sprs.__items, \spr;.endif;
  .endm;.macro sp.push,  va:vararg
    sp.mem.push sp.sprs.__items, sp.prolog, sp.frame, sp.mem_ID, sp.lr.__has_items , sp.fprs.count, sp.gprs.count, sp.sprs.count, sp.temp.count , sp.fprs.step, sp.gprs.step, sp.sprs.step, sp.temp.step , sp.fprs.bytes, sp.gprs.bytes, sp.sprs.bytes, sp.temp.bytes , sp.fprs.low, sp.gprs.low, sp.sprs.low, sp.temp.low , sp.fprs.high, sp.gprs.high, sp.sprs.high, sp.temp.high , sp.fprs.total, sp.gprs.total, sp.sprs.total, sp.temp.total , sp.fprs.base, sp.gprs.base, sp.sprs.base, sp.temp.base , sp.fprs.__has_items, sp.gprs.__has_items, sp.sprs.__has_items, sp.temp.__has_items
    sp.prolog = 0;sp.epilog = 0;sp.fprs.restart;sp.gprs.restart;sp.sprs.restart;sp.temp.restart
    items.alloc sp.sprs.__items;sp.mem_ID$ = sp.mem_ID$ + 1;sp.mem_ID = sp.mem_ID$
    sp.temp.low = 0;sp.temp.high = 16;sp.temp.bytes = 16;sp.temp.count = 16
    sp.lr.__has_items = 0;sp.__errata
    .irp arg,  \va
      .ifnb \arg;  sp.chars.reset;sp.chars.enc \arg;num = sp.chars$0
        .if num == 'r;  sp.__checkreg \arg, sp.gprs
        .elseif num == 'f;  sp.__checkreg \arg, sp.fprs
        .elseif num == 'x;  sp.__checkx \arg, sp.temp.__items
        .else;  sp.__checkelse \arg;.endif;.endif;.endr;
    .if sp.lr.__has_items
      mflr r0;.endif;sidx.noalt "<stwu sp, -sp.frame>", sp.mem_ID, "<(sp)>"
    .if sp.lr.__has_items;  sidx.noalt "<stw r0, sp.frame>", sp.mem_ID, "< + 4 (sp)>"
    .endif;sp.temp.__items sp.temp;sp.sprs.__items sp.sprs;sp.gprs.__items sp.gprs
    sp.fprs.__items sp.fprs;sp.prolog = sp.mem_ID;sp.fprs.__items;sp.gprs.__items
    sp.temp.__items
  .endm;.macro sp.commit
    .if sp.epilog == 0;  sp.epilog = sp.mem_ID
      sidx.noalt "<sp.temp.base>", sp.mem_ID, "< = sp.temp.base>"
      sidx.noalt "<sp.temp.total>", sp.mem_ID, "< = sp.temp.bytes>"
      sidx.noalt "<sp.temp.total = sp.temp.total>", sp.mem_ID
      sidx.noalt3 "<sp.sprs.base>", sp.mem_ID, "< = (sp.temp.total>" , sp.mem_ID, "< + sp.temp.base>", sp.mem_ID, "< + 3) !& ~3>"
      sidx.noalt "<sp.sprs.total>", sp.mem_ID, "< = sp.sprs.bytes>"
      sidx.noalt "<sp.sprs.total = sp.sprs.total>", sp.mem_ID
      sidx.noalt3 "<sp.gprs.base>", sp.mem_ID, "< = (sp.sprs.total>" , sp.mem_ID, "< + sp.sprs.base>", sp.mem_ID, "< + 3) !& ~3>"
      sidx.noalt "<sp.gprs.total>", sp.mem_ID, "< = sp.gprs.bytes>"
      sidx.noalt "<sp.gprs.total = sp.gprs.total>", sp.mem_ID
      sidx.noalt "<sp.gprs.lowest>", sp.mem_ID, "< = sp.gprs.low+1>"
      sp.gprs.lowest = sp.gprs.low+1
      sidx.noalt3 "<sp.fprs.base>", sp.mem_ID, "< = (sp.gprs.total>" , sp.mem_ID, "< + sp.gprs.base>", sp.mem_ID, "< + 7) !& ~7>"
      sidx.noalt "<sp.fprs.total>", sp.mem_ID, "< = sp.fprs.bytes>"
      sidx.noalt "<sp.fprs.total = sp.fprs.total>", sp.mem_ID
      sidx.noalt "<sp.fprs.lowest>", sp.mem_ID, "< = sp.fprs.low+1>"
      sp.fprs.lowest = sp.fprs.low+1
      sidx.noalt3 "<sp.frame>", sp.mem_ID, "< = (sp.fprs.base>" , sp.mem_ID, "< + sp.fprs.total>", sp.mem_ID, "< + 15) !& ~15>"
      sidx.noalt "<sp.frame = sp.frame>", sp.mem_ID;.endif;.endm;.macro sp.pop,  va:vararg
    regs.restart;sp.commit
    .if sp.fprs.__has_items;  lmfd 31, sp.fprs.base(sp), sp.fprs.lowest;.endif;
    .if sp.gprs.__has_items
      lmw sp.gprs.lowest, sp.gprs.base(sp);.endif;
    .if sp.sprs.__has_items;  sp.sprs.__items sp.__lmspr;.endif;
    .if sp.lr.__has_items
      lwz r0, sp.frame+4(sp);.endif;
    addi sp, sp, sp.frame
    .if sp.lr.__has_items
      mtlr r0;.endif;sp.epilog = 0;items.free sp.sprs.__items
    sp.mem.popm , sp.temp.__has_items, sp.sprs.__has_items, sp.gprs.__has_items, sp.fprs.__has_items , sp.temp.base, sp.sprs.base, sp.gprs.base, sp.fprs.base , sp.temp.total, sp.sprs.total, sp.gprs.total, sp.fprs.total , sp.temp.high, sp.sprs.high, sp.gprs.high, sp.fprs.high , sp.temp.low, sp.sprs.low, sp.gprs.low, sp.fprs.low , sp.temp.bytes, sp.sprs.bytes, sp.gprs.bytes, sp.fprs.bytes , sp.temp.step, sp.sprs.step, sp.gprs.step, sp.fprs.step sp.temp.count, sp.sprs.count, sp.gprs.count, sp.fprs.count , sp.lr.__has_items, sp.mem_ID, sp.frame, sp.prolog, sp.sprs.__items
    sp.__errata
  .endm;.macro prolog,  va:vararg;  sp.push lr, \va
  .endm;.macro epilog,  va:vararg;  sp.pop
  .endm;.macro sp.__errata
    .if sp.mem_ID;  sp.temp.base = 0;sidx.noalt "<sp.frame = sp.frame>", sp.mem_ID
      sidx.noalt "<sp.temp.total = sp.temp.total>", sp.mem_ID
      sidx.noalt "<sp.sprs.total = sp.sprs.total>", sp.mem_ID
      sidx.noalt "<sp.gprs.total = sp.gprs.total>", sp.mem_ID
      sidx.noalt "<sp.fprs.total = sp.fprs.total>", sp.mem_ID
      sidx.noalt "<sp.sprs.base =  (sp.temp.total>", sp.mem_ID, "< + 3) !& ~3>"
      sidx.noalt "<sp.gprs.base = (sp.sprs.base + sp.sprs.total>", sp.mem_ID, "< + 3) !& ~3>"
      sidx.noalt "<sp.fprs.base = (sp.gprs.base + sp.gprs.total>", sp.mem_ID, "< + 7) !& ~7>"
      sidx.noalt "<sp.gprs.lowest = sp.gprs.lowest>", sp.mem_ID
      sidx.noalt "<sp.fprs.lowest = sp.fprs.lowest>", sp.mem_ID;.endif;.endm;
  .macro sp.__lmspr,  va:vararg;  lmspr r0, sp.sprs.base(sp), \va
  .endm;.macro sp.__checkreg,  arg,  enum
    .if (sp.chars$1 >= 0x30) && (sp.chars$1 <=0x33)
      enum.mut.count.sp_obj \enum, \arg
      enum.mut.count.sp_obj \enum, \enum\().count + \enum\().step
    .else;  sp.__checkx \arg, \enum\().__items;.endif;
  .endm;.macro sp.__checkx,  arg,  items
    .if (sp.chars$1 >= 0x41) && (sp.chars$1 < 0x60)
      \items, \arg;.else;  sp.__checkelse \arg;.endif;
  .endm;.macro sp.__checkelse,  arg
    .ifc \arg,  lr;  sp.lr.__has_items = 1;.exitm;.endif;
    .ifc \arg,  LR;  sp.lr.__has_items = 1;.exitm;.endif;
    .ifc \arg,  no_lr;  sp.lr.__has_items = 0;.exitm;.endif;
    .ifc \arg,  NO_LR;  sp.lr.__has_items = 0;.exitm;.endif;ifnum.check_ascii
    .if num;  sp.temp.__items, , \arg
    .else;  ifdef spr., \arg
      .if def;  sp.sprs.__items, \arg
      .else;  sp.temp.__items, \arg;.endif;.endif;
  .endm;sp_obj.init;.endif

