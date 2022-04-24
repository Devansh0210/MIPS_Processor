`include "data_mem.v"
`include "reg_dec.v"
`include "reg_file.v"
`include "alu.v"
`include "mips_control_fsm.v"
`include "alu_control.v"

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
      wire PCen;
      
      wire RegDst;
      wire [1:0] ALUdir;
      wire MemTowire;
      // reg RegDst;
      wire PCWrite;
      wire [2:0] ALUop;
      wire ALUsrcA;
      wire [2:0] ALUsrcB;
      wire [1:0] PCsrc;
      wire RegWrite;
      reg [1:0] RegSrcA;
      wire IorD;
      wire MemRead, MemWrite; // wire
      wire IRwrite; // 
      wire be;
      wire branch;      
      
      
      reg clk; // Reference Clock
      reg rst;

      assign addr = (IorD ? ALUout : PC); // IorD mux for Memory Address
      wire done_sig;
      ControlFSM fsm1 (
            q4,
            rst,
            q1,
            clk,
            PCsrc,
            IorD,
            MemWrite,
            MemRead,
            IRwrite,
            RegDst,
            RegWrite,
            ALUsrcA,
            ALUsrcB,
            ALUdir,
            MemToReg,
            PCWrite,
            branch,
            be,
            cur_state,
            done_sig
      );

        
      
      // assign RegDst = (q4[3:1] == 3'b010); // Control for branch
      
      initial begin
            PC = 16'h0000; // Init PC
            // MemToReg = 0;
            clk <= 0; //  Start the Clock
            forever #1 clk <= ~clk;
      end
      
      initial begin
            rst = 1;
            #1.5 rst = 0;
      end

      assign se1 = { {4{q321[11]}} , q321}; // Sign-Extender 12bit --> 16 bit
      assign se2 = { {8{q21[7]}} , q21}; // Sign Extender 8 bits --> 16 bits
      
      assign q4 = instr[15:12];
      assign q3 = instr[11:8];
      assign q2 = instr[7:4];
      assign q1 = instr[3:0];
      assign q321 = instr[11:0];
      assign q21 = instr[7:0];
      
      wire [3:0] op_fsm;
      assign op_fsm = MemData[15:12];

      wire [3:0] ex_ins_1, ex_ins_2;
      
      RegDecoder rad (
            q3,
            ex_ins_1,
            ex_ins_2
      );
                  
                  
      assign w_reg = (RegDst ? ex_ins_1 : q3); // WriteReg Mux
      assign read_reg_1 = (RegSrcA[1] ? ex_ins_2 : (RegSrcA[0] ? q3 : q2)); // Source Reg 1 Mux
      assign read_reg_2 = q1; // Source Reg 2
      assign w_data = (MemToReg ? MDR : ALUout);
      assign PCen = (PCWrite | (branch & (be ~^ zero)));


      ALU alu1(
            ALUop,
            srcA,
            srcB,
            alures,
            zero
      );

      wire [15:0] d_rdata;
      RegFile regf (
            w_reg,
            read_reg_1,
            read_reg_2,
            w_data,
            RegWrite,
            rd1,
            rd2,
            rd3,
            d_rdata
      ); // Register File


      assign srcA = (ALUsrcA ? A : PC); // ALU Source A
      assign srcB = (ALUsrcB[2] ? se2 : (ALUsrcB[1] ? (ALUsrcB[0] ? q2 : se1) : (ALUsrcB[0] ? 16'd1 : B))); // ALU Source B

      wire [15:0] d_mem;

      Datamemory mem1(
            addr,                    // address
            rd3,                       // input data
            MemRead,                 // Memory Access
            MemWrite,                // Memory Access
            MemData,
            d_mem                  // Write Data
      );

      
      alucontrol alu_c1 ( 
            q4,
            q1,
            ALUdir,
            ALUop
      );
      
       // ALU module
      

      always @(posedge clk) begin
            // @(alures);
            ALUout <= alures;
      end

      always @(posedge clk) begin
            @(MemData);
            MDR <= MemData;
      end

      always @(posedge clk) begin
            

            // @(IRwrite);
            // if(IRwrite)
            //       instr = MemData;
            
            C <= rd3;
            A = rd1;
            B = rd2;
            
            
            // @(PCen);
            // @(srcA, srcB);
            @(posedge done_sig);
            // PC <= (~PCen ? PC : (PCsrc == 2'b00 ? ALUout : (PCsrc == 2'b01 ? C : (PCsrc == 2'b10 ? PC + 1 : PC))));
            if(PCen) begin
                  // )
                  case (PCsrc)
                        2'b00 : begin
                              // @(alures);
                              PC = PC + se1;
                        end
                        2'b01 : PC = C;
                        2'b10 : PC = PC + 1;  
                        default : PC <= PC;
                  endcase   
            end

            if(IRwrite)
                  instr = MemData;
            
      end // Semi-Control Loop which handles architecture registers

      // always @(posedge done_sig) begin
      //       if(PCen) begin
      //             // )
      //             case (PCsrc)
      //                   2'b00 : begin
      //                         // @(alures);
      //                         PC = alures;
      //                   end
      //                   2'b01 : PC = C;
      //                   2'b10 : PC = PC + 1;  
      //                   default : PC <= PC;
      //             endcase
      //       end
      // end
      

      always @(*) begin
            case (q4)
                  4'b1000 : RegSrcA <= 2'b00;
                  4'b1100 : RegSrcA <= 2'b00;
                  4'b1011 : RegSrcA <= 2'b00;
                  4'b1111 : RegSrcA <= 2'b00;
                  4'b0100 : RegSrcA <= 2'b00;
                  4'b0101 : RegSrcA <= 2'b00;
                  4'b1001 : RegSrcA <= 2'b01;
                  4'b1010 : RegSrcA <= 2'b01;
                  4'b1101 : RegSrcA <= 2'b01;
                  4'b1110 : RegSrcA <= 2'b01;
                  4'b0000 : RegSrcA <= 2'b01;
                  4'b0111 : RegSrcA <= 2'b01;
                  4'b0110 : RegSrcA <= 2'b01;
                  4'b0001 : RegSrcA <= 2'b10;
                  4'b0010 : RegSrcA <= 2'b10;
                  default : RegSrcA <= 2'b00;
            endcase
      end

      // always @(*) begin
      //       case(q4)
      //             4'b0100 : RegDst <= 0;
      //             4'b0101 : RegDst <= 0;
      //             default : RegDst <= 1;
      //       endcase
      // end

      wire [3:0] cur_state;

      initial begin // 
            $dumpfile("mem_test.vcd");
            $dumpvars(2, MIPS_16);
            #30 $finish;
      end

endmodule
