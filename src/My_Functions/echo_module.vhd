-- Dr. Kaputa
-- Lab 10: Audio Processor 3000

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity echo_module is
  port(
    clk, reset, sync          : in std_logic;
    audio_in            : in std_logic_vector(23 downto 0);
    audio_out           : out std_logic_vector(23 downto 0)
  );
end echo_module;

architecture beh of echo_module is
-- sync => reciving new audio
-- set din to audio in
-- go to write state
-- write current address + 1
-- add past ptr + 1
-- read past_ptr
--wait till next sync
component memory is 
  generic (addr_width : integer := 13;
           data_width : integer := 24);
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    we                : in std_logic;
    addr              : in std_logic_vector(addr_width - 1 downto 0);
    din               : in std_logic_vector(data_width - 1 downto 0);
    dout              : out std_logic_vector(data_width - 1 downto 0)
  );
end component memory;

-- FSM Signals
constant idle             : std_logic_vector(2 downto 0) := "001";
constant write_new_data   : std_logic_vector(2 downto 0) := "010";
constant read_new_data    : std_logic_vector(2 downto 0) := "100";

signal CurrentState      : std_logic_vector(2 downto 0);
signal NextState         : std_logic_vector(2 downto 0);

--Data Signal
signal past_audio :std_logic_vector(23 downto 0):=(others => '0');
signal write_enable :std_logic:='0';

--Audio Pointers
signal current_audio_ptr :std_logic_vector(12 downto 0):="1111101000000";
signal echo_audio_ptr    :std_logic_vector(12 downto 0):="0000000000000";
signal mem_addr          :std_logic_vector(12 downto 0):=(OTHERS => '0');
begin

     State_Reg:PROCESS(clk, reset) IS
    BEGIN
      IF(reset = '1') THEN
          CurrentState <= idle;
      ELSIF(clk'EVENT AND clk = '1') THEN
          CurrentState <= NextState;
      END IF;
    END PROCESS;

     ZeCloud:PROCESS(CurrentState, sync) IS
     BEGIN
       CASE (CurrentState) IS
           WHEN idle =>
               IF(sync = '1') THEN
                  NextState <= write_new_data;
               ELSE
                   NextState <= idle;
               END IF;
           WHEN write_new_data =>
               NextState <= read_new_data;
           WHEN read_new_data =>
               NextState <= idle;
           WHEN OTHERS =>
               NextState <= idle;
       END CASE;
     END PROCESS;

     current_ptr_handler:process(clk,reset,CurrentState)
     begin
       IF(reset = '1') THEN
           current_audio_ptr <= "1111101000000";
       ELSIF(clk'EVENT AND clk = '1') THEN
           IF(CurrentState = write_new_data) THEN
               current_audio_ptr <= std_logic_vector(unsigned(current_audio_ptr) + 1);
           else
               current_audio_ptr <= current_audio_ptr;
           end if;
       END IF;
     end process;

     echo_ptr_handler:process(clk,reset,CurrentState)
     begin
       IF(reset = '1') THEN
         echo_audio_ptr <= (OTHERS => '0');
       ELSIF(clk'EVENT AND clk = '1') THEN
         IF(CurrentState = read_new_data) THEN
           echo_audio_ptr <= std_logic_vector(unsigned(echo_audio_ptr) + 1);
         else
           echo_audio_ptr <= echo_audio_ptr;
         end if;
       END IF;
     end process;

     ptr_select:process(CurrentState)
     begin
      CASE (CurrentState) IS
        WHEN write_new_data =>
          mem_addr <= current_audio_ptr;
        WHEN OTHERS =>
          mem_addr <= echo_audio_ptr;
        END CASE;
     end process;

     write_enable_handler:process(NextState)
     begin
       CASE (NextState) IS
               WHEN write_new_data =>
                   write_enable <= '1';
               WHEN OTHERS =>
                   write_enable <= '0';
           END CASE;
     end process;


 echo_mem:memory
 port map(
  clk   => clk,
  reset => reset,
  we    => write_enable,
  addr  => mem_addr,
  din   => audio_in,
  dout  => past_audio
 );

 audio_out <= STD_LOGIC_VECTOR((signed(audio_in) + signed(past_audio))/2);

end beh;