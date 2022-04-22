import random


mem_lines = """"""
for i in range(100):
      k = "%04x\n" % random.randrange(16**4)
      mem_lines += k



with open("mem_init.mem", "w") as mem_file:
      mem_file.write("// 0x0000 Initial Address \n")
      mem_file.writelines(mem_lines)

