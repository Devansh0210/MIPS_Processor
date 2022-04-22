module RegDecoder(
      input [3:0] R,
      output [3:0] ext_Rd, ext_Rp 
);

      assign ext_Rd = {2'b11, R[3:2]};
      assign ext_Rp = {2'b10, R[1:0]};

endmodule

// module tb();

//       reg [3:0] r1;
//       wire [3:0] er1, er2;

//       RegDecoder uut (
//             .R(r1),
//             .ext_Rd(er1),
//             .ext_Rp(er2)
//       );

//       initial
//             $monitor("%b --> %b || %b", r1, er1, er2);

//       initial begin
//             r1 <= 4'b1010;
//             // r2 <= 2'b10;

//             #10 r1 <= 4'b1100;
//             // r2 <= 2'b01;
//       end

// endmodule