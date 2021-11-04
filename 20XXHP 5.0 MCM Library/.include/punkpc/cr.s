.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module cr, 1
.if module.included == 0;  punkpc enum, regs
  .macro cr.__build_set_clr,  cr,  re
    .macro \cr,  d,  va:vararg;  \re \d, \d, \d
    .endm;.endm;.macro cr.enable_overrides
    .if cr.enable_overrides == 0;  cr.enable_overrides = 1;cr.__build_set_clr crset, crorc
      cr.__build_set_clr crclr, crandc;.endif;
  .endm;.macro cr.disable_overrides
    .if cr.enable_overrides;  cr.enable_overrides = 0;.purgem crset;.purgem crclr;.endif;
  .endm;cr.enable_overrides = 0;cr.enable_overrides;.endif

