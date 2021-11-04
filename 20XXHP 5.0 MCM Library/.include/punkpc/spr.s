.ifndef punkpc.library.included
  .include "punkpc.s";.endif;punkpc.module spr, 3
.if module.included == 0;  punkpc idxr, regs
  .macro lmspr,  a,  idxr,  sprs:vararg;  idxr \idxr;spr_count = 0
    .irp spr,  \sprs
      .ifnb \spr;  spr_count = spr_count + 1
        .rept 1
          .ifc \spr,  cr
            lwz \a, idxr.x(idxr.r)
            mtcr \a;idxr.x=idxr.x+4;.exitm;.endif;
          .ifc \spr,  CR
            lwz \a, idxr.x(idxr.r)
            mtcr \a;idxr.x=idxr.x+4;.exitm;.endif;
          .ifc \spr,  sr
            lwz \a, idxr.x(idxr.r)
            mtsr \a;idxr.x=idxr.x+4;.exitm;.endif;
          .ifc \spr,  SR
            lwz \a, idxr.x(idxr.r)
            mtsr \a;idxr.x=idxr.x+4;.exitm;.endif;
          .ifc \spr,  msr
            lwz \a, idxr.x(idxr.r)
            mtmsr \a;idxr.x=idxr.x+4;.exitm;.endif;
          .ifc \spr,  MSR
            lwz \a, idxr.x(idxr.r)
            mtmsr \a;idxr.x=idxr.x+4;.exitm;.endif;spr.__i=0
          .irpc c,  \spr
            .irpc n,  0123456789
              .ifc \n,  \c;  spr.__i=1;.exitm;.endif;.endr;.exitm;.endr;
          .if spr.__i
            lwz \a, idxr.x(idxr.r)
            mtspr spr.\spr, \a;idxr.x=idxr.x+4
          .else;
            lwz \a, idxr.x(idxr.r)
            mtspr spr.\spr, \a;idxr.x=idxr.x+4;.endif;.endr;.endif;.endr;
  .endm;.macro stmspr,  a,  idxr,  sprs:vararg;  idxr \idxr;spr_count = 0
    .irp spr,  \sprs
      .ifnb \spr;  spr_count = spr_count + 1
        .rept 1
          .ifc \spr,  cr
            mfcr \a
            stw \a, idxr.x(idxr.r);idxr.x=idxr.x+4;.exitm;.endif;
          .ifc \spr,  CR
            mfcr \a
            stw \a, idxr.x(idxr.r);idxr.x=idxr.x+4;.exitm;.endif;
          .ifc \spr,  sr
            mfsr \a
            stw \a, idxr.x(idxr.r);idxr.x=idxr.x+4;.exitm;.endif;
          .ifc \spr,  SR
            mfsr \a
            stw \a, idxr.x(idxr.r);idxr.x=idxr.x+4;.exitm;.endif;
          .ifc \spr,  msr
            mfmsr \a
            stw \a, idxr.x(idxr.r);idxr.x=idxr.x+4;.exitm;.endif;
          .ifc \spr,  MSR
            mfmsr \a
            stw \a, idxr.x(idxr.r);idxr.x=idxr.x+4;.exitm;.endif;spr.__i=0
          .irpc c,  \spr
            .irpc n,  0123456789
              .ifc \n,  \c;  spr.__i=1;.exitm;.endif;.endr;.exitm;.endr;
          .if spr.__i
            mfspr \a, \spr
            stw \a, idxr.x(idxr.r);idxr.x=idxr.x+4
          .else;
            mfspr \a, spr.\spr
            stw \a, idxr.x(idxr.r);idxr.x=idxr.x+4;.endif;.endr;.endif;.endr;
  .endm;spr.qr.default = 1;spr.XER = 1;spr.xer = 1;spr.LR = 8;spr.lr = 8;spr.CTR = 9;spr.ctr = 9
  spr.DSISR = 18;spr.dsisr = 18;spr.DAR = 19;spr.dar = 19;spr.DEC = 22;spr.dec = 22;spr.SDR1 = 25
  spr.sdr1 = 25;spr.SRR0 = 26;spr.srr0 = 26;spr.SRR1 = 27;spr.srr1 = 27;spr.SPRG0 = 272
  spr.sprg0 = 272;spr.SPRG1 = 273;spr.sprg1 = 273;spr.SPRG2 = 274;spr.sprg2 = 274;spr.SPRG3 = 275
  spr.sprg3 = 275;spr.EAR = 282;spr.ear = 282;spr.IBAT0U = 528;spr.ibat0u = 528;spr.IBAT0L = 529
  spr.ibat0l = 529;spr.IBAT1U = 530;spr.ibat1u = 530;spr.IBAT1L = 531;spr.ibat1l = 531
  spr.IBAT2U = 532;spr.ibat2u = 532;spr.IBAT2L = 533;spr.ibat2l = 533;spr.IBAT3U = 534
  spr.ibat3u = 534;spr.IBAT3L = 535;spr.ibat3l = 535;spr.DBAT0U = 536;spr.dbat0u = 536
  spr.DBAT0L = 537;spr.dbat0l = 537;spr.DBAT1U = 538;spr.dbat1u = 538;spr.DBAT1L = 539
  spr.dbat1l = 539;spr.DBAT2U = 540;spr.dbat2u = 540;spr.DBAT2L = 541;spr.dbat2l = 541
  spr.DBAT3U = 542;spr.dbat3u = 542;spr.DBAT3L = 543;spr.dbat3l = 543;spr.GQR0 = 912
  spr.QR0 = 912;spr.gqr0 = 912;spr.qr0 = 912;spr.GQR1 = 913;spr.QR1 = 913;spr.gqr1 = 913
  spr.qr1 = 913;spr.GQR2 = 914;spr.QR2 = 914;spr.gqr2 = 914;spr.qr2 = 914;spr.GQR3 = 915
  spr.QR3 = 915;spr.gqr3 = 915;spr.qr3 = 915;spr.GQR4 = 916;spr.QR4 = 916;spr.gqr4 = 916
  spr.qr4 = 916;spr.GQR5 = 917;spr.QR5 = 917;spr.gqr5 = 917;spr.qr5 = 917;spr.GQR6 = 918
  spr.QR6 = 918;spr.gqr6 = 918;spr.qr6 = 918;spr.GQR7 = 919;spr.QR7 = 919;spr.gqr7 = 919
  spr.qr7 = 919;spr.GQR = 913;spr.QR = 913;spr.gqr = 913;spr.qr = 913;spr.HID2 = 920
  spr.hid2 = 920;spr.WPAR = 921;spr.wpar = 921;spr.DMAU = 922;spr.dmau = 922;spr.DMAL = 923
  spr.dmal = 923;spr.MMCR0 = 952;spr.mmcr0 = 952;spr.PMC1 = 953;spr.pmc1 = 953;spr.PMC2 = 954
  spr.pmc2 = 954;spr.SIA = 955;spr.sia = 955;spr.MMCR1 = 956;spr.mmcr1 = 956;spr.PMC3 = 957
  spr.pmc3 = 957;spr.PMC4 = 958;spr.pmc4 = 958;spr.HID0 = 1008;spr.hid0 = 1008;spr.HID1 = 1009
  spr.hid1 = 1009;spr.IABR = 1010;spr.iabr = 1010;spr.DABR = 1013;spr.dabr = 1013;spr.L2CR = 1017
  spr.l2cr = 1017;spr.ICTC = 1019;spr.ictc = 1019;spr.THRM1 = 1020;spr.thrm1 = 1020
  spr.THRM2 = 1021;spr.thrm2 = 1021;spr.THRM3 = 1022;spr.thrm3 = 1022;spr.TBL = 268;spr.tbl = 268
  spr.TBU = 269;spr.tbu = 269;spr.UTBL = 284;spr.utbl = 284;spr.UTBU = 285;spr.utbu = 285
  spr.PVR = 287;spr.pvr = 287;spr.UMMCR0 = 936;spr.ummcr0 = 936;spr.UPMC1 = 937;spr.upmc1 = 937
  spr.UPMC2 = 938;spr.upmc2 = 938;spr.USIA = 939;spr.usia = 939;spr.UMMCR1 = 940;spr.ummcr1 = 940
  spr.UPMC3 = 941;spr.upmc3 = 941;spr.UPMC4 = 942;spr.upmc4 = 942;spr.cr = 0;spr.CR = 0
  spr.sr = 0;spr.SR = 0;spr.msr = 0;spr.MSR = 0;.endif

