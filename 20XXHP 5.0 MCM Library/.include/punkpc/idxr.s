.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module idxr, 2
.if module.included == 0;  punkpc xev;idxr.r=0
  .macro idxr,  xr:vararg
    .irp s,  len,  beg,  dep,  end,  idx,  reg;  idxr.\s=-1;.endr;
    .irpc c,  \xr;  idxr.len=idxr.len+1
      .ifc (,  \c;  idxr.dep=idxr.dep+1
        .if idxr.dep==0;  idxr.beg=idxr.len+1;idxr.end=-1;.endif;.endif;
      .ifc ),  \c;  idxr.dep=idxr.dep-1
        .if idxr.dep==-1;  idxr.end=idxr.len-1;.endif;.endif;.endr;xev 0, idxr.beg-2, \xr
    idxr.x=xev;xev idxr.beg, idxr.end, \xr;idxr.r=xev
  .endm;.endif;

