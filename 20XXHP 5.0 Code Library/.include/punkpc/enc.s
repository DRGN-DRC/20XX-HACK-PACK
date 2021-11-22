.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module enc, 1
.if module.included == 0;  punkpc stack, if;enc.__char = 0;enc.__skip = 0;enc.__exit = 0
  enc.__escaping = 0;enc.__encode_raw = 0;stack enc.__escaped
  .macro enc.new,  self,  st=0,  en=-1;  stack \self
    .if obj.ndef;  \self\().enc_start = \st;\self\().enc_end = \en
      .macro \self\().enc,  str:vararg;  enc.__encode_raw = 0
        enc.__encode \self, \self\().enc_start, \self\().enc_end, \str
      .endm;
      .macro \self\().enc_range,  start=\self\().enc_start,  end=\self\().enc_end,  str:vararg
        enc.__encode_raw = 0;enc.__encode \self, \start, \end, \str
      .endm;
      .macro \self\().enc_raw,  start=\self\().enc_start,  end=\self\().enc_end,  str:vararg
        enc.__encode_raw = 1;enc.__encode \self, \start, \end, "\str"
      .endm;.endif;
  .endm;.macro enc.__encode,  self,  start,  end,  str:vararg;  ifalt;enc.__encode.alt = alt
    .noaltmacro;enc.__escaping = 0;enc.__escapes = 0;enc.__quotes = 0;enc.__skip = 0
    enc.__index = 0;enc.__exit = 0
    .irpc c,  \str
      .if enc.__index >= \start
        enc.__encode.char "'\c+1", "\c "
        .if enc.__escaping == 0
          .if enc.__skip == 0;  \self\().push enc.__char;.endif;
          .if enc.__exit;  .exitm;.endif;
          .if enc.__skip > 0
            enc.__skip = enc.__skip - 1;.endif;.endif;.endif;enc.__index = enc.__index + 1
      .if enc.__index == \end;  enc.__exit = 1;.endif;.endr;ifalt.reset enc.__encode.alt
  .endm;.macro enc.__encode.char,  i,  va:vararg;  enc.__char = \i-1
    .if enc.__escaping < 0
      enc.__escaping = 0;.endif;
    .if enc.__escaping;  enc.__escape
    .elseif enc.__char == 451;  enc.__escaping = -!enc.__encode_raw;enc.__char = 0x22
      enc.__quotes=enc.__quotes + 1
    .elseif enc.__char == 430;  enc.__escaping = !enc.__encode_raw;enc.__char = 0x4C
      enc.__escapes=enc.__escapes + 1;.endif;
  .endm;.macro enc.__escape
    .if enc.__escaping == 1;  enc.__escape.beg
    .elseif enc.__escaping <= 4;
      enc.__escape.oct;.elseif enc.__escaping <= 7;
      enc.__escape.dec;.elseif enc.__escaping <= 9;
      enc.__escape.hex;.else;  enc.__escaping = 0;.endif;
  .endm;.macro enc.__escape.beg
    .if enc.__char == 451;  enc.__escaping = 0;enc.__char = 0x22
    .elseif enc.__char == 430;  enc.__escaping = 0;enc.__char = 0x5C
    .elseif (enc.__char >= 0x30) && (enc.__char <= 0x37);
      enc.__escaping = 2;enc.__escape
    .elseif enc.__char == 0x64;  enc.__escaping = 5
    .elseif enc.__char == 0x78;  enc.__escaping = 8
    .elseif enc.__char == 0x74;  enc.__escaping = 0;enc.__char = 0x9
    .elseif enc.__char == 0x72;  enc.__escaping = 0;enc.__char = 0xD
    .elseif enc.__char == 0x6E;  enc.__escaping = 0;enc.__char = 0xA
    .else;  enc.__escaping = 0;.endif;
  .endm;.macro enc.__escape.oct;  enc.__escaping = enc.__escaping + 1
    .if (enc.__char >= 0x30) && (enc.__char <= 0x37)
      enc.__escaped.push enc.__char & 7
      .if enc.__escaping >= 5
        enc.__escaping = 0;.endif;
    .else;  enc.__escaping = 0;.endif;
    .if enc.__escaping == 0;  enc.__char = 0
      .rept enc.__escaped.s;  enc.__escaped.deq enc.__escaped
        enc.__char = enc.__char << 3 | enc.__escaped
      .endr;.endif;
  .endm;.macro enc.__escape.dec;  enc.__escaping = enc.__escaping + 1
    .if (enc.__char >= 0x30) && (enc.__char <= 0x39)
      enc.__escaped.push enc.__char & 15
      .if enc.__escaping >= 8
        enc.__escaping = 0;.endif;
    .else;  enc.__escaping = 0;.endif;
    .if enc.__escaping == 0;  enc.__char = 0
      .rept enc.__escaped.s;  enc.__escaped.deq enc.__escaped
        enc.__char = enc.__char * 10 + enc.__escaped;.endr;.endif;
  .endm;.macro enc.__escape.hex;  enc.__escaping = enc.__escaping + 1
    .if (enc.__char >= 0x30) && (enc.__char <= 0x39)
      enc.__escaped.push (enc.__char & 15);.else;  enc.__char = enc.__char - 0x37
      .if (enc.__char >= 10) && (enc.__char <= 15)
        enc.__escaped.push enc.__char;.else;  enc.__char = enc.__char - 0x20
        .if (enc.__char >= 10) && (enc.__char <= 15)
          enc.__escaped.push enc.__char;.else;  enc.__escaping = 0;.endif;.endif;.endif;
    .if enc.__escaping >= 10
      enc.__escaping = 0;.endif;
    .if enc.__escaping == 0;  enc.__char = 0
      .rept enc.__escaped.s;  enc.__escaped.deq enc.__escaped
        enc.__char = enc.__char << 4 | enc.__escaped
      .endr;.endif;
  .endm;.endif;

