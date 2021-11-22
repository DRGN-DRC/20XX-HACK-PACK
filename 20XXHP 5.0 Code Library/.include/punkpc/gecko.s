.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module gecko, 1
.if module.included == 0;  punkpc errata, align, if;errata.new gecko.block;gecko.block.__open = 0
  .macro gecko.inj,  address;  gecko.end;gecko.block.__open = 1;gecko.block.ref gecko.__size
    .long 0xC2000000 | (0x01FFFFFF & \address), gecko.__size;gecko.__start = .
  .endm;.macro gecko.ovw,  address,  va:vararg;  gecko.end;gecko.__altm = alt;ifalt
    gecko.__alt = alt;gecko.__target = \address - 4;gecko.__quote = 0;.noaltmacro
    gecko.__ovw, \va;ifalt.reset gecko.__alt;alt = gecko.__altm
  .endm;.macro gecko.__ovw,  arg,  va:vararg
    .ifnb \arg;  .long 0x04000000 | (0x01FFFFFF & gecko.__target)
      .if gecko.__quote;  \arg
      .else;  .long \arg;.endif;.endif;gecko.__target = gecko.__target + 4
    .ifnb \va;  .altmacro;gecko.__ovw_alt \va;.noaltmacro
      .if gecko.__quote;  gecko.__ovw \va
      .else;  gecko.__ovw_check \va
        .if num;  gecko.__ovw \va
        .else;  gecko.__ovw_va \va;.endif;.endif;.endif;
  .endm;.macro gecko.__ovw_alt,  arg,  va:vararg;  gecko.__i = 0;gecko.__quote = 0
    .irpc c,  <\arg>
      .if gecko.__i
        .ifc \c\c,  "";  gecko.__quote = 1;.endif;.exitm
      .else;  gecko.__i = 1;.endif;.endr;
  .endm;.macro gecko.__ovw_check,  arg,  va:vararg;  ifnum \arg
  .endm;.macro gecko.__ovw_va,  va:vararg
    .ifnb \va;  .long 0x04000000 | (0x01FFFFFF & gecko.__target);\va;.endif;
  .endm;.macro gecko.end
    .if gecko.block.__open;  gecko.block.__open = 0
      .if (. - gecko.__start) & 7;  .long 0
      .else;
        nop;.long 0;.endif;gecko.size = (. - gecko.__start)>>3
      gecko.block.solve gecko.size;gecko.block.i = gecko.block.i + 1;.endif;
  .endm;.macro gecko,  a,  b:vararg
    .ifnb \a
      .ifnb \b;  gecko.ovw \a, \b
      .else;  gecko.inj \a;.endif;
    .else;  gecko.end;.endif;
  .endm;.endif;

