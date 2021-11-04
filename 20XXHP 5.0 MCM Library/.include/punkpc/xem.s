.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module xem, 2
.if module.included == 0
  .macro xem,  p,  x,  s;  .altmacro;xema \p, %\x, \s;.noaltmacro
  .endm;.macro xema,  p,  x,  s;  \p\x\s
  .endm;xem=0;.endif

