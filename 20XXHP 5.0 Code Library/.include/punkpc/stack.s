.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module stack, 0x202
.if module.included == 0;  punkpc sidx, if, obj;stack.fill = 0;stack.size = 0;stack.sss = 1<<31-1
  stack$ = 0;stack.idx = 0;stack.oob = 0;stack.uses_mutators = 1;obj.class stack;mut.class stack
  .macro stack,  self,  varg:vararg;  stack.obj \self
    .if obj.ndef;  \self\().s = stack.size;ifdef \self
      .if ndef;  \self = stack.fill;.endif;
      .irp ppt,  s,  ss,  pop,  q,  qq;  \self\().\ppt=0;.endr;
      \self\().init_size = stack.size;\self\().fill = stack.fill;\self\()$0 = stack.fill
      \self\().sss = stack.sss
      .if \self\().init_size > 0
        .altmacro;stack.fill \self, 0, \self\().size, \self\().fill;.noaltmacro;.endif;
      .macro \self\().reset,  fill,  start=\self\().qq,  size=\self\().init_size,  va:vararg
        mut.call \self, reset, default, stack, , , \fill, \start, \size, \va
      .endm;.macro \self\().push,  va:vararg=\self
        mut.call \self, push, default, stack, , , \va
      .endm;.macro \self\().pop,  va:vararg=\self\().pop
        mut.call \self, pop, default, stack, , , \va
      .endm;.macro \self\().popm,  va:vararg;  mut.call \self, popm, default, stack, , , \va
      .endm;.macro \self\().deq,  va:vararg=\self\().deq
        mut.call \self, deq, default, stack, , , \va
      .endm;stack.mut \self
    .else;  mut.call \self, reset, default, stack;.endif;
    stack.purge_hook \self, fill, s, ss, q, new, reset, push, pop, popm, deq, oob_push, oob_pop, oob_deq
    .ifnb \varg;  stack \varg
    .else;  .irp ppt,  fill,  size,  ;  stack.\ppt = 0;.endr;.endif;
  .endm;stack.meth, fill, s, ss, q, new, reset, push, pop, popm, deq
  .macro stack.rept,  self,  va:vararg;  sidx.memalt = alt;ifalt;sidx.alt = alt
    stack.pointer \self;stack.point, stack.__rept, +1, , , \va
  .endm;.macro stack.rept_range,  self,  va:vararg;  sidx.memalt = alt;ifalt;sidx.alt = alt
    stack.pointer \self;stack.point, stack.__rept, +1, \va
  .endm;.macro stack.__rept,  self,  step,  start,  end,  macro,  va:vararg
    .ifb \start;  stack.__rept \self, +1, \self\().q, \self\().s-1, "\macro", \va
    .else;  sidx.__rept \self, \step, \start, \end, "\macro", \va;.endif;
  .endm;.macro stack.__check_first_blank,  arg,  va:vararg
    .ifb \arg;  stack.__check_blank = 1
    .else;  stack.__check_blank = 0;.endif;
  .endm;.macro stack.__fill,  self,  start,  size,  fill;  LOCAL i, idx, f
    .ifb \start;  idx = \self\().qq
    .else;  idx = \start;.endif;
    .ifb \size;  i = \self\().init_size
    .else;  i = \size;.endif;
    .ifb \fill;  f = \self\().fill
    .else;  i = \fill;.endif;
    .if \self\().sss < (idx+i)
      i = \self\().sss - idx;.endif;
    .if (idx <= \self\().ss) && (\self\().ss < (idx+i))
      \self\().ss = idx+i;.endif;
    .if i > 0
      .rept i;  sidx.ema \self, %idx, <=f>
        idx=idx+1;.endr;.endif;
  .endm;.macro stack.mut.fill.default,  va:vararg;  .altmacro;stack.__fill \va
  .endm;.macro stack.mut.s.default,  self,  idx,  va:vararg
    .ifb \idx;  stack.mut.s.default \self, \self\().ss
    .else;  \self\().s=\idx
      .if \idx > \self\().ss
        \self\().s=\self\().ss;.endif;.endif;
  .endm;.macro stack.mut.ss.default,  self,  idx,  va:vararg
    .ifb \idx;  stack.mut.ss.default \self, \self\().ss
    .else;  \self\().s=\idx
      .if \idx > \self\().sss
        \self\().s = \self\().sss;.endif;
      .if \idx > \self\().ss
        \self\().ss=\self\().s;.endif;.endif;
  .endm;.macro stack.mut.q.default,  self,  idx,  va:vararg
    .ifb \idx;  stack.mut.q.default \self, \self\().qq
    .else;  \self\().q=\idx
      .if \idx < \self\().qq
        \self\().q=\self\().qq;.endif;.endif;
  .endm;.macro stack.mut.new.default,  self,  size=1,  fill,  va:vararg
    .ifb \fill;  stack.mut.new.default \self, \size, \self\().fill
    .else;  stack.fill \self, \self\().ss+1, \size, \fill;.endif;
  .endm;.macro stack.mut.popm.default,  self,  va:vararg;  stack.pop \self
    .ifnb \va;  stack.pop \self, \va;.endif;
  .endm;.macro stack.mut.reset.default,  self,  fill,  start,  size
    .ifb \start;  stack.mut.reset.default \self, \fill, \self\().qq, \size;.exitm;.endif;
    .ifb \size;  stack.mut.reset.default \self, \fill, \start, \self\().init_size;.exitm;.endif;
    \self\().q = \start;\self\().s = \self\().q + \size
    .ifnb \fill;  stack.fill \self, \self\().q, \size, \fill;.endif;
    .if \self\().q < \self\().qq
      \self\().q = \self\().qq;.endif;
    .if \self\().s > \self\().ss
      \self\().s = \self\().ss;.endif;
  .endm;.macro stack.mut.push.default,  self,  va:vararg
    .ifb \va;  stack.mut.push.default, \self, \self
    .else;  ifalt;stack.memalt = alt;.altmacro
      .irp val,  \va
        .ifnb \val
          .if \self\().s < \self\().sss
            .if \self\().s >= \self\().ss
              stack.oob=1;mut.call \self, oob_push, incr, stack, , , \val;.endif;
            .if stack.oob==0;  sidx.ema \self, %\self\().s, <=\val>
              \self\().s = \self\().s + 1;\self = \self\().fill;.endif;.endif;.endif;
        stack.oob=0;.endr;ifalt.reset stack.memalt;stack.oob=0;.endif;
  .endm;.macro stack.mut.pop.default,  self,  va:vararg
    .ifb \va;  stack.mut.pop.default \self, \self\().pop
    .else;  ifalt;stack.memalt = alt;.altmacro
      .irp sym,  \va
        .ifnb \sym
          .if \self\().s <= \self\().q
            stack.oob=1;mut.call \self, oob_pop, null, stack, , , \sym;.endif;
          .if stack.oob==0;  \self\().pop = \self;\sym = \self
            \self\().s = \self\().s - 1;sidx.ema <\self = \self>, %\self\().s
          .endif;.endif;stack.oob=0;.endr;ifalt.reset stack.memalt;stack.oob=0;.endif;
  .endm;.macro stack.mut.deq.default,  self,  va:vararg
    .ifb \va;  stack.mut.deq.default, \self, \self\().deq
    .else;  stack.memalt = alt;.altmacro
      .irp sym,  \va
        .ifnb \sym;  stack.oob=0
          .if \self\().q+1 >= \self\().s
            stack.oob=1;mut.call \self, oob_deq, null, stack, , , \sym;.endif;
          .if stack.oob==0;  sidx.ema <\self\().deq=\self>, %\self\().q
            \sym = \self\().deq;\self\().q = \self\().q + 1;.endif;.endif;stack.oob=0;.endr;
      ifalt.reset stack.memalt;stack.oob=0;.endif;
  .endm;.macro stack.mut.s.relative,  self,  idx=1,  va:vararg
    stack.mut.s.default \self, \self\().s + \idx, \va
  .endm;.macro stack.mut.push.skip_blank,  self,  va:vararg;  stack.__check_first_blank \va
    .if stack.__check_blank;  stack.mut.s.relative \self, \va
    .else;  stack.mut.push.default \self, \va;.endif;
  .endm;.macro stack.mut.oob_pop.default,  va:vararg;  stack.mut.oob_pop.null \va
  .endm;.macro stack.mut.oob_deq.default,  va:vararg;  stack.mut.oob_deq.null \va
  .endm;.macro stack.mut.oob_push.default,  va:vararg;  stack.mut.oob_push.incr \va
  .endm;.macro stack.mut.oob_push.nop,  self,  va:vararg;  stack.oob=0
  .endm;.macro stack.mut.oob_pop.nop,  self,  va:vararg;  stack.oob=0
  .endm;.macro stack.mut.oob_deq.nop,  self,  va:vararg;  stack.oob=0
  .endm;.macro stack.mut.oob_push.rot,  self,  sym,  va:vararg;  \self\().s = \self\().qq
    stack.oob = 0
    .if \self\().q > \self\().s
      \self\().q = \self\().s;.endif;
  .endm;.macro stack.mut.oob_pop.rot,  self,  sym,  va:vararg;  \self\().s = \self\().ss
    stack.oob = 0
  .endm;.macro stack.mut.oob_deq.rot,  self,  sym,  va:vararg
    sidx.ema <\self\().deq=\self>, %\self\().q
    \sym = \self\().deq;\self\().q = \self\().qq
  .endm;.macro stack.mut.oob_push.incr,  self,  va:vararg;  \self\().ss = \self\().s + 1
    stack.oob = 0
  .endm;.macro stack.mut.oob_push.step,  self,  va:vararg
    \self\().ss = \self\().s + \self\().step;\self\().s = \self\().s + \self\().step - 1
    stack.oob = 0
  .endm;.macro stack.mut.oob_pop.null,  self,  sym,  va:vararg;  \sym = \self
    \self = \self\().fill
  .endm;.macro stack.mut.oob_deq.null,  self,  sym,  va:vararg
    .if \self\().q == \self\().s;  \sym=\self\().fill;\self\().deq = \sym
    .else;  sidx.ema <\self\().deq=\self>, %\self\().q
      \sym = \self\().deq;\self\().reset, , 0;.endif;
  .endm;.macro stack.mut.oob_pop.cap,  self,  va:vararg;  \self\().s = \self\().q+1;stack.oob=0
  .endm;.macro stack.mut.oob_deq.cap,  self,  va:vararg;  \self\().q = \self\().s-1;stack.oob=0
  .endm;.endif;

