module Datamemory(Address, Writedata, MemRead, MemWrite, Memdata, clk);
      
      input [15:0] Address; //The Address must be =(IorD)?ALUout:PC;
      input [15:0] Writedata;
      input clk, MemWrite, MemRead;
      output reg [15:0] Memdata;

      reg [15:0] Memory[0:65535];
          
      always @(posedge clk) begin
            if(MemWrite)  
                  Memory[Address] <= Writedata;
            
            if (MemRead)
                  Memdata <= (MemRead) ? Memory[Address] : 16'bx;
      end

endmodule