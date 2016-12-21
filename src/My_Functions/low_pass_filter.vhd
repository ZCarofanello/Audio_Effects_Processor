-- Dr. Kaputa
-- Lab 10: Audio Processor 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity low_pass_filter is 
  port(
    clk, reset, sync    : in std_logic;
    audio_in            : in std_logic_vector(23 downto 0);
    audio_out           : out std_logic_vector(23 downto 0)
  );
end low_pass_filter;

architecture beh of low_pass_filter is
component LPF IS
	PORT (
		clk	: IN STD_LOGIC;
		reset_n	: IN STD_LOGIC;
		enable	: IN STD_LOGIC;
		ast_sink_data	: IN STD_LOGIC_VECTOR (23 DOWNTO 0);
		ast_sink_valid	: IN STD_LOGIC;
		ast_source_ready	: IN STD_LOGIC;
		ast_sink_error	: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		ast_source_data	: OUT STD_LOGIC_VECTOR (34 DOWNTO 0);
		ast_sink_ready	: OUT STD_LOGIC;
		ast_source_valid	: OUT STD_LOGIC;
		ast_source_error	: OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
	);
END component LPF;
signal raw_filter_data :std_logic_vector(34 downto 0);
signal reset_n :std_logic:='0';
begin
 reset_n <= not(reset);
  -- left feedthrough
Just_The_Filter:LPF
PORT MAP(
    clk	             => clk,
    reset_n	         => reset_n,
    enable           => '1',
    ast_sink_data	   => audio_in,
    ast_sink_valid	 => sync,
    ast_source_ready => '1',
    ast_sink_error	 => "00",
    ast_source_data	 => raw_filter_data
    );
    audio_out <= raw_filter_data(34 downto 11);
end beh;