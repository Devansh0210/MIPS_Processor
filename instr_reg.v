module InstrReg(
      input [15:0] instr,
      input irw,
      output reg [3:0] q4, q3, q2, q1,
      output reg [11:0] q321,
      output reg [7:0] q21
);

      always @(*) begin
            if(irw) begin
                  q4 <= instr[15:12];
                  q3 <= instr[11:8];
                  q2 <= instr[7:4];
                  q1 <= instr[3:0];
                  q321 <= instr[11:0];
                  q21 <= instr[7:0];   
            end
      end
endmodule