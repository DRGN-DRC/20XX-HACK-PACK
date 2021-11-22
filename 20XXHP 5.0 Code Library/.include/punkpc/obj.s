.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module obj, 2
.if module.included == 0;  punkpc if, hidden, mut;obj.state.altm = alt;obj.state.alt = 0
  objClasses$ = 0;obj.class.uses_pointers = 1;obj.class.self_pointers = 0
  obj.class.uses_mutators = 0;obj.class..uses_obj_mut_methods = 1
  obj.class.uses_pointers.default = 1;obj.class.self_pointers.default = 0
  obj.class.uses_mutators.default = 0;obj.class.uses_obj_mut_methods.default = 1
  .macro obj.class,  class,  class_ppt,  dict=point,  get=pointer,  mut_ns=mut,  hook_ns=hook
    .ifb \class_ppt;  obj.class \class, is_\class, \dict, \get, \mut_ns, \hook_ns;.exitm;.endif;
    obj.state.altm = alt;ifalt;obj.state.alt = alt;ifdef \class\()$
    .if ndef;  \class\()$ = 0;.endif;ifdef \class\().is_objClass
    .if ndef;  \class\().is_objClass = 0;.endif;obj.class_def = 1;obj.class_ndef = 0
    .if \class\().is_objClass == 0;  obj.class_def = 0;obj.class_ndef = 1
      objClasses$ = objClasses$ + 1;\class\().is_objClass = objClasses$
      .irp param,  .uses_pointers,  .self_pointers,  .uses_mutators,  .uses_obj_mut_methods
        ifdef \class, \param
        .if ndef;  \class\param = obj.class\param;.endif;
        .irp conc,  .default;  obj.class\param = obj.class\param\conc;.endr;.endr;
      .macro \class\().obj,  objs:vararg
        .ifb \objs;  \class\().obj $.__anon\@
        .else;  obj.state.altm = alt;ifalt;obj.state.alt = alt
          .irp obj,  \objs
            .ifnb obj;  obj.__check_if_def \obj, .\class_ppt, \class, \dict;.endif;.endr;
          ifalt.reset obj.state.alt;alt = obj.state.altm;.endif;
      .endm;.if \class\().uses_pointers
        .if \class\().uses_mutators
          .macro \class\().meth,  obj,  va:vararg
            .ifb \obj;  obj.__def_class_methods \class, \va
            .else;  \class\().\get \obj
              \class\().\dict, obj.__def_obj_methods, \class, \mut_ns, \hook_ns, \va
            .endif;
          .endm;
          .macro \class\().call_\mut_ns,  self=\class\().\get,  hook,  mode,  va:vararg
            \class\().\get \self
            \class\().\dict, mut.call, \hook, \mode, \class, \mut_ns, \hook_ns, \va
          .endm;mut.class \class, \mut_ns, \hook_ns;.endif;
        .macro \class\().\get,  obj,  sym=\class\().\get;  ifnum \obj;def=nnum;ndef=num
          .if num;  \sym = \obj
          .else;  ifdef \obj, ., \class_ppt
            .if def
              .irp p,  .\class_ppt;  \sym = \obj\p;.endr;
            .else;  ifdef \obj
              .if def;  def=0;ndef=1;\sym = \obj
              .else;  \sym = 0;.endif;.endif;.endif;
        .endm;.macro \class\().\dict,  point=\class\().\get,  va:vararg
          obj.vacount \point;ifalt;.altmacro
          .if obj.vacount > 1
            obj.class.dict.__recurse_start \class, \dict, %\point, , \va
          .elseif \point > 0;
            obj.class.dict.__eval \class, \dict, %\point, \va;.endif;
        .endm;.macro \class\().\dict\()q,  point=\class\().\get,  va:vararg
          obj.vacount \point;ifalt;.altmacro
          .if obj.vacount > 1
            obj.class.dictq.__recurse_start \class, \dict, %\point, , \va
          .elseif \point > 0;
            obj.class.dictq.__eval \class, \dict, %\point, \va;.endif;
        .endm;.macro \class\().call_method,  self=\class\().\get,  meth,  va:vararg
          \class\().\get \self;\class\().\dict, obj.__call_method, \meth, \va
        .endm;
        .macro \class\().set_property,  self=\class\().\get,  ppt,  val=\class\().property
          \class\().\get \self;\class\().\dict, obj.__set_property, \ppt, \val
        .endm;
        .macro \class\().get_property,  self=\class\().\get,  ppt,  sym=\class\().property
          \class\().\get \self;\class\().\dict, obj.__get_property, \ppt, \sym
        .endm;.endif;.endif;ifalt.reset obj.state.alt;alt = obj.state.altm
  .endm;.macro obj.vacount,  va:vararg;  obj.vacount=0
    .irp vacount,  \va;  obj.vacount=obj.vacount+1;.endr;
  .endm;.macro obj.hidden_constructor,  obj,  constr,  va;  hidden "_", ", \obj, \va", \constr
  .endm;.macro obj.__call_method,  a,  b,  va:vararg;  \a\b \va
  .endm;.macro obj.__set_property,  a,  b,  c;  \a\b = \c
  .endm;.macro obj.__get_property,  a,  b,  c;  \c = \a\b
  .endm;.macro obj.__check_if_def,  obj,  ppt,  class,  dict;  ifdef \obj\ppt;obj.def = def
    obj.ndef = ndef
    .if obj.ndef
      .if \class\().uses_mutators;  \class\().mut \obj;.endif;\class\()$ = \class\()$ + 1
      \obj\ppt = \class\()$;.altmacro
      .irp class_ev,  %\class\()$;  .noaltmacro
        .if \class\().uses_pointers
          .macro $.__\class\().\dict\()$\class_ev,  m,  va:vararg
            .ifb \va;  \m \obj
            .else;  \m \obj, \va;.endif;
          .endm;.macro $.__\class\().\dict\()q$\class_ev,  m,  va:vararg
            .ifb \va;  \m \obj
            .else;  \m \va, \obj;.endif;
          .endm;.endif;
        .if \class\().self_pointers;  \obj = \class_ev;.endif;obj.point = \class_ev
        .altmacro;.endr;.endif;
  .endm;.macro obj.__def_obj_methods,  obj,  class,  mut_ns,  hook_ns,  varg:vararg
    .irp m,  \varg
      .ifnb \m;  \class\().purge_hook \obj, \m
        .macro \obj\().\m,  va:vararg
          mut.call \obj, \m, default, \class, \mut_ns, \hook_ns, \va
        .endm;.endif;.endr;
  .endm;.macro obj.__def_class_methods,  class,  varg:vararg
    .irp m,  \varg
      .ifnb \m
        .macro \class\().\m,  obj,  va:vararg;  \class\().call_mut \obj, \m, default, \va
        .endm;.endif;.endr;
  .endm;.macro obj.class.dict.__recurse_start,  class,  dict,  point,  pointcheck,  va:vararg
    $.__\class\().\dict\()$\point obj.class.dict.__recurse, \class, \dict, <>, <>, %\pointcheck, \va
  .endm;
  .macro obj.class.dict.__recurse,  obj,  class,  dict,  comma,  stack,  point,  pointcheck,  va:vararg
    .ifnb \pointcheck
      $.__\class\().\dict\()$\point obj.class.dict.__recurse, \class, \dict, <, >, <\stack\comma \obj>, %\pointcheck, \va
    .else;  obj.class.dict.__recurse_peak \class, \dict, <\stack\comma \obj>, \point, \va
    .endif;.endm;
  .macro obj.class.dict.__recurse_peak,  class,  dict,  stack,  point,  m,  va:vararg
    ifalt.reset
    .ifb \va
      .if alt;  $.__\class\().\dict\()$\point <\m \stack>
      .else;  $.__\class\().\dict\()$\point "\m \stack";.endif;
    .else;  .if alt;  $.__\class\().\dict\()$\point <\m \stack, >, \va
      .else;  $.__\class\().\dict\()$\point "\m \stack,", \va;.endif;.endif;
  .endm;.macro obj.class.dict.__eval,  class,  dict,  point,  va:vararg;  ifalt.reset
    $.__\class\().\dict\()$\point \va
  .endm;.macro obj.class.dictq.__recurse_start,  class,  dict,  point,  pointcheck,  va:vararg
    $.__\class\().\dict\()$\point obj.class.dictq.__recurse, \class, \dict, <>, <>, %\pointcheck, \va
  .endm;
  .macro obj.class.dictq.__recurse,  obj,  class,  dict,  comma,  stack,  point,  pointcheck,  va:vararg
    .ifnb \pointcheck
      $.__\class\().\dict\()$\point obj.class.dictq.__recurse, \class, \dict, <, >, <\stack\comma \obj>, %\pointcheck, \va
    .else;  obj.class.dictq.__recurse_peak \class, \dict, <\stack\comma \obj>, \point, \va
    .endif;.endm;
  .macro obj.class.dictq.__recurse_peak,  class,  dict,  stack,  point,  m,  va:vararg
    ifalt.reset
    .ifb \va
      .if alt;  $.__\class\().\dict\()q$\point <\m>, \stack
      .else;  $.__\class\().\dict\()q$\point "\m", \stack;.endif;
    .else;  .if alt;  $.__\class\().\dict\()q$\point <\m>, \va, \stack
      .else;  $.__\class\().\dict\()q$\point "\m", \va, \stack;.endif;.endif;
  .endm;.macro obj.class.dictq.__eval,  class,  dict,  point,  va:vararg;  ifalt.reset
    $.__\class\().\dict\()q$\point \va
  .endm;.endif;

