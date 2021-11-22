.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module en, 0x100
.if module.included == 0
  .macro en,  va:vararg
    .irp sym,  \va
      .ifnb \sym
        .irpc c,  \sym
          .ifc \c,  (;  en.count=\sym;.exitm;.endif;
          .ifc \c,  +;  en.step=\sym;.exitm;.endif;
          .ifc \c,  -;  en.step=\sym;.exitm;.endif;\sym=en.count
          en.count=en.count+en.step;.exitm;.endr;.endif;.endr;
  .endm;.macro en.restart;  en.count = en.count.restart;en.step = en.step.restart
  .endm;.macro en.save,  dict;  \dict\().count = en.count;\dict\().step = en.step
  .endm;.macro en.load,  dict;  en.count = \dict\().count;en.step = \dict\().step
  .endm;en.count.restart = 0;en.step.restart = 1;en.restart;.endif

