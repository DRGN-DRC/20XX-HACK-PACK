.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module lmf, 2
.if module.included == 0;  punkpc regs, idxr
  .macro lmfs,  start,  idxr,  end=31;  lmfs.r = \start & 31;idxr \idxr
    .if \end >= \start
      .rept ((\end&31)+1)-(\start&31)
        lfs lmfs.r, idxr.x(idxr.r);lmfs.r = lmfs.r + 1;idxr.x = idxr.x + 4;.endr;
    .else;  .rept ((\start&31)+1)-(\end&31)
        lfs lmfs.r, idxr.x(idxr.r);lmfs.r = lmfs.r - 1;idxr.x = idxr.x + 4;.endr;.endif;
  .endm;.macro stmfs,  start,  idxr,  end=31;  stmfs.r = \start & 31;idxr \idxr
    .if \end >= \start
      .rept ((\end&31)+1)-(\start&31)
        stfs stmfs.r, idxr.x(idxr.r);stmfs.r = stmfs.r + 1;idxr.x = idxr.x + 4;.endr;
    .else;  .rept ((\start&31)+1)-(\end&31)
        stfs stmfs.r, idxr.x(idxr.r);stmfs.r = stmfs.r - 1;idxr.x = idxr.x + 4;.endr;.endif;
  .endm;.macro lmfd,  start,  idxr,  end=31;  lmfd.r = \start & 31;idxr \idxr
    .if \end >= \start
      .rept ((\end&31)+1)-(\start&31)
        lfd lmfd.r, idxr.x(idxr.r);lmfd.r = lmfd.r + 1;idxr.x = idxr.x + 8;.endr;
    .else;  .rept ((\start&31)+1)-(\end&31)
        lfd lmfd.r, idxr.x(idxr.r);lmfd.r = lmfd.r - 1;idxr.x = idxr.x + 8;.endr;.endif;
  .endm;.macro stmfd,  start,  idxr,  end=31;  stmfd.r = \start & 31;idxr \idxr
    .if \end >= \start
      .rept ((\end&31)+1)-(\start&31)
        stfd stmfd.r, idxr.x(idxr.r);stmfd.r = stmfd.r + 1;idxr.x = idxr.x + 8;.endr;
    .else;  .rept ((\start&31)+1)-(\end&31)
        stfd stmfd.r, idxr.x(idxr.r);stmfd.r = stmfd.r - 1;idxr.x = idxr.x + 8;.endr;.endif;
  .endm;.endif;

