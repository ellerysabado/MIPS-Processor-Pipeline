library IEEE;
use IEEE.std_logic_1164.all;

entity IF_ID is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_Flush      : in std_logic_vector(31 downto 0);     -- Data value input
       i_PCAdd      : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_InstMem    : in std_logic_vector(N-1 downto 0);     -- Data value input 
       o_PCAdd      : out std_logic_vector(N-1 downto 0);     -- Data value output FIX THIS Data bits--------------------------------
       o_InstMem    : out std_logic_vector(N-1 downto 0));    -- Data value output 

end IF_ID;

architecture dataflow of IF_ID is

component Register_N

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end component;


begin

  PCAdd : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_PCAdd,
           o_Q             => o_PCAdd); 


  InstMem : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_InstMem,
           o_Q             => o_InstMem); 

end dataflow;