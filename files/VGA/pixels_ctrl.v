module pixels_ctrl(
    input clk,
    input rst_n,
    //input [5:0] ascii,
    input [8:0] row,
    input [9:0] col,
    output reg [11:0] color
);

wire [8:0] row_start;
wire [8:0] row_end;
wire [9:0] col_start;
wire [9:0] col_end;

//80*30 mem
wire [127:0] data;
wire [7:0] ascii;

wire [11:0] addr;
assign addr= 80 * row[8:4] + col[9:3];

dist_mem_gen_1 vram (.dpra(addr), .clk(clk), .we(0), .a(addr), .d(0), .dpo(ascii));

paint paint_ctrl (.ascii(ascii), .data(data));

wire character;                                 //Use the real position.
assign row_start=(row>>4)*16;
assign col_start=(col>>3)*8;
assign row_end=row_start+16;
assign col_end=col_start+8;

assign character = (row >= row_start) && (row < row_end) && (col >= col_start) && (col < col_end) && (data[127-((row-row_start)*8-col+col_start)] == 1);

always @(*) begin
    if(character)
        color<=12'b1111_1111_1111;
    else
        color<=12'b0000_0000_0000;
end
endmodule // pixels_ctrl