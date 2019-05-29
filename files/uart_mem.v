// This file contains the UART Receiver.  This receiver is able to
// receive 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When receive is complete o_rx_dv will be
// driven high for one clock cycle.
// 
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87
  
// +----------------------------------------------+
// |  31   |  30   | 29 ...  8   |    7  ... 0    |
// | READY | VALID | don't care  |  Serial data   |
// +----------------------------------------------+

// Usage: When Data is valid, bit 30 == 1
//        Write bit 31 to 1 (1 cycle is okay) to read next
//        (then bit 31 will automatically set to 0)
// After CPU read the data, CPU set the ready bit to 0, and continue to receive the data.

module uart_mem (
    input mem_wen,
    input clk,
    input rst_n,
    input [31:0] mem_wdata,
    input o_Rx_DV,
    input [7:0] o_Rx_Byte,
    output [31:0] mem_rdata,
    output i_Rx_Next
  
);
    reg ready_bit;
    reg ready_bit_prev;
    assign mem_rdata[31]    =   ready_bit; // Ready bit
    assign mem_rdata[30]    =   o_Rx_DV;   // Valid bit
    assign mem_rdata[7:0]   =   o_Rx_Byte;
    assign mem_rdata[29:8]  =   23'b0;
    assign i_Rx_Next = ready_bit;
    
    always @ (posedge clk or negedge rst_n) 
      begin
        if (~rst_n) begin
            ready_bit <= 1'b0;
        end else begin
            if (mem_wen) begin
                ready_bit <= mem_wdata[31];
            end else begin
                ready_bit <= ready_bit;
            end
        end
      end

endmodule