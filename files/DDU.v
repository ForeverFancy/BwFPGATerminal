module counter(
    input clk,
    input rst_n,
    output [31:0] count
);
    reg [31:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)
            cnt<=31'd0;
        else if(cnt>=31'd250000)
            cnt<=31'd0;
        else
        begin
            cnt<=cnt+31'd1;
        end  
    end
    assign count=cnt;
endmodule

module seg_display(
    input [3:0] x,
    input [7:0] en,
    output [7:0] an,
    output [6:0] seg
    );
    reg [6:0] Seg;
    always @(*)
    begin
        case(x)
            4'd0:Seg = 7'b1000000;
            4'd1:Seg = 7'b1111001;
            4'd2:Seg = 7'b0100100;
            4'd3:Seg = 7'b0110000;
            4'd4:Seg = 7'b0011001;
            4'd5:Seg = 7'b0010010;
            4'd6:Seg = 7'b0000010;
            4'd7:Seg = 7'b1111000;
            4'd8:Seg = 7'b0000000;
            4'd9:Seg = 7'b0010000;
            4'd10:Seg = 7'b0001000;
            4'd11:Seg = 7'b0000011;
            4'd12:Seg = 7'b1000110;
            4'd13:Seg = 7'b0100001;
            4'd14:Seg = 7'b0000110;
            4'd15:Seg = 7'b0001110;
            default :Seg = 7'b1111111;
        endcase
    end
    assign an=en;
    assign seg=Seg;
endmodule

module DDU(
    input clk,
    input rst_n,
    input cont,
    input step,
    input mem,
    input inc,
    input dec,
    input [7:0] initaddr,
    input IR,
    input [8:0] row,
    input [9:0] col,
    input UART_TXD_IN,
    output [7:0] byte,
    output done,
    output ru,
    output [7:0] an,
    output [6:0] seg,
    output reg dp,
    output [7:0] ascii,
    output [4:0] led
);
    wire [31:0] reg_data;
    wire [31:0] ddu_data;
    wire [31:0] PC;
    wire [31:0] ir;
    reg run;
    reg [31:0] addr;
    assign ru=run;
    wire [31:0] MDR;
    wire CPU_mem_write;
    wire [31:0] CPU_mem_write_data;
    wire [12:0] CPU_write_addr;
    wire [12:0] CPU_read_addr;
    wire [31:0] CPU_mem_data;
    wire [11:0] VGA_addr;

    assign VGA_addr = 80 * row[8:4] + col[9:3];
    
    CPU my_CPU (.clk(clk), .rst_n(rst_n), .cont(cont), .run(run), .CPU_MDR(MDR), .ddu_addr(addr), .reg_data(reg_data), .PC(PC), .ir(ir), .CPU_mem_write(CPU_mem_write), .CPU_write_addr(CPU_write_addr) ,.CPU_mem_write_data(CPU_mem_write_data), .CPU_read_addr(CPU_read_addr));

    Mem my_mem (.clk(clk), .rst_n(rst_n), .UART_TXD_IN(UART_TXD_IN), .we(CPU_mem_write),
    .write_data(CPU_mem_write_data), .VGA_addr(VGA_addr),
    .write_addr(CPU_write_addr), .read_addr(CPU_read_addr), .data(CPU_mem_data), .byte(byte), .done(done),
     .data2(MDR), .ascii(ascii));
    
    wire [31:0] count;
    counter my_counter (.clk(clk), .rst_n(rst_n), .count(count));
    
    assign led=addr[4:0];
    //assign led[10:0]=PC[10:0];
    // assign addr=initaddr;

    parameter MOVE_PERIOD = 25_000_000;
    reg [31:0] move_cnt; 
    reg [31:0] move_cnt2;

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)
        begin
            move_cnt<=0;
            addr<=initaddr;
        end
        else if(move_cnt>=MOVE_PERIOD)
        begin
            move_cnt<=0;
            if(inc)
                addr<=addr-1;
            else if(dec)
                addr<=addr+1;
            // else if(step==~run)
            //     run<=~run;
        end
        else if(inc)
        begin
            move_cnt<=move_cnt+1;
            addr<=addr;
        end
        else if(dec)
        begin
            move_cnt<=move_cnt+1;
            addr<=addr;
        end
        // else if(step)
        // begin
        //     move_cnt<=move_cnt+1;            
        // end
        else
        begin
            move_cnt<=0;
            addr<=addr;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)
        begin
            move_cnt2<=0;
            run<=0;
        end
        else if(move_cnt2>=MOVE_PERIOD)
        begin
            move_cnt2<=0;
            if(step==~run)
                run<=step;
        end
        else
        begin
            move_cnt2<=move_cnt2+1;
            run<=run;
        end
    end

    reg [3:0] x;
    reg [7:0] en;
    assign ddu_data = mem ? CPU_mem_data : IR ? ir : reg_data;
    
    always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
    begin
        x=4'd0;
        en=8'b11111111;
        dp=1;
    end
    else 
    begin
    case (count[15:13])
        3'b000:begin
            en=~8'b10000000;
            x=ddu_data[31:28];
        end
        3'b001:begin
            en=~8'b01000000;
            x=ddu_data[27:24];
        end
        3'b010:begin
            en=~8'b00100000;
            x=ddu_data[23:20];
        end
        3'b011:begin
            en=~8'b00010000;
            x=ddu_data[19:16];
        end
        3'b100:begin
            en=~8'b00001000;
            x=ddu_data[15:12];
        end
        3'b101:begin
            en=~8'b00000100;
            x=ddu_data[11:8];
        end
        3'b110:begin
            en=~8'b00000010;
            x=ddu_data[7:4];
        end
        3'b111:begin
            en=~8'b00000001;
            x=ddu_data[3:0];
        end
        default: begin
        x=4'b1111;
        en=8'b11111111;
        dp=1;
        end
    endcase
    end
    end
    
    seg_display seg_display_unit (.x(x), .en(en), .an(an), .seg(seg));

endmodule // DDU   