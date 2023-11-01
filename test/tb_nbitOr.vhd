library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_nbitOr is
  generic(gCLK_HPER   : time := 50 ns;
	  N : INTEGER := 32);
end tb_nbitOr;

architecture behavior of tb_nbitOr is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component nbitOr
  PORT (
        in1 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        in2 : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        o_O : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
    );
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST : std_logic;
  signal sin1 : std_logic_vector(31 downto 0);
  signal sin2 : std_logic_vector(31 downto 0);
  signal so_O : std_logic_vector(31 downto 0);

begin

  ORR: nbitOr 
  port map( 
           in1 => sin1,
           in2 => sin2,
           o_O   => so_O);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;


P_RST: process
  begin
  	s_RST <= '0';   
    wait for gCLK_HPER/2;
	s_RST <= '1';
    wait for gCLK_HPER*2;
	s_RST <= '0';
	wait;
  end process;  
  
  -- Testbench process  
  P_TB: process
  begin

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "11100011100111000111000111000111";
    wait for cCLK_PER;

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "01010111100011100011100001111100";
    wait for cCLK_PER;

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "00110011111000001110101010101111";
    wait for cCLK_PER;

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "01011100111000111100011110000111";
    wait for cCLK_PER;

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "10110000011110001110001110001111";
    wait for cCLK_PER;
    
    sin1 <= "10100000101000001000101010101010";
    sin2 <=  "11111111111111111111111111111111";
    wait for cCLK_PER;

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "00000000000000000000000000000000";
    wait for cCLK_PER;

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "11111111111111100000000000000000";
    wait for cCLK_PER;

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "00000000000000001111111111111111";
    wait for cCLK_PER;

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "11111111100000000000011111111111";
    wait for cCLK_PER;

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "00000000001111111111000000000000";
    wait for cCLK_PER;

    sin1 <= "10100000101000001000101010101010";
    sin2 <= "11111111111000101111111111111110";
    wait for cCLK_PER;
    wait;
  end process;
  
end behavior;