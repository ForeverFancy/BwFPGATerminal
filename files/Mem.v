module Mem(
    input clk,
    input rst_n,
    input we,
    input [31:0] write_data,
    input [7:0] write_addr,
    input [7:0] read_addr,
    output [31:0] data,
    output [31:0] data2
);

    dist_mem_gen_0 dist_mem (.a(read_addr), .d(write_data), .dpra(write_addr), .clk(clk), .we(we), .spo(data2), .dpo(data));

endmodule // Mem