.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module hex, 1
.if module.included == 0;  punkpc enc, align
  .macro hex.new,  self,  va:vararg
    .ifnb \self;  enc.new \self
      .if obj.ndef;  stack.purge_hook \self, hex, emit, read;stack.meth \self, emit, read
        .macro \self,  varg:vararg;  stack.call_mut \self, hex, default, \varg
        .endm;\self\().mode push, hex;\self\().i = 0;\self\().emit = 0
        \self\().read_size = 1;\self\().__nib = 0;\self\().__byte = 0;\self\().__align = 0
        \self\().__pushing_hex = 0;.endif;.endif;
  .endm;.macro stack.mut.hex.default,  self,  va:vararg;  \self\().__pushing_hex = 1
    \self\().i = \self\().s;hex.__altm = alt;ifalt;hex.__alt = alt;.noaltmacro
    .ifnb \va;  \self\().enc_raw 0, -1, \va;.endif;hex.__flush_escaped \self
    ifalt.reset hex.__alt;alt = hex.__altm;\self\().__pushing_hex = 0
    .if \self\().emit;  \self\().emit \self\().i;.endif;
  .endm;.macro stack.mut.read.default,  self,  idx,  va:vararg;  hex.__idx = \idx
    .if \self\().read_size > 4
      \self\().read_size = 4;.elseif \self\().read_size < 1;
      \self\().read_size = 1;.endif;hex.__size = \self\().read_size
    .irp sym,  \va
      .ifnb \sym;  hex.__read = 0
        sidx.rept \self, hex.__idx, hex.__size+hex.__idx-1, hex.__read_byte
        \sym = hex.__read;hex.__idx = hex.__idx + hex.__size;.endif;.endr;
  .endm;.macro hex.__read_byte,  arg;  hex.__read = (hex.__read << 8) | \arg
  .endm;.macro stack.mut.emit.default,  self,  beg,  end,  macro=.byte,  va:vararg
    .ifb \beg;  hex.__emit_beg = \self\().q
    .else;  hex.__emit_beg = \beg;.endif;
    .ifb \end;  hex.__emit_end = \self\().s-1
    .else;  hex.__emit_end = \end;.endif;
    stack.rept_range \self, hex.__emit_beg, hex.__emit_end, \macro
  .endm;.macro stack.mut.push.hex,  self,  char,  va:vararg
    .if \self\().__pushing_hex == 0;  stack.mut.push.default \self, \char, \va;.exitm;.endif;
    .if \self\().__pushing_hex == 1
      .if \char == 0x30;  \self\().__pushing_hex = 2
      .else;  hex.__check_escape \self, \char;.endif;
    .else;  hex.__escaping \self, \char;.endif;
  .endm;.macro hex.__flush_escaped,  self
    .if \self\().__pushing_hex == 2;  hex.__check_escape \self, 0x30
    .elseif \self\().__pushing_hex == 3;  .if hex.__align > 1
        hex.__align = (1<<(hex.__align-1))
        hex.__align = (hex.__align - \self\().s) & (hex.__align-1)
        .rept hex.__align;  stack.mut.push.default \self, 0;.endr;.endif;.endif;
    \self\().__pushing_hex = 1;hex.__align = 0
  .endm;.macro hex.__check_escape,  self,  char
    .if (enc.__quotes & 1);  \self\().__pushing_hex = 4
    .elseif \char == 0x2E;  hex.__escape_dot \self
    .elseif ((\char >= 0x30) && (\char <= 0x39));
      hex.__nibble \self, \char - 0x30;.elseif ((\char >= 0x41) && (\char <= 0x46));
      hex.__nibble \self, \char - 0x37;.elseif ((\char >= 0x61) && (\char <= 0x66));
      hex.__nibble \self, \char - 0x57;.endif;
  .endm;.macro hex.__nibble,  self,  val;  \self\().__byte = (\self\().__byte << 4) | (\val)
    .if \self\().__nib;  stack.mut.push.default \self, (\self\().__byte & 0xFF);.endif;
    \self\().__nib = \self\().__nib ^ 1
  .endm;.macro hex.__escaping,  self,  char
    .if \self\().__pushing_hex == 2
      .if ((\char == 0x78) || (\char == 0x58));  \self\().__pushing_hex = 1
      .else;  hex.__flush_escaped \self
        .if \char == 0x30;  \self\().__pushing_hex = 2
        .else;  hex.__check_escape \self, \char;.endif;.endif;
    .elseif \self\().__pushing_hex == 3;  .if \char == 0x2E;  hex.__escape_dot \self
      .else;  hex.__flush_escaped \self;.endif;
    .elseif \self\().__pushing_hex == 4;  .if (enc.__quotes & 1)
        stack.mut.push.default \self, \char
      .else;  \self\().__pushing_hex = 1;.endif;.endif;
  .endm;.macro hex.__escape_dot,  self
    .if \self\().__align < 6
      \self\().__align = \self\().__align + 1;.endif;\self\().__pushing_hex = 3
    .if \self\().__align == 1
      .if \self\().__nib;  hex.__nibble \self, 0;.endif;.endif;
  .endm;.macro hex.__escape_quote,  self;  .endm;hex.new hex;hex.emit = 1;.endif

