`timescale 1ns / 1ps

module SpiCtrl(
    CLK,
    RST,
    SPI_EN,
    SPI_DATA,
    CS,
    SDO,
    SCLK,
    SPI_FIN
    );

	// ===========================================================================
	// 										Port Declarations
	// ===========================================================================
    input CLK;
    input RST;
    input SPI_EN;
    input [7:0] SPI_DATA;
    output CS;
    output SDO;
    output SCLK;
    output SPI_FIN;

	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================
	wire CS, SDO, SCLK, SPI_FIN;

	reg [39:0] current_state = "Idle";		// Signal for state machine
	
	reg [7:0] shift_register = 8'h00;		// Shift register to shift out SPI_DATA saved when SPI_EN was set
	reg [3:0] shift_counter = 4'h0;			// Keeps track how many bits were sent
	wire clk_divided;						// Used as SCLK
	reg [4:0] counter = 5'b00000;				// Count clocks to be used to divide CLK
	reg temp_sdo = 1'b1;							// Tied to SDO
	
	reg falling = 1'b0;							// signal indicating that the clk has just fell

	// ===========================================================================
	// 										Implementation
	// ===========================================================================
	assign clk_divided = ~counter[4];
	assign SCLK = clk_divided;
	assign SDO = temp_sdo;
	
	assign CS = (current_state == "Idle" && SPI_EN == 1'b0) ? 1'b1 : 1'b0;
	assign SPI_FIN = (current_state == "Done") ? 1'b1 : 1'b0;
	
	//  State Machine
	always @(posedge CLK) begin
			if(RST == 1'b1) begin							// Synchronous RST
				current_state <= "Idle";
			end
			else begin
			
				case(current_state)

					// Wait for SPI_EN to go high
					"Idle" : begin
						if(SPI_EN == 1'b1) begin
							current_state <= "Send";
						end
					end

					// Start sending bits, transition out when all bits are sent and SCLK is high
					"Send" : begin
						if(shift_counter == 4'h8 && falling == 1'b0) begin
							current_state <= "Hold1";
						end
					end
					
					// Hold CS low for a bit
					"Hold1" : begin
						current_state <= "Hold2";
					end

					// Hold CS low for a bit
					"Hold2" : begin
						current_state <= "Hold3";
					end

					// Hold CS low for a bit
					"Hold3" : begin
						current_state <= "Hold4";
					end

					// Hold CS low for a bit
					"Hold4" : begin
						current_state <= "Done";
					end

					// Finish SPI transimission wait for SPI_EN to go low
					"Done" : begin
						if(SPI_EN == 1'b0) begin
							current_state <= "Idle";
						end
					end

					default : current_state <= "Idle";

				endcase
			end
	end
	//  End of State Machine

	
	//  Clock Divider
	always @(posedge CLK) begin
			//  start clock counter when in send state
			if(current_state == "Send") begin
				counter <= counter + 1'b1;
			end
			//  reset clock counter when not in send state
			else begin
				counter <= 5'b00000;
			end
	end
	//  End Clock Divider
	
	
	//  SPI_SEND_BYTE,  sends SPI data formatted SCLK active low with SDO changing on the falling edge
	always @(posedge CLK) begin
			if(current_state == "Idle") begin
					shift_counter <= 4'h0;
					// keeps placing SPI_DATA into shift_register so that when state goes to send it has the latest SPI_DATA
					shift_register <= SPI_DATA;
					temp_sdo <= 1'b1;
			end
			else if(current_state == "Send") begin
					//  if on the falling edge of Clk_divided
					if(clk_divided == 1'b0 && falling == 1'b0) begin
							//  Indicate that it is passed the falling edge
							falling <= 1'b1;
							// send out the MSB
							temp_sdo <= shift_register[7];
							//  Shift through SPI_DATA
							shift_register <= {shift_register[6:0],1'b0};
							//  Keep track of what bit it is on
							shift_counter <= shift_counter + 1'b1;
					end
					//  on SCLK high reset the falling flag
					else if(clk_divided == 1'b1) begin
						falling <= 1'b0;
					end
			end
	end

endmodule
