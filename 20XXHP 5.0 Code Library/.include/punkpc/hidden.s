.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module hidden, 1
.if module.included == 0;  hidden = 0;hidden.count = 0
  .macro hidden,  pfx,  sfx,  m,  va:vararg;  hidden.count = hidden.count + 1
    .ifnb \va;  \m \pfx\()\sfx, \va
    .else;  \m \pfx\()\sfx;.endif;
  .endm;.macro hidden.str,  pfx,  sfx,  m,  va:vararg;  hidden.count = hidden.count + 1
    .ifnb \va;  \m "\pfx\()\sfx", \va
    .else;  \m "\pfx\()\sfx";.endif;
  .endm;.macro hidden.alt,  pfx,  sfx,  m,  va:vararg;  hidden.count = hidden.count + 1
    .ifnb \va;  \m <\pfx\()\sfx>, \va
    .else;  \m <\pfx\()\sfx>
    .endif;.endm;.macro hidden.get,  pfx,  sym;  hidden.get.sfx \pfx, , \sym
  .endm;.macro hidden.set,  pfx,  val;  hidden.set.sfx \pfx, , \val
  .endm;.macro hidden.get.sfx,  pfx,  sfx,  sym=hidden
    hidden \pfx, \sfx, hidden.get.handler \sym
  .endm;.macro hidden.set.sfx,  pfx,  sfx,  val=hidden
    hidden \pfx, \sfx, hidden.set.handler \val
  .endm;.macro hidden.get.handler,  val,  sym;  \sym = \val
  .endm;.macro hidden.set.handler,  sym,  val;  \sym = \val
  .endm;.endif;

