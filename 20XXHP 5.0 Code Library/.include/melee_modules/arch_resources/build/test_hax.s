.include "melee"
punkpc ppc
melee arch

static_pointer_addr = 0x8040180C  # change this to change the pointer location
# - this location is just error message ascii, so it's virtually safe to overwrite

arch.start  # Begin archive wrapper block...

  arch.symbol "init.flush"
    .long (1f-0f)>>3  # count 8-byte
    0:
      arch.point _instructions_start
      arch.point _instructions_end
    1: # this will create range to 'flush' the instruction cache with

  arch.symbol "init.sync"
    .long (1f-0f)>>2  # count 4-byte
    0:
      arch.point _my_init.sync_callback
    1: # this will cause the included callback to be executed on initialization

  arch.symbol "init.static"
    .long (1f-0f)>>3  # count 8-byte
    0:
      arch.point static_pointer_addr, _my_data
    1: # this will cause a pointer to internal to be written on initialization

  _instructions_start:

    _my_init.sync_callback: arch "example_files/test_hax_syncCB.s"  # emit callback source here...

  _instructions_end:
  align 5  # instructions in this region will be flushed

  _my_data:
    arch.point _tlut_array_base
    arch.point _image
    # toc

    _tlut_array_base:  .zero 25<<3; align 5
    # create blank monochrome RGBA palette slots in the file, to be updated at runtime

    _image:  arch.raw "example_files/mono.bmp", 0x3E, 0x2000
    # load 0x2000 bytes of pixel data from offset 0x3E of a bitmap file (skipping header)

arch.end   # end of nestable wrapper
