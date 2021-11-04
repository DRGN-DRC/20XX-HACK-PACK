.include "melee"; melee all; punkpc str
# include all melee modules, and make sure punkpc str objects are available

# The following ifdef blocks will default to paths given by user before including this file
# - else, they will define the following default paths
ifdef test_GProc_setup.is_str
.if ndef; str test_GProc_setup "example_files/test_GProc/setup.s"; .endif
ifdef test_GProc_data.is_str
.if ndef; str test_GProc_data "example_files/test_GProc/data.s"; .endif
ifdef test_GProc_proc.is_str
.if ndef; str test_GProc_proc "example_files/test_GProc/proc.s"; .endif


arch.start
# begin archive wrapper...

  test_GProc_data.str arch   # Static data accessed by the GProc goes in this section
  # - the path in the str variable is passed over to the arch library object

  _flush_begin:
  # this _flush block has its instructions flushed on load, to prevent IC ghosts
  # - it allows for safe inclusion of executable instrucitons inside of dynamic memory

    test_GProc_setup.str arch  # GObj/GProc setup routine goes here
    test_GProc_proc.str arch   # GProc goes here


  _flush_end:
  arch.symbol "init.flush"
    .long 1  # flush 1 range...

    arch.point _flush_begin, _flush_end
    # flush instruction cache between _flush_begin ... _flush_end on initialization

  arch.symbol "init.call"
    .long 1  # call 1 callback...

    arch.point _setup
    # setup callback will run once "init.flush" has finished

arch.end
# end of archive wrapper
