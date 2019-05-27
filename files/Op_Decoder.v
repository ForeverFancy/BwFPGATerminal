module Op_Decoder(
    input [1:0] ALUOp,
    input [5:0] funct,
    input [2:0] i_op,
    output [3:0] op
);
    reg [3:0] temp_op;

    parameter SRL = 4'H00;
    parameter ADD = 4'H01;
    parameter SUB = 4'H02;
    parameter AND = 4'H03;
    parameter OR = 4'H04;
    parameter XOR = 4'H05;
    parameter NOT = 4'H06;
    parameter SRA = 4'H07;
    parameter NOR = 4'H08;
    parameter SLT = 4'H09;
    parameter NON = 4'H10;
    parameter SLTU = 4'H11;


    always @(*) begin
        if(ALUOp==2'b00)
            temp_op=ADD;
        else if(ALUOp==2'b01)
            temp_op=SUB;
        else if(ALUOp==2'b10)
        begin
            case (funct)
                6'b100_000:temp_op=ADD;
                6'b100_001:temp_op=ADD;
                6'b100_010:temp_op=SUB;
                6'b100_011:temp_op=SUB;
                6'b100_100:temp_op=AND;
                6'b100_101:temp_op=OR;
                6'b100_110:temp_op=XOR;
                6'b100_111:temp_op=NOR;
                6'b101_010:temp_op=SLT;
                6'b101_011:temp_op=SLTU;
                6'b000_100:temp_op=SLL;
                6'b000_110:temp_op=SRL;
                6'b000_111:temp_op=SRA;
                default: temp_op=NON;
            endcase
        end
        else if(ALUOp==2'b11)
        begin
            case (i_op)
                3'b000:temp_op=ADD;
                3'b100:temp_op=AND;
                3'b101:temp_op=OR;
                3'b110:temp_op=XOR;
                3'b010:temp_op=SLT;
                default: temp_op=NON;
            endcase
        end
        else
            temp_op=NON;
    end

    assign op=temp_op;

endmodule // Op_Decoder