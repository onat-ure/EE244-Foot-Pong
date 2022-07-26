-- Synthesizable Simple VGA Driver to Display All Possible Colors
-- EE244 class Bogazici University 
-- Implemented on Xilinx Spartan VI FPGA chip 
LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_signed.all ;
USE ieee.std_logic_arith.all ;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
entity ee244_vgadriver is 
 port ( 
 board_clk: in std_logic;
 vsync: out std_logic;
 hsync: out std_logic;
 video_on : out std_logic;
 pixel_x, pixel_y : out std_logic_vector (9 downto 0));
end;



architecture arch_vga_driver of ee244_vgadriver is 

	
signal Clk_25MHz	: STD_LOGIC := '0';
signal counter	: integer range 0 to 199999999 := 0;


signal hval : integer := 0;
signal vval : integer := 0;
signal vga_en : std_logic;
signal rst : std_logic;



begin

FREQ_DIV: process (board_clk) begin
	if rising_edge(board_clk) then
		if (counter = 1) then -- 25 MHz Clock
			Clk_25MHz <= not Clk_25MHz;
			counter <= 0;
		else
			counter <= counter + 1;
		end if;
	end if;
end process;


h_counter: process(Clk_25MHz)
begin
	if rising_edge(Clk_25MHz) then
		if (hval = 799) then
			hval <= 0;
		else
			hval <= hval  + 1;
		end if;
	end if;
end process;

v_counter: process(Clk_25MHz, hval)
begin
	if rising_edge(Clk_25MHz) then
		if (hval = 799) then
			if (vval = 524) then
				vval <= 0;
			else
				vval <= vval  + 1;
			end if;
		end if;
	end if;
end process;

h_sync: process (Clk_25MHz, hval)
begin
	if rising_edge(Clk_25MHz) then
		if (hval <=95) then
			hsync <= '0';
		else
			hsync <= '1';
		end if;
	end if;
end process;

v_sync: process (Clk_25MHz, vval)
begin
	if rising_edge(Clk_25MHz) then
		if (vval <=1) then
			vsync <= '0';
		else
			vsync <= '1';
		end if;
	end if;
end process;


vga_enable: process (Clk_25MHz, hval, vval)
begin
	if rising_edge (Clk_25Mhz) then
		if (hval >= 144 and hval <784 and vval >= 35 and vval <515) then
			vga_en <= '1';
		else
			vga_en <= '0';
		end if;
	end if;
end process;


res: process (Clk_25MHz, vval)
begin
	if rising_edge (Clk_25MHz) then
		if (hval = 799 and vval = 524) then
		rst <= '1';
		else
		rst <= '0';
		end if;
	end if;
end process;

pixel_x <= std_logic_vector(to_unsigned (hval, pixel_x'length));
pixel_y <= std_logic_vector(to_unsigned (vval, pixel_y'length));
video_on <= vga_en;

end arch_vga_driver;