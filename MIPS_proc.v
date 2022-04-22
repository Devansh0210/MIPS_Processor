`include "data_mem.v"
`include "reg_dec.v"
`include "reg_file.v"
`include "alu.v"

module MIPS_16();

      reg [15:0] PC;
      reg [15:0] ALUout;
      wire [15:0] addr;
      reg [15:0] A, B, C;
      wire [15:0] MemData;
      wire [3:0] qw4, qw3, qw2, qw1;
      wire [11:0] se1;
      wire [7:0] se2;
      reg [15:0] instr;
      reg [15:0] MDR;
      wire [15:0] rd1, rd2, rd3;
      wire [3:0] q4, q3, q2, q1;
      wire [11:0] q321;
      wire [7:0] q21;
      wire [3:0] w_reg, read_reg_1, read_reg_2;
      wire [15:0] w_data;
      wire [15:0] srcA, srcB;
      wire zero;
      wire [15:0] alures;
      
      
      wire RegDst;
      reg PCWrite;
      reg [2:0] opcode;
      reg ALUsrcA;
      reg [2:0] ALUsrcB;
      reg [1:0] PCsrc;
      reg RegWrite;
      reg [1:0] RegSrcA;
      reg MemToReg;
      reg IorD;
      reg MemRead, MemWrite; // reg
      reg IRwrite; // 
      

      reg clk; // Reference Clock
      
      assign addr = (IorD ? ALUout : PC); // IorD mux for Memory Address
      
      Datamemory mem1(
            addr,                    // address
            C,                       // input data
            MemRead,                 // Memory Access
            MemWrite,                // Memory Access
            MemData                  // Write Data
      );
        
      
      // assign RegDst = (q4[3:1] == 3'b010); // Control for branch
      
      initial begin
            PC <= 16'h0000; // Init PC
            clk <= 0; //  Start the Clock
            forever #1 clk <= ~clk;
      end
      
      assign se1 = { {4{q321[11]}} , q321}; // Sign-Extender 12bit --> 16 bit
      assign se2 = { {8{q21[7]}} , q21}; // Sign Extender 8 bits --> 16 bits
      
      assign q4 = instr[15:12];
      assign q3 = instr[11:8];
      assign q2 = instr[7:4];
      assign q1 = instr[3:0];
      assign q321 = instr[11:0];
      assign q21 = instr[7:0];
      
      wire [3:0] ex_ins_1, ex_ins_2;
      
      RegDecoder rad (
            q3,
            ex_ins_1,
            ex_ins_2
      );
                  
                  
      assign w_reg = (RegDst ? ex_ins_1 : q3); // WriteReg Mux
      assign read_reg_1 = (RegSrcA[1] ? ex_ins_2 : (RegSrcA[0] ? q3 : q2)); // Source Reg 1 Mux
      assign read_reg_2 = q1; // Source Reg 2
      
      RegFile regf (
            w_reg,
            read_reg_1,
            read_reg_2,
            w_data,
            RegWrite,
            rd1,
            rd2,
            rd3
      ); // Register File


      assign srcA = (ALUsrcA ? A : PC); // ALU Source A
      assign srcB = (ALUsrcB[2] ? se2 : (ALUsrcB[1] ? (ALUsrcB[0] ? q2 : se1) : (ALUsrcB[0] ? 16'd2 : B))); // ALU Source B


      ALU alu1(
            opcode,
            srcA,
            srcB,
            alures,
            zero
      ); // ALU module

      always @(posedge clk) begin
            MDR <= MemData;

            if(IRwrite)
                  instr <= MemData;
            
            A <= rd1;
            B <= rd2;
            C <= rd3;
            
            ALUout <= alures;
            if(PCWrite) begin
                  case (PCsrc)
                        2'b00 : PC <= ALUout;
                        2'b01 : PC <= C;
                        2'b10 : PC <= alures;  
                        default: PC <= PC;
                  endcase
            end
      end // Semi-Control Loop which handles architecture registers

      initial begin // 
            $dumpfile("mem_test.vcd");
            // $dumpvars(0, MIPS_16);
            $dumpvars(1, regf);
            #4 $finish;
      end
      
      // initial begin
            // PCsrc <= 2'b10;
            // PCWrite <= 1'b1;
            // ALUsrcA <= 1'b0;
            // ALUsrcB <= 3'b001;
            // opcode <= 3'b000;
            // IorD <= 1'b0;
            // IRwrite <= 1'b1;
            // MemRead <= 1'b1;

      //       @(posedge clk);

      //       PCWrite <= 0;
            
            

      // end

endmodule