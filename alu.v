module ALU(
      input [2:0] opcode,
      input signed [15:0] A,
      input signed [15:0] B,
      output reg [15:0] res,
      output zero
);



      always @ (*) begin
            case(opcode)
                  3'b000 : res <= A + B; // Add
                  3'b001 : res <= A - B; // Subtract
                  3'b010 : res <= A << B; // Left Shfit
                  3'b011 : res <= A >> B; // Right Shfit
                  3'b100 : res <= (A >>> B) ; // Arithmetic Right Shift
                  default : res <= A + B;
            endcase
      end

      assign zero = &(A ~^ B); // Zero Flag

endmodule

module tb();

      reg [15:0] At, Bt;
      reg [2:0] opt;

      wire [15:0] res;
      wire zero;

      ALU dut (
            .opcode(opt),
            .A(At),
            .B(Bt),
            .res(res),
            .zero(zero)
      );

      initial
            $monitor("opcode : %b, A = %b(%d)B = %b(%d) :::: res = %b(%d) --- %b", opt, At, At, Bt, Bt, res, res, zero);

      initial begin
            At <= 16'b1110110010101101;
            Bt <= 16'd3;
            #10 $finish;
      end



      initial begin
            opt = 3'd0;
            repeat(7) #1 opt = opt + 1;
      end
endmodule