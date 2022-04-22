module control 
(OP,reset,funcf,clk,PCsrc,IorD,Memwrite,Memread,IRwrite,RegDst,RegSrcA,RegWrite,ALUsrcA,ALUsrcB,ALUop,memtoReg)

    input clk;
    input [0:3] OP;
    input [0:3] funcf;
    input reset;

    output reg [1:0] PCsrc;
    output reg IorD;
    output reg Memwrite;
    output reg Memread;
    output reg IRwrite;
    output reg RegDst;
    output reg RegSrcA;
    output reg RegWrite;
    output reg ALUsrcA;
    output reg [2:0] ALUsrcB;
    output reg [1:0] ALUop;
    output reg memtoReg;

    //states defination
    Fetch=4'b0000;
    Decode_rb=4'b0001;
    Decode_i=4'b0010;
    Decode_lsw=4'b0011;
    Execute_r=4'b0100;
    Execute_b=4'b0101;
    Execute_j=4'b0110;
    Execute_i1=4'b0111;
    Execute_i2=4'b1000;
    Execute_lsw=4'b1001;
    Writeback_r=4'b1011;
    Writeback_i=4'b1100;
    Writeback_lw=4'b1101;
    Writeback_sw=4'b1110;
    Mem_lw=4'b1111;
    //control circuit
    reg [3:0] state;
    reg [3:0] nextstate;


    always@(posedge clk)
    if(reset)
    state<=Fetch;
    else 
    state<=nextstate;

    always@(state or OP)
    begin
        case(state)         
    Fetch:
        case(OP)
        4'b1000:nextstate=Decode_rb;
        4'b1100:nextstate=Decode_rb;
        4'b1011:nextstate=Decode_rb;
        4'b1111:nextstate=Decode_rb;
        4'b0100:nextstate=Decode_rb;
        4'b0101:nextstate=Decode_rb;
        4'b0011:nextstate=Decode_rb;
        4'b1001:nextstate=Decode_i;
        4'b1010:nextstate=Decode_i;
        4'b1101:nextstate=Decode_i;
        4'b1110:nextstate=Decode_i;
        4'b0000:nextstate=Decode_i;
        4'b0111:nextstate=Decode_i;
        4'b0110:nextstate=Decode_i;
        4'b0001:nextstate=Decode_lsw;
        4'b0010:nextstate=Decode_lsw;
        endcase
    Decode_rb:
        case(OP)
        4'b1000:nextstate=Execute_r;
        4'b1100:nextstate=Execute_r;
        4'b1011:nextstate=Execute_r;
        4'b1111:nextstate=Execute_r;
        4'b0100:nextstate=Execute_b;
        4'b0101:nextstate=Execute_b;
        4'b0011:nextstate=Execute_j;
        endcase
    Decode_i:
        case(OP)
        4'b1001:nextstate=Execute_i1;
        4'b1010:nextstate=Execute_i1;
        4'b1101:nextstate=Execute_i1;
        4'b1110:nextstate=Execute_i1;
        4'b0111:nextstate=Execute_i1;
        4'b0110:nextstate=Execute_i1;
        4'b0000:nextstate=Execute_i2;
        endcase
    Decode_lsw: 
        case(OP)
        4'b0001:nextstate=Execute_lsw;
        endcase
    Execute_r:
        case(OP)
        4'b1000:nextstate=Writeback_r;
        4'b1100:nextstate=Writeback_r;
        4'b1011:nextstate=Writeback_r;
        4'b1111:nextstate=Writeback_r;
        endcase
    Execute_i1:
        case(OP)
        4'b1001:nextstate=Writeback_i;
        4'b1010:nextstate=Writeback_i;
        4'b1101:nextstate=Writeback_i;
        4'b1110:nextstate=Writeback_i;
        4'b0111:nextstate=Writeback_i;
        4'b0110:nextstate=Writeback_i;
        endcase
    Execute_i2:
        case(OP)
        4'b0000:nextstate=Writeback_i;
        endcase
    Execute_lsw:
        case(OP)
        4'b0001:nextstate=Mem_lw;
        4'b0010:nextstate=Writeback_sw;
        endcase
    Mem_lw:
        case(OP)
        4'0001:nextstate=Writeback_lw;
        endcase
endcase
    always @(state) begin
        case(state)
            Fetch:
                begin
                    PCsrc=1'b0;
                    IorD=1'b0;
                    Memwrite=1'b0;
                    Memread=1'b1;
                    IRwrite=1'b1;
                    ALUsrcA=1'b0;
                    ALUsrcB=3'b001;
                    ALUop=2'b00;
                end
            Decode_rb:
                begin   
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegDst=1'b0;
                    RegSrcA=2'b00;
                    RegWrite=1'b0;
                end
            Decode_i:
                begin
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegDst=1'b0;
                    RegSrcA=2'b00;
                    RegWrite=1'b0;
            Decode_lsw:
                begin
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegDst=1'b1;
                    RegSrcA=2'b10;
                    RegWrite=1'b0;
                end
            Execute_r:
                begin
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegWrite=1'b0;
                    ALUsrcA=1'b1;
                    ALUop=2'b10;
                end
            Execute_i1:
                begin
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegWrite=1'b0;
                    ALUsrcA=1'b1;
                    ALUsrcB=3'b100'
                    ALUop=2'b10;
                end
            Execute_i2:
                begin
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegWrite=1'b0;
                    ALUsrcA=1'b1;
                    ALUsrcB=3'b011;
                    ALUop=2'b10;
                end
            Execute_lsw:
                begin
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegWrite=1'b0;
                    ALUsrcA=1'b1;
                    ALUsrcB=3'b100;
                    ALUop=2'b00;
                end
            Execute_b:
                begin
                    PCsrc=1'b1;
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegWrite=1'b0;
                end
            Execute_j://CHECK(PCsrc)........................................................................
                begin   
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegWrite=1'b0;
                    ALUsrcA=1'b0;
                    ALUsrcB=3'b010;
                    ALUop=2'b00;
                end
            Writeback_r:
                begin
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegDst=1'b0;
                    RegWrite=1'b1;
                    ALUsrcB=3'b000;
                    memtoReg=1'b0;
                end
            Writeback_i://CHECK(same as Writeback_r...................................................................)
                begin
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegDst=1'b0;
                    RegWrite=1'b1;
                    ALUsrcB=3'b000;
                    memtoReg=1'b0;
                end
            Writeback_lw:
                begin
                    Memwrite=1'b0;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegDst=1'b1;
                    RegWrite=1'b1;
                    ALUsrcB=3'b000;
                    memtoReg=1'b1;
                end
            Writeback_sw:
                begin
                    Memwrite=1'b1;
                    Memread=1'b0;
                    IRwrite=1'b0;
                    RegWrite=1'b0;
                    ALUsrcB=3'b000;
                end
            Mem_lw:
                begin
                    IorD=1'b1;
                    Memwrite=1'b0;
                    MemRead=1'b1;
                    IRwrite=1'b0;
                    RegWrite=1'b0;


    end
   
   
   
   
   
   
   
   
   initial
    begin
        PCsrc=2'b00;
        IorD=1'b0;
        Memwrite=1'b0;
        Memread=1'b0;
        IRwrite=1'b0;
        RegDst=1'b0;
        RegSrcA=1'b0;
        RegWrite=1'b0;
        ALUsrcA=1'b0;
        ALUsrcB=3'b000;
        ALUop=2'b00;
        memtoReg=1'b0;
    end
