def gen_param(num, w):
      return f"\tparameter S{num} = {w}'b{bin(num)[2:]};\n"

p_lines = """"""

for i in range(16):
      p_lines += gen_param(i, 4)

with open("fsm_param.v", "w") as f:
      f.writelines(p_lines)