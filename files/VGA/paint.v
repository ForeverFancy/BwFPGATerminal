module paint(
    input clk,
    input rst_n,
    input [8:0] row,
    input [9:0] col,
    input [6:0] ascii,
    output [11:0] color
);
parameter col_start = 192;
parameter col_end = 448;
parameter row_start = 112;
parameter row_end = 368;

parameter init_row = 200;
parameter init_col = 230;

wire [15:0] addra;
//128*16bit

wire [11:0] out_color;
dist_mem_gen_0 my_mem (.a(addra), .spo(out_color));

assign addra=(row-row_start)*ascii*16+(col-col_start);
assign color=out_color;


endmodule // paint