#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************
create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]
derive_clock_uncertainty

#**************************************************************
# Create Generated Clock
#**************************************************************
#create_generated_clock -name pixel_clk [get_ports {vgaCLK}] -source [get_ports {CLOCK_50}] -divide_by 2 -phase 0
#create_generated_clock -name {pixel_clk} -period 40.000 -waveform { 0.000 20.000 }
create_generated_clock -name pixel_clk [get_nodes {pixel_clk}] -source [get_ports {CLOCK_50}] -divide_by 2 -phase 0
derive_clock_uncertainty

#**************************************************************
# Set Clock Latency
#**************************************************************

#**************************************************************
# Set Clock Uncertainty
#**************************************************************
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {pixel_clk}]  0.020
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {pixel_clk}]  0.020
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {pixel_clk}]  0.020
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {pixel_clk}]  0.020


#**************************************************************
# Set Input Delay
#**************************************************************
set_input_delay -add_delay  -clock [get_clocks {CLOCK_50}]  2.000 [get_ports {FPGA_RESET_N}]


#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_R[0]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_R[1]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_R[2]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_R[3]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_G[0]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_G[1]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_G[2]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_G[3]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_B[0]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_B[1]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_B[2]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_B[3]}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_HS}]
set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {VGA_VS}]
#set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {led}]
#set_output_delay -add_delay  -clock [get_clocks {pixel_clk}]  1.500 [get_ports {vgaCLK}]

#**************************************************************
# Set Clock Groups
#**************************************************************

#**************************************************************
# Set False Path
#**************************************************************

#**************************************************************
# Set Multicycle Path
#**************************************************************

#**************************************************************
# Set Maximum Delay
#**************************************************************

#**************************************************************
# Set Minimum Delay
#**************************************************************

#**************************************************************
# Set Input Transition
#**************************************************************
