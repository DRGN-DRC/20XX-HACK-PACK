.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module str, 0x101
.if module.included == 0;  punkpc ifdef, ifalt, obj;obj.class str;str.self_pointers = 1
  str.__vacount=0;str.__force_litmem=0;str.__logic=0;str.show_warnings=1;str.__mRead = 1
  str.__mWrite=0;str.__mLitmem = 2;str.__mStrmem=0;str.__mLitio = 4;str.__mStrio=0
  str.__mPrefix = 8;str.__mSuffix=0;str.__mAltstr = 16;str.__mNoalt=0
  .macro lit,  va:vararg;  str.__force_litmem=1;str \va
  .endm;.macro str,  self,  varg:vararg;  str.obj \self
    .if ndef;  \self\().litmode=0;\self\().is_blank=1
      .irp method,  .conc,  .pfx,  .str,  .strq,  .conclit,  .pfxlit,  .lit,  .litq,  .concitems,  .pfxitems
        .macro \self\method,  va:vararg;  str.__obj_\method \self, \va
        .endm;.endr;
      .macro \self\().clear;  str.__buildstrmem \self;\self\().is_blank=1
      .endm;.macro \self\().__strbuf_event;  .endm;.endif;str.__vacount \varg
    .if str.__force_litmem;  str.__vacount=2;.endif;str.__force_litmem=0
    .if str.__vacount>1
      str.__buildlitmem \self, , , \varg;.else;  str.__buildstrmem \self, \varg;.endif;
  .endm;.macro str.str,  str,  va:vararg;  str.pointer \str
    str.point, str.__read_handle, str, \va
  .endm;.macro str.lit,  str,  va:vararg;  str.pointer \str
    str.point, str.__read_handle, lit, \va
  .endm;.macro str.strq,  str,  va:vararg;  str.pointer \str
    str.point, str.__read_handle, strq, \va
  .endm;.macro str.litq,  str,  va:vararg;  str.pointer \str
    str.point, str.__read_handle, litq, \va
  .endm;.macro str.conc,  str,  va:vararg;  str.pointer \str
    str.point, str.__write_handle, conc, \va
  .endm;.macro str.pfx,  str,  va:vararg;  str.pointer \str
    str.point, str.__write_handle, pfx, \va
  .endm;.macro str.conclit,  str,  va:vararg;  str.pointer \str
    str.point, str.__write_handle, conclit, \va
  .endm;.macro str.pfxlit,  str,  va:vararg;  str.pointer \str
    str.point, str.__write_handle, pfxlit, \va
  .endm;.macro str.clear,  str;  str.pointer \str;str.point, str.__write_handle, clear
  .endm;.macro str.concitems,  str,  va:vararg;  str.pointer \str
    str.point, str.__write_handle, concitems, \va
  .endm;.macro str.pfxitems,  str,  va:vararg;  str.pointer \str
    str.point, str.__write_handle, pfxitems, \va
  .endm;.macro str.count.items,  str;  str.pointer \str;str.litq str.pointer, str.__vacount
    str.count = str.__vacount
  .endm;.macro str.count.chars,  str;  str.pointer \str;str.strq str.pointer, str.__vachars
    str.count = str.__vacount
  .endm;.macro str.errors,  va:vararg;  str.__qrecurse_iter .error, \va
  .endm;.macro str.error,  va:vararg;  str.__qrecurse .error, \va
  .endm;.macro str.warnings,  va:vararg
    .if str.show_warnings;  str.__qrecurse_iter .warning, \va;.endif;
  .endm;.macro str.warning,  va:vararg
    .if str.show_warnings;  str.__qrecurse .warning, \va;.endif;
  .endm;.macro str.print_lines,  va:vararg;  str.__qrecurse_iter .print, \va
  .endm;.macro str.print_line,  va:vararg;  str.__qrecurse .print, \va
  .endm;.macro str.print,  va:vararg;  str.__qrecurse .print, \va
  .endm;.macro str.ascii,  va:vararg;  str.__qrecurse_iter .ascii, \va
  .endm;.macro str.asciz,  va:vararg;  str.__qrecurse_iter .asciz, \va
  .endm;.macro str.asciiz,  va:vararg;  str.__qrecurse_iter .ascii, \va;.byte 0
  .endm;.macro str.emit,  m,  va:vararg;  ifalt
    .if alt;  st.delimit \m, < >, \va
    .else;  str.delimit \m, " ", \va;.endif;
  .endm;.macro str.delimit,  m,  delimit,  va:vararg;  str str.emitter;ifalt
    .irp str,  \va;  str.emitter.point = 0;str.emitter.eval = 0
      .irpc c,  \str
        .ifc \c,  [;  str.emitter.point = \str;.exitm;.endif;
        .ifc \c,  %;  str.emitter.eval = 1;.exitm;.endif;.exitm;.endr;
      .if str.emitter.eval;  str.emitter.alt = alt;str str.emitter.eval;.altmacro
        str.emitter.eval.conc \str;ifalt.reset str.emitter.alt
        str.emitter.point = str.emitter.eval.is_str;.endif;
      .if str.emitter.point;  str.str str.emitter.point, str.emitter.conc
        .if alt;  str.emitter.conc <\delimit>
        .else;  str.emitter.conc "\delimit";.endif;
      .else;  .if alt;  str.emitter.conc <\str\delimit>
        .else;  str.emitter.conc "\str\delimit";.endif;.endif;.endr;str.emitter.str \m
  .endm;.macro str.irp,  str,  m,  va:vararg;  str.pointer \str
    str.point, str.__irp_handle, 0, "\m", \va
  .endm;.macro str.irpq,  str,  va:vararg;  str.pointer \str
    str.point, str.__irp_handle, 1, \va
  .endm;.macro str.irpc,  str,  va:vararg;  str.pointer \str
    str.point, str.__irpc_handle, 0, \va
  .endm;.macro str.irpcq,  str,  va:vararg;  str.pointer \str
    str.point, str.__irpc_handle, 1, \va
  .endm;.macro str.__logic,  self,  va:vararg;  str.__logic = 0;str.__logic = 0
    str.__Altstr = 0;str.__Prefix=0;ifalt
    .if alt;  str.__logic = str.__logic + str.__mAltstr;str.__Altstr = str.__mAltstr;.endif;
    .if \self\().litmode;  str.__logic = str.__logic + str.__mLitmem;.endif;
    .irp m,  \va;  str.__logic = str.__logic + str.__\m
      .ifc \m,  mPrefix;  str.__Prefix=str.__mPrefix;.endif;.endr;
  .endm;.macro str.__vacount,  va:vararg;  str.__vacount=0
    .irp x,  \va;  str.__vacount = str.__vacount+1;.endr;
  .endm;.macro str.__vachars,  va:vararg;  str.__vacount=0
    .irpc c,  \va;  str.__vacount = str.__vacount+1;.endr;
  .endm;.macro str.__obj_.conc,  self,  va:vararg;  str.__vacount \va
    str.__logic \self, mWrite, mStrio, mSuffix;.altmacro
    .if str.__vacount>1
      str.__strbuf_quoteme \self, %str.__logic, \va;.else;
      str.__strbuf_dispatch \self, %str.__logic, \va;.endif;\self\().is_blank=0
  .endm;.macro str.__obj_.pfx,  self,  va:vararg;  str.__vacount \va
    str.__logic \self, mWrite, mStrio, mPrefix;.altmacro
    .if str.__vacount>1
      str.__strbuf_quoteme \self, %str.__logic, \va;.else;
      str.__strbuf_dispatch \self, %str.__logic, \va;.endif;\self\().is_blank=0
  .endm;.macro str.__obj_.str,  self,  va:vararg;  str.__logic \self, mRead, mStrio, mSuffix
    .altmacro;str.__strbuf_commasuf \self, %str.__logic, \va
  .endm;.macro str.__obj_.strq,  self,  va:vararg;  str.__logic \self, mRead, mStrio, mPrefix
    .altmacro;str.__strbuf_commapre \self, %str.__logic, \va
  .endm;.macro str.__obj_.conclit,  self,  va:vararg;  str.__vacount \va
    str.__logic \self, mWrite, mLitio, mSuffix;.altmacro
    .if str.__vacount>1
      str.__strbuf_dispatch \self, %str.__logic, , \va;.else;
      str.__strbuf_dispatch \self, %str.__logic, \va;.endif;\self\().is_blank=0
  .endm;.macro str.__obj_.pfxlit,  self,  va:vararg;  str.__vacount \va
    str.__logic \self, mWrite, mLitio, mPrefix;.altmacro
    .if str.__vacount>1
      str.__strbuf_dispatch \self, %str.__logic, , \va;.else;
      str.__strbuf_dispatch \self, %str.__logic, \va;.endif;\self\().is_blank=0
  .endm;.macro str.__obj_.lit,  self,  va:vararg;  str.__logic \self, mRead, mLitio, mSuffix
    .altmacro;str.__strbuf_commasuf \self, %str.__logic, \va
  .endm;.macro str.__obj_.litq,  self,  va:vararg;  str.__logic \self, mRead, mLitio, mPrefix
    .altmacro;str.__strbuf_commapre \self, %str.__logic, \va
  .endm;.macro str.__obj_.concitems,  self,  va:vararg;  str.__vacount \va
    str.__logic \self, mWrite, mStrio, mSuffix;.altmacro
    .if \self\().is_blank
      .if str.__vacount>1
        str.__strbuf_quoteme \self, %str.__logic, \va;.else;
        str.__strbuf_dispatch \self, %str.__logic, \va;.endif;
    .else;  .if str.__vacount>1
        str.__strbuf_quoteme \self, %str.__logic, , \va;.else;
        str.__strbuf_dispatch \self, %str.__logic, , \va;.endif;.endif;\self\().is_blank=0
  .endm;.macro str.__obj_.pfxitems,  self,  va:vararg;  str.__vacount \va
    str.__logic \self, mWrite, mStrio, mPrefix;.altmacro
    .if \self\().is_blank
      .if str.__vacount>1
        str.__strbuf_quoteme \self, %str.__logic, \va;.else;
        str.__strbuf_dispatch \self, %str.__logic, \va;.endif;
    .else;  .if str.__vacount>1
        str.__strbuf_quoteme \self, %str.__logic, \va,;.else;
        str.__strbuf_dispatch \self, %str.__logic, \va,;.endif;.endif;\self\().is_blank=0
  .endm;.macro str.__buildstrmem,  self,  strmem;  \self\().litmode = 0
    .purgem \self\().__strbuf_event
    .macro \self\().__strbuf_event,  cb,  a,  va:vararg
      .if str.__Altstr;  str.__strbuf_event$\cb \self, <\a>, <\strmem>, \va
      .else;  str.__strbuf_event$\cb \self, "\a", "\strmem", \va;.endif;
    .endm;.endm;.macro str.__buildlitmem,  self,  pfxmem,  concmem,  litmem:vararg
    \self\().litmode = 1;.purgem \self\().__strbuf_event
    .macro \self\().__strbuf_event,  cb,  a,  va:vararg
      .if str.__Altstr
        .if str.__Prefix
          .if \cb == 27
            str.__strbuf_event$\cb \self, <\a>, \va <\pfxmem\litmem\concmem>
          .else;  str.__strbuf_event$\cb \self, <\a>, \va \pfxmem\litmem\concmem
          .endif;.else;  .if \cb == 19
            str.__strbuf_event$\cb \self, <\a>, <\pfxmem\litmem\concmem> \va
          .else;  str.__strbuf_event$\cb \self, <\a>, \pfxmem\litmem\concmem \va
          .endif;.endif;
      .else;  .if str.__Prefix
          .if \cb == 11
            str.__strbuf_event$\cb \self, "\a", \va "\pfxmem\litmem\concmem"
          .else;  str.__strbuf_event$\cb \self, "\a", \va \pfxmem\litmem\concmem;.endif;
        .else;  .if \cb == 3
            str.__strbuf_event$\cb \self, "\a", "\pfxmem\litmem\concmem" \va
          .else;  str.__strbuf_event$\cb \self, "\a", \pfxmem\litmem\concmem \va;.endif;
        .endif;.endif;
    .endm;.endm;.macro str.__strbuf_dispatch,  self,  cb,  va:vararg
    .if nalt;  .noaltmacro;.endif;\self\().__strbuf_event \cb, \va
  .endm;.macro str.__strbuf_quoteme,  self,  cb,  va:vararg
    .if nalt;  .noaltmacro;\self\().__strbuf_event \cb, "\va"
    .else;  \self\().__strbuf_event \cb, <\va>
    .endif;.endm;.macro str.__strbuf_commapre,  self,  cb,  a,  va:vararg;  str.__vacount \va
    .if str.__vacount == 1
      .ifb \va;  str.__vacount = 0;.endif;.endif;
    .if str.__vacount
      .if nalt;  .noaltmacro;\self\().__strbuf_event \cb, "\a", \va,
      .else;  \self\().__strbuf_event \cb, <\a>, \va,
      .endif;.else;  .if nalt;  .noaltmacro;\self\().__strbuf_event \cb, "\a"
      .else;  \self\().__strbuf_event \cb, <\a>
      .endif;.endif;
  .endm;.macro str.__strbuf_commasuf,  self,  cb,  a,  va:vararg;  str.__vacount \va
    .if str.__vacount
      .if nalt;  .noaltmacro;\self\().__strbuf_event \cb, "\a", \va
      .else;  \self\().__strbuf_event \cb, <\a>, \va
      .endif;.else;  .if nalt;  .noaltmacro;\self\().__strbuf_event \cb, "\a"
      .else;  \self\().__strbuf_event \cb, <\a>
      .endif;.endif;
  .endm;.macro str.__write_handle,  str,  method,  va:vararg;  \str\().\method \va
  .endm;.macro str.__read_handle,  str,  method,  cb,  va:vararg;  str.__vacount \va
    .if str.__vacount == 1
      .ifb \va;  str.__vacount=0;.endif;.endif;
    .if str.__vacount;  \str\().\method \cb, \va
    .else;  \str\().\method \cb;.endif;
  .endm;.macro str.__irpc_handle,  str,  q,  m,  va:vararg;  str str.irpc ".irpc char,"
    str.__vacount \va
    .if str.__vacount == 1
      .ifb \va;  str.__vacount=0;.endif;.endif;
    .if str.__vacount
      .if \q;  \str\().litq str.irpc.conc;str.irpc.conc "; \m \va, \char; .endr"
      .else;  \str\().litq str.irpc.conc;str.irpc.conc "; \m \char, \va; .endr";.endif;
    .else;  \str\().litq str.irpc.conc;str.irpc.conc "; \m \char; .endr";.endif;str.irpc.lit
  .endm;.macro str.__irp_handle,  str,  q,  m,  va:vararg;  str str.irp ".irp item,"
    str.__vacount \va
    .if str.__vacount == 1
      .ifb \va;  str.__vacount=0;.endif;.endif;
    .if str.__vacount
      .if \q;  \str\().litq str.irp.conc;str.irp.conc "; \m \va, \item; .endr"
      .else;  \str\().litq str.irp.conc;str.irp.conc "; \m \item, \va; .endr";.endif;
    .else;  \str\().litq str.irp.conc;str.irp.conc "; \m \item; .endr";.endif;str.irp.lit
  .endm;.macro str.__qrecurse_iter,  m,  str,  va:vararg;  \m "\str"
    .ifnb \va;  str.__qrecurse_iter \m, \va;.endif;
  .endm;.macro str.__qrecurse,  va:vararg;  ifalt
    .if alt;  str.__qrecurse_alt \va
    .else;  str.__qrecurse_nalt \va;.endif;
  .endm;.macro str.__qrecurse_alt,  m,  str,  conc,  va:vararg
    .ifnb \va;  str.__qrecurse_alt \m, <\str\conc>, \va
    .else;  \m "\str\conc";.endif;
  .endm;.macro str.__qrecurse_nalt,  m,  str,  conc,  va:vararg
    .ifnb \va;  str.__qrecurse_nalt \m, "\str\conc", \va
    .else;  \m "\str\conc";.endif;
  .endm;.macro str.__strbuf_event$0,  self,  a,  str,  va:vararg
    str.__buildstrmem \self, "\str\a"
  .endm;.macro str.__strbuf_event$1,  self,  a,  str,  va:vararg;  \a "\str" \va
  .endm;.macro str.__strbuf_event$2,  self,  a,  va:vararg;  str.__buildlitmem \self, , "\a", \va
  .endm;.macro str.__strbuf_event$3,  self,  a,  va:vararg;  \a \va
  .endm;.macro str.__strbuf_event$4,  self,  a,  str,  va:vararg
    str.__buildlitmem \self, , \a, \str\va
  .endm;.macro str.__strbuf_event$5,  self,  a,  str,  va:vararg;  \a \str \va
  .endm;.macro str.__strbuf_event$6,  self,  a,  va:vararg;  str.__buildlitmem \self, , \a, \va
  .endm;.macro str.__strbuf_event$7,  self,  a,  va:vararg;  \a \va
  .endm;.macro str.__strbuf_event$8,  self,  a,  str,  va:vararg
    str.__buildstrmem \self, "\a\str"
  .endm;.macro str.__strbuf_event$9,  self,  a,  str,  va:vararg;  \a \va "\str"
  .endm;.macro str.__strbuf_event$10,  self,  a,  va:vararg
    str.__buildlitmem \self, "\a", , \va
  .endm;.macro str.__strbuf_event$11,  self,  a,  va:vararg;  \a \va
  .endm;.macro str.__strbuf_event$12,  self,  a,  str,  va:vararg
    str.__buildlitmem \self, \a, , \va\str
  .endm;.macro str.__strbuf_event$13,  self,  a,  str,  va:vararg;  \a \va \str
  .endm;.macro str.__strbuf_event$14,  self,  a,  va:vararg;  str.__buildlitmem \self, \a, , \va
  .endm;.macro str.__strbuf_event$15,  self,  a,  va:vararg;  \a \va
  .endm;.macro str.__strbuf_event$16,  self,  a,  str,  va:vararg
    str.__buildstrmem \self, <\str\a>
  .endm;.macro str.__strbuf_event$17,  self,  a,  str,  va:vararg;  \a <\str> \va
  .endm;.macro str.__strbuf_event$18,  self,  a,  va:vararg
    str.__buildlitmem \self, , <\a>, \va
  .endm;.macro str.__strbuf_event$19,  self,  a,  va:vararg;  \a \va
  .endm;.macro str.__strbuf_event$20,  self,  a,  str,  va:vararg
    str.__buildlitmem \self, , \a, \str\va
  .endm;.macro str.__strbuf_event$21,  self,  a,  str,  va:vararg;  \a \str \va
  .endm;.macro str.__strbuf_event$22,  self,  a,  va:vararg;  str.__buildlitmem \self, , \a, \va
  .endm;.macro str.__strbuf_event$23,  self,  a,  va:vararg;  \a \va
  .endm;.macro str.__strbuf_event$24,  self,  a,  str,  va:vararg
    str.__buildstrmem \self, <\a\str>
  .endm;.macro str.__strbuf_event$25,  self,  a,  str,  va:vararg;  \a <\str> \va
  .endm;.macro str.__strbuf_event$26,  self,  a,  va:vararg
    str.__buildlitmem \self, <\a>, , \va
  .endm;.macro str.__strbuf_event$27,  self,  a,  va:vararg;  \a \va
  .endm;.macro str.__strbuf_event$28,  self,  a,  str,  va:vararg
    str.__buildlitmem \self, \a, , \va\str
  .endm;.macro str.__strbuf_event$29,  self,  a,  str,  va:vararg;  \a \va \str
  .endm;.macro str.__strbuf_event$30,  self,  a,  va:vararg;  str.__buildlitmem \self, \a, , \va
  .endm;.macro str.__strbuf_event$31,  self,  a,  va:vararg;  \a \va
  .endm;.endif;

