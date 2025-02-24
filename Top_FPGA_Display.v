`timescale 1ns / 1ps

module Top_FPGA_Display(
    input wire clk,
    input wire reset,
    input wire [3:0] Dig_1,
    input wire [3:0] Dig_2,
    input wire [3:0] Dig_3,
    input wire [3:0] Dig_4,
    output wire [6:0] CA_out,
    output wire [3:0] anode_out
);

reg [3:0] x_mux;
wire clk_en;
wire [1:0] s;

ClockEnable clockenable(
    .clk(clk),
    .reset(reset),
    .clk_en(clk_en)
);

AnodeDriver anodedriver(
    .clk(clk_en),
    .reset(reset),
    .AN(anode_out),
    .s(s)
);


always @(s) begin
        if (reset) begin
            x_mux <= 4'b0000;
        end else begin
        case(s)
            2'b00: x_mux <= Dig_1;
             2'b01: x_mux <= Dig_2;
              2'b10: x_mux <= Dig_3;
               2'b11: x_mux <= Dig_4;
            default: x_mux <= 4'b0000;
        endcase
    end 
end 



SevenBit_Hex_Decoder hex7segmentDecoder(
    .x(x_mux),
    .ca(CA_out)
);

endmodule