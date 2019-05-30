// This file contains the UART Receiver.  This receiver is able to
// receive 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When receive is complete o_rx_dv will be
// driven high for one clock cycle.
// 
  
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
    wire ready_bit;
    reg ready_bit_prev;
    assign mem_rdata[31]    =   o_Rx_DV;    // Ready bit
    // assign mem_rdata[30]    =   o_Rx_DV;   // Valid bit
    assign mem_rdata[7:0]   =   o_Rx_Byte;
    assign mem_rdata[30:8]  =   23'b0;
    // assign i_Rx_Next = ready_bit;
    assign i_Rx_Next = ~ready_bit;
    assign ready_bit = ~rst_n ? 1'b1 : mem_wen ? mem_wdata[31] :o_Rx_DV;
    
    // always @ (posedge clk or negedge rst_n) 
    //   begin
    //     if (~rst_n) begin
    //         ready_bit <= 1'b1;
    //     end else begin
    //         if (mem_wen) begin
    //             ready_bit <= mem_wdata[31];
    //         end else begin
    //             ready_bit <= o_Rx_DV;
    //         end
    //     end
    //   end
    
    // always @ (posedge clk or negedge rst_n)
    //   begin
    //     if (~rst_n) begin
    //       ready_bit_prev <= 1'b0;
    //     end else begin
    //       ready_bit_prev <= ready_bit;
    //     end
    //   end
endmodule