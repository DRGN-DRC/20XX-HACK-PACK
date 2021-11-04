.ifndef melee.library.included; .include "melee"; .endif
melee.module all

.if module.included == 0


  melee ppc, common, arch, DVD, GObj, HSDObj, mem, MPad
  # load all melee GAS modules
  # - this is the default if `melee` is called with no args


.endif
