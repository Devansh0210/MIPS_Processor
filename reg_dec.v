module RegDecoder(
      input [1:0] Rd, Rp,
      output [3:0] ext_Rd, ext_Rp 
);

      assign ext_Rd = {2'b11, Rd};
      assign ext_Rp = {2'b10, Rp};

endmodule

module tb();

      reg [1:0] r1, r2;
      wire [3:0] er1, er2;

      RegDecoder uut (
            .Rd(r1),
            .Rp(r2),
            .ext_Rd(er1),
            .ext_Rp(er2)
      );

      initial
            $monitor("%b --> %b || %b --> %b", r1, er1, r2, er2);

      initial begin
            r1 <= 2'b00;
            r2 <= 2'b10;

            #10 r1 <= 2'b11;
            r2 <= 2'b01;
      end

endmodule