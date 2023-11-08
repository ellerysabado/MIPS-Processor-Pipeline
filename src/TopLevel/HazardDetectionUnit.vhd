library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HazardDetectionUnit is
    Port (
        ID_EX_MemRead      : in std_logic;
        ID_EX_RegisterRt   : in std_logic_vector(4 downto 0);
        IF_ID_RegisterRs   : in std_logic_vector(4 downto 0);
        IF_ID_RegisterRt   : in std_logic_vector(4 downto 0);
        ControlMUXSel      : out std_logic;
        PCWrite            : out std_logic; 
        IF_ID_Write        : out std_logic;
    );
end HazardDetectionUnit;

architecture Behavioral of HazardDetectionUnit is
begin
    -- Check for data hazards and generate the stall signal
    StallSignal <= '1' when (ID_EX_MemRead = '1' and (ID_EX_RegisterRt = IF_ID_RegisterRs or ID_EX_RegisterRt = IF_ID_RegisterRs)) else
                   '0';
end Behavioral;
