library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;
entity FetchComponent_tb is
   generic(gCLK_HPER   : time := 10 ns; 
           N : integer := 32;
	   I : integer := 26);
end FetchComponent_tb;

architecture behavior of FetchComponent_tb is
constant cCLK_PER  : time := gCLK_HPER * 2;

component FetchComponent is
  port(i_CLK        : in std_logic;     -- Clock input
       i_jAddr      : in std_logic_vector(I-1 downto 0);     -- Reset input
       i_PC         : in std_logic_vector(N-1 downto 0);     -- Write enable input
       i_branchAddr : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_branchEN   : in std_logic;     
       i_jumpEN     : in std_logic; 
       i_jrAddr     : in std_logic_vector(N-1 downto 0); 
       i_jrEN	    : in std_logic;
       o_pcOut      : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_pcAddFour  : out std_logic_vector(N-1 downto 0));
end component;

signal s_CLK, s_reset : std_logic := '0';

signal       s_jAddr      :  std_logic_vector(I-1 downto 0) := "00000000000000000000000000";    
signal       s_PC         :  std_logic_vector(N-1 downto 0) := x"00000000";     -- Write enable input
signal       s_branchAddr :  std_logic_vector(N-1 downto 0) := x"00000000";     -- Data value input
signal       s_branchEN   :  std_logic := '0';     
signal       s_jumpEN     :  std_logic := '0'; 
signal       s_jrAddr     :  std_logic_vector(N-1 downto 0) := x"00000000"; 
signal       s_jrEN	  :  std_logic := '0';

signal       s_pcOut      :  std_logic_vector(N-1 downto 0);   -- Data value output
signal       s_pcAddFour  :  std_logic_vector(N-1 downto 0);

begin

DUT0: FetchComponent
port map(i_CLK		=> s_CLK,     
       i_jAddr		=> s_jAddr,      
       i_PC		=> s_PC,        
       i_branchAddr	=> s_branchAddr, 
       i_branchEN	=> s_branchEN,       
       i_jumpEN		=> s_jumpEN,    
       i_jrAddr		=> s_jrAddr,      
       i_jrEN		=> s_jrEN,	    
       o_pcOut		=> s_pcOut,     
       o_pcAddFour	=> s_pcAddFour);


P_CLK: process
  begin
    s_CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    s_CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;
 



  P_TB: process
  begin

 -- Test case 0: let pcAddFour get thru
    s_jAddr         <= "00000000000000000000000000";
    s_PC	    <= x"10010000";                  -- current PC address
    s_branchAddr    <= x"10010008";
    s_branchEN      <= '0';                          -- Enable branch
    s_jumpEN        <= '1';                          -- Disable jump
    s_jrAddr        <= x"1001000F";
    s_jrEn          <= '0';		            -- Enable jump reg
    wait for gCLK_HPER*2;
    -- Expect: pcOut = 0x10010004
    -- Expect: pcPlusFour = 0x10010004

    -- Test case 1: let PCAddBranch get thru
    s_jAddr         <= "00000000000000000000000000";
    s_PC	    <= x"10010000";                  -- current PC address
    s_branchAddr    <= x"00000001";
    s_branchEN      <= '1';                          -- Enable branch
    s_jumpEN        <= '1';                          -- Disable jump
    s_jrAddr        <= x"00000000";
    s_jrEn          <= '0';		             -- Enable jump reg
    wait for gCLK_HPER*2;
    -- Expect: pcOut = 0x10010004
    -- Expect: pcPlusFour = 0x10010004

    -- Test case 2: let jReg get thru
    s_jAddr         <= "00000000000000000000000000";
    s_PC	    <= x"10010000";                  -- current PC address
    s_branchAddr    <= x"00000000";
    s_branchEN      <= '0';                          -- Enable branch
    s_jumpEN        <= '1';                          -- Disable jump
    s_jrAddr        <= x"FFFFFFFF";
    s_jrEn          <= '1';		             -- Enable jump reg
    wait for gCLK_HPER*2;
    -- Expect: pcOut = 0x10010004
    -- Expect: pcPlusFour = 0x10010004

 -- Test case 3: let PCAddFour get thru
    s_jAddr         <= "00000000000000000000000000";
    s_PC	    <= x"00000000";                  -- current PC address
    s_branchAddr    <= x"00000000";
    s_branchEN      <= '0';                          -- Enable branch
    s_jumpEN        <= '1';                          -- Disable jump
    s_jrAddr        <= x"00000000";
    s_jrEn          <= '0';		             -- Enable jump reg
    wait for gCLK_HPER*2;
    -- Expect: pcOut = 0x00000004
    -- Expect: pcPlusFour = 0x00000004

 -- Test case 4: let jReg get thru
    s_jAddr         <= "00000000000000000000000000";
    s_PC	    <= x"10010000";                  -- current PC address
    s_branchAddr    <= x"00111100";
    s_branchEN      <= '0';                          -- Enable branch
    s_jumpEN        <= '1';                          -- Disable jump
    s_jrAddr        <= x"ABCDABCD";
    s_jrEn          <= '1';		             -- Enable jump reg
    wait for gCLK_HPER*2;
    -- Expect: pcOut = 0x10010004
    -- Expect: pcPlusFour = 0x10010004

  -- Test case 5: let PCAddBranch get thru
    s_jAddr         <= "00000000000000000000000000";
    s_PC	    <= x"10010000";                  -- current PC address
    s_branchAddr    <= x"00000001";
    s_branchEN      <= '1';                          -- Enable branch
    s_jumpEN        <= '1';                          -- Disable jump
    s_jrAddr        <= x"00000000";
    s_jrEn          <= '0';		             -- Enable jump reg
    wait for gCLK_HPER*2;
    -- Expect: pcOut = 0x10010004
    -- Expect: pcPlusFour = 0x10010004


  end process;
end behavior;