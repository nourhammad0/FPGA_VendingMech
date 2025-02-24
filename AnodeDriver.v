`timescale 1ns / 1ps


module AnodeDriver(
    input clk,
    //input clk_en,
    input reset,
    output reg [3:0] AN,
    output reg [1:0] s
    );


always @(posedge clk or posedge reset) begin
    if (reset) begin
        s <= 0;
    end else begin
        s <= s + 1;
    end
end

 always @(*) begin
    case(s)
        2'b00: AN <= 4'b1110;
        2'b01: AN <= 4'b1101;
        2'b10: AN <= 4'b1011;
        2'b11: AN <= 4'b0111;
    endcase
end
endmodule