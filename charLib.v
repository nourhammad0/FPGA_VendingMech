`timescale 1ns / 1ps

module charLib(
    input clka,
    input [10:0] addra,
    output [7:0] douta
    );
    
    BRAM_wrapper inst(
    .BRAM_PORTA_0_addr(addra),
    .BRAM_PORTA_0_clk(clka),
    .BRAM_PORTA_0_din(8'b0),
    .BRAM_PORTA_0_dout(douta),
    .BRAM_PORTA_0_we());
    
endmodule
