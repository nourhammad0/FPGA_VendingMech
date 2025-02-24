# Define the main clock with a period of 10 ns (100 MHz)
create_clock -name clk -period 10 [get_ports clk]

# Define clock enables
create_generated_clock -name clk_en -source [get_pins Clock_Vend/clk] -divide_by 1 [get_ports clk_en]

# Specify input delay for the input ports
set_input_delay -clock clk -max 2 [get_ports {nickel dime quarter purchase Arizona Pepsi Gingerale StrawberryLemonade}]

# Specify output delay for the output ports
set_output_delay -clock clk -max 2 [get_ports {CA_out Anode_out error_out Gingerale_LED Arizona_LED StrawberryLemonade_LED Pepsi_LED}]
