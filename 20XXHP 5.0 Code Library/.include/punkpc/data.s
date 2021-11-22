.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module data, 3
.if module.included == 0;  punkpc if, sidx, hex;data.start.inline = 1;data.start.use_blrl = 1
  data.base_reg = 12
  .ifndef punkpc.data.custom_namespace
    .macro data.table,  name,  loc;  punkpc.data.table \name, \loc
    .endm;.macro data.start,  name,  loc;  punkpc.data.start \name, \loc
    .endm;.macro data.end,  reg;  punkpc.data.end \reg
    .endm;.macro data.get,  reg,  keyword,  base_reg
      punkpc.data.get \reg, \keyword, \base_reg
    .endm;.macro data.foot,  va:vararg;  punkpc.data.foot \va
    .endm;.macro data.struct,  idx,  struct_pfx,  names:vararg
      punkpc.data.struct \idx, \struct_pfx, \names
    .endm;.endif;punkpc.data.loc = .;punkpc.data.idx = 0;punkpc.data.endlabels$ = 0
  .macro punkpc.data.loc,  label;  punkpc.data.loc = \label
  .endm;.macro punkpc.data.loc.update,  loc;  punkpc.data.loc.type = 0
    .ifc \loc,  .;  punkpc.data.loc = .;.exitm;.endif;ifnum \loc
    .if num;  punkpc.data.loc.type = 1
      .irpc c,  \loc;  num=1
        .ifc \c,  f;  num=0;.endif;
        .ifc \c,  b;  num=0;.endif;.endr;
      .if num;  punkpc.data.loc.type = 2
        .if punkpc.data.endlabels$;  punkpc.data.loc \loc\()f
        .else;  punkpc.data.loc.type = 3;punkpc.data.loc \loc\()b;.endif;
      .else;  punkpc.data.loc.type = 4' punkpc.data.loc = \loc;.endif;
    .else;  ifdef _data.table$\loc
      .if def;  punkpc.data.loc.type = 5;punkpc.data.loc = _data.table$\loc
      .else;  ifdef \loc
        .if def;  punkpc.data.loc.type = 6;punkpc.data.loc = \loc
        .else;  punkpc.data.loc.type = 7;punkpc.data.loc = _data.table$\loc;.endif;.endif;
    .endif;
  .endm;.macro punkpc.data.table,  name,  loc
    .ifb \loc;  punkpc.data.loc.update \name
      .if punkpc.data.loc.type == 7;  punkpc.data.loc = .;.endif;
    .else;  punkpc.data.loc.update \loc;.endif;
    .ifb \name;  _data.table = punkpc.data.loc
    .else;  punkpc.data.table.update \name;.endif;
  .endm;.macro punkpc.data.table.update,  name=start;  ifdef _data.table$\name
    .if ndef;  _data.table$\name = .;.endif;_data.table$\name = punkpc.data.loc
    _data.table = _data.table$\name
  .endm;.macro punkpc.data.start,  name=start,  loc
    .ifb \loc
      .if data.start.inline;  sidx.get _data.end, punkpc.data.endlabels$ + 1
        _data.end = sidx
        b _data.end;.endif;
      .if data.start.use_blrl
        blrl;.endif;_data.table$start = .;punkpc.data.table start;.endif;
    punkpc.data.table \name, \loc;_data.start = _data.table
  .endm;.macro punkpc.data.end,  reg;  punkpc.data.endlabels$ = punkpc.data.endlabels$ + 1
    sidx = .;sidx.set _data.end, punkpc.data.endlabels$
    .ifnb \reg;  punkpc.data.get \reg;.endif;
  .endm;.macro punkpc.data.foot,  name=foot,  loc;  data.start.inline = 0
    .if punkpc.data.endlabels$;  data.start.use_blrl = 0;.endif;punkpc.data.start \name, \loc
  .endm;.macro punkpc.data.get,  reg,  keyword,  base_reg=data.base_reg
    .ifb \keyword
      bl _data.start - 4
      .ifnb \reg;  data.base_reg = \reg
        mflr \reg;.endif;
    .else;  punkpc.data.loc.update \keyword
      addi \reg, \base_reg, punkpc.data.loc - _data.start;.endif;
  .endm;.macro punkpc.data.struct,  idx=punkpc.data.idx,  pfx,  names:vararg
    .ifnb \pfx\names;  punkpc.data.idx = \idx - 1;punkpc.data.altm = alt;ifalt
      punkpc.data.alt = alt;.altmacro
      .irp name,  \names
        .ifnb \name;  punkpc.data.idx = punkpc.data.idx + 1
          .if punkpc.data.idx == \idx;  _data.struct = .;.endif;
          punkpc.data.struct.eval %punkpc.data.idx, \pfx\name;.endif;.endr;
      ifalt.reset punkpc.data.alt;alt = punkpc.data.altm
    .else;  _data.struct = .;\idx = _data.struct - _data.table;.endif;
  .endm;.macro punkpc.data.struct.eval,  i,  s
    punkpc.data.struct.assign \s, \i\()b - _data.table
  .endm;.macro punkpc.data.struct.assign,  s,  e;  \s = \e
  .endm;.endif;

