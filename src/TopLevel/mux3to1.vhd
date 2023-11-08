library IEEE;
use IEEE.std_logic_1164.all;

entity mux3to1 is
generic(N : integer := 32);
    port (
        A	: in std_logic_vector(N-1 downto 0);
	B	: in std_logic_vector(N-1 downto 0);
	C	: in std_logic_vector(N-1 downto 0);
        Sel     : in std_logic_vector(1 downto 0);
        Y       : out std_logic_vector(N-1 downto 0)
    );
end entity mux3to1;

architecture Dataflow of mux3to1 is
begin
    Y <= A when Sel = "00" else
         B when Sel = "01" else
         C when Sel = "10" else
         (others => '0');
end architecture Dataflow;