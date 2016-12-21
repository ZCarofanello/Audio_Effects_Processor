-- Dr. Kaputa
-- Lab 10: Audio Processor 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity distortion is 
  port(
    clk,reset           : in std_logic;
    audio_in            : in std_logic_vector(23 downto 0);
    audio_out           : out std_logic_vector(23 downto 0)
  );
end distortion;

architecture beh of distortion is
signal absolute_val, signed_audio :std_logic_vector(23 downto 0):=(OTHERS=>'0');
signal clipped_val,check_val :std_logic_vector(23 downto 0):=(OTHERS=>'0');
signal sign_0,sign_1 :std_logic:='0';
--Constants
constant max_val :std_logic_vector(15 downto 0):=x"FFFF";
constant zeros  :std_logic_vector(15 downto 0):=x"0000";
begin

    pipline:process(clk,reset)
    begin
        if (reset = '1') then 
            audio_out <= (others => '0');
        elsif (clk'event and clk = '1') then
            signed_audio <= audio_in;
            audio_out <= clipped_val;
        end if;
    end process;
    
    sign_keeping:process(clk,reset)
    begin
        if (reset = '1') then 
            sign_1 <= '0';
        elsif (clk'event and clk = '1') then
            sign_0 <= audio_in(0);
            sign_1 <= sign_0;
        end if;
    end process;
    
    clipping:process(signed_audio)
    begin
        if(signed(signed_audio) < to_signed(-4200,24)) then
            clipped_val <= std_logic_vector(to_signed(-4200,24));
        elsif(signed(signed_audio) > to_signed(4200,24)) then
            clipped_val <= std_logic_vector(to_signed(4200,24));
        else
            clipped_val <= signed_audio;
        end if;
    end process;
end beh;