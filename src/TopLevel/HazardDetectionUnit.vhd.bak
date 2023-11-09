LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY HazardDetectionUnit IS
    PORT (
        ID_EX_MemRead    : IN STD_LOGIC;
        ID_EX_RegisterRt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        IF_ID_RegisterRs : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        IF_ID_RegisterRt : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        ControlMUXSel    : OUT STD_LOGIC;
        PCWrite          : OUT STD_LOGIC;
        IF_ID_Write      : OUT STD_LOGIC;
        IF_Flush         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END HazardDetectionUnit;

ARCHITECTURE Behavioral OF HazardDetectionUnit IS
BEGIN

    ControlMUXSel <= '0' WHEN (ID_EX_MemRead = '1' AND
        ((ID_EX_RegisterRt = IF_ID_RegisterRs) OR
        (ID_EX_RegisterRt = IF_ID_RegisterRt)))

    IF_ID_Write <= '0' WHEN (ID_EX_MemRead = '1' AND
        ((ID_EX_RegisterRt = IF_ID_RegisterRs) OR
        (ID_EX_RegisterRt = IF_ID_RegisterRt)))

        IF_Flush <= x"00000000" WHEN (ID_EX_MemRead = '1' AND
        ((ID_EX_RegisterRt = IF_ID_RegisterRs) OR
        (ID_EX_RegisterRt = IF_ID_RegisterRt)))

    
    END Behavioral;