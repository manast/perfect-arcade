library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity VGA is
  port ( 
       PIXELCLK : in std_logic;

  		 RESET	: in std_logic;

  		 --
  		 -- Resolution settings (in PIXELCLK units)
  		 --
  		 HSP		: integer range 0 to 128 :=0;
  		 HFP		: integer range 0 to 128 :=0;
  		 HBP		: integer range 0 to 128 :=0;
  		 WIDTH	: integer range 0 to 4096 :=0;

  		 VSP		: integer range 0 to 128 :=0;
  		 VFP		: integer range 0 to 128 :=0;
  		 VBP		: integer range 0 to 128 :=0;
  		 HEIGHT	: integer range 0 to 4096 :=0;

       -- Blank signal, active when retracing.
       HBLANK  : out std_logic;
       VBLANK  : out std_logic;
       BLANK   : out std_logic;

       -- Horizontal and Vertical pixel counters
       HPOS	: out integer range 0 to 4096 :=0;
       VPOS	: out integer range 0 to 4096 :=0;

       --
       -- Outputs to VGA connector
       --
       HSYNC 	: out std_logic;
       VSYNC 	: out std_logic
    );

end VGA;

architecture MyVga of VGA is
	signal hcnt_reg : integer range 0 to 4096 :=0;
	signal vcnt_reg : integer range 0 to 4096 :=0;
  signal hpos_reg : integer range 0 to 4096 :=0;
  signal vpos_reg : integer range 0 to 4096 :=0;
  
  signal pixel_reg: integer range 0 to 16777215 :=0;
  signal hblank_temp: std_logic;
  signal vblank_temp: std_logic;
begin

process(PIXELCLK, RESET)
begin

	if RESET = '1' then
		-- reset counters
		hcnt_reg <= 0;
		vcnt_reg <= 0;
    hpos_reg <= 0;
    vpos_reg <= 0;

	elsif(rising_edge(PIXELCLK)) then

		-- Update horizontal and vertical counters
		if hcnt_reg < WIDTH then
			hcnt_reg <= hcnt_reg + 1;
		else
			hcnt_reg <= 0;
			if(vcnt_reg < HEIGHT) then
				vcnt_reg <= vcnt_reg + 1;
			else
				vcnt_reg <= 0;
			end if;
		end if;

		-- Update horizonal and vertical sync signals
		if (hcnt_reg < HSP) then
			HSYNC <= '0';
      hpos_reg <= 0;
      hblank_temp <= '0';
		else
			HSYNC <= '1';
      
      -- update horizontal pixel counter
      if(hcnt_reg < HSP + WIDTH) then
        hpos_reg <= hpos_reg + 1;
        hblank_temp <= '0';
      else
        hblank_temp <= '1';
      end if;
		end if;

		if (vcnt_reg < VSP) then
			VSYNC <= '0';
      vblank_temp <= '1';
      vpos_reg <= 0;
		else
			VSYNC <= '1';
      -- update vertical pixel counter
      if(vcnt_reg < VSP + HEIGHT) then
        vpos_reg <= vpos_reg + 1;
        vblank_temp <= '0';
      else
        vblank_temp <= '1';
      end if;
		end if;

     -- Output counters
    HPOS <= hcnt_reg;
    HPOS <= vcnt_reg;

    -- output blank signals
    BLANK <= hblank_temp or vblank_temp;
    HBLANK <= hblank_temp;
    VBLANK <= vblank_temp;
	end if;
end process;


end MyVga;



