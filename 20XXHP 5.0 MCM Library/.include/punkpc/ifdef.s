.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module ifdef, 3
.if module.included == 0;  punkpc ifalt;ifdef.alt = 0
  .macro ifdef,  va:vararg;  ifdef.alt = alt;ifalt;.noaltmacro;ifdef.__recurse \va;ifalt.reset
    alt = ifdef.alt
  .endm;.macro ifdef.__recurse,  sym,  conc,  varargs:vararg
    .ifnb \conc;  ifdef "\sym\conc", \varargs
    .else;  .altmacro;ifdef.alt \sym;.endif;
  .endm;.macro ifdef.alt,  sym;  def=0;def_value=0
    .ifdef sym;  def=1;def_value=\sym;.endif;ndef=def^1
  .endm;.endif;

