`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 11:48:56 PM
// Design Name: 
// Module Name: Clk_OLED
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Clk_OLED(
    input wire clk_in,    // 100MHz input clock
    input wire reset,     // Reset signal
    output reg clk_out    // 1Hz output clock
);

    reg [16:0] counter;   // 26-bit counter to count 50 million cycles

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == 999999) begin
                counter <= 0;
                clk_out <= ~clk_out;  // Toggle the output clock
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
