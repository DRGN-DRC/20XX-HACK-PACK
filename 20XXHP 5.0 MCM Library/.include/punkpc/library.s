.ifndef punkpc.library.version;  punkpc.library.version = 0;.endif;
.ifeq punkpc.library.version;  punkpc.library.version = 0x100;module.included = 1;_punkpc = .
  .macro module.library,  self,  ext,  default:vararg
    .macro \self,  va:vararg
      .ifb \va
        .ifnb \default;  \self \default;.endif;
      .else;  .irp sym,  \va
          .ifnb \sym;  \self\().__mem_maindir \sym;.endif;.endr;.endif;
    .endm;.macro \self\().raw,  va:vararg
      .irp args,  \va;  module.raw.build_args \self, \args;.endr;
    .endm;.macro \self\().module,  m,  version=1;  module.included "\self", ".\m", ".version"
      .if module.included == 0
        .irp vsn,  ".version";  \self\().\m\vsn = \version;.endr;.endif;
    .endm;.macro \self\().maindir,  main;  .purgem \self\().__mem_maindir
      .macro \self\().__mem_maindir,  str,  args,  lude="lude",  m="\main"
        \self\().__mem_subdir "\m", , , "\str", "\lude", "\args"
      .endm;.endm;.macro \self\().subdir,  sub,  ext;  .purgem \self\().__mem_subdir
      .macro \self\().__mem_subdir,  m,  s="\sub",  e="\ext",  str,  lude,  args
        module.__parse_symdir \self, "\m", "\s", "\e", "\str", "\lude", "\args"
      .endm;.endm;.macro \self\().__mem_subdir;  .endm;.macro \self\().__mem_maindir;  .endm;
    \self\().maindir "\self\()/";\self\().subdir "";\self\().library.included = 1
    \self\().verify_vsn = 1
  .endm;.macro module.included,  __mdul_pfx,  __mdul_mid,  __mdul_suf=".version"
    module.included = 0
    .if \__mdul_pfx\().verify_vsn;  .altmacro
      module.included.alt \__mdul_pfx\__mdul_mid\__mdul_suf;.noaltmacro
      .if module.included
        .if \__mdul_pfx\__mdul_mid\__mdul_suf == 0;  module.included = 0;.endif;.endif;.endif;
  .endm;.macro module.included.alt,  __mdul_vsn;  module.included = 0
    .ifdef __mdul_vsn;  module.included = 1;.endif;
  .endm;.macro module.raw.build_args,  self,  file,  va:vararg
    .ifb \va;  \self\().__mem_maindir \file, , "bin"
    .else;  \self\().__mem_maindir \file, ", \va" , "bin";.endif;
  .endm;.macro module.__parse_symdir,  self,  main,  sub,  ext,  str,  lude,  args
    module.__chbegin = 0;module.__chend = 0;module.__chcount = 0;module.included = 0
    .if \self\().verify_vsn
      .irpc c,  "\str"
        .ifc "\c",  "/";  module.__chbegin = module.__chcount;.endif;
        .ifc "\c",  ".";  module.__chend = module.__chcount;.endif;
        module.__chcount = module.__chcount + 1;.endr;
      .ifb \ext;  module.__chend = 0;.endif;
      .if module.__chend == 0;  module.__chend = module.__chcount;.endif;
      module.___parse_symdir \self, "\str";.endif;
    .if module.included == 0;  .inc\lude "\main\sub\str\ext" \args;.endif;
  .endm;.macro module.___parse_symdir,  self,  str,  sym
    .if module.__chbegin >= module.__chend
      module.__chcount = 0
      .irpc c,  "\str"
        .if module.__chcount < module.__chbegin
          module.__chcount = module.__chcount + 1;.else;
          module.___parse_symdir \self, "\str", "\sym\c";.exitm;.endif;.endr;
    .else;  .if module.__chbegin == 0
        .ifb \sym;  module.___parse_symdir \self, "\str", "\str";.exitm;.endif;.endif;
      module.included \self, ".\sym";.endif;
  .endm;.endif;

