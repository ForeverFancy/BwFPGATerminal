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
    input UART_TXD_IN,
    output [7:0] byte,
    output done,
    output ru,
    output [7:0] an,
    output [6:0] seg,
    output dp,
    output [6:0] o_asc,
    //output [4:0] led,
    output UART_RXD_OUT,
    output vga_h_sync,
    output vga_v_sync,
    output [11:0] color
);
    wire clk;
    wire rst_n;

    clk_wiz_0 CLOCK (.clk_in1(CLK), .reset(reset), .clk_out1(clk), .locked(rst_n));    

    wire de;
    wire clk_60Hz;
    wire [8:0] row;
    wire [9:0] col;
    wire [11:0] c;
    wire [7:0] ascii;
    wire [4:0] led;
    assign o_asc=ascii[6:0];

    VGA my_VGA (.clk(clk), .rst_n(rst_n), .ascii(ascii), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), .o_row(row), .o_col(col), .color(color));
    
    DDU my_DDU (.clk(clk), .rst_n(rst_n), .cont(cont), .step(step), .mem(mem),
    .inc(inc), .dec(dec), .initaddr(initaddr), .IR(IR), .row(row), .col(col),
    .UART_TXD_IN(UART_TXD_IN), .ru(ru), .an(an), .seg(seg), .dp(dp), .byte(byte), .done(done),
    .ascii(ascii), .led(led), .serial(UART_RXD_OUT));
   
endmodule // top