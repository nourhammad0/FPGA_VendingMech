`timescale 1ns / 1ps

module Controrller_Do_Not_Use(

    input wire [3:0] a, b, 
    input wire clk, 
    input wire clr,
    input wire start,
    output reg shiftControl, 
    output reg in
);
    // States
    parameter LOAD = 2'b00;
    parameter DONE = 2'b01;
    parameter CLEAR = 2'b10;
    parameter IDLE = 2'b11;
    
    reg [1:0] current_s, next_s;
    reg [4:0] count = 4'd0;
    reg done;

     always @(negedge clk or posedge clr) begin
        if (clr) begin
            current_s <= CLEAR;
            count <= 0;
            //in <= 0;        

        end else if (start) begin
            current_s <= LOAD;
        end else if (shiftControl) begin
            if (count < 4) begin
                in <= a[count];  
            end else if (count < 8) begin
                in <= 0;        
            end else if (count < 12) begin
                in <= b[count - 8];
//            end else if (count < 20) begin
//                in <= 0;
            end else if (count == 20) begin
                current_s <= DONE; 
                count <= 0;
                in <= 0;
            end
            count <= count + 1;
        end else begin
            current_s <= next_s;
        end
    end

                always @(*) begin
        case (current_s) // Next State being defined 
           CLEAR: begin
                next_s <= IDLE;
                shiftControl <= 0;
                done <= 0;
            end
            LOAD: begin
                next_s <= LOAD;
                shiftControl <= 1;
//                done <= 1;
            end
            DONE: begin
                next_s <= IDLE;
                done <= 1;
                shiftControl <= 0;
            end
            IDLE: begin
                next_s <= IDLE;
                shiftControl <= 0;

            end
            default: begin
                next_s <= IDLE;
                shiftControl <= 0;
            end
        endcase
    end    
endmodule
     
   
   
