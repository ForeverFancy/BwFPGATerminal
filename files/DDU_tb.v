module DDU_tb(
    
);
    reg clk;
    reg reset;
    reg cont;
    reg step;
    reg mem;
    reg inc;
    reg dec;
    wire [7:0] an;
    wire [6:0] seg;
    wire dp;
    wire [15:0] led;

    integer i;
    integer j;
    DDU my_ddu (.clk(clk), .reset(reset), .cont(cont), .step(step), .mem(mem), .inc(inc), .dec(dec), .an(an), .seg(seg), .dp(dp), .led(led));
    
    initial
    begin
        clk=0;
        cont=0;
        
        reset=1;
        inc=0;
        dec=0;
        mem=1;
        #5 reset=0;
        //ddu_addr=0;
        for (i = 0;i < 500;i = i + 1) begin
            #10 clk=~clk;
        end
    end
    initial
    begin
        step=1;
        #15 step=0;
        for (j = 0;j < 1500;j = j + 1) begin
                #3 step=~step;
            end
        
    end

endmodule // DDU_tb
