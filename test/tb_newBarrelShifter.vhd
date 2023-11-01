library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_newBarrelShifter is
  generic(gCLK_HPER   : time := 50 ns);
end tb_newBarrelShifter;

architecture behavior of tb_newBarrelShifter is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component newBarrelShifter
  Port (
        i_S : in STD_LOGIC_VECTOR(4 downto 0); -- 5 select lines
        i_D : in std_logic_vector(31 downto 0);
        shiftsel : in STD_LOGIC;
        LogOrAr : STD_LOGIC;
        o_O : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_RST : std_logic;
  signal si_S : STD_LOGIC_VECTOR(4 downto 0); -- 5 select lines
  signal si_D : std_logic_vector(31 downto 0);
  signal s_shiftsel : std_logic;
  signal s_LogOrAr : std_logic;
  signal so_O : std_logic_vector(31 downto 0);

begin

  DUT00: newBarrelShifter 
  port map( 
           i_S => si_S,
           i_D => si_D,
           shiftsel => s_shiftsel,
           LogOrAr => s_LogOrAr,
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
    si_S <= "00000";
    s_LogOrAr <= '1';
    s_shiftsel <= '0';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;

    si_S <= "00001";
    s_LogOrAr <= '1';
    s_shiftsel <= '0';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;

    si_S <= "00010";
    s_LogOrAr <= '1';
    s_shiftsel <= '0';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;

    si_S <= "00011";
    s_LogOrAr <= '1';
    s_shiftsel <= '0';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;

    si_S <= "00100";
    s_LogOrAr <= '1';
    s_shiftsel <= '0';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;
    
    si_S <= "00101";
    s_LogOrAr <= '1';
    s_shiftsel <= '0';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;

    si_S <= "00110";
    s_LogOrAr <= '1';
    s_shiftsel <= '1';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;

    si_S <= "00111";
    s_LogOrAr <= '1';
    s_shiftsel <= '1';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;

    si_S <= "01000";
    s_LogOrAr <= '1';
    s_shiftsel <= '1';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;

    si_S <= "01001";
    s_LogOrAr <= '1';
    s_shiftsel <= '1';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;

    si_S <= "01010";
    s_LogOrAr <= '1';
    s_shiftsel <= '1';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;

    si_S <= "01011";
    s_LogOrAr <= '1';
    s_shiftsel <= '1';
    si_D <= "10100000101000001000101010101010";
    wait for cCLK_PER;
    wait;
  end process;
  
end behavior;