.include "melee"; melee all; punkpc str
# include all melee modules, and make sure punkpc str objects are available

# The following ifdef blocks will default to paths given by user before including this file
# - else, they will define the following default paths
ifdef test_GProc_proc.is_str
.if ndef; str test_GProc_proc "example_files/test_MPad/proc.s"; .endif
ifdef test_GProc_data.is_str
.if ndef; str test_GProc_data "example_files/test_MPad/data.s"; .endif


# Implement GProc test with the above path modifications
# - DPad paths are used by MPad proc
arch example_files/test_GProc/_main.s
