library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

--
-- This circuit generates the tiles x and y coordinates 
-- for every incoming pixel
--
entity tile_map is
  generic (
    bpp : integer := 4, 
    bpt : integer := 8, -- Bits per tile index

    tile_log_width : integer := 3, -- default 8x8 tiles
    tile_log_height : integer := 3,

    max_log_width: integer := 10,
    max_log_height: integer := 10,

    max_log_x_offset: integer := 16, -- Max possible scroll offsets
    max_log_y_offset: integer := 16
  );

  port (
      HPOS    : in std_logic_vector(max_log_width-1 downto 0);
      VPOS    : in std_logic_vector(max_log_height-1 downto 0);

      HOFFSET : in std_logic_vector(max_log_x_offset-1 downto 0);
      VOFFSET : in std_logic_vector(max_log_y_offset-1 downto 0);

      -- Outputs
  		TILE_X : out std_logic_vector(max_log_x_offset-tile_log_width downto 0);
      TILE_Y : out std_logic_vector(max_log_y_offset-tile_log_height downto 0);

      HLSB    : out std_logic_vector());
      VLSB    : out std_logic_vector()) -- LSB bits for indexing pixel within tile.
      );
end tile_map;

architecture RTL of tile_map is
  signal xpos: integer range 0 to 2**max_log_x_offset :=0;
  signal ypos: integer range 0 to 2**max_log_y_offset :=0;

begin

  xpos <= HPOS + HOFFSET;
  TILE_X <= xpos(max_log_x_offset downto tile_log_width);
  HLSB <= xpos(tile_log_width-1 downto 0);
  
  ypos <= VPOS + VOFFSET;
  TILE_Y <= xpos(max_log_y_offset downto tile_log_height);
  VLSB <= xpos(tile_log_height-1 downto 0);

end RTL;
