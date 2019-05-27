module ALU #(parameter N = 5)
(
    input [N:0] a,
    input [N:0] b,
    input [3:0] op,
    output [N:0] res,
    output [3:0] flag
);
    reg [N:0] temp_res;
    reg [3:0] temp_flag;
    reg count;

    localparam SRL = 4'H00;
    localparam ADD = 4'H01;
    localparam SUB = 4'H02;
    localparam AND = 4'H03;
    localparam OR = 4'H04;
    localparam XOR = 4'H05;
    localparam NOT = 4'H06;
    localparam SRA = 4'H07;
    localparam NOR = 4'H08;
    localparam SLT = 4'H09;
    localparam NON = 4'H10;
    localparam SLTU = 4'H11;

    localparam CF = 4'b1000;
    localparam S = 4'b0100;
    localparam V = 4'b0010;
    localparam ZERO = 4'b0001;

    always @(*) begin
        case (op)
            NON: begin
                temp_res=0;
                temp_flag=0;
            end
            SRL: begin
                temp_res=0;
                temp_flag=0;
                temp_res=a >> b;
                if(temp_res==0)
                    temp_flag=ZERO;
            end
            ADD: begin
                count=0;
                temp_res=0;
                temp_flag=0;
                {count,temp_res}={1'b0,a}+{1'b0,b};
                if (count) begin
                    temp_flag=temp_flag+CF;
                end
                if(a[N]==b[N] && a[N]!=temp_res[N]) begin
                    temp_flag=temp_flag+V;
                end
                if(temp_res[N]==1) begin
                    temp_flag=temp_flag+S;
                end
                if(temp_res==0) begin
                    temp_flag=temp_flag+ZERO;
                end
            end
            SUB: begin
                count=0;
                temp_res=0;
                temp_flag=0;
                {count,temp_res}={1'b0,a}-{1'b0,b};
                if(temp_res[N]==1) begin
                    temp_flag=temp_flag+S;
                end
                if(temp_res==0) begin
                    temp_flag=temp_flag+ZERO;
                end
                if(a<b) begin
                    temp_flag=temp_flag+CF;
                end
                if((a[N]==0 && b[N]==1 && temp_res[N]==1) || (a[N]==1 && b[N]==0 && temp_res[N]==0))begin
                    temp_flag=temp_flag+V;
                end
            end
            AND: begin
                temp_res=0;
                temp_flag=0;
                temp_res=a&b;
                if(temp_res==0)
                    temp_flag=ZERO;
            end
            OR:  begin
                temp_res=0;
                temp_flag=0;
                temp_res=a|b;
                if(temp_res==0)
                    temp_flag=ZERO;
            end
            NOR: begin
                temp_res=0;
                temp_flag=0;
                temp_res=~(a|b);
                if(temp_res==0)
                    temp_flag=ZERO;
            end
            SLT: begin
                temp_res=0;
                temp_flag=0;
                if($signed(a)<$signed(b))
                    temp_res=1;
                else
                    temp_res=0;
                if(temp_res==0)
                    temp_flag=ZERO;
            end
            SLTU: begin
                temp_res=0;
                temp_flag=0;
                if($unsigned(a)<$unsigned(b))
                    temp_res=1;
                else
                    temp_res=0;
                if(temp_res==0)
                    temp_flag=ZERO;
            end
            XOR: begin
                temp_res=0;
                temp_flag=0;
                temp_res=a ^ b;
                if(temp_res==0)
                    temp_flag=ZERO;
            end
            NOT: begin
                temp_res=0;
                temp_flag=0;
                temp_res=~a;
                if(temp_res==0)
                    temp_flag=ZERO;
            end
            SRA: begin
                temp_res=0;
                temp_flag=0;
                temp_res=($signed(a)) >>> b;
                if(temp_res==0)
                    temp_flag=ZERO;
                if(temp_res[N]==1)
                    temp_flag=temp_flag+S;
            end          
          default: begin
            temp_res=0;
            temp_flag=0;
          end
        endcase
    end
    
    assign res=temp_res;
    assign flag=temp_flag;

endmodule // ALU