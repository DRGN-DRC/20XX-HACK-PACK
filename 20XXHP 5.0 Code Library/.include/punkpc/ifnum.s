.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module ifnum, 5
.if module.included == 0;  num=0;nnum=1
  .macro ifnum,  n;  num=0
    .irpc c,  \n
      .irpc d,  0123456789
        .ifc \c,  \d;  num=1;.exitm;.endif;.endr;
      .if num == 0
        .irpc d,  +-*%/&^!~()[]
          .ifc \c,  \d;  num=2;.exitm;.endif;.endr;.endif;.exitm;.endr;nnum=!num
  .endm;.macro ifnum_ascii,  n;  num=0
    .irpc c,  \n;  ifnum.__get_ascii "'\c";.exitm;.endr;ifnum.check_ascii
  .endm;.macro ifnum.check_ascii,  set_num=num;  num=\set_num;nnum = 1
    .if num >= 0x28
      .if num <= 0x2D
        nnum=0;.exitm;.endif;.endif;
    .if num >= 0x2F
      .if num <= 0x39
        nnum=0;.exitm;.endif;.endif;
    .irp x,  0x21,  0x25,  0x26,  0x5B,  0x5D,  0x7C,  0x7E
      .if num == \x;  nnum = 0;.exitm;.endif;.endr;
    .if nnum;  num = 0;.endif;
  .endm;.macro ifnum.__get_ascii,  c;  num = \c
  .endm;.endif;

