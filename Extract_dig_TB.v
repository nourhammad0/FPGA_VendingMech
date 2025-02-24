`timescale 1ns / 1ps
module Extract_dig_TB;
    
    reg [7:0] num; 
    wire [3:0] tenths; 
    wire [3:0] ones;
    
    Extract_Dig DUT (
        .digit_1(num),
        .ones_place(ones),
        .tenths_place(tenths)
    );

initial begin
    num = 7'd95;
    #10;
    $display("num = %d, tenths = %d, ones = %d", num, tenths, ones);
    
    num = 6'd25; 
    #10; 
    $display("num = %d, tenths = %d, ones = %d", num, tenths, ones);

$finish;
end
    
    
endmodule
