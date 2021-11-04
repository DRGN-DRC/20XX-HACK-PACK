.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module bcount, 2
.if module.included == 0
  .macro bcount.zbe,  i,  rtrn=bcount;  bcount = 0;bcount.int = \i;bcount.len = 32
    .if !bcount.int;  bcount = 32
    .else;  .rept 5;  bcount.len = bcount.len >> 1
        .if !(bcount.int >> (32-bcount.len))
          bcount.int = bcount.int << bcount.len
          bcount = bcount + bcount.len;.endif;.endr;.endif;\rtrn = bcount
  .endm;.macro bcount.zle,  i,  rtrn=bcount;  bcount = 0;bcount.int = \i;bcount.len = 32
    .if !bcount.int;  bcount = 32
    .else;  .rept 5;  bcount.len = bcount.len >> 1
        .if !(bcount.int << (32-bcount.len))
          bcount.int = bcount.int >> bcount.len
          bcount = bcount + bcount.len;.endif;.endr;.endif;\rtrn = bcount
  .endm;.macro bcount.be,  i,  rtrn=bcount;  bcount.zle \i;bcount = 32-bcount;\rtrn = bcount
  .endm;.macro bcount.le,  i,  rtrn=bcount;  bcount.zbe \i;bcount = 32-bcount;\rtrn = bcount
  .endm;.macro bcount,  i,  rtrn=bcount;  bcount.zbe \i;bcount = 32-bcount;\rtrn = bcount
  .endm;.macro bcount.signed,  i,  rtrn=bcount;  bcount.sign = \i>>31
    .if (\i==-1)||(\i==0);  bcount = 2
    .else;  .if bcount.sign;  bcount.le ~\i
      .else;  bcount.le \i;.endif;bcount=bcount+1;.endif;\rtrn = bcount
  .endm;.macro bcount.zsigned,  i,  rtrn=bcount;  bcount.signed \i;bcount = 32 - bcount
    \rtrn = bcount
  .endm;.endif;

