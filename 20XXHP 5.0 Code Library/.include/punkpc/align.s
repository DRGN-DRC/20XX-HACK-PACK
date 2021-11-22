.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module align, 1
.if module.included == 0;  punkpc ifalt;_align.__start = _punkpc;align.default = 2
  .macro align,  exp=align.default;  align.to \exp
  .endm;.macro align.to,  exp,  lab=_align.__start;  align.__altm = alt;ifalt;align.__alt = alt
    .noaltmacro;align.__noalt (\exp & 0xF), \lab;ifalt.reset align.__alt;alt = align.__altm
  .endm;.macro align.__noalt,  exp,  lab;  align.__exp = 1 << \exp - 1
    align.__exp = (align.__exp - (. - \lab - 1) & align.__exp)
    .if align.__exp;  .zero align.__exp;.endif;
  .endm;.endif;

