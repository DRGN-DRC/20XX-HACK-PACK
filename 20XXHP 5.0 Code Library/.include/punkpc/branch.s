.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module branch, 3
.if module.included == 0
  .ifndef branchl.purgem;  branchl.purgem = 0;.endif;
  .if branchl.purgem;  branchl.purgem = 0;.purgem branch;.purgem branchl;.endif;
  .irp x,  branchl,  branch,  bla,  ba
    .irp y,  .purgem;  \x\y = 1;.endr;.endr;
  .macro bla,  a,  b
    .ifb \b
      lis r0, \a @h
      ori r0, r0, \a @l
      mtlr r0
      blrl;.else;
      lis \a, \b @h
      ori \a, \a, \b @l
      mtlr \a
      blrl;.endif;
  .endm;.macro ba,  a,  b
    .ifb \b
      lis r0, \a @h
      ori r0, r0, \a @l
      mtctr r0
      bctr;.else;
      lis \a, \b @h
      ori \a, \a, \b @l
      mtctr \a
      bctr;.endif;
  .endm;.irp l,  l,  ,  
    .macro branch\l,  va:vararg;  b\l\()a \va
    .endm;.endr;.endif;

