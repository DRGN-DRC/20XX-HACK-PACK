_static_data:

# <-- GObj can reach this data from a pointer at offset 0x0 of its own data table
# - you can include any kind of static parameter you'd want your GProc to use here
# - this data will appear at the beginning of the data section in your archive

  0: .long 0
  align 2

  data.table _static_data
  data.struct 0, "data.", xTest
