library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port ( 
    CLOCK_50      : in std_logic;
    CLOCK_27     : in std_logic;
    AUD_DACLRCK   : in std_logic;
    AUD_ADCLRCK   : in std_logic;
    AUD_BCLK      : in std_logic; 
    AUD_ADCDAT    : in std_logic;
    KEY           : in std_logic_vector(1 DOWNTO 0);
    SW            : in std_logic_vector(3 downto 0);
    FPGA_I2C_SDAT : inout std_logic;
    FPGA_I2C_SCLK : out std_logic; 
    AUD_DACDAT    : out std_logic; 
    AUD_XCK       : out std_logic;
    LEDR          : out std_logic_vector(9 DOWNTO 0)
  );
end top;

architecture beh of top is
  component audio_processor_3000 is 
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
  end component;

  component clock_generator
    port( 
      CLOCK_27 : in std_logic;
      reset    : in std_logic;
      AUD_XCK  : out std_logic
    );
  end component;
  
  component audio_and_video_config
    port( 
      CLOCK_50 : in std_logic;
      reset    : in std_logic;
      I2C_SDAT : INOUT std_logic;
      I2C_SCLK : out std_logic
    );
  end component;   
  
  component audio_codec
    port(
      CLOCK_50        : in std_logic;
      reset           : in std_logic;
      read_s          : in std_logic;
      write_s         : in std_logic;
      writedata_left  : in std_logic_vector(23 DOWNTO 0); 
      writedata_right : in std_logic_vector(23 DOWNTO 0);                 
      AUD_ADCDAT      : in std_logic;
      AUD_BCLK        : in std_logic;
      AUD_ADCLRCK     : in std_logic;
      AUD_DACLRCK     : in std_logic;
      read_ready      : out std_logic; 
      write_ready     : out std_logic;
      readdata_left   : out std_logic_vector(23 DOWNTO 0);
      readdata_right  : out std_logic_vector(23 DOWNTO 0);                
      AUD_DACDAT      : out std_logic
    );
  end component;
  
  signal read_ready       : std_logic;
  signal write_ready      : std_logic;
  signal read_s           : std_logic;
  signal write_s          : std_logic;
  signal readdata_left    : std_logic_vector(23 DOWNTO 0);
  signal readdata_right   : std_logic_vector(23 DOWNTO 0);                        
  signal write_data_right : std_logic_vector(23 DOWNTO 0);                        
  signal write_data_left  : std_logic_vector(23 DOWNTO 0);                        
  signal led              : std_logic_vector(9 DOWNTO 0);           
  signal reset            : std_logic;
  signal enable           : std_logic;
  signal execute_btn      : std_logic;
 
begin
  reset <= NOT(KEY(0));
  execute_btn <= KEY(1);

  read_s <= read_ready;
  write_s <= write_ready AND read_ready;
  
  audio_processor : audio_processor_3000  
    port map(
      clk             => CLOCK_50,
      reset           => reset,
      execute_btn     => execute_btn,
      sync            => write_s,
      selecter        => Sw,
      left_audio_in   => readdata_left,
      right_audio_in  => readdata_right,
      led             => led,
      audio_out_left  => write_data_left,
      audio_out_right => write_data_right
      );
  
  my_clock_gen: clock_generator 
    port map (
      CLOCK_27  => CLOCK_50, 
      reset     => reset, 
      AUD_XCK   => AUD_XCK
    );
      
  cfg: audio_and_video_config 
    port map (
      CLOCK_50  => CLOCK_50,
      reset     => reset,
      I2C_SDAT  => FPGA_I2C_SDAT,
      I2C_SCLK  => FPGA_I2C_SCLK
    );
    
  codec: audio_codec 
    port map (
      CLOCK_50          => CLOCK_50,
      reset             => reset,
      read_s            => read_s,
      write_s           => write_s,
      writedata_left    => write_data_left,
      writedata_right   => write_data_right,
      AUD_ADCDAT        => AUD_ADCDAT,
      AUD_BCLK          => AUD_BCLK,
      AUD_ADCLRCK       => AUD_ADCLRCK,
      AUD_DACLRCK       => AUD_DACLRCK,
      read_ready        => read_ready,
      write_ready       => write_ready,
      readdata_left     => readdata_left,
      readdata_right    => readdata_right,
      AUD_DACDAT        => AUD_DACDAT
    );
    
    LEDR <= led;
end beh;