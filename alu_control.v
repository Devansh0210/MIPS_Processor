module alucontrol(
    OP,
    funcf,
    ALUdir,
    ALUop
)

input [3:0] OP;
input [3:0] funcf;
input [1:0] ALUdir;
output reg [2:0] ;

always@(OP or funcf or ALUdir) begin
    case(ALUdir)
                2'b00:ALUop=3'000;                      //forcible addition
                2'b11:ALUop=3'001;                      //forcible Subtration
                2'b10:begin
                case(OP)
                        4'b1000:ALUop=3'b000;            //R-type additions                             
                        4'b1100:ALUop=3'b001;            //R-type subtration                            
                        4'b0000:begin                    //shift operation                                     
                                case(funcf) 
                                            4'b0001:ALUop=3'b010;   //left shift 
                                            4'b0010:ALUop=3'b011;   //Logical Right shift
                                            4'b0011:ALUop=3'b100;   //Arthematic Right shift 
                        endcase
                        end
                        4'b1011:ALUop=3'b101;            //R-type NAND operation
                        4'b1111:ALUop=3'b110;            //R-type OR operation
                endcase
                end
end
