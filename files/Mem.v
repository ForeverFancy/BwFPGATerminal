module Mem(
    input clk,
    input rst_n,
    input we,
    input UART_TXD_IN,
    input [31:0] write_data,
    input [7:0] write_addr,
    //input [31:0] v_data,
    input [11:0] VGA_addr,
    input [7:0] read_addr,
    output [31:0] data,
    output [31:0] data2,
    output [31:0] ascii
);
    parameter display_ram_start = 256;
    parameter display_ram_end = 4352;
    parameter uart_ram_addr = 4353;      //0x1101

    wire is_main_ram;
    wire is_display_ram;
    wire is_uart_ram;

    assign is_main_ram = write_addr < display_ram_start ;
    assign is_display_ram = (write_addr >= display_ram_start) && (write_addr < display_ram_end);
    assign is_uart_ram = ( write_addr == uart_ram_addr ); 

    wire [31:0] main_ram_data;

    dist_mem_gen_0 dist_mem_0 (.a(read_addr), .d(write_data), .dpra(write_addr), .clk(clk), .we(we && is_main_ram), .spo(main_ram_data), .dpo(data));
    
    wire [31:0] v_out_data;

    dist_mem_gen_1 dist_mem_1 (.a(VGA_addr - display_ram_start), .d(write_data), .dpra(write_addr - display_ram_start), .clk(clk), .we(we && is_display_ram), .spo(v_out_data), .dpo(ascii));

    wire i_Rx_Next;
    wire o_Rx_DV;
    wire [7:0] o_Rx_Byte;
    wire [31:0] uart_data;

    uart_rx uart_receiver (.i_Clock(clk), .i_Rx_Serial(UART_TXD_IN), .i_Rx_Next(i_Rx_Next), .o_Rx_DV(o_Rx_DV), .o_Rx_Byte(o_Rx_Byte));

    uart_mem my_uart_mem (.mem_wen(we && is_uart_ram), .clk(clk), .rst_n(rst_n), .mem_wdata(write_data), .o_Rx_DV(o_Rx_DV), .o_Rx_Byte(o_Rx_Byte), .mem_rdata(uart_data), .i_Rx_Next(i_Rx_Next));

    assign data2 = is_main_ram ? main_ram_data : uart_data;

endmodule // Mem