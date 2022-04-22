module Datamemory(Address, Writedata, MemRead, MemWrite, Memdata);
      
      input [15:0] Address; //The Address must be =(IorD)?ALUout:PC;
      input [15:0] Writedata;
      input MemWrite, MemRead;
      output reg [15:0] Memdata;

      reg [15:0] Memory [0:100];
      
      initial begin
            $readmemh("mem_init.mem", Memory, 16'h0000, 16'd0100);
      end

      always @(*) begin
            if(MemWrite) begin
                  Memory[Address] <= Writedata;
                  $writememh("mem_fin.mem", Memory);
            end 
            
            
            if (MemRead)
                  Memdata <= (MemRead) ? Memory[Address] : 16'bx;
      end

endmodule