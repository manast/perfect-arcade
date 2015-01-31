library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity vga_timings is
  port (CLK : in std_logic;

      SEL     : in std_logic_vector(3 downto 0);

  		 --
  		 -- Resolution settings (in PIXELCLK units)
  		 --
  		 HSP		: out integer range 0 to 128 :=0;
  		 HFP		: out integer range 0 to 128 :=0;
  		 HBP		: out integer range 0 to 128 :=0;
  		 WIDTH	: out integer range 0 to 4096 :=0;

  		 VSP		: out integer range 0 to 128 :=0;
  		 VFP		: out integer range 0 to 128 :=0;
  		 VBP		: out integer range 0 to 128 :=0;
  		 HEIGHT	: out integer range 0 to 4096 :=0;

       --
       -- CLOCK in Khz
       --
       CLKFREQ : out integer range 0 to 500000 
  );
end vga_timings;


architecture RTL of vga_timings is
begin

  process(SEL)
  begin
    case SEL is
      -- VGA 640x480 60Hz
      when "0000" =>
        WIDTH <= 640;
        HFP <= 16;
        HSP <= 96;
        HBP <= 48;
        
        HEIGHT <= 480;
        VFP <= 11;
        VSP <= 2;        
        VBP <= 31;

        CLKFREQ <= 25175;
      when "0001" =>
        WIDTH <= 256;
        HEIGHT <= 224;
        VFP <= 5;
        VBP <= 5;
        CLKFREQ <= 15000;
      when others =>
        WIDTH <= 640;
        HFP <= 16;
        HSP <= 96;
        HBP <= 48;
        
        HEIGHT <= 480;
        VFP <= 11;
        VSP <= 2;        
        VBP <= 31;

        CLKFREQ <= 25175;
    end case;
  end process;
end RTL;


