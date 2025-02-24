`timescale 1ns / 1ps

module Extract_Dig(
input [7:0]digit_1,
output [3:0]ones_place,
output [3:0]tenths_place
    );   
    // This is for particularly the LED display such that it can get the correct values //
    assign ones_place = digit_1 % 10;
    
    assign tenths_place = digit_1 / 10;
    
endmodule


