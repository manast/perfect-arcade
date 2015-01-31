--
-- Testbench for VGA sync
--
library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity vga_sync_tb is
end vga_sync_tb;
     
architecture behav of vga_sync_tb is
--  Declaration of the component that will be instantiated.
  component vga_sync
    port(
      PIXELCLK, RESET : in std_logic;
      HSP, HFP, HBP, VSP, VFP, VBP : in integer range 0 to 128;
      WIDTH, HEIGHT, HPOS, VPOS : in integer range 0 to 4096 :=0;
      HBLANK, VBLANK, BLANK: out std_logic;
      HSYNC, VSYNC : out std_logic
    );
  end component;

  for sync_0: vga_sync use entity video.vga_sync;
  
  --  Specifies which entity is bound with the component.
  --for sync_0: vga_sync use entity work.vga_sync;
  signal PIXELCLK, RESET : std_logic := '0';
  signal HSP, HFP, HBP, VSP, VFP, VBP : integer range 0 to 128 := 0;
  signal WIDTH, HEIGHT, HPOS, VPOS : integer range 0 to 4096 :=0;
  signal HBLANK, VBLANK, BLANK: std_logic := '0';
  signal HSYNC, VSYNC : std_logic := '0';

  constant clk_period : time := 39.7219 ns; -- 25Mhz
begin
  --  Component instantiation.
  sync_0: vga_sync port map (
    PIXELCLK => PIXELCLK, 
    RESET => RESET,
    HSP => HSP, 
    HFP => HFP, 
    HBP => HBP,
    VSP => VSP,
    VFP => VFP,
    VBP => VBP,
    WIDTH => WIDTH,
    HEIGHT => HEIGHT,
    HPOS => HPOS,
    VPOS => VPOS,
    HBLANK => HBLANK,
    VBLANK => VBLANK,
    BLANK => BLANK,
    HSYNC => HSYNC,
    VSYNC => VSYNC
  );

  WIDTH <= 640;
  HFP <= 16;
  HSP <= 96;
  HBP <= 48;
        
  HEIGHT <= 480;
  VFP <= 11;
  VSP <= 2;        
  VBP <= 31;

  clk_process: process
  begin
    PIXELCLK <= '0';
    wait for clk_period/2;
    PIXELCLK <= '1';
    wait for clk_period/2;
  end process;

end behav;


