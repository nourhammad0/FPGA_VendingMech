`timescale 1ns / 1ps

module Top_VendingMachine(


    // CONTROLER MODULE //
    
    input wire clk,
    input wire clr,                     // Button1 //
    input wire purchase,                // Button2 //
    input wire nickel,                  // Button3 //
    input wire dime,                    // Button4 //
    input wire quarter,                 // Button5 //
    
    input wire Arizona,                 // Switch1 //
    input wire Pepsi,                   // Switch2 //
    input wire Gingerale,               // Switch3 //
    input wire StrawberryLemonade,      // Switch4 //
   
   
   // FPGA DISPLAY OUT //
    output wire [6:0]CA_out,
    output wire [3:0]Anode_out,
    
   // FOR LED'S
    
    output wire error_out,
    output wire LED_Clr,
    output wire LED_purch,
    output wire Gingerale_LED,
    output wire Arizona_LED,
    output wire StrawberryLemonade_LED,
    output wire Pepsi_LED,    
    
//     ____________________________________
//   |              OLED                   |
//   | ____________________________________|
    
    output wire CS,
	output wire SDIN,
	output wire SCLK,
	output wire DC,
	output wire RES,
	output wire VBAT,
	output wire VDD,
	output wire FIN
    );
    
    wire[127:0] Page0, Page1, Page2, Page3;

    
    wire[7:0] money, change, cost; // UserInputs, 
    
    wire clk_en;
    wire [1:0] error;
    
    reg [7:0] digit_1;
    reg [3:0] ones_place, tenths_place;
    wire[3:0] User_Tenths, User_Ones;
    wire[3:0] Change_Tenths, Change_Ones;

    Clock_Enable_To_Vend Clock_Vend(
    .clk(clk),
    .reset(clr),
    .clk_en(clk_en)
    );


    // The Controller //
    Controller_States ControlState(
    .clk(clk_en),
    .clr(clr),
    .purchase(purchase),
    .nickel(nickel),
    .dime(dime),
    .quarter(quarter),
    .drink_Arizona(Arizona),
    .drink_Pepsi(Pepsi),
    .drink_gingerale(Gingerale),
    .drink_strawberryLemonade(StrawberryLemonade),
    .costObtained(cost),
    .userInput(money),
    .change_out(change),
    .error(error),
    
    // for LED's //
    .Gingerale_LED(Gingerale_LED),
    .Arizona_LED(Arizona_LED),
    .StrawberryLemonade_LED(StrawberryLemonade_LED),
    .Pepsi_LED(Pepsi_LED),
    .LED_Clr(LED_Clr),
    .LED_purch(LED_purch),
    
    
    //Oled  Stuff
    
    .Page_0(Page0),
    .Page_1(Page1),
    .Page_2(Page2),
    .Page_3(Page3)
    
    );
    
    
    // Users Money //
    Extract_Dig User_AM(
        .digit_1(money),
        .ones_place(User_Ones),
        .tenths_place(User_Tenths)
    );
    
    wire [3:0] Cost_Tenths, Cost_Ones;
    
    // Cost Money //  *** PROBABLY WONT USE ***
    Extract_Dig Cost_AM(
        .digit_1(cost),
        .ones_place(Cost_Ones),
        .tenths_place(Cost_Tenths)
    );
    
    
    Top_FPGA_Display FPGA_DISPLAY(
            .clk(clk),
            .reset(clr),
            .Dig_1(User_Ones),
            .Dig_2(User_Tenths),
            .Dig_3(Cost_Ones),        // origianlly Change_Ones //
            .Dig_4(Cost_Tenths),      // originally Change_Tenths //
            .CA_out(CA_out),
            .anode_out(Anode_out)
        );
    
    
    assign error_out = error;
    
    
    
    
    
// Starting OLED Instentiation //
    
    wire CS, SDIN, SCLK, DC;
	//wire VDD, VBAT, RES;
    
    PmodOLEDCtrl OLED_Control(
		.CLK(clk),
		//.RST(clr),
		.EN(clk_en),
        .Page0(Page0),
        .Page1(Page1),
        .Page2(Page2),
        .Page3(Page3),
		.CS(CS),
		.SDIN(SDIN),
		.SCLK(SCLK),
		.DC(DC),
		.RES(RES),
		.VBAT(VBAT),
		.VDD(VDD),
		.FIN(FIN)
	);
    
    
    
endmodule
