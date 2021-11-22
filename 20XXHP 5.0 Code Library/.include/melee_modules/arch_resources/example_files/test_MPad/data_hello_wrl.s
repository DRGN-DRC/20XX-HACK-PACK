_static_data:

# <-- GObj can reach this data from a pointer at offset 0x0 of its own data table
# - you can include any kind of static parameter you'd want your GProc to use here
# - this data will appear at the beginning of the data section in your archive

  0: .asciz " Hello %s%s"
  1: .asciz "World"
  2: .asciz "!"
  align 2
  # for testing a print function, from DPad presses

  data.table _static_data
  # data tables anchor "data.struct" offset bases

  data.struct 0, "data.", xTestFormatString, xTestString1, xTestString2
  # these names are given to the above enumerated ascii strings
  # - they can be used as offset symbols, for reaching the strings with add instructions
