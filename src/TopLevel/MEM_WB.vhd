library IEEE;
use IEEE.std_logic_1164.all;

entity MEM_WB is

  port(
    
  );

end MEM_WB;

architecture dataflow of MEM_WB is

component Register_N

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end component;


begin

end dataflow;