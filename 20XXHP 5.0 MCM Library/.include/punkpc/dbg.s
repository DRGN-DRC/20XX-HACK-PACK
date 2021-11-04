.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module dbg, 2
.if module.included == 0
  .macro dbg,  i,  x
    .ifb \x;  .altmacro;dbg %\i, \i;.noaltmacro
    .else;  .warning "\x = \i";.endif;
  .endm;.endif;

