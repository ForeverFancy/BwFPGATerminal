module Control(
    input clk,
    input rst_n,
    input [5:0] op,
    input cont,
    input run,
    output reg PCWriteCond,
    output reg PCWrite,
    output reg IorD,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg IRWrite,
    output reg [1:0] PCSource,
    output reg [1:0] ALUOp,
    output reg ALUSrcA,
    output reg [2:0] ALUSrcB,
    output reg RegWrite,
    output reg RegDst
);
    reg [4:0] state;
    reg [4:0] next_state;

    parameter instruction_fetch = 0;
    parameter instruction_decode_and_register_fetch = 1;
    parameter memory_address_compution = 2;
    parameter memory_access_lw = 3;
    parameter write_back = 4;
    parameter memory_access_sw = 5;
    parameter execution = 6;
    parameter r_completion = 7;
    parameter branch_completion = 8;
    parameter jump_completion = 9;
    parameter init = 10;
    parameter i_exec = 11;
    parameter i_write_back = 12;
    parameter wait_mem = 13;
    parameter i_logic_exec = 14;
    parameter ready0 = 15;
    parameter ready1 = 16;
    parameter wait_reg = 17;

    parameter lw = 6'b100_011;
    parameter sw = 6'b101_011;
    parameter r_type = 6'b000_000;
    parameter beq = 6'b000_100;
    parameter bne = 6'b000_101;
    parameter j = 6'b000_010;
    parameter addi = 6'b001_000;
    parameter andi = 6'b001_100;
    parameter ori = 6'b001_101;
    parameter xori = 6'b001_110;
    parameter slti = 6'b001_010;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)
        begin
            state<=init;
        end
        else
        begin
            state<=next_state;
        end
    end

//TODO:Finish this part.
    always @(state) begin
        case(state)
            init:
            begin
                PCWriteCond=0;
                PCWrite=0;
                IorD=0;
                MemRead=0;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=0;
                PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=0;
                ALUSrcB=3'b000;
                RegWrite=0;
                RegDst=0;
            end
            wait_mem:
            begin
                PCWriteCond=0;
                PCWrite=0;
                IorD=0;
                MemRead=0;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=0;
                PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=0;
                ALUSrcB=3'b000;
                RegWrite=0;
                RegDst=0;
            end
            instruction_fetch:
            begin
                PCWriteCond=0;
                PCWrite=1;         
                IorD=0;            //instruction
                MemRead=1;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=1;
                PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=0;
                ALUSrcB=3'b001;
                RegWrite=0;
                RegDst=0;
            end
            instruction_decode_and_register_fetch:
            begin
                // PCWriteCond=0;
                // PCWrite=0;
                // IorD=0;
                // MemRead=0;
                // MemWrite=0;
                // MemtoReg=0;
                // IRWrite=0;
                // PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=0;
                ALUSrcB=3'b011;
                // RegWrite=0;
                // RegDst=0;
            end
            memory_address_compution:
            begin
                PCWriteCond=0;
                PCWrite=0;
                // IorD=0;
                // MemRead=0;
                // MemWrite=0;
                // MemtoReg=0;
                // IRWrite=0;
                // PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=1;
                ALUSrcB=3'b010;
                // RegWrite=0;
                // RegDst=0;
            end
            memory_access_lw:
            begin
                PCWriteCond=0;
                PCWrite=0;
                IorD=1;
                MemRead=1;
                // MemWrite=0;
                // MemtoReg=0;
                // IRWrite=0;
                // PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=1;
                ALUSrcB=3'b010;
                // RegWrite=0;
                // RegDst=0;
            end
            write_back:
            begin
                PCWriteCond=0;
                PCWrite=0;
                IorD=1;
                // MemRead=0;
                // MemWrite=0;
                MemtoReg=1;
                // IRWrite=0;
                // PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=1;
                ALUSrcB=3'b010;
                RegWrite=1;
                RegDst=0;
            end
            wait_reg:
            begin
                // PCWriteCond=0;
                PCWrite=0;
                IorD=1;
                // MemRead=0;
                // MemWrite=0;
                MemtoReg=1;
                // IRWrite=0;
                // PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=1;
                ALUSrcB=3'b010;
                RegWrite=1;
                RegDst=0;
            end
            memory_access_sw:
            begin
                // PCWriteCond=0;
                // PCWrite=0;
                IorD=1;
                // MemRead=0;
                MemWrite=1;
                // MemtoReg=0;
                // IRWrite=0;
                // PCSource=2'b00;
                // ALUOp=2'b00;
                // ALUSrcA=0;
                // ALUSrcB=3'b000;
                // RegWrite=0;
                // RegDst=0;
            end
            execution:
            begin
                PCWriteCond=0;
                PCWrite=0;
                IorD=0;
                MemRead=0;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=0;
                PCSource=2'b00;
                ALUOp=2'b10;
                ALUSrcA=1;
                ALUSrcB=3'b000;
                RegWrite=0;
                RegDst=0;
            end
            r_completion:
            begin
                PCWriteCond=0;
                PCWrite=0;
                IorD=0;
                MemRead=0;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=0;
                PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=0;
                ALUSrcB=3'b000;
                RegWrite=1;
                RegDst=1;
            end
            branch_completion:
            begin
                PCWriteCond=1;
                PCWrite=0;
                IorD=0;
                MemRead=0;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=0;
                PCSource=2'b01;
                ALUOp=2'b01;
                ALUSrcA=1;
                ALUSrcB=3'b000;
                RegWrite=0;
                RegDst=0;
            end
            jump_completion:
            begin
                PCWriteCond=0;
                PCWrite=1;
                IorD=0;
                MemRead=0;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=0;
                PCSource=2'b10;
                ALUOp=2'b00;
                ALUSrcA=0;
                ALUSrcB=3'b000;
                RegWrite=0;
                RegDst=0;
            end
            i_exec:
            begin
                PCWriteCond=0;
                PCWrite=0;
                IorD=0;
                MemRead=0;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=0;
                PCSource=2'b00;
                ALUOp=2'b11;
                ALUSrcA=1;
                ALUSrcB=3'b010;
                RegWrite=0;
                RegDst=0;
            end
            i_logic_exec:
            begin
                PCWriteCond=0;
                PCWrite=0;
                IorD=0;
                MemRead=0;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=0;
                PCSource=2'b00;
                ALUOp=2'b11;
                ALUSrcA=1;
                ALUSrcB=3'b100;
                RegWrite=0;
                RegDst=0;
            end
            i_write_back:
            begin
                PCWriteCond=0;
                PCWrite=0;
                IorD=0;
                MemRead=0;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=0;
                PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=0;
                ALUSrcB=3'b000;
                RegWrite=1;
                RegDst=0;
            end
            default:
            begin
                PCWriteCond=0;
                PCWrite=0;
                IorD=0;
                MemRead=0;
                MemWrite=0;
                MemtoReg=0;
                IRWrite=0;
                PCSource=2'b00;
                ALUOp=2'b00;
                ALUSrcA=0;
                ALUSrcB=3'b000;
                RegWrite=0;
                RegDst=0;
            end
        endcase
    end

    always @(state or run or cont) begin
        case (state)
            init:
            begin
                if(cont==1)
                    next_state=instruction_fetch;
                else if(cont==0 && run==1)
                    next_state=instruction_fetch;
                else
                    next_state=ready0;
            end
            instruction_fetch:
            begin
                next_state=wait_mem;
            end
            wait_mem:
            begin
                next_state=instruction_decode_and_register_fetch;
            end
            instruction_decode_and_register_fetch:
            begin
                case(op)
                    lw:
                    begin
                        next_state=memory_address_compution;
                    end
                    sw:
                    begin
                        next_state=memory_address_compution;
                    end
                    r_type:
                    begin
                        next_state=execution;
                    end
                    beq:
                    begin
                        next_state=branch_completion;
                    end
                    bne:
                    begin
                        next_state=branch_completion;
                    end
                    j:
                    begin
                        next_state=jump_completion;
                    end
                    addi:
                    begin
                        next_state=i_exec;
                    end
                    andi:
                    begin
                        next_state=i_logic_exec;
                    end
                    ori:
                    begin
                        next_state=i_logic_exec;
                    end
                    xori:
                    begin
                        next_state=i_logic_exec;
                    end
                    slti:
                    begin
                        next_state=i_exec;
                    end
                    default:
                    begin
                        next_state=init;
                    end
                endcase
            end
            i_logic_exec:
            begin
                next_state=i_write_back;
            end
            memory_address_compution:
            begin
                case (op)
                    lw:next_state=memory_access_lw;
                    sw:next_state=memory_access_sw; 
                    default: next_state=init;
                endcase
            end
            memory_access_lw:
            begin
                next_state=write_back;
            end
            write_back:
            begin
                next_state=wait_reg;
            end
            wait_reg:
            begin
                if(cont==1)
                    next_state=instruction_fetch;
                else if(cont==0 && run==1)
                    next_state=ready1;
                else
                    next_state=ready0;
            end
            memory_access_sw:
            begin
                if(cont==1)
                    next_state=instruction_fetch;
                else if(cont==0 && run==1)
                    next_state=ready1;
                else
                    next_state=ready0;
            end
            execution:
            begin
                next_state=r_completion;
            end
            r_completion:
            begin
                if(cont==1)
                    next_state=instruction_fetch;
                else if(cont==0 && run==1)
                    next_state=ready1;
                else
                    next_state=ready0;
            end
            branch_completion:
            begin
                if(cont==1)
                    next_state=instruction_fetch;
                else if(cont==0 && run==1)
                    next_state=ready1;
                else
                    next_state=ready0;
            end
            jump_completion:
            begin
                if(cont==1)
                    next_state=instruction_fetch;
                else if(cont==0 && run==1)
                    next_state=ready1;
                else
                    next_state=ready0;
            end
            i_exec:
            begin
                next_state=i_write_back;
            end
            i_write_back:
            begin
                if(cont==1)
                    next_state=instruction_fetch;
                else if(cont==0 && run==1)
                    next_state=ready1;
                else
                    next_state=ready0;
            end
            ready0:
            begin
                if(cont==1)
                    next_state=instruction_fetch;
                else if(cont==0 && run==1)
                    next_state=instruction_fetch;
                else
                    next_state=ready0;
            end
            ready1:
            begin
                if(cont==1)
                    next_state=instruction_fetch;
                else if(cont==0 && run==0)
                    next_state=instruction_fetch;
                else
                    next_state=ready1;
            end
            default:
            begin
                next_state=init;
            end    
        endcase
    end

endmodule // Control