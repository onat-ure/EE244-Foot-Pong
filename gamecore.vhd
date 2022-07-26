library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity gamecore is
    Port ( board_clk : in  STD_LOGIC;
	 
		     player1_up: in STD_LOGIC;
			  player1_down: in STD_LOGIC;
			  
			  player2_up: in STD_LOGIC;
			  player2_down: in STD_LOGIC;
			  
           player1_pos : out  STD_LOGIC_VECTOR (8 downto 0);
           player2_pos : out  STD_LOGIC_VECTOR (8 downto 0);
			  
           ball_posx : out  STD_LOGIC_VECTOR (9 downto 0);
           ball_posy : out  STD_LOGIC_VECTOR (8 downto 0);				  
			  
			  score1 : out  STD_LOGIC_VECTOR (2 downto 0);
           score2 : out  STD_LOGIC_VECTOR (2 downto 0)
			  );
end gamecore;

architecture Behavioral of gamecore is

--- clock divider definitions
signal Clk_120Hz	: STD_LOGIC := '0';
signal counter	: integer range 0 to 199999999 := 0;

--- player 1 pos and dir definitions
signal player1_dir: integer:=0;
signal player1_pos_int : integer:=240;

--- player 2 pos and dir definitions
signal player2_dir: integer:=0;
signal player2_pos_int : integer:=240;

--- ball pos and dir definitions
signal ball_dirx: integer:=1;
signal ball_diry: integer:=1;
signal ball_posy_int : integer range 0 to 480 :=240;
signal ball_posx_int : integer range 0 to 640 :=321;

-- score definitions

signal score1_int: integer:=0;
signal score2_int: integer:=0;

begin

--- player 1 movement

player1_dir <=
	-1 when (player1_up ='1' and player1_down ='0') else
	1 when (player1_up ='0' and player1_down ='1') else
	0;

player1_move: process (Clk_120Hz, player1_dir, player1_pos_int)
	begin
		if rising_edge(Clk_120Hz) then
		--- limits moving out of screen
			if ( player1_pos_int > 26 and player1_pos_int <455 ) or ( player1_pos_int = 26 and player1_dir = +1 ) or ( player1_pos_int = 455 and player1_dir = -1 )then
				 player1_pos_int <= player1_pos_int + player1_dir;
			else
				
			end if;
		end if;
			

	end process;

player1_pos <= std_logic_vector(to_unsigned (player1_pos_int, player1_pos'length));

--- player 2 movement

player2_dir <=
	-1 when (player2_up ='1' and player2_down ='0') else
	1 when (player2_up ='0' and player2_down ='1') else
	0;

player2_move: process (Clk_120Hz, player2_dir, player2_pos_int)
	begin
		if rising_edge(Clk_120Hz) then
		--- limits moving out of screen
			if ( player2_pos_int > 26 and player2_pos_int <455 ) or ( player2_pos_int = 26 and player2_dir = 1 ) or ( player2_pos_int = 455 and player2_dir = -1 )then
				player2_pos_int <= player2_pos_int + player2_dir;
			else
			
			end if;
		end if;
	end process;

player2_pos <= std_logic_vector(to_unsigned (player2_pos_int, player2_pos'length));

--- ball movement

ball_move: process (Clk_120Hz, ball_dirx, ball_diry, ball_posx_int, ball_posy_int)
	begin
		
		if rising_edge(Clk_120Hz) then
			if (score1_int = 5) then -- end game player 1 won
				score1_int<=0;
				score2_int<=0;
				ball_posx_int<=321;
				ball_posy_int<=240;			
				ball_dirx <= 1;
				ball_diry <= 1;
				
			elsif score2_int = 5 then -- end game player 1 won
				score1_int<=0;
				score2_int<=0;
				ball_posx_int<=321;
				ball_posy_int<=240;			
				ball_dirx <= 1;
				ball_diry <= 1;
			
			elsif ( ball_posx_int = 48) and ( 204 <= ball_posy_int and ball_posy_int <= 275) then --player2 scored
				score2_int <= score2_int +1;
				ball_posx_int <= 321;
				ball_posy_int <= 240;			
				ball_dirx <= -1;
				ball_diry <= -1;

			elsif ( ball_posx_int = 597 ) and ( 204 <= ball_posy_int and ball_posy_int <= 275) then -- player1 scored
				score1_int <= score1_int +1;
				ball_posx_int<=321;
				ball_posy_int<=240;			
				ball_dirx <= 1;
				ball_diry <= 1;
		
		--- 4 duvar için 4 tane sinirlayici durum, 2 kale için 2 sinirlayici durum
			elsif (ball_posx_int = 85 and  player1_pos_int - 25 <= ball_posy_int and ball_posy_int <= player1_pos_int + 25)	then --- player 1
					ball_dirx <= - ball_dirx;
					ball_posx_int <= ball_posx_int - ball_dirx;
					ball_posy_int <= ball_posy_int + ball_diry;
			elsif (ball_posx_int = 555 and  player2_pos_int - 25 <= ball_posy_int and ball_posy_int <= player2_pos_int + 25)	then --- player 2
					ball_dirx <= - ball_dirx;
					ball_posx_int <= ball_posx_int - ball_dirx;
					ball_posy_int <= ball_posy_int + ball_diry;
			elsif (204 <= ball_posy_int and ball_posy_int <= 275 ) and (ball_posx_int = 32 or ball_posx_int = 612 ) then --- goals
					ball_dirx <= - ball_dirx;
					ball_posx_int <= ball_posx_int - ball_dirx;
					ball_posy_int <= ball_posy_int + ball_diry;					
			elsif ( (ball_posy_int = 201) or (ball_posy_int = 278) ) and ( (30 <= ball_posx_int and ball_posx_int <= 66) or (579 <= ball_posx_int and ball_posx_int <= 610) ) then --- goal arms
					ball_diry <= - ball_diry;
					ball_posy_int <= ball_posy_int - ball_diry;
					ball_posx_int <= ball_posx_int + ball_dirx;					
					
			
			elsif ( ball_posy_int > 0 and ball_posy_int <480  and ball_posx_int > 0 and ball_posx_int <640 ) then --- general ball movement
					ball_posx_int <= ball_posx_int + ball_dirx;
					ball_posy_int <= ball_posy_int + ball_diry;
			elsif (ball_posy_int = 0)	then --- top wall
					ball_diry <= - ball_diry;
					ball_posy_int <= ball_posy_int - ball_diry;
					ball_posx_int <= ball_posx_int + ball_dirx;
			elsif (ball_posy_int =480) then --- bottom wall
					ball_diry <= - ball_diry;
					ball_posy_int <= ball_posy_int - ball_diry;
					ball_posx_int <= ball_posx_int + ball_dirx;
			elsif (ball_posx_int = 0)	then --- left wall
					ball_dirx <= - ball_dirx;
					ball_posx_int <= ball_posx_int - ball_dirx;
					ball_posy_int <= ball_posy_int + ball_diry;
			elsif (ball_posx_int =640) then --- right wall
					ball_dirx <= - ball_dirx;
					ball_posx_int <= ball_posx_int - ball_dirx;
					ball_posy_int <= ball_posy_int + ball_diry;
					
			else
			
			end if;
			
		end if;
	end process;

ball_posx <= std_logic_vector(to_unsigned (ball_posx_int, ball_posx'length));
ball_posy <= std_logic_vector(to_unsigned (ball_posy_int, ball_posy'length));


score1 <= std_logic_vector(to_unsigned (score1_int, score1'length));
score2 <= std_logic_vector(to_unsigned (score2_int, score1'length));


--- frequency divider for moving objects
FREQ_DIV: process (board_clk) begin
	if rising_edge(board_clk) then
		if (counter = 249999) then -- 200 Hz Clock
			Clk_120Hz <= not Clk_120Hz;
			counter <= 0;
		else
			counter <= counter + 1;
		end if;
	end if;
end process;

end Behavioral;

