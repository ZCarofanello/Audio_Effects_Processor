# Zachary Carofanello
# Quartus II compile script for DE2 board

# 1] name your project here
set project_name "audio_processor"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE EP2C35F672C6
set_global_assignment -name TOP_LEVEL_ENTITY top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name QIP_FILE ../../src/rom_instructions/rom_instructions.qip
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_Audio_Bit_Counter.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_Audio_In_Deserializer.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_Audio_Out_Serializer.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_Clock_Edge.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_I2C.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_I2C_AV_Auto_Initialize.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_I2C_DC_Auto_Initialize.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_I2C_LCM_Auto_Initialize.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_Slow_Clock_Generator.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/Altera_UP_SYNC_FIFO.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/audio_and_video_config.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/audio_codec.v
set_global_assignment -name VERILOG_FILE ../../src/audio_ip/clock_generator.v
set_global_assignment -name VHDL_FILE ../../src/My_Madness/audio_processor_3000.vhd
set_global_assignment -name VHDL_FILE ../../src/My_Madness/distortion.vhd
set_global_assignment -name VHDL_FILE ../../src/My_Madness/echo_module.vhd
set_global_assignment -name VHDL_FILE ../../src/My_Madness/generic_mixer.vhd
set_global_assignment -name VHDL_FILE ../../src/My_Madness/low_pass_filter.vhd
set_global_assignment -name VHDL_FILE ../../src/My_Madness/memory.vhd
set_global_assignment -name VHDL_FILE ../../src/FIR_filter/LPF.vhd
set_global_assignment -name VHDL_FILE ../../src/top.vhd
#============================================================
# AUD
#============================================================
set_location_assignment PIN_B5 -to AUD_ADCDAT
set_location_assignment PIN_C5 -to AUD_ADCLRCK
set_location_assignment PIN_B4 -to AUD_BCLK
set_location_assignment PIN_A4 -to AUD_DACDAT
set_location_assignment PIN_C6 -to AUD_DACLRCK
set_location_assignment PIN_A5 -to AUD_XCK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to AUD_ADCDAT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to AUD_ADCLRCK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to AUD_BCLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to AUD_DACDAT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to AUD_DACLRCK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to AUD_XCK

#============================================================
# CLOCK 50MHz
#============================================================
set_location_assignment PIN_N2 -to CLOCK_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK_50

#============================================================
# CLOCK 27MHz
#============================================================
set_location_assignment PIN_D13 -to CLOCK_27
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK_27

#============================================================
# FPGA
#============================================================
set_location_assignment PIN_A6 -to FPGA_I2C_SCLK
set_location_assignment PIN_B6 -to FPGA_I2C_SDAT
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FPGA_I2C_SCLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to FPGA_I2C_SDAT

#============================================================
# KEY
#============================================================
set_location_assignment PIN_G26 -to KEY[0]
set_location_assignment PIN_N23 -to KEY[1]
set_location_assignment PIN_P23 -to KEY[2]
set_location_assignment PIN_W26 -to KEY[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to KEY[3]

#============================================================
# LEDR
#============================================================
set_location_assignment PIN_AE23 -to LEDR[0]
set_location_assignment PIN_AF23 -to LEDR[1]
set_location_assignment PIN_AB21 -to LEDR[2]
set_location_assignment PIN_AC22 -to LEDR[3]
set_location_assignment PIN_AD22 -to LEDR[4]
set_location_assignment PIN_AD23 -to LEDR[5]
set_location_assignment PIN_AD21 -to LEDR[6]
set_location_assignment PIN_AC21 -to LEDR[7]
set_location_assignment PIN_AA14 -to LEDR[8]
set_location_assignment PIN_Y13  -to LEDR[9]
set_location_assignment PIN_AA13 -to LEDR[10]
set_location_assignment PIN_AC14 -to LEDR[11]
set_location_assignment PIN_AD15 -to LEDR[12]
set_location_assignment PIN_AE15 -to LEDR[13]
set_location_assignment PIN_AF13 -to LEDR[14]
set_location_assignment PIN_AE13 -to LEDR[15]
set_location_assignment PIN_AE12 -to LEDR[16]
set_location_assignment PIN_AD12 -to LEDR[17]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[16]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[17]

#============================================================
# SW
#============================================================
set_location_assignment PIN_N25  -to SW[0]
set_location_assignment PIN_N26  -to SW[1]
set_location_assignment PIN_P25  -to SW[2]
set_location_assignment PIN_AE14 -to SW[3]
set_location_assignment PIN_AF14 -to SW[4]
set_location_assignment PIN_AD13 -to SW[5]
set_location_assignment PIN_AC13 -to SW[6]
set_location_assignment PIN_C13  -to SW[7]
set_location_assignment PIN_B13  -to SW[8]
set_location_assignment PIN_A13  -to SW[9]
set_location_assignment PIN_N1   -to SW[10]
set_location_assignment PIN_P1   -to SW[11]
set_location_assignment PIN_P2   -to SW[12]
set_location_assignment PIN_T7   -to SW[13]
set_location_assignment PIN_U3   -to SW[14]
set_location_assignment PIN_U4   -to SW[15]
set_location_assignment PIN_V1   -to SW[16]
set_location_assignment PIN_V2   -to SW[17]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[16]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[17]


execute_flow -compile
project_close