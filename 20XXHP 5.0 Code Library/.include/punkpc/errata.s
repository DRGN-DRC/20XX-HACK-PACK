.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module errata, 1
.if module.included == 0;  punkpc obj, sidx, if;errata.uses_mutators = 1;errata.uses_pointers = 1
  errata.self_pointers = 1;errata.uses_obj_mut_methods = 0;obj.class errata
  .macro errata.new,  self,  va:vararg
    .ifnb \self;  errata.obj \self
      .if obj.ndef;  errata.meth \self, ref, solve
        errata.purge_hook \self, ref_iter, solve_iter;\self\().i = 0;\self\().__val = 0
      .endif;errata.new \va;.endif;
  .endm;.macro errata.mut.ref.default,  va:vararg;  errata.__loop ref_iter, \va
  .endm;.macro errata.mut.solve.default,  va:vararg;  errata.__loop solve_iter, \va
  .endm;.macro errata.mut.ref_iter.default,  self,  arg,  va:vararg;  ifnum \arg
    .if num;  errata.__i = errata.__i - 1;\self\().i = \arg
    .else;  sidx.noalt "<\arg = \self>", \self\().i + errata.__i
    .endif;.endm;.macro errata.mut.solve_iter.default,  self,  arg,  va:vararg;  ifnum_ascii \arg
    .if num == '[;  errata.__i = errata.__i - 1;\self\().i = \arg
    .else;  \self\().__val = \arg
      sidx.noalt "<\self>", \self\().i + errata.__i, "< = \self\().__val>"
    .endif;.endm;.macro errata.mut.solve_iter.stack,  self,  va:vararg
    errata.mut.solve_iter.default \self, \va
    .if num != '[;  errata.__i = errata.__i - 1;\self\().i = \self\().i + 1;.endif;
  .endm;errata.meth, ref, solve
  .macro errata.__loop,  meth,  self,  va:vararg;  errata.__i = 0;errata.__altm = alt;ifalt
    errata.__alt = alt;.noaltmacro
    .irp arg,  \va
      .ifnb \arg;  errata.call_mut \self, \meth, default, \arg;.endif;
      errata.__i = errata.__i + 1;.endr;ifalt.reset errata.__alt;alt = errata.__altm
  .endm;.endif;

