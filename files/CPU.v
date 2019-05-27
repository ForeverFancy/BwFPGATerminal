module CPU(
    input clk,
    input rst_n,
    input cont,
    input run,
    input [31:0] ddu_addr,
    output [31:0] mem_data,
    output [31:0] reg_data,
    output [31:0] ir,
    output reg [31:0] PC
);  
    wire [31:0] Read_data1;
    wire [31:0] Read_data2;
    wire [4:0] reg_addr1;
    wire [4:0] reg_addr2;
    wire [4:0] reg_addr3;
    wire [4:0] reg_write_addr;
    wire [31:0] reg_write_data;
    wire signed [31:0] Sign_extend_IR;
    wire [31:0] Zero_extend_IR;
    wire [31:0] Next_PC;

    reg [31:0] IR;
    wire [31:0] MDR;
    wire [31:0] ALU_res;
    wire [31:0] mem_addr;
    wire [31:0] mem_write_data;
    reg [31:0] ALUout;
    
    wire [5:0] op;
    wire [2:0] i_op;
    wire [5:0] funct;
    wire [15:0] imm;

    assign op=IR[31:26];
    assign i_op=IR[28:26];
    assign funct=IR[5:0];
    assign imm=IR[15:0];

    wire PCWriteCond;
    wire PCWrite;
    wire IorD;
    wire MemRead;
    wire MemWrite;
    wire MemtoReg;
    wire IRWrite;
    wire [1:0] PCSource;
    wire [1:0] ALUOp;
    wire ALUSrcA;
    wire [2:0] ALUSrcB;
    wire RegWrite;
    wire RegDst;

    //ALU unit
    wire [3:0] flag;
    wire [3:0] ALU_opcode;
    wire [31:0] a;
    wire [31:0] b;

    assign Sign_extend_IR=$signed(IR[15:0]);
    assign Zero_extend_IR=$unsigned(IR[15:0]);

    assign a = ALUSrcA ? Read_data1 : PC;
    assign b = ALUSrcB == 3'b000 ? Read_data2 :ALUSrcB == 3'b001 ? 4 : ALUSrcB == 3'b010 ? Sign_extend_IR : ALUSrcB == 3'b011 ? Sign_extend_IR << 2 : Zero_extend_IR;

    Op_Decoder op_decoder (.ALUOp(ALUOp), .funct(funct), .i_op(i_op), .op(ALU_opcode));

    ALU #(31) ALU_unit (.a(a), .b(b), .op(ALU_opcode), .res(ALU_res), .flag(flag));

    //Reg unit
    assign reg_write_addr = RegDst ? IR[15:11] : IR[20:16];
    assign reg_write_data = MemtoReg ? MDR : ALUout;
    assign reg_addr1 = IR[25:21];
    assign reg_addr2 = IR[20:16];
    assign reg_addr3 = ddu_addr[4:0];
    //32 regs.
    Register_File #(4,31) my_reg (.ra0(reg_addr1), .ra1(reg_addr2), .ra2(reg_addr3), .wa(reg_write_addr), 
    .wd(reg_write_data), .we(RegWrite), .rst_n(rst_n), .clk(clk), .rd0(Read_data1), .rd1(Read_data2), .rd2(reg_data));
    
    //Mem unit
    assign mem_addr=IorD ? ALUout:PC;
    wire [7:0] read_addr;
    wire [7:0] write_addr;

    assign read_addr=mem_addr[9:2];
    assign write_addr=MemWrite ? mem_addr[9:2] : ddu_addr;

    assign mem_write_data=Read_data2;
    Mem my_mem (.clk(clk), .rst_n(rst_n), .we(MemWrite), .write_data(mem_write_data),
    .write_addr(write_addr), .read_addr(read_addr), .data(mem_data), .data2(MDR));
    
    //control unit
    Control control_unit (.clk(clk), .rst_n(rst_n), .cont(cont), .run(run), .op(op),
    .PCWriteCond(PCWriteCond), .PCWrite(PCWrite), .IorD(IorD), 
    .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg),
    .IRWrite(IRWrite), .PCSource(PCSource), .ALUOp(ALUOp), 
    .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .RegWrite(RegWrite), .RegDst(RegDst));
    
    wire [31:0] PC_Jump;
    assign PC_Jump = {PC[31:28], IR[25:0], 2'b00};
    
    assign Next_PC = PCSource==2'b00 ? (PC+4) : PCSource==2'b01 ? ALUout :PC_Jump;
    
    wire PCNextEN;
    wire ZERO;

    assign ZERO=flag[0];
    assign PCNextEN = (PCWriteCond && ZERO && ~op[0]) || (PCWriteCond && ~ZERO && op[0]) ||PCWrite;
    
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)
        begin
            PC<=0;
            IR<=0;
            ALUout<=0;
        end
        else
        begin
            if(PCNextEN)
                PC<=Next_PC;
            if(IRWrite)
                IR<=MDR;
            ALUout<=ALU_res;
        end
    end

    assign ir=IR;

endmodule // 