.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module mut, 5
.if module.included == 0;  punkpc ifdef;mut.mutable_class$ = 0;mut.mutable_obj$ = 0
  mut.mutator$ = 0;mut.mutable_mode$ = 0;mut.uses_obj_mut_methods = 1
  .macro mut.class,  class,  mut_ns=mut,  hook_ns=hook;  ifdef \class\().is_mutable_class
    .if ndef;  mut.mutable_class$ = mut.mutable_class$ + 1
      \class\().is_mutable_class=mut.mutable_class$;ifdef \class\().uses_obj_mut_methods
      .if ndef;  \class\().uses_obj_mut_methods = mut.uses_obj_mut_methods;.endif;
      .macro \class\().hook,  obj,  hook;  mut.hook \hook, \obj, \class, \mut_ns, \hook_ns
      .endm;.macro \class\().mut,  obj,  mut,  hook
        .ifb \hook
          .ifnb \mut;  mut.obj \obj, \class, \mut_ns, \mut
          .else;  mut.obj \obj, \class, \mut_ns, \hook_ns;.endif;
        .else;  mut.mut \mut, \hook, \obj, \hook_ns;.endif;
      .endm;.macro \class\().mode,  obj,  mode,  hook
        mut.mode \mode, \hook, \obj, \class, \mut_ns, \hook_ns
      .endm;.macro \class\().call_\hook_ns,  obj,  hook,  mode=default,  va:vararg
        mut.call \obj, \hook, \mode, \class, \mut_ns, \hook_ns, \va
      .endm;.macro \class\().purge_hook,  obj,  va:vararg
        .irp hook,  \va;  mut.purge_hook \hook, \obj, \hook_ns;.endr;
      .endm;.endif;
  .endm;.macro mut.obj,  obj,  class,  mut_ns=mut,  hook_ns=hook;  ifdef \obj\().is_mutable_obj
    .if ndef;  mut.mutable_obj$ = mut.mutable_obj$ + 1
      \obj\().is_mutable_obj = mut.mutable_obj$
      .if \class\().uses_obj_mut_methods
        .macro \obj\().hook,  va:vararg
          .irp hook,  \va;  mut.hook \hook, \obj, \class, \mut_ns, \hook_ns;.endr;
        .endm;.macro \obj\().mut,  mut,  va:vararg
          .irp hook,  \va;  mut.mut "\mut", \hook, \obj, \hook_ns;.endr;
        .endm;.macro \obj\().mode,  hook,  va:vararg
          .irp mode,  \va;  mut.mode \mode, \hook, \obj, \class, \mut_ns, \hook_ns;.endr;
        .endm;.endif;.endif;
  .endm;.macro mut.hook,  hook,  obj,  class,  mut_ns=mut,  hook_ns=hook
    mut.purge_hook \hook, \obj, \hook_ns
    .macro \obj\().\hook_ns\().\hook,  va:vararg
      \class\().\mut_ns\().\hook\().default \obj, \va
    .endm;\obj\().\hook_ns\().\hook\().purgable = 1
  .endm;.macro mut.mut,  mut,  hook,  obj,  hook_ns=hook;  mut.purge_hook \hook, \obj, \hook_ns
    .ifb \mut
      .macro \obj\().\hook_ns\().\hook,  va:vararg;  .endm;.else;
      .macro \obj\().\hook_ns\().\hook,  va:vararg;  \mut \obj, \va
      .endm;.endif;\obj\().\hook_ns\().\hook\().purgable = 1
  .endm;.macro mut.mode,  mode=default,  hook,  obj,  class,  mut_ns=mut,  hook_ns=hook
    mut.purge_hook \hook, \obj, \hook_ns;ifdef \class\().\mut_ns\().\hook\().mode$
    .if ndef;  \class\().\mut_ns\().\hook\().mode$ = 0;.endif;
    ifdef \class\().\mut_ns\().\hook\().\mode\().is_mutator_mode
    .if ndef;  mut.mutable_mode$ = mut.mutable_mode$ + 1
      \class\().\mut_ns\().\hook\().\mode\().is_mutator_mode = mut.mutable_mode$
      \class\().\mut_ns\().\hook\().mode$ = \class\().\mut_ns\().\hook\().mode$ + 1
      \class\().\mut_ns\().\hook\().\mode = \class\().\mut_ns\().\hook\().mode$;.endif;
    .macro \obj\().\hook_ns\().\hook,  va:vararg
      \class\().\mut_ns\().\hook\().\mode \obj, \va
    .endm;\obj\().\hook_ns\().\hook\().mode = \class\().\mut_ns\().\hook\().\mode
    \obj\().\hook_ns\().\hook\().purgable = 1
  .endm;.macro mut.call,  obj,  hook,  mode,  class,  mut_ns=mut,  hook_ns=hook,  va:vararg
    .if \obj\().\hook_ns\().\hook\().purgable;  \obj\().\hook_ns\().\hook \va
    .else;  \class\().\mut_ns\().\hook\().\mode \obj, \va;.endif;
  .endm;.macro mut.purge_hook,  hook,  obj,  hook_ns=hook
    ifdef \obj\().\hook_ns\().\hook\().is_mutator
    .if def
      .if \obj\().\hook_ns\().\hook\().purgable;  .purgem \obj\().\hook_ns\().\hook;.endif;
    .else;  mut.mutator$ = mut.mutator$ + 1
      \obj\().\hook_ns\().\hook\().is_mutator = mut.mutator$
      \obj\().\hook_ns\().\hook\().mode = 0;.endif;\obj\().\hook_ns\().\hook\().mode = 0
    \obj\().\hook_ns\().\hook\().purgable = 0
  .endm;.endif;

