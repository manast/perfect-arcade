
library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity sprite_ctrl is
  generic (
    bpp : integer := 4,
    sprite_width_log: integer := 5,
    sprite_height_log: integer := 5,
    screen_width: integer := 640,
    screen_hight: integer := 480,
    data_width: integer := 5 -- max of sprite_width_log and sprite_height_log
  );

  port (
      PIXELCLK : in std_logic; -- pixel clock

      -- Data Control
      DATA      : in std_logic_vector(data_width-1 downto 0);
      CTRL      : in std_logic_vector(3 downto 0);

      -- Input
      BLANK     : in std_logic;
      HPOS      : in integer range 0 to screen_width;
      VPOS      : in integer range 0 to screen_height;

      -- Output
      SPRITE_ON : out std_logic;
      PIXEL     : out std_logic_vector(bpp-1 to 0);
      SADDR     : out std_logic_vector(sprite_width_log*sprite_height_log-1 to 0));
end sprite_ctrl;

architecture RTL of sprite_ctrl is
  constant sprite_width : integer := 2**sprite_width_log,
  constant sprite_height: integer := 2**sprite_heigth_log,  
    
  signal xpos: integer range 0 to sprite_width :=0;
  signal ypos: integer range 0 to sprite_height :=0;
begin

  if(CTRL = "11")
    xpos <= DATA;
  elsif CTRL = "10" then 
    ypos <= DATA;
  end if

  SPRITE_ON <= '1' when (HPOS >= xpos) and (HPOS < xpos + sprite_width) and
                        (VPOS >= ypos) and (VPOS < ypos + sprite_height) else
               '0';

  -- TODO: SADDR must be an addr in bpp granularity (maybe not needed after all...)
   SADDR <= ((VPOS(sprite_height_log-1 downto 0) - ypos(sprite_height_log-1 downto 0)) ssl sprite_width_log) +
              HPOS(sprite_width_log-1 downto 0) - xpos(sprite_width_log-1 downto 0);
end RTL;


