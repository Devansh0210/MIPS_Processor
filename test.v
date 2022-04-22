module tb();

      wire[1:0] w1;
      reg [1:0] r1;

      assign w1 = r1;

      initial begin
            r1 <= 2'b10;
            #10 r1 <= 2'b11;
      end

      initial
            $monitor("w1 = %b r1 = %b", w1, r1);

endmodule