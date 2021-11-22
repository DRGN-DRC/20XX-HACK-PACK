.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module sidx, 4
.if module.included == 0;  punkpc ifalt;.altmacro
  .macro sidx.em,  p,  i,  s,  va:vararg;  .noaltmacro;\p\()$\i\s\va
  .endm;.macro sidx.ema,  p,  i,  s,  va:vararg;  \p\()$\i\s\va
  .endm;.macro sidx.alt,  p,  i,  s,  va:vararg;  sidx.ema \p, %\i, \s, \va
  .endm;.macro sidx.noalt,  p,  i,  s,  va:vararg;  .altmacro;sidx.em \p, %\i, \s, \va
  .endm;.macro sidx.toalt,  p,  i,  s,  va:vararg;  .altmacro;sidx.ema \p, %\i, \s, \va
  .endm;.macro sidx.em2,  p,  i,  s,  i2,  s2,  va:vararg;  .noaltmacro;\p\()$\i\s\()$\i2\s2\va
  .endm;.macro sidx.ema2,  p,  i,  s,  i2,  s2,  va:vararg;  \p\()$\i\s\()$\i2\s2\va
  .endm;.macro sidx.alt2,  p,  i,  s,  i2,  s2,  va:vararg
    sidx.ema2 \p, %\i, \s, %\i2, \s2, \va
  .endm;.macro sidx.noalt2,  p,  i,  s,  i2,  s2,  va:vararg;  .altmacro
    sidx.em2 \p, %\i, \s, %\i2, \s2, \va
  .endm;.macro sidx.toalt2,  p,  i,  s,  i2,  s2,  va:vararg;  .altmacro
    sidx.ema2 \p, %\i, \s, %\i2, \s2, \va
  .endm;.macro sidx.em3,  p,  i,  s,  i2,  s2,  i3,  s3,  va:vararg;  .noaltmacro
    \p\()$\i\s\()$\i2\s2\()$\i3\s3\va
  .endm;.macro sidx.ema3,  p,  i,  s,  i2,  s2,  i3,  s3,  va:vararg
    \p\()$\i\s\()$\i2\s2\()$\i3\s3\va
  .endm;.macro sidx.alt3,  p,  i,  s,  i2,  s2,  i3,  s3,  va:vararg
    sidx.ema3 \p, %\i, \s, %\i2, \s2, %\i3, \s3 \va
  .endm;.macro sidx.noalt3,  p,  i,  s,  i2,  s2,  i3,  s3,  va:vararg;  .altmacro
    sidx.em3 \p, %\i, \s, %\i2, \s2, %\i3, \s3 \va
  .endm;.macro sidx.toalt3,  p,  i,  s,  i2,  s2,  i3,  s3,  va:vararg;  .altmacro
    sidx.ema3 \p, %\i, \s, %\i2, \s2, %\i3, \s3 \va
  .endm;.macro sidx.em4,  p,  i,  s,  i2,  s2,  i3,  s3,  i4,  s4,  va:vararg;  .noaltmacro
    \p\()$\i\s\()$\i2\s2\()$\i3\s3\()$\i4\s4\va
  .endm;.macro sidx.ema4,  p,  i,  s,  i2,  s2,  i3,  s3,  i4,  s4,  va:vararg
    \p\()$\i\s\()$\i2\s2\()$\i3\s3\()$\i4\s4\va
  .endm;.macro sidx.alt4,  p,  i,  s,  i2,  s2,  i3,  s3,  va:vararg
    sidx.ema4 \p, %\i, \s, %\i2, \s2, %\i3, \s3, %\i4, \s4, \va
  .endm;.macro sidx.noalt4,  p,  i,  s,  i2,  s2,  i3,  s3,  va:vararg;  .altmacro
    sidx.em4 \p, %\i, \s, %\i2, \s2, %\i3, \s3, %\i4, \s4, \va
  .endm;.macro sidx.toalt4,  p,  i,  s,  i2,  s2,  i3,  s3,  va:vararg;  .altmacro
    sidx.ema4 \p, %\i, \s, %\i2, \s2, %\i3, \s3, %\i4, \s4, \va
  .endm;.macro sidx.get,  p,  i;  .altmacro;sidx.ema <sidx=\p>, %\i
    .noaltmacro;.endm;.macro sidx.get2,  p,  i,  i2;  .altmacro
    sidx.ema2 <sidx=\p>, %\i, , %\i2
    .noaltmacro;.endm;.macro sidx.get3,  p,  i,  i2,  i3;  .altmacro
    sidx.ema3 <sidx=\p>, %\i, , %\i2, , %\i3
    .noaltmacro;.endm;.macro sidx.get4,  p,  i,  i2,  i3,  i4;  .altmacro
    sidx.ema4 <sidx=\p>, %\i, , %\i2, , %\i3, , %\i4
    .noaltmacro;.endm;.macro sidx.set,  p,  i;  .altmacro;sidx.ema \p, %\i, <=sidx>
    .noaltmacro;.endm;.macro sidx.set2,  p,  i,  i2;  .altmacro
    sidx.ema2 \p, %\i, , %\i2, <=sidx>
    .noaltmacro;.endm;.macro sidx.set3,  p,  i,  i2,  i3;  .altmacro
    sidx.ema3 \p, %\i, , %\i2, , %\i3, <=sidx>
    .noaltmacro;.endm;.macro sidx.set4,  p,  i,  i2,  i3,  i4;  .altmacro
    sidx.ema4 \p, %\i, , %\i2, , %\i3, , %\i4, <=sidx>
    .noaltmacro;.endm;.noaltmacro
  .macro sidx.rept,  self,  va:vararg;  sidx.memalt = alt;ifalt;sidx.alt = alt
    sidx.__rept \self, +1, \va
  .endm;.macro sidx.__rept,  self,  step,  start=0,  end=0,  macro,  va:vararg
    .if (\step > 0) && (\start > \end)
      sidx.__rept \self, -1, \start, \end, "\macro", \va;.else;  sidx.__rept = \start
      sidx.__rept_count = (\end+1) - \start
      .if sidx.__rept_count < 0
        sidx.__rept_count = -sidx.__rept_count +2;.endif;
      .if sidx.__rept_count
        .rept sidx.__rept_count
          .ifb \va;  sidx.noalt "<sidx.__rept_iter \macro, \self>", sidx.__rept
          .else;  sidx.noalt "<sidx.__rept_iter \macro, \self>", sidx.__rept, , , \va
          .endif;sidx.__rept = sidx.__rept + \step;.endr;ifalt.reset sidx.alt
        alt = sidx.memalt;.endif;.endif;
  .endm;.macro sidx.__rept_iter,  macro,  mem,  va:vararg;  ifalt.reset sidx.alt
    \macro \mem \va
  .endm;.endif;

