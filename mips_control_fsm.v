module controlFSM(
      input [3:0] opcode, func_field,
      input clk, rst
      output reg PCWrite,
      output reg [1:0] alu_opcode,
      output reg ALUsrcA,
      output reg [2:0] ALUsrcB,
      output reg [1:0] PCsrc,
      output reg RegWrite,
      output reg [1:0] RegSrcA,
      output reg MemToReg,
      output reg IorD,
      output reg MemRead, MemWrite, 
      output reg IRwrite,
      output reg isBranch
);

      parameter S0 = 4'b0;
	parameter S1 = 4'b1;
	parameter S2 = 4'b10;
	parameter S3 = 4'b11;
	parameter S4 = 4'b100;
	parameter S5 = 4'b101;
	parameter S6 = 4'b110;
	parameter S7 = 4'b111;
	parameter S8 = 4'b1000;
	parameter S9 = 4'b1001;
	parameter S10 = 4'b1010;
	parameter S11 = 4'b1011;
	parameter S12 = 4'b1100;
	parameter S13 = 4'b1101;
	parameter S14 = 4'b1110;
	parameter S15 = 4'b1111;

      reg [3:0] cur_state, next_state;

      always @(posedge clk) begin
            if(rst)
                  cur_state <= S0;
            else
                  cur_state <= next_state;
      end

      always @(*) begin
            PCWrite = 0;
            alu_opcode = 0;
            ALUsrcA = 0;
            ALUsrcB = 0;
            PCsrc = 0;
            RegWrite = 0;
            RegSrcA = 0;
            MemToReg = 0;
            IorD = 0;
            MemRead = 0; 
            MemWrite = 0; 
            IRwrite = 0; 

            case (cur_state)
                  S0 :  begin
                        PCsrc = 2'b00;
                        // PCWrite = ;
                        IorD = 1'b0;
                        MemWrite = 1'b0; 
                        MemRead = 1'b1; 
                        IRwrite = 1'b1; 
                        RegSrcA = 0;
                        RegWrite = 0;
                        ALUsrcA = 1'b0;
                        ALUsrcB = 3'b001;
                        alu_opcode = 2'b00;
                        MemToReg = 1'bx;
                        end
                  

                  S1 :  begin
                        PCsrc = 2'b00;
                        // PCWrite = ;
                        IorD = 1'b0;
                        MemWrite = 1'b0; 
                        MemRead = 1'b0; 
                        IRwrite = 1'b0; 
                        RegSrcA = 2'b00;
                        RegWrite = 1'b0;
                        ALUsrcA = 1'b0;
                        ALUsrcB = 3'b001;
                        alu_opcode = 2'bxx;
                        MemToReg = 1'bx;
                        end
                   
            endcase
      end




endmodule