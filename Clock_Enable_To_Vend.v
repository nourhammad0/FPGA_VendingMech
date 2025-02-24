`timescale 1ns / 1ps


module Clock_Enable_To_Vend(
    input clk,
    input reset,
    output reg clk_en
    );
    
    
reg [31:0] counter = 0;

always @(posedge clk or posedge reset)
begin
            if (reset) begin
            counter <= 0;
            clk_en <= 0;
            end
                else if(counter == 49999999)  // To make it a presentable on FPGA board make 1 Hz = 49999999
                        begin
                            counter <= 0;
                            clk_en <= 1;
                        end 
                            else 
                            begin
                                clk_en <= 0;
                                counter <= counter + 1;
                            end
 end
 
    
    
endmodule