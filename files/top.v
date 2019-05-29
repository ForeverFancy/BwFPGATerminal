module top(
    input CLK,
    input reset,
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
    output ru,
    output [7:0] an,
    output [6:0] seg,
    output reg dp,
    output [7:0] ascii,
    output [15:0] led,
    output vga_h_sync,
    output vga_v_sync,
    output [3:0] VGA_G,
    output [3:0] VGA_R,
    output [3:0] VGA_B
);
    wire clk;
    wire rst_n;
    clk_wiz_0 my_clk (.clk_in1(CLK), .reset(reset), .locked(rst_n), .clk_out1(clk));

    wire de;
    wire clk_60Hz;
    wire [8:0] row;
    wire [9:0] col;
    wire [11:0] c;
    wire [7:0] ascii;

    VGA my_VGA (.clk(clk), .rst_n(rst_n), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), .de(de), .clk_60Hz(clk_60Hz), .row(row), .col(col));
    
    pixels_ctrl pixels_ctrl_unit (.clk(clk_60Hz), .rst_n(rst_n), .row(row),  .col(col), .ascii(ascii), .color(c));
    
    DDU my_DDU (.clk(clk), .rst_n(rst_n), .cont(cont), .step(step), .mem(mem),
    .inc(inc), .dec(dec), .initaddr(initaddr), .IR(IR), .row(row), .col(col),
    .UART_TXD_IN(UART_TXD_IN) .ru(ru), .an(an), .seg(seg), .dp(dp),
    .ascii(ascii), .led(led));

    wire [11:0] color;
    assign color = de ? c : 0;
    assign VGA_R=color[11:8];
    assign VGA_G=color[7:4];
    assign VGA_B=color[3:0];
    
endmodule // top