-- Dr. Kaputa
-- Lab 10: Audio Processor 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_mixer is 
  port(
    clk,reset,sync      : in std_logic;
    opcode              : in std_logic_vector(1 downto 0);
    audio_in            : in std_logic_vector(23 downto 0);
    audio_out           : out std_logic_vector(23 downto 0)
  );
end generic_mixer;

architecture beh of generic_mixer is
component distortion is 
  port(
    clk,reset           : in std_logic;
    audio_in            : in std_logic_vector(23 downto 0);
    audio_out           : out std_logic_vector(23 downto 0)
  );
end component distortion;

component echo_module is 
  port(
    clk, reset, sync    : in std_logic;
    audio_in            : in std_logic_vector(23 downto 0);
    audio_out           : out std_logic_vector(23 downto 0)
  );
end component echo_module;

component low_pass_filter is 
  port(
    clk, reset          : in std_logic;
    audio_in            : in std_logic_vector(23 downto 0);
    audio_out           : out std_logic_vector(23 downto 0)
  );
end component low_pass_filter;
signal distortion_audio, echo_audio, low_pass :std_logic_vector(23 downto 0);

constant pass  :STD_LOGIC_VECTOR(1 downto 0):="00";
constant echo :STD_LOGIC_VECTOR(1 downto 0):="01";
constant lpf  :STD_LOGIC_VECTOR(1 downto 0):="10";
constant dist  :STD_LOGIC_VECTOR(1 downto 0):="11";

begin

clipping:distortion
port map(
clk => clk,
reset => reset,
audio_in => audio_in,
audio_out => distortion_audio
);

echo_mod:echo_module
port map(
clk => clk,
sync => sync,
reset => reset,
audio_in => audio_in,
audio_out => echo_audio
);

low_passing:low_pass_filter
port map(
clk => clk,
reset => reset,
audio_in => audio_in,
audio_out => low_pass
);

    mux:process (audio_in,distortion_audio, echo_audio, low_pass)
    begin
                CASE (Opcode) IS
                WHEN pass =>
                    audio_out <= audio_in;
                WHEN echo =>
                    audio_out <= echo_audio;
                WHEN lpf =>
                    audio_out <= low_pass;
                WHEN dist =>
                    audio_out <= distortion_audio;
                WHEN OTHERS =>
                    audio_out <= audio_in;
            END CASE;
    
    end process;


end beh;