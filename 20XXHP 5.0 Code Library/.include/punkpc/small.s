.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module small, 0x101
.if module.included == 0;  punkpc bcount, enum, ifalt
  .macro small.__instr_build,  rlw
    .macro \rlw,  va:vararg;  small.__instr_handle \rlw, \va
    .endm;.endm;.macro small.__instr_handle,  va:vararg;  small.__altm = alt;ifalt
    small.__alt = alt;.noaltmacro;small.__instr \va;ifalt.reset small.__alt;alt = ifalt.__altm
  .endm;.macro small.__instr,  rlw,  d,  a,  m,  va:vararg;  .purgem \rlw
    .ifnb \va;  \rlw \d, \a, (\m)&31, \va
    .else;  small.__instr_logic \rlw, \d, \a, \m;.endif;small.__instr_build \rlw
  .endm;.macro small.__instr_logic,  rlw,  d,  a,  m;  small.__beg = 0;small.__end = 0
    small.__rot = 0;small.__inv = 0;small.__ins = 0
    .ifc \rlw,  rlwimi;  small.__ins = 1
    .else;  .ifc \rlw,  rlwimi.;  small.__ins = 1;.endif;.endif;
    .if \m;  bcount.zbe \m, small.__beg;bcount.be \m;small.__end = (bcount-1)&31
      small.__inv = (small.__beg == 0) && (small.__end == 31)
      .if small.__inv;  bcount.zbe ~(\m), small.__end;bcount.be ~(\m), small.__beg
        .if small.__ins;  small.__rot = (32-small.__end)&31;small.__end = small.__end - 1
        .else;  small.__rot = small.__end;small.__beg = small.__beg - small.__end
          small.__end = 31;.endif;
      .else;  small.__rot = (31-small.__end)&31
        .if small.__ins == 0;  small.__end = 31
          small.__beg = (small.__beg + small.__rot)&31;small.__rot = (32-small.__rot)&31
        .endif;.endif;\rlw \d, \a, (small.__rot&31), (small.__beg&31), (small.__end&31)
    .elseif small.__ins == 0;
      li \d, 0;.endif;
  .endm;.macro small.enable_insr_extr
    .if small.enable_insr_extr == 0;  small.enable_insr_extr = 1
      .irp rlw,  rlwinm,  rlwinm.,  rlwimi,  rlwimi.;  small.__instr_build \rlw;.endr;.endif;
  .endm;.macro small.disable_insr_extr
    .if small.enable_insr_extr;  small.enable_insr_extr = 0
      .irp rlw,  rlwinm,  rlwinm.,  rlwimi,  rlwimi.;  .purgem \rlw;.endr;.endif;
  .endm;small.enable_insr_extr = 0;small.enable_insr_extr;.endif

