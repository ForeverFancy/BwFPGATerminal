module pixels_ctrl(
    input clk,
    input rst_n,
    input ascii,
    input [8:0] row,
    input [9:0] col,
    output reg [11:0] color
);

parameter col_start = 192;
parameter col_end = 448;
parameter row_start = 112;
parameter row_end = 368;

wire [8:0] mouse_row;
wire [9:0] mouse_col;                      //Use the real position.

wire mouse;
assign mouse=(col>=mouse_col-10 && col<=mouse_col+10 && row>=mouse_row-1 && row<=mouse_row+1) || (row>=mouse_row-10 && row<=mouse_row+10 && col>=mouse_col-1 && col<=mouse_col+1);

wire [11:0] bg_color;
paint paint_ctrl (.clk(clk), .rst_n(rst_n), .row(row), .col(col), .ascii(ascii), .color(bg_color));

always @(*) begin
    if(col<=col_start | col>=col_end | row<=row_start | row>=row_end)
        color<=12'b0000_0000_0000;
    else if(mouse)
        color<=12'b0000_1111_0000;
    else
        color<=bg_color;
end
endmodule // pixels_ctrl