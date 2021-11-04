# arch : 'archive' file building macros

# arch  filename.s
# - this will build the archive file by the given file name in the melee_modules/arch_resources/ dir

# arch.raw  filename.bmp
# - this will emit the binary

# arch.start  arg1, arg2, arg3
# - this starts an archive block -- using 'arch.end' to end it
#   - multiple archives can be encapsulated by nesting these blocks
# - optional arguments will be copied over to header tag/padding
#   - defaults mimic stage files: "001B", 0, 0

# arch.symbol  "unique_symbol_name"
# - this starts a new region in the archive data section and registers it with a given symbol string
#   - the current location in the assembly is used to create a label for this archive symbol

# arch.reloc   optional_label
# - registers a location in this assembly as part of the relocation table
#   - if no label is given, then one is generated using the current location in the assembly

# arch.point   target_label
# - creates a 4-byte data section pointer to a given target label
# - location of this pointer is automatically added to the relocation table

# arch.end
# - finish an archilve block started by 'arch.start'
#   - this pops the top archive off the stack, if multiple archives are being nested
# - generates all data following the data section automatically




# --- uses the punkpc 'melee' library:

.ifndef melee.library.included; .include "melee"; .endif
melee.module arch

.if module.included == 0
  punkpc items, stack, align

  module.library arch, ""
  arch.verify_vsn = 0
  arch.maindir "melee_modules/arch_resources/"
  arch.subdir "", ""
  # set up a module library called 'arch' for reaching the resources folder
  # - arch.raw can be used to emit files as binary inline with your assembly
  # - arch.subdir can used to reach alternative directory paths
  # - included source/binary does not need to be protected in a class module definition


  items.method arch.__params
  # create a new items pseudo-object to store list of param names ...

  arch.align = 0
  # default alignment is 0, for end of archive
  # - set this to 5 to make files align with DVD read buffer

  .irp param, arch.symbols, arch.relocs, arch.refs, arch.__id, arch.__inst; \param = 0; .endr
  # - these will store a state of the block context using various symbols ...

  stack arch.__mem
  # .__mem will store state memory in a stack, for pushing/popping nested archives

  .macro arch.__id, macro, va:vararg; sidx.noalt "<\macro _>", arch.__id, ", ", \va
  # wrapper for sidx (scalar indexing macro) passes state ID to methods, for use in namespaces

  .endm; .macro arch.start, va:vararg;
    arch.__mem.push arch.symbols, arch.relocs, arch.refs, arch.__id
    # push params to memory ...

    align 5;
    arch.__inst = arch.__inst + 1
    arch.__id = arch.__inst
    # new ID for this archive instance

    arch.__id arch.__start, \va
    # continue with literal ID (as decimal string)

  .endm; .macro arch.reloc, va:vararg; arch.__id arch.__reloc, \va
  .endm; .macro arch.point, va:vararg; arch.__id arch.__point, \va
  .endm; .macro arch.symbol, va:vararg; arch.__id arch.__symbol, \va
  .endm; .macro arch.end, va:vararg; arch.__id arch.__end, \va
  # - these wrappers will pass the current state ID to each method
  #   - this makes it easier to create unique labels for resolving errata correctly

  .endm; .macro arch.__start, id, tag=0x30303142, pad1=0, pad2=0
    arch.__start\id = .
    # new start label ...

    .irp x, _size\id
      .irp param, total\x, data\x, rt\x, st\x, ref\x
        .long arch.__\param
        # promise to resolve errata for .long once these uniquely indexed names are calculated

    .endr; .endr; .long \tag, \pad1, \pad2
    # finish header using args, or default args if none were provided

    arch.__data_start\id = .
    # set new data start label, following the header

    items.method arch.__strings\id
    stack arch.__relocs\id, arch.__symbols\id, arch.__refs\id
    # all state parameters have been initialized...
    # - use arch.symbol, arch.reloc, and/or arch.point to construct archive contents
    # - finish archive with arch.end

  .endm; .macro arch.__symbol, id, name
    arch.__strings\id, "\name"
    arch.__symbols\id\().push .-arch.__data_start\id
    # record current location to this str object as an extended attribute

  .endm; .macro arch.__reloc, id, loc=".", va:vararg
    .irp arg, \loc, \va;
      .ifnb \arg; arch.__relocs\id\().push \arg -arch.__data_start\id; .endif; .endr
      # location is stacked for relocation table entry

  .endm; .macro arch.__point, id, va:vararg
    .irp dest, \va
      .ifnb \dest
        arch.__reloc \id, .
        .long \dest-arch.__data_start\id
        # creates a pointer to destination (and marks it for relocation)

    .endif; .endr

  .endm; .macro arch.__end, id
    align 2
    arch.__rt_start\id = .
    # start of relocation table ...

    arch.__data_size\id = .-arch.__data_start\id
    arch.__rt_size\id = arch.__relocs\id\().s
    arch.__st_size\id = arch.__symbols\id\().s
    arch.__ref_size\id = arch.__refs\id\().s
    # finalize size of data section, to resolve header errata

    stack.rept arch.__relocs\id, .long
    # emit relocation table...
    # - refs are currently unsupported, but planned

    arch.__st_start\id = .
    # start symbol table ...

    arch.__strings\id arch.__symbols_loop
    # handle generation of symbols table and symbol strings ...

    align arch.align

    arch.__total_size\id = .-arch.__start\id
    # resolve final piece of errata by calculating total file size ...

    arch.__mem.popm arch.__id, arch.refs, arch.relocs, arch.symbols
    # recover state memory

  .endm; .macro arch.__symbols_loop, va:vararg; arch.__id arch.___symbols_loop, \va
  .endm; .macro arch.___symbols_loop, id, va:vararg
    .irp str, \va
      .ifnb \str
        arch.__q = arch.__symbols\id\().q
        arch.__symbols\id\().deq arch.__sym
        sidx.noalt "<.long arch.__sym, arch.__sym\id>", arch.__q
        # create new errata for symbol start labels ...

      .endif
    .endr; arch.__q = 0; arch.__str_start\id = .
    .irp str, \va
      .ifnb \str
        sidx.noalt "<arch.__sym\id>", arch.__q, " = .-arch.__str_start\id"
        .asciz "\str"
        arch.__q = arch.__q + 1
      .endif
    .endr
  .endm

  # --- symbols:

  # archive object
  arch.xFileSize      = 0x00
  arch.xDataSize      = 0x04
  arch.xRelocCount    = 0x08
  arch.xNodeCount     = 0x0C #
  arch.xRefCount      = 0x10
  arch.xData          = 0x20 #
  arch.xRelocTable    = 0x24
  arch.xNodeTable     = 0x28 #
  arch.xRefTable      = 0x2C
  arch.xSymbolStrings = 0x30 #
  arch.xFileStart     = 0x40
  arch.size = 0x44

  # returns for arch.check_init
  arch.check_init.rStart       = r3
  arch.check_init.rRelocTable  = r4
  arch.check_init.rBase        = r5
  arch.check_init.bInitialized = 4
  arch.check_init.bRelocated   = 5
  arch.check_init.bNoRelocs    = 6

  # arg interface for generic arch.event.* callback events
  arch.event.rParams = r10  # region of file pointed to by this symbol
  arch.event.rArch   = r11  # archive object
  arch.event.rSelf   = r12  # address of this event symbol definition

  # arg interface for "init.call" callbacks
  arch.init.call.rArch = r3 # archive object
  arch.init.call.rSelf = r4 # address of this callback (in file)

.endif
/**/
