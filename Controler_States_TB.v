`timescale 1ns / 1ps

module Controler_States_TB;
// Inputs 
reg clk; 
reg clr; 
reg purchase; 
reg nickel; 
reg dime; 
reg quarter; 
reg drink_Arizona; 
reg drink_Pepsi; 
reg drink_gingerale; 
reg drink_strawberryLemonade; // Outputs 
wire [7:0] totalCoin; 
wire [7:0] change; 
wire [7:0] costObtained;


Controller_States DUT( 
    .clk(clk), 
    .clr(clr), 
    .purchase(purchase), 
    .nickel(nickel), 
    .dime(dime), 
    .quarter(quarter), 
    .drink_Arizona(drink_Arizona), 
    .drink_Pepsi(drink_Pepsi), 
    .drink_gingerale(drink_gingerale), 
    .drink_strawberryLemonade(drink_strawberryLemonade),
    .costObtained(costObtained),
    .userInput(totalCoin), 
    .change_out(change) 
    ); 
    
    
    // Clock generation 
    initial 
    begin 
    clk = 0; 
    forever #5 clk = ~clk; // Toggles the clock
    end
    
    initial begin 

    
        clr = 0; 
        purchase = 0; 
        nickel = 0; 
        dime = 0; 
        quarter = 0; 
        drink_Arizona = 0; 
        drink_Pepsi = 0; 
        drink_gingerale = 0; 
        drink_strawberryLemonade = 0; 
        
        
        // Apply reset 
        clr = 1; 
        #10 clr = 0; 
        
        
        // Insert coins 
        #10 nickel = 0; 
        #10 nickel = 0; 
        #10 dime = 0; 
        #10 dime = 0; 
        #10 dime = 0; 
        #10 dime = 0;
        #10 dime = 1; 
        #10 dime = 0; 
        #10 quarter = 1; 
        #10 quarter = 0;
        #10 quarter = 1; 
        #10 quarter = 0; 
        #10 quarter = 1; 
        #10 quarter = 0; 
        
        #10 quarter = 1; 
        #10 quarter = 0;  // Testing for the 95 overflow state //
        
        
        // Select drinks 
        #25;
        
        #10 drink_gingerale = 1;
        #10 drink_gingerale = 0; 
        
        
        
        #10 drink_Arizona = 1; 
        #10 drink_Arizona = 0;

        
        #25;
        
        
 
        
        
        // Purchase 
        #15;
        purchase = 1; 
        #10 
        purchase = 0;
        
        #15;
        purchase = 1; 
        #10 
        purchase = 0;
        
        
        #15;
//        purchase = 1; 
//        #10 
//        purchase = 0;



// Testing Clear //
        #15;
        clr = 1;
        #10;
        clr = 0;

        
         
        // Check outputs 
        #20; 
        $display("Total Coin: %d", totalCoin); 
        $display("Change: %d", change);
        $display("Cost: %d", costObtained); 
        
        // Finish simulation 
        $finish;
        end
endmodule
