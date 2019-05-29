module Mem(
    input clk,
    input rst_n,
    input we,
    input [31:0] write_data,
    input [7:0] write_addr,
    input [31:0] v_data,
    input [5:0] VGA_addr,
    input [7:0] read_addr,
    output [31:0] data,
    output [31:0] data2,
    output [31:0] v_out_data
);

    dist_mem_gen_0 dist_mem_0 (.a(read_addr), .d(write_data), .dpra(write_addr), .clk(clk), .we(we), .spo(data2), .dpo(data));
    wire [5:0] v_addr;
    assign v_addr= read_addr >= 256 ? read_addr-256 : 0;
    dist_mem_gen_1 dist_mem_1 (.a(v_addr), .d(v_data), .dpra(VGA_addr), .clk(clk), .we(we), .spo(v_out_data), .dpo(v_out_data));

    //uart_mem my_uart_mem (.mem_wen(), .clk(clk), .rst_n(rst_n), .mem_wdata(), .o_Rx_DV(), .o_Rx_Byte(), mem_rdata(), i_Rx_Next() )

endmodule // Mem