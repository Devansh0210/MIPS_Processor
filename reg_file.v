module RegFile(
      input [3:0] rw, rs1, rs2,
      input RegWrite,
      input [15:0] WD,
      output reg [15:0] rd1, rd2, rd3
); 

      reg [15:0] RegData [0:15];
      initial begin
            $readmemh("reg_init.mem", RegData);
      end

      always @(*) begin
            rd1 <= RegData[rs1];
            rd2 <= RegData[rs2];
            rd3 <= RegData[rw];
      
            if(RegWrite)
                  RegData[rw] <= WD;

            $writememh("reg_fin.mem", RegData);
      end

endmodule

module tb();

      reg [3:0] tr1, tr2, tr3;
      reg rw;
      reg [15:0] dw;
      output wire [15:0] rd1, rd2, rd3; 

      RegFile dut (
            .rw(tr1),
            .rs1(tr2),
            .rs2(tr3),
            .RegWrite(rw),
            .WD(dw),
            .rd1(rd1),
            .rd2(rd2),
            .rd3(rd3)
      );

      initial
            $monitor("%b --> %h || %b --> %h || %b --> %h", tr1, rd3, tr2, rd1, tr3, rd2);

      initial begin
            tr1 <= 4'd15;
            tr2 <= 4'd2;
            tr3 <= 4'd1;
            rw <= 1;
            dw <= 16'hdada;
      end

endmodule