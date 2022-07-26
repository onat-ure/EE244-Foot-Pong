library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity pixel_generator is
    Port ( 

			  pixel_x : in  std_logic_vector(9 downto 0);
           pixel_y : in  std_logic_vector(9 downto 0);
           video_on : in  STD_LOGIC;
			  
			  red: out std_logic_vector(2 downto 0);
			  green: out std_logic_vector(2 downto 0);
			  blue: out std_logic_vector(1 downto 0);
			  
           player1_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           player2_pos : in  STD_LOGIC_VECTOR (8 downto 0);

           ball_posx : in  STD_LOGIC_VECTOR (9 downto 0);
           ball_posy : in  STD_LOGIC_VECTOR (8 downto 0);			  
			  
			  score1 : in  STD_LOGIC_VECTOR (2 downto 0);
           score2 : in  STD_LOGIC_VECTOR (2 downto 0)
           );
end pixel_generator;



architecture Behavioral of pixel_generator is

signal p_x, p_y : integer;
constant x_max : integer:=640;
constant y_max : integer:=480;
signal white: std_logic_vector(7 downto 0);
signal yellow: std_logic_vector(7 downto 0);
signal navy: std_logic_vector(7 downto 0);
signal rgb : STD_LOGIC_vector (7 downto 0);

--- middle line
constant middle_X_L: integer:=319;
constant middle_X_R: integer:=322;

signal middle_on: std_logic;


--- goals y
constant goal_Y_SIZE: integer:=72;
constant goal_Y_T: integer:=y_max/2-goal_Y_SIZE/2;
constant goal_Y_B: integer:=goal_Y_T+goal_Y_SIZE-1; 

---- left goal x
constant leftgoal_X_L: integer:=30;
constant leftgoal_X_R: integer:=35;

signal leftgoal_on: std_logic;

---- right goal x

constant rightgoal_X_L: integer:=610;
constant rightgoal_X_R: integer:=615;

signal rightgoal_on: std_logic;

---- goal arms sizes
constant goalarm_Y_SIZE: integer:=5;
constant goalarm_X_SIZE: integer:=36;

---- top arms y
constant goaltoparm_Y_B: integer:=goal_Y_T-1;
constant goaltoparm_Y_T: integer:=goaltoparm_Y_B - goalarm_Y_SIZE;

---- left arms x
constant leftgoalarm_X_L: integer:= leftgoal_X_L;
constant leftgoalarm_X_R: integer:= leftgoal_X_L + goalarm_X_SIZE;

---- right arms x
constant rightgoalarm_X_L: integer:= rightgoal_X_R - goalarm_X_SIZE;
constant rightgoalarm_X_R: integer:= rightgoal_X_R;

---- bottom arms y
constant goalbottomarm_Y_T: integer:=goal_Y_B+1;
constant goalbottomarm_Y_B: integer:=goalbottomarm_Y_T + goalarm_Y_SIZE;

signal arms_on: std_logic;


--- players

constant player_Y_SIZE: integer:=50;
constant player_X_SIZE: integer:=5;

--- player 1
signal player1_pos_int: integer;

---- player 1 x
constant player1_X_L: integer:=85;
constant player1_X_R: integer:=player1_X_L + player_X_SIZE;

---- player 1 y
signal player1_Y_T: integer:= 240 - player_Y_SIZE/2;
signal player1_Y_B: integer:= 240 + player_Y_SIZE/2;


signal player1_on: std_logic;

--- player 2
signal player2_pos_int: integer;

---- player 2 x
constant player2_X_R: integer:= 555 ;
constant player2_X_L: integer:= player2_X_R - player_X_SIZE;

---- player 2 y
signal player2_Y_T: integer:= 240 - player_Y_SIZE/2;
signal player2_Y_B: integer:= 240 + player_Y_SIZE/2;


signal player2_on: std_logic;

--- ball
constant ball_Y_SIZE: integer:=4;
constant ball_X_SIZE: integer:=4;
signal ball_posy_int: integer;
signal ball_posx_int: integer;

--- ball y

signal ball_Y_T: integer;
signal ball_Y_B: integer; 

---- ball x
signal ball_X_L: integer;
signal ball_X_R: integer;

signal ball_on: std_logic;

-- ssd

constant ssd1_posx: integer:=270;
constant ssd2_posx: integer:=350;
constant ssd_posy: integer:=30;
constant ssd_len: integer:=20;

-- ssd1
-- ssd1 a
constant ssd1_a_x_L: integer:=ssd1_posx;
constant ssd1_a_x_R: integer:=ssd1_a_x_L+ssd_len;

constant ssd1_a_y: integer:=ssd_posy;

signal ssd1_a_on: std_logic;

-- ssd1 b
constant ssd1_b_x: integer:=ssd1_posx+ssd_len;

constant ssd1_b_y_T: integer:=ssd_posy;
constant ssd1_b_y_B: integer:=ssd1_b_y_T+ssd_len;

signal ssd1_b_on: std_logic;

-- ssd1 c
constant ssd1_c_x: integer:=ssd1_posx+ssd_len;

constant ssd1_c_y_T: integer:=ssd_posy+ssd_len;
constant ssd1_c_y_B: integer:=ssd1_c_y_T+ssd_len;

signal ssd1_c_on: std_logic;

-- ssd1 d
constant ssd1_d_x_L: integer:=ssd1_posx;
constant ssd1_d_x_R: integer:=ssd1_d_x_L+ssd_len;

constant ssd1_d_y: integer:=ssd_posy+ssd_len+ssd_len;

signal ssd1_d_on: std_logic;

-- ssd1 e
constant ssd1_e_x: integer:=ssd1_posx;

constant ssd1_e_y_T: integer:=ssd_posy+ssd_len;
constant ssd1_e_y_B: integer:=ssd1_e_y_T+ssd_len;

signal ssd1_e_on: std_logic;

-- ssd1 f
constant ssd1_f_x: integer:=ssd1_posx;

constant ssd1_f_y_T: integer:=ssd_posy;
constant ssd1_f_y_B: integer:=ssd1_f_y_T+ssd_len;

signal ssd1_f_on: std_logic;

-- ssd1 g
constant ssd1_g_x_L: integer:=ssd1_posx;
constant ssd1_g_x_R: integer:=ssd1_g_x_L+ssd_len;

constant ssd1_g_y: integer:=ssd_posy+ssd_len;

signal ssd1_g_on: std_logic;

-- ssd2
-- ssd2 a
constant ssd2_a_x_L: integer:=ssd2_posx;
constant ssd2_a_x_R: integer:=ssd2_a_x_L+ssd_len;

constant ssd2_a_y: integer:=ssd_posy;

signal ssd2_a_on: std_logic;

-- ssd2 b
constant ssd2_b_x: integer:=ssd2_posx+ssd_len;

constant ssd2_b_y_T: integer:=ssd_posy;
constant ssd2_b_y_B: integer:=ssd2_b_y_T+ssd_len;

signal ssd2_b_on: std_logic;

-- ssd2 c
constant ssd2_c_x: integer:=ssd2_posx+ssd_len;

constant ssd2_c_y_T: integer:=ssd_posy+ssd_len;
constant ssd2_c_y_B: integer:=ssd2_c_y_T+ssd_len;

signal ssd2_c_on: std_logic;

-- ssd2 d
constant ssd2_d_x_L: integer:=ssd2_posx;
constant ssd2_d_x_R: integer:=ssd2_d_x_L+ssd_len;

constant ssd2_d_y: integer:=ssd_posy+ssd_len+ssd_len;

signal ssd2_d_on: std_logic;

-- ssd2 e
constant ssd2_e_x: integer:=ssd2_posx;

constant ssd2_e_y_T: integer:=ssd_posy+ssd_len;
constant ssd2_e_y_B: integer:=ssd2_e_y_T+ssd_len;

signal ssd2_e_on: std_logic;

-- ssd2 f
constant ssd2_f_x: integer:=ssd2_posx;

constant ssd2_f_y_T: integer:=ssd_posy;
constant ssd2_f_y_B: integer:=ssd2_f_y_T+ssd_len;

signal ssd2_f_on: std_logic;


-- ssd2 g
constant ssd2_g_x_L: integer:=ssd2_posx;
constant ssd2_g_x_R: integer:=ssd2_g_x_L+ssd_len;

constant ssd2_g_y: integer:=ssd_posy+ssd_len;

signal ssd2_g_on: std_logic;


begin


---- player 1 y
player1_Y_T <= player1_pos_int - player_Y_SIZE/2;
player1_Y_B <= player1_pos_int + player_Y_SIZE/2;

player1_pos_int <= (to_integer(unsigned(player1_pos) ) );

---- player 2 y
player2_Y_T <= player2_pos_int - player_Y_SIZE/2;
player2_Y_B <= player2_pos_int + player_Y_SIZE/2;

player2_pos_int <= (to_integer(unsigned(player2_pos) ) );

--- ball y
ball_posy_int <= (to_integer(unsigned(ball_posy) ) );
ball_Y_T <= ball_posy_int -ball_Y_SIZE/2;
ball_Y_B <= ball_Y_T +ball_Y_SIZE-1; 

---- ball x
ball_posx_int <= (to_integer(unsigned(ball_posx) ) );
ball_X_L <= ball_posx_int -ball_X_SIZE/2;
ball_X_R <= ball_X_L+ball_X_SIZE-1;



p_x <= (to_integer(unsigned(pixel_x)) - 143); --- to reference the counters to display time
p_y <= (to_integer(unsigned(pixel_y)) - 34);


--- ssd1 on when

ssd1_a_on <=
 '1' when ( score1 = "000" or score1 = "010" or score1 = "011" or score1 = "101" ) and (ssd1_a_X_L<=p_x) and (p_x<=ssd1_a_X_R) and (ssd1_a_Y=p_y) else
 '0';
ssd1_b_on <=
 '1' when ( score1 = "000" or score1 = "001" or score1 = "010" or score1 = "011" or score1 = "100" ) and (ssd1_b_X=p_x) and (ssd1_b_Y_T<=p_y) and (p_y<=ssd1_b_Y_B) else
 '0'; 
ssd1_c_on <=
 '1' when ( score1 = "000" or score1 = "001" or score1 = "011" or score1 = "100" or score1 = "101" ) and (ssd1_c_X=p_x) and (ssd1_c_Y_T<=p_y) and (p_y<=ssd1_c_Y_B) else
 '0';  
ssd1_d_on <=
 '1' when ( score1 = "000" or score1 = "010" or score1 = "011" or score1 = "101" ) and (ssd1_d_X_L<=p_x) and (p_x<=ssd1_d_X_R) and (ssd1_d_Y=p_y) else
 '0';
ssd1_e_on <=
 '1' when ( score1 = "000" or score1 = "010" ) and (ssd1_e_X=p_x) and (ssd1_e_Y_T<=p_y) and (p_y<=ssd1_e_Y_B) else
 '0';
ssd1_f_on <=
 '1' when ( score1 = "000" or score1 = "100" or score1 = "101" ) and (ssd1_f_X=p_x) and (ssd1_f_Y_T<=p_y) and (p_y<=ssd1_f_Y_B) else
 '0';  
ssd1_g_on <=
 '1' when ( score1 = "010" or score1 = "011" or score1 = "100" or score1 = "101" ) and (ssd1_g_X_L<=p_x) and (p_x<=ssd1_g_X_R) and (ssd1_g_Y=p_y) else
 '0'; 

--- ssd2 on when

ssd2_a_on <=
 '1' when ( score2 = "000" or score2 = "010" or score2 = "011" or score2 = "101" ) and (ssd2_a_X_L<=p_x) and (p_x<=ssd2_a_X_R) and (ssd2_a_Y=p_y) else
 '0';
ssd2_b_on <=
 '1' when ( score2 = "000" or score2 = "001" or score2 = "010" or score2 = "011" or score2 = "100" ) and (ssd2_b_X=p_x) and (ssd2_b_Y_T<=p_y) and (p_y<=ssd2_b_Y_B) else
 '0'; 
ssd2_c_on <=
 '1' when ( score2 = "000" or score2 = "001" or score2 = "011" or score2 = "100" or score2 = "101" ) and (ssd2_c_X=p_x) and (ssd2_c_Y_T<=p_y) and (p_y<=ssd2_c_Y_B) else
 '0';  
ssd2_d_on <=
 '1' when ( score2 = "000" or score2 = "010" or score2 = "011" or score2 = "101" ) and (ssd2_d_X_L<=p_x) and (p_x<=ssd2_d_X_R) and (ssd2_d_Y=p_y) else
 '0';
ssd2_e_on <=
 '1' when ( score2 = "000" or score2 = "010" ) and (ssd2_e_X=p_x) and (ssd2_e_Y_T<=p_y) and (p_y<=ssd2_e_Y_B) else
 '0';
ssd2_f_on <=
 '1' when ( score2 = "000" or score2 = "100" or score2 = "101" ) and (ssd2_f_X=p_x) and (ssd2_f_Y_T<=p_y) and (p_y<=ssd2_f_Y_B) else
 '0';  
ssd2_g_on <=
 '1' when ( score2 = "010" or score2 = "011" or score2 = "100" or score2 = "101" ) and (ssd2_g_X_L<=p_x) and (p_x<=ssd2_g_X_R) and (ssd2_g_Y=p_y) else
 '0';


-- goals on when
leftgoal_on <=
 '1' when (leftgoal_X_L<=p_x) and (p_x<=leftgoal_X_R) and (goal_Y_T<=p_y) and (p_y<=goal_Y_B) else
 '0'; 


rightgoal_on <=
 '1' when (rightgoal_X_L<=p_x) and (p_x<=rightgoal_X_R) and (goal_Y_T<=p_y) and (p_y<=goal_Y_B) else
 '0'; 

-- goal arms on
arms_on <=
 '1' when ( (leftgoalarm_X_L<=p_x) and (p_x<=leftgoalarm_X_R) and (goaltoparm_Y_T<=p_y) and (p_y<=goaltoparm_Y_B) ) OR --- left top
			( (leftgoalarm_X_L<=p_x) and (p_x<=leftgoalarm_X_R) and (goalbottomarm_Y_T<=p_y) and (p_y<=goalbottomarm_Y_B) ) OR --- left bottom
			( (rightgoalarm_X_L<=p_x) and (p_x<=rightgoalarm_X_R) and (goaltoparm_Y_T<=p_y) and (p_y<=goaltoparm_Y_B) ) OR --- right top
			( (rightgoalarm_X_L<=p_x) and (p_x<=rightgoalarm_X_R) and (goalbottomarm_Y_T<=p_y) and (p_y<=goalbottomarm_Y_B) ) else ---- right bottom
'0';


-- players on when
player1_on <=
 '1' when (player1_X_L<=p_x) and (p_x<=player1_X_R) and (player1_Y_T<=p_y) and (p_y<=player1_Y_B) else
 '0';
player2_on <=
 '1' when (player2_X_L<=p_x) and (p_x<=player2_X_R) and (player2_Y_T<=p_y) and (p_y<=player2_Y_B) else
 '0';
middle_on <=
 '1' when (middle_X_L<=p_x) and (p_x<=middle_X_R) else
 '0';
ball_on <=
 '1' when (ball_X_L<=p_x) and (p_x<=ball_X_R) and (ball_Y_T<=p_y) and (p_y<=ball_Y_B) else
 '0';

-- some colors
white <= "11111111";
yellow <= "11111100";
navy <= "00000011";

process (video_on, leftgoal_on, rightgoal_on, arms_on, player1_on, player2_on, white)
	begin
		if video_on='0' then
			rgb <= "00000000";
		else
			if leftgoal_on='1' then
				rgb <= white;
			elsif rightgoal_on='1' then
				rgb <= white;
			elsif middle_on='1' then
				rgb <= white;
			elsif arms_on='1' then
				rgb <= white;
			elsif player1_on='1' then
				rgb <= yellow;				
			elsif player2_on='1' then
				rgb <= navy;
			elsif ball_on='1' then
				rgb <= white;
--- ssd1			
			elsif ssd1_a_on='1' or ssd1_b_on='1' or ssd1_c_on='1' or ssd1_d_on='1' or ssd1_e_on='1' or ssd1_f_on='1' or ssd1_g_on='1' then
				rgb <= white;		
--- ssd2				
			elsif ssd2_a_on='1' or ssd2_b_on='1' or ssd2_c_on='1' or ssd2_d_on='1' or ssd2_e_on='1' or ssd2_f_on='1' or ssd2_g_on='1' then
				rgb <= white;					
			else
				rgb <= "00000000";
			end if;
		end if;
end process;

red <= rgb (7 downto 5);
green <= rgb (4 downto 2);
blue <= rgb (1 downto 0);

end Behavioral;

