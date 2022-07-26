library IEEE;
use IEEE.STD_LOGIC_1164.ALL;





entity main is

port ( 
 board_clk: in std_logic;
 vsync: out std_logic;
 hsync: out std_logic;

 red: out std_logic_vector(2 downto 0);
 green: out std_logic_vector(2 downto 0);
 blue: out std_logic_vector(1 downto 0);
 
 EppAstb: in std_logic;                                               -- Address strobe
 EppDstb: in std_logic;                                               -- Data strobe
 EppWr : in std_logic;                                               -- Port write signal
 EppDB : inout std_logic_vector(7 downto 0); 								-- port data bus 
 EppWait: out std_logic
);

end main;



architecture Behavioral of main is

component IOExpansion
            Port(
     -- Epp-like bus signals
                   EppAstb: in std_logic;                                               -- Address strobe
                   EppDstb: in std_logic;                                               -- Data strobe
                   EppWr : in std_logic;                                               -- Port write signal
                   EppDB : inout std_logic_vector(7 downto 0); -- port data bus 
                   EppWait: out std_logic;                                             -- Port wait signal
     -- user extended signals
                   Led : in std_logic_vector(7 downto 0);                                                                 --    x01               8 virtual LEDs on the PC I/O Ex GUI
                   LBar : in std_logic_vector(23 downto 0);                                                              --            ..4 24 lights on the PC I/O Ex GUI light bar
                   Sw          : out std_logic_vector(15 downto 0);                                                        --              .6 16 switches, bottom row on the PC I/O Ex GUI
                   Btn : out std_logic_vector(15 downto 0);                                                                  -- ix07..8 16 Buttons, bottom row on the PC I/O Ex GUI 
                   dwOut: out std_logic_vector(31 downto 0); -- x09..b 32 Bits user output
                   dwIn : in std_logic_vector(31 downto 0)                                                                    --x0d..10 32 Bits user input
);   
 end component;
 
signal        Led1            :     std_logic_vector(7                            downto          0);         -- Ox01                     8      virtual LEDs on the PC I/O Ex GUI
signal        LBar1            :     std_logic_vector(23                           downto          0);         -- 0x02..4                  24     lights on the PC I/O Ex GUI light bar
signal        Sw1              :     std_logic_vector(15                           downto          0);         -- Ox05..6                  16     switches, bottom row on the PC I/O Ex GUI
signal        Btn1             :     std_logic_vector(15                           downto          0);         -- 0x07..8                  16     Buttons, bottom row on the PC I/O Ex GUI
signal        dwBtwn:                std_logic_vector(31                           downto          0);         --   0x09..b    


signal x : std_logic_vector (9 downto 0);
signal y : std_logic_vector (9 downto 0);
signal enable : std_logic;

component ee244_vgadriver
	port ( 
		board_clk: in std_logic;
		vsync: out std_logic;
		hsync: out std_logic;
		video_on : out std_logic;
		pixel_x, pixel_y : out std_logic_vector (9 downto 0));
end component;

component pixel_generator
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
end component;

component gamecore
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
end component;

signal player1_pos : STD_LOGIC_VECTOR (8 downto 0);
signal player2_pos : STD_LOGIC_VECTOR (8 downto 0);

signal ball_posx : STD_LOGIC_VECTOR (9 downto 0);
signal ball_posy : STD_LOGIC_VECTOR (8 downto 0);	
			  
signal score1 : STD_LOGIC_VECTOR (2 downto 0);
signal score2 : STD_LOGIC_VECTOR (2 downto 0);


begin

I0ex: IOExpansion port map(
				EppAstb=>EppAstb,         
            EppDstb=>EppDstb, 
            EppWr=>EppWr, 
            EppDB=>EppDB, 
            EppWait=>EppWait, 
            Led=>Led1, 
            LBar=>Lbar1,
            Sw=>Sw1,
            Btn=>Btn1, 
            dwOut=>dwBtwn, 
            dwIn=>dwBtwn);

driver: ee244_vgadriver PORT MAP (board_clk,vsync,hsync, enable, x, y );

generator: pixel_generator PORT MAP(x,y,enable,red,green,blue, player1_pos, player2_pos, ball_posx, ball_posy,score1,score2);

core: gamecore port map (board_clk, Btn1(15),Btn1(7), Btn1(14), Btn1(6), player1_pos, player2_pos, ball_posx, ball_posy, score1,score2);

end Behavioral;

