module Register_File #(parameter M = 3,parameter N = 3)
(
    input [M:0] ra0,
    input [M:0] ra1,
    input [M:0] ra2,
    input [M:0] wa,
    input [N:0] wd,
    input we,
    input rst_n,
    input clk,
    output [N:0] rd0,
    output [N:0] rd1,
    output [N:0] rd2
);

    integer i;
    reg [N:0] mem [0:(1<<(M+1))-1];

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)
        begin
            for (i = 0;i < 1<<(M+1);i = i + 1) begin
                mem[i]=0;
            end
        end
        else if(we)
        begin
            mem[wa]=wd;
        end
    end

    assign rd0=mem[ra0];
    assign rd1=mem[ra1];
    assign rd2=mem[ra2];

endmodule // register_file