module Datamemory(Address, Writedata, Memread, Memwrite, Memdata, Clk);
      
      input [15:0] Address; //The Address must be =(IorD)?ALUout:PC;
      input [15:0] Writedata;
      input Clk, Memwrite, Memread;
      output reg [15:0] Memdata;

      reg [15:0] Memory[0:65535];
          
      always @(posedge Clk) begin
            if(Memwrite)  
                  Memory[Address] <= Writedata;
            
            if (Memread)
                  Memdata <= (Memread) ? Memory[Address] : 16'bx;
      end

endmodule