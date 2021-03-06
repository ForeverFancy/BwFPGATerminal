
module Counter16(
    input Clk,
    input rst,
    input [15:0] range,
    output reg [15:0] count
);
    always @(posedge Clk or negedge rst) begin
        if (~rst) begin
            count<=0;
        end else if(count==range-1)
        begin
            count<=0;
        end
        else
        begin
            count<=count+1;
        end
    end

endmodule // Counter16


module VGA(
    input clk,
    input rst_n,
    input [7:0] ascii,
    output [8:0] o_row,                     
    output [9:0] o_col,
    output vga_h_sync,
    output vga_v_sync,
    output [11:0] color
    );
    
    wire [8:0] row;                     
    wire [9:0] col;                      
    
    wire [11:0] c;
	parameter H_SYNC = 96;
	parameter H_BEGIN = 144;
	parameter H_END = 784;
	parameter H_PERIOD = 800;
	parameter V_SYNC = 2;
	parameter V_BEGIN = 31;
	parameter V_END = 511;
	parameter V_PERIOD = 521;

    wire clk_60Hz;
    
    wire [9:0] hcount;
    Counter16 hcounter (.Clk(clk), .rst(rst_n), .range(H_PERIOD), .count(hcount));
    assign vga_h_sync=(hcount<H_SYNC)?0:1;
    assign col=hcount-H_BEGIN;

    wire [9:0] vcount;
    Counter16 vcounter (.Clk(~hcount[9]), .rst(rst_n), .range(V_PERIOD), .count(vcount));
    assign vga_v_sync=(vcount<=V_SYNC)?0:1;
    assign row=vcount-V_BEGIN;
   
    assign clk_60Hz=(hcount==0)&&(vcount==0);
    pixels_ctrl pixels_ctrl_unit (.clk(clk_60Hz), .rst_n(rst_n), .ascii(ascii), .row(row), .col(col), .color(c));
    
    wire de;
    assign de=(hcount>=H_BEGIN) && (hcount<H_END) && (vcount>=V_BEGIN) && (vcount<V_END);
    assign color=de?c:0;
    
    assign o_row=row;
    assign o_col=col;
endmodule
