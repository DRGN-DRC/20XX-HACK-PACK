regs (r3), rFormatString, rArg1, rArg2;  printf = 0x80323eb4
addi rFormatString, rStatic, data.xTestFormatString
addi rArg1, rStatic, data.xTestString1
addi rArg2, rStatic, data.xTestString2
crclr cr1.lt
branchl printf
# print "Hello World!" into the Dolphin log
