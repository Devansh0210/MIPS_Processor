import cocotb
from cocotb.binary import BinaryValue
from cocotb.triggers import Timer
from cocotb.clock import Clock
from random import randint


@cocotb.test()
async def test_mips_16(dut):
      clk = Clock(dut.clk, 2)
      await cocotb.start(clk.start())

      dut.PCWrite.value = 1
      dut.ALUsrcA.value = 0
      dut.ALUsrcB.value = 1
      dut.opcode.value = 0
      dut.IorD.value = 0
      dut.IRwrite.value = 1
      dut.MemRead.value = 1
      dut.w_data.value = 45

      print(dut.regf.RegData.value)