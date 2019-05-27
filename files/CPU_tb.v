module CPU_tb(
    
);
    reg clk;
    reg rst_n;
    reg cont;
    reg run;
    reg [31:0] ddu_addr;
    wire [31:0] mem_data;
    wire [31:0] reg_data;
    wire [31:0] PC;
    wire [31:0] ir;
    integer i;
    
    CPU my_cpu (.clk(clk), .rst_n(rst_n), .cont(cont), .run(run), .ddu_addr(ddu_addr), .mem_data(mem_data), .reg_data(reg_data), .PC(PC), .ir(ir));
    
    initial
    begin
        clk=0;
        rst_n=0;
        #5 rst_n=1;
        cont=1;
        run=0;
        ddu_addr=0;
        for (i = 0;i < 500;i = i + 1) begin
            #10 clk=~clk;
        end
    end

endmodule // CPU_tb