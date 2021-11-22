.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module load, 3
.if module.included == 0;  punkpc regs
  .ifndef load.purgem;  load.purgem = 0;.endif;
  .if load.purgem;  .purgem load;.endif;load.purgem = 1
  .irp x,  bufa,  bufb,  bufi,  len,  w,  em,  strinput;  load.__\x=0;.endr;load.opt=1
  .macro load,  r=-31,  va:vararg;  load.__rev=0;i=0;load.__str=0
    .irp x,  bufa,  bufb,  bufi,  len,  w,  em,  strinput;  load.__\x=0;.endr;
    .irpc c,  \r
      .ifc \c,  -;  load.__rev=1;.endif;.exitm;.endr;
    .if load.__rev;  load.__va (-(\r)), \va
    .else;  load.__va \r, \va;.endif;
  .endm;.macro load.__va,  r,  a,  va:vararg
    .ifnb \a;  load.__strinput=0
      .irpc c,  "\a"
        .if load.__strinput;  load.__ch "'\c"
        .else;  .ifc \c,  >
            load.__strinput=1;load.__str=load.__str+1;i=0
          .else;  .exitm;.endif;.endif;.endr;
      .if load.__strinput
        .rept (4-i)&3;  load.__ch 0;.endr;
      .else;  load.__buf \a;.endif;load.__va \r, \va
    .else;  load.__w=load.__bufi;load.__bufi=-1;load.len=load.__w<<2
      .rept load.__w;  load.__bufi=load.__bufi+1
        .if load.__rev;  load.__em \r-load.__bufi
        .else;  load.__em load.__bufi+\r;.endif;.endr;.endif;
  .endm;.macro load.__ch,  c;  i=(i+1)&3
    .if i&1;  load.__bufa=(load.__bufb<<8)|(\c&0xFF)
    .else;  load.__bufb=(load.__bufa<<8)|(\c&0xFF)
    .endif;.ifeq i;  load.__buf load.__bufb;load.__bufb=0;.endif;
  .endm;.macro load.__buf,  i;  xem load.__buf$, load.__bufi, "<=\i>"
    load.__bufi=load.__bufi+1;.endm;.macro load.__em,  r
    xem "<load.__em=load.__buf$>", load.__bufi
    .if load.opt
      .if (load.__em>=-0x7FFF)&&(load.__em<=0x7FFF)
        li \r, load.__em;.else;
        lis \r, load.__em@h
        .if (load.__em&0xFFFF)
          ori \r, \r, load.__em@l;.endif;.endif;
    .else;
      lis \r, load.__em@h
      ori \r, \r, load.__em@l;.endif;
  .endm;.endif;

