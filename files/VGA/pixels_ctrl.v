module pixels_ctrl(
    input clk,
    input rst_n,
    input [5:0] ascii,
    input [8:0] row,
    input [9:0] col,
    output reg [11:0] color
);

parameter col_start = 192;
parameter col_end = 200;
parameter row_start = 112;
parameter row_end = 128;
//80*30 mem
wire [127:0] data;
paint paint_ctrl (.ascii(ascii), .data(data));

wire character;                                 //Use the real position.
assign character = (row >= row_start) && (row <= row_end) && (col >= col_start) && (col <= col_end) && (data[(row-row_start)*16+col-col_start] == 1);

always @(*) begin
    if(col<=col_start | col>=col_end | row<=row_start | row>=row_end)
        color<=12'b0000_0000_0000;
    else if(character)
        color<=12'b0000_1111_0000;
    else
        color<=12'b1111_1111_1111;
end
endmodule // pixels_ctrl