LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY newBarrelShifter IS
    PORT (
        i_S : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- 5 select lines
        i_D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        shiftsel : IN STD_LOGIC;
        logOrAr : IN STD_LOGIC;
        o_O : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END newBarrelShifter;

ARCHITECTURE Structual OF newBarrelShifter IS
    SIGNAL s_shiftsig : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL o_one : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL o_two : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL o_three : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL o_four : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL o_five : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL oneTozero : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL threeTozero : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL sevenTozero : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL fifteenTozero : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    s_shiftsig <= shiftsel & logOrAr;
    --shift 1
    o_one <= i_D(30 DOWNTO 0) & '0' WHEN i_S(0) = '1' AND s_shiftsig = "00" ELSE
        i_D(30 DOWNTO 0) & '0' WHEN i_S(0) = '1' AND s_shiftsig = "01" ELSE
        '0' & i_D(31 DOWNTO 1) WHEN i_S(0) = '1' AND s_shiftsig = "10" ELSE
        i_D(31) & i_D(31 DOWNTO 1) WHEN i_S(0) = '1' AND s_shiftsig = "11" ELSE
        i_D;
    oneTozero <= (others => o_one(31));
    --shift 2
    o_two <= o_one(29 DOWNTO 0) & "00" WHEN i_S(1) = '1' AND s_shiftsig = "00" ELSE
        o_one(29 DOWNTO 0) & "00" WHEN i_S(1) = '1' AND s_shiftsig = "01" ELSE
        "00" & o_one(31 DOWNTO 2) WHEN i_S(1) = '1' AND s_shiftsig = "10" ELSE
        oneTozero & o_one(31 DOWNTO 2) WHEN i_S(1) = '1' AND s_shiftsig = "11" ELSE
        o_one;
    threeTozero <= (others => o_two(31));
    --shfit 4
    o_three <= o_two(27 DOWNTO 0) & "0000" WHEN i_S(2) = '1' AND s_shiftsig = "00" ELSE
        o_two(27 DOWNTO 0) & "0000" WHEN i_S(2) = '1' AND s_shiftsig = "01" ELSE
        "0000" & o_two(31 DOWNTO 4) WHEN i_S(2) = '1' AND s_shiftsig = "10" ELSE
        threeTozero & o_two(31 DOWNTO 4) WHEN i_S(2) = '1' AND s_shiftsig = "11" ELSE
        o_two;
    sevenTozero <= (others => o_three(31));
    --shift 8
    o_four <= o_three(23 DOWNTO 0) & "00000000" WHEN i_S(3) = '1' AND s_shiftsig = "00" ELSE
        o_three(23 DOWNTO 0) & "00000000" WHEN i_S(3) = '1' AND s_shiftsig = "01" ELSE
        "00000000" & o_three(31 DOWNTO 8) WHEN i_S(3) = '1' AND s_shiftsig = "10" ELSE
        sevenTozero & o_three(31 DOWNTO 8) WHEN i_S(3) = '1' AND s_shiftsig = "11" ELSE
        o_three;
    fifteenTozero <= (others => o_four(31));
    o_five <= o_four(15 DOWNTO 0) & "0000000000000000" WHEN i_S(4) = '1' AND s_shiftsig = "00" ELSE
        o_four(15 DOWNTO 0) & "0000000000000000" WHEN i_S(4) = '1' AND s_shiftsig = "01" ELSE
        "0000000000000000" & o_four(31 DOWNTO 16) WHEN i_S(4) = '1' AND s_shiftsig = "10" ELSE
        fifteenTozero & o_four(31 DOWNTO 16) WHEN i_S(4) = '1' AND s_shiftsig = "11" ELSE
        o_four;

o_O <= o_five;
END Structual;
