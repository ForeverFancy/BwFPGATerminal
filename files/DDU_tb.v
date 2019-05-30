module DDU_tb(
    
);
    reg clk;
    reg rst_n;
    reg cont;
    reg step;
    reg mem;
    reg inc;
    reg dec;
    reg [7:0] initaddr;
    reg IR;
    reg [8:0] row;
    reg [9:0] col;
    reg UART_TXD_IN;
    wire ru;
    wire [7:0] an;
    wire [6:0] seg;
    wire dp;
    wire [7:0] ascii;
    wire [15:0] led;

    integer i;
    integer j;
    DDU my_DDU_tb (.clk(clk), .rst_n(rst_n), .cont(cont), .step(step), .mem(mem),
    .inc(inc), .dec(dec), .initaddr(initaddr), .IR(IR), .row(row), .col(col),
    .UART_TXD_IN(UART_TXD_IN), .ru(ru), .an(an), .seg(seg), .dp(dp),
    .ascii(ascii), .led(led));

    initial
    begin
        clk=0;
        cont=1;
        rst_n=0;
        step=0;
        initaddr=0;
        UART_TXD_IN=1;
        inc=0;
        dec=0;
        mem=0;
        #5 rst_n=1;
        //ddu_addr=0;
        for (i = 0;i < 2000;i = i + 1) begin
            #10 clk=~clk;
            if(i==5)
            UART_TXD_IN=0;
            if(i==30)
            UART_TXD_IN=1;
        end
    end
    

endmodule // DDU_tb
