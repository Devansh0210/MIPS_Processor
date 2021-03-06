module RegFile(
      input [3:0] rw, rs1, rs2,
      input [15:0] WD,
      input RegWrite,
      output reg [15:0] rd1, rd2, rd3
); 

      reg [15:0] RegData [0:15];
      initial begin
            $readmemh("reg_init.mem", RegData); // Initialize Register File
      end

      always @(rs1, rs2, rw, RegWrite, WD) begin
            rd1 <= RegData[rs1]; // Source Reg - 1
            rd2 <= RegData[rs2]; // Source Reg - 2
            rd3 <= RegData[rw];  // Destination Reg
      
            if(RegWrite)
                  RegData[rw] <= WD; // Write Data in RegFile based on Signal
            
            $writememh("reg_fin.mem", RegData); // Write updated Register File
      end

endmodule

// module tb();

//       reg [3:0] tr1, tr2, tr3;
//       reg rw;
//       reg [15:0] dw;
//       output wire [15:0] rd1, rd2, rd3; 

//       RegFile dut (
//             .rw(tr1),
//             .rs1(tr2),
//             .rs2(tr3),
//             .RegWrite(rw),
//             .WD(dw),
//             .rd1(rd1),
//             .rd2(rd2),
//             .rd3(rd3)
//       );

//       initial
//             $monitor("%b --> %h || %b --> %h || %b --> %h", tr1, rd3, tr2, rd1, tr3, rd2);

//       initial begin
//             tr1 <= 4'd15;
//             tr2 <= 4'd2;
//             tr3 <= 4'd1;
//             rw <= 1;
//             dw <= 16'hdada;

//             #10 tr1 <= 4'd13;
//             dw <= 16'heeee;       
//       end

// endmodule