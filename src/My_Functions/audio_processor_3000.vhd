-- Dr. Kaputa
-- Lab 10: Audio Processor 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_processor_3000 is 
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic;
    sync                : in std_logic;
    selecter            : in std_logic_vector(3 downto 0);
    left_audio_in       : in std_logic_vector(23 downto 0);
    right_audio_in      : in std_logic_vector(23 downto 0);
    audio_out_left      : out std_logic_vector(23 downto 0);
    audio_out_right     : out std_logic_vector(23 downto 0);
    LED                 : out std_logic_vector(9 downto 0)
  );
end audio_processor_3000;

architecture beh of audio_processor_3000 is
component generic_mixer is 
  port(
    clk,reset,sync      : in std_logic;
    opcode              : in std_logic_vector(1 downto 0);
    audio_in            : in std_logic_vector(23 downto 0);
    audio_out           : out std_logic_vector(23 downto 0)
  );
end component generic_mixer;

signal left_int_sig,right_int_sig  : std_logic_vector(23 downto 0):=(others=> '0');

begin
-- Left Mixer
Left_mix:generic_mixer
port map(
clk => clk,
reset => reset,
sync => sync,
opcode => selecter(1 downto 0),
audio_in => left_audio_in,
audio_out => left_int_sig
);
  -- left feedthrough
  process(clk,reset)
  begin 
    if (reset = '1') then 
      audio_out_left <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (sync = '1') then    
        audio_out_left <= left_int_sig;
      end if;
    end if;
  end process;
  
--  -- Right Mixer
-- Right_mix:generic_mixer
-- port map(
-- clk => clk,
-- reset => reset,
-- sync => sync,
-- opcode => selecter(1 downto 0),
-- audio_in => right_audio_in,
-- audio_out => right_int_sig
-- );
    
  --right feedthrough
-- process(clk,reset)
-- begin 
-- if (reset = '1') then 
--   audio_out_right <= (others => '0');
-- elsif (clk'event and clk = '1') then
--   if (sync = '1') then    
--     audio_out_right <= right_audio_in;
--   end if;
-- end if;
-- end process;
  audio_out_right <= (OTHERS => '0');
end beh;