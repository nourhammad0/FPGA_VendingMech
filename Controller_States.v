`timescale 1ns / 1ps

module Controller_States(
    input clk,
    input clr, // Button
    input purchase, // (button) item purchased and dropped //
    
    // Money (Button) //
    input nickel,
    input dime,
    input quarter,
    
    // Drinks (Switches) //
    
    input drink_Arizona,               // Worth: 50 c
    input drink_Pepsi,                 // Worth: 80 c
    input drink_gingerale,             // Worth: 25 c
    input drink_strawberryLemonade,    // Worth: 65 c
    
    output reg [7:0]costObtained,
    
    // Total Cash to be tracked //
    output reg [7:0]userInput, // totalCoin //
    output reg [7:0]change_out,

    output reg [1:0] error,

    // LED to see if item has been selected //
    output reg [1:0] Gingerale_LED,
    output reg [1:0] Arizona_LED,
    output reg [1:0] StrawberryLemonade_LED,
    output reg [1:0] Pepsi_LED,
    
    output reg [1:0] LED_purch,
    output reg [1:0] LED_Clr,
    
    // OLED OUTPUTS
    output reg [127:0] Page_0,Page_1, Page_2, Page_3
    
    );
 
 
 // ===================================================================================

    reg [7:0] totalCoin; // userInputs //
    reg [1:0] currstate;
    reg [1:0] nextState;
    
    parameter FULL_AMOUNT = 7'd95; // 95 cents is the cap //
// ====================================================================================


    
// ===================================================================  
    // Money AM (Amount) //
    
     parameter nickel_AM = 4'd5;
     parameter dime_AM = 4'd10;
     parameter quarter_AM = 5'd25;
 
    
    parameter Arizona_AM = 7'd50;
    parameter Pepsi_AM = 7'd80;
    parameter Gingerale_AM = 7'd25;
    parameter StrawberryLemonade_AM = 7'd65;
// ===================================================================    
    
    
    
// ===========================================
    // States //
    parameter INSERT_COIN = 3'd0;
    parameter SELECT = 3'd1;
    parameter PURCHASE = 3'd2;
    parameter CHANGE = 3'd3;
    parameter CLEAR = 3'd4;
// ===========================================  
    
// ==================================================================================================================================================
                                              // Creating Parameters for lines (Pages) //
    
// Insert Coin State
    parameter Nours_Vend_Mach = {8'h4E, 8'h4F, 8'h55, 8'h52, 8'h53, 8'h20, 8'h56, 8'h45, 8'h4E, 8'h44, 8'h20, 8'h4D, 8'h41, 8'h43, 8'h48, 8'h20};
    parameter Insert_Money = {8'h49, 8'h4E, 8'h53, 8'h45, 8'h52, 8'h54, 8'h20, 8'h4D, 8'h4F, 8'h4E, 8'h45, 8'h59, 8'h20, 8'h20, 8'h20, 8'h20};
    parameter Coin_5_10 = {8'h35, 8'h20, 8'h20, 8'h20, 8'h57, 8'h31, 8'h39, 8'h20, 8'h20, 8'h31, 8'h30, 8'h20, 8'h20, 8'h55, 8'h31, 8'h38};   
    parameter Coin_25 = {8'h32, 8'h35, 8'h20, 8'h20, 8'h54, 8'h31, 8'h38, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};


// ==================================================================================================================================================
// PreSelection
    parameter Processing = {8'h50, 8'h72, 8'h6F, 8'h63, 8'h65, 8'h73, 8'h73, 8'h69, 8'h6E, 8'h67, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
    parameter Selection = {8'h53, 8'h65, 8'h6C, 8'h65, 8'h63, 8'h74, 8'h69, 8'h6F, 8'h6E, 8'h2E, 8'h2E, 8'h2E, 8'h20, 8'h20, 8'h20, 8'h20};

    
// Selection state
   parameter Gingerale_page = {8'h47, 8'h69, 8'h6E, 8'h67, 8'h65, 8'h72, 8'h61, 8'h6C, 8'h65, 8'h20, 8'h20, 8'h20, 8'h20, 8'h56, 8'h31, 8'h36};
   parameter Arizona_page = {8'h41, 8'h72, 8'h69, 8'h7A, 8'h6F, 8'h4E, 8'h61, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h57, 8'h31, 8'h36};
   parameter Str_Lemonade_page = {8'h53, 8'h4C, 8'h65, 8'h6D, 8'h6F, 8'h6E, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h57, 8'h31, 8'h37};
   parameter Pepsi_page = {8'h50, 8'h65, 8'h70, 8'h73, 8'h69, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h57, 8'h31, 8'h35};
   
// ==================================================================================================================================================

// Vending state
    parameter Vending_page = {8'h56, 8'h65, 8'h6E, 8'h64, 8'h69, 8'h6E, 8'h67, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
    
    parameter Error_Poor_page = {8'h45, 8'h72, 8'h72, 8'h6F, 8'h72, 8'h20, 8'h50, 8'h6F, 8'h6F, 8'h72, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
    
    
   parameter Gingerale_Sel = {8'h47, 8'h69, 8'h6E, 8'h67, 8'h65, 8'h72, 8'h61, 8'h6C, 8'h65, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
   parameter Arizona_Sel = {8'h41, 8'h72, 8'h69, 8'h7A, 8'h6F, 8'h4E, 8'h61, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
   parameter Str_Lemonade_Sel = {8'h53, 8'h4C, 8'h65, 8'h6D, 8'h6F, 8'h6E, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
   parameter Pepsi_Sel = {8'h50, 8'h65, 8'h70, 8'h73, 8'h69, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};

// ==================================================================================================================================================

// General
    parameter blank_page = {8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
    
    parameter Dispencing = {8'h20, 8'h44, 8'h49, 8'h53, 8'h50, 8'h45, 8'h4E, 8'h43, 8'h49, 8'h4E, 8'h47, 8'h2E, 8'h2E, 8'h2E, 8'h20};

    parameter Thank_You = { 8'h20, 8'h20, 8'h54, 8'h68, 8'h61, 8'h6E, 8'h6B, 8'h20, 8'h59, 8'h6F, 8'h75, 8'h20, 8'h20, 8'h20, 8'h20};


// ==================================================================================================================================================
    
reg prev_drink1, prev_drink2, prev_drink3, prev_drink4; // Previous drink state


// STATES START HERE //
    
always @(negedge clk) // * always block
    begin
    case(nextState)
        INSERT_COIN: currstate = nextState;      
        SELECT:      currstate = nextState; 
        PURCHASE:    currstate = nextState;  
        CHANGE:      currstate = nextState;
        default:     currstate = INSERT_COIN; 
    endcase
    end
    
    
    // NEXT STATES START HERE //
    
always @(posedge clk or posedge clr)
           begin
           
       if (clr) begin 
                    userInput <= 0; 
                    totalCoin <= 0; 
                    costObtained <= 0;
                    change_out <= 0;
                    error <= 0;
                    LED_Clr <= 1;
                    
                    // Drink LED's
                    Arizona_LED <= 0;
                    Pepsi_LED <= 0;
                    Gingerale_LED <= 0;
                    StrawberryLemonade_LED <= 0;
                     
                    nextState <= INSERT_COIN;

                    
               end
               else begin 
               LED_Clr <= 0;
           
  case(currstate)
    INSERT_COIN: begin 
    if (clr) begin
    nextState <= CLEAR;
    end 
  
                    LED_Clr <= 0;
                    LED_purch <= 0;
                    costObtained <= 0;
                    error <= 0; // To stop displaying the error 
                     
                    // Deselecting drinks after purchase or if true to prevent latch
                    Arizona_LED <= 0;
                    Pepsi_LED <= 0;
                    StrawberryLemonade_LED <= 0;
                    Gingerale_LED <= 0;
                     
                     
                     
                         //==========================                
                         //      OLED INSERT COIN                           
                         //==========================
                         
                    Page_0 <= Nours_Vend_Mach;
                    Page_1 <= Insert_Money;
                    Page_2 <= Coin_5_10;
                    Page_3 <= Coin_25;        
                                        
                            
                            
                     if(userInput >= FULL_AMOUNT)
                     begin
                         userInput <= FULL_AMOUNT;
                         totalCoin <= userInput;
                         nextState <= INSERT_COIN;
                     end
                                 
                          else if(nickel) begin
                            userInput <= (userInput + nickel_AM > 95) ? 95: userInput + nickel_AM;
                            nextState <= INSERT_COIN;
                          end
                         
                          else if(dime) begin
                            userInput <= (userInput + dime_AM > 95) ? 95: userInput + dime_AM;
                            nextState <= INSERT_COIN;
                          end

                          else if(quarter) begin
                            userInput <= (userInput + quarter_AM > 95) ? 95: userInput + quarter_AM;
                            nextState <= INSERT_COIN;
                          end

                     else begin userInput <= userInput + 0; end
                                                            
                                                           
                 
                 // DETECTS IF USER CAN PURCHASE SPECIFIC DRINKS
                 if (userInput >= Arizona_AM)begin                                    
                    Arizona_LED <= 1;
                 end else begin Arizona_LED <= 0; end
                                    
                                    
                               if (userInput >= Pepsi_AM) begin
                                    Pepsi_LED <= 1;
                                    end else begin Pepsi_LED <= 0; end
                                    
                               if (userInput >= Gingerale_AM)begin
                                    Gingerale_LED <= 1;
                                    end else begin Gingerale_LED <= 0; end
                                    
                               if (userInput >= StrawberryLemonade_AM)begin
                                    StrawberryLemonade_LED <= 1;
                                    end else begin StrawberryLemonade_LED <= 0; end 
                                    
                                    
                                    if(purchase)begin
                                     nextState <= SELECT;
                                     end
//                               end 
                          end  // End of INSERT_COIN //  
          
    SELECT: begin
                         //================================             
                         //      OLED Pre - Selection                           
                         //================================
                    Page_0 <= Gingerale_page;
                    Page_1 <= Arizona_page;
                    Page_2 <= Str_Lemonade_page;
                    Page_3 <= Pepsi_page;
    
                if (drink_Arizona && !prev_drink2)begin
                    costObtained <= costObtained + Arizona_AM;
                        nextState <= SELECT;
                        Arizona_LED <= 1;
                    end else if(!prev_drink2 && drink_Arizona) 
                    begin 
                        costObtained <= costObtained - Arizona_AM;
                    end
                    
                    
                if (drink_Pepsi && !prev_drink4) begin
                        costObtained <= costObtained + Pepsi_AM;
                        nextState <= SELECT; 
                        Pepsi_LED <= 1;
                    end else if(!prev_drink4 && drink_Pepsi)
                    begin 
                            costObtained <= costObtained - Pepsi_AM;                            
                    end
                
                if (drink_gingerale && !prev_drink1)begin
                        costObtained <= costObtained + Gingerale_AM;
                        nextState <= SELECT; 
                        Gingerale_LED <= 1;
                    end else if(!prev_drink1 && drink_gingerale)
                    begin 
                    costObtained <= costObtained - Gingerale_AM;
                    end 
                    
                if (drink_strawberryLemonade && !prev_drink3)begin
                    costObtained <= costObtained + StrawberryLemonade_AM;
                        nextState <= SELECT; 
                        StrawberryLemonade_LED <= 1;
                    end else if(!prev_drink3 && drink_strawberryLemonade)
                    begin 
                        costObtained <= costObtained - StrawberryLemonade_AM;
                    end
                    
                    //=====================================
                    //              ERROR DETECTION
                    prev_drink1 <= drink_gingerale;
                    prev_drink2 <= drink_Arizona;
                    prev_drink3 <= drink_strawberryLemonade;
                    prev_drink4 <= drink_Pepsi;
                    
                if(purchase)
                    begin
                     totalCoin <= userInput;
                    nextState <= PURCHASE;
                    end 
            end // Selection Ended //        
                   
    PURCHASE: begin
          
                         //================================             
                         //      OLED Pre - Purchase                           
                         //================================   
          
          Page_0 <= Vending_page;
          Page_1 <= blank_page;
          Page_2 <= blank_page;
          Page_3 <= blank_page;
                        
                        
                        Gingerale_LED <= 0;
                        Arizona_LED <= 0;
                        StrawberryLemonade_LED <= 0;
                        Pepsi_LED <= 0;
         
          
          
          
             if(userInput >= costObtained)
                 begin
                    change_out <= totalCoin - costObtained; 
                    
//                        userInput <= change_out; // newly added
                        LED_purch <= 1;
                        error <= 0;

              if(drink_gingerale) begin Page_1 <= Gingerale_Sel; Gingerale_LED <= 1; end else Page_1 <= blank_page;
              if(drink_Arizona) begin Page_2 <= Arizona_Sel; Arizona_LED <= 1; end else Page_2 <= blank_page;
              if(drink_strawberryLemonade) begin Page_3 <= Str_Lemonade_Sel; StrawberryLemonade_LED <= 1; end else Page_3 <= blank_page;
              if(drink_Pepsi) begin Page_3 <= Pepsi_Sel; Pepsi_LED <= 1; end
                                //Gingerale_Sel
                                //Arizona_Sel
                                //Str_Lemonade_Sel
                                //Pepsi_Sel      
               if(purchase) 
                    begin
               nextState <= CHANGE;
                    end
                 end
                 
             else begin
             error <= 1;        // This will inform the person that they have insufficient funds //
             
             Page_1 <= Error_Poor_page;
             
             
             
             if(purchase)
                    begin
             nextState <= INSERT_COIN;
                    end
             end
                 
             
           end // Purchase Ended //   
          
    CHANGE: begin
                change_out <= totalCoin - costObtained; // this will go into an extractor such that it can be displayed //
                userInput <= change_out;
                
                LED_purch <= 0;
                
                         //================================             
                         //      OLED CHANGE                           
                         //================================
                Page_0 <= blank_page;
                Page_1 <= Thank_You;
                Page_2 <= blank_page;
                Page_3 <= blank_page;
                
                
                
                
                nextState <= INSERT_COIN;          
          end                  
                   default: begin 
                    nextState <= INSERT_COIN;
                  end          
        endcase
           end
        end
endmodule
