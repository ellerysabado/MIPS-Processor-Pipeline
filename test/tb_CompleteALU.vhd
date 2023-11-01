LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.all;
use work.inArr16.all;

ENTITY tb_CompleteALU IS
    GENERIC (
        gCLK_HPER : TIME := 10 ns;
        N : INTEGER := 32);
        PORT (
            i_iput1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            i_iput2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            alucontrol : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            ALUSrc : IN STD_LOGIC;
            o_ASum : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            o_ZERO : OUT STD_LOGIC;
            o_over : OUT STD_LOGIC
        );
END tb_CompleteALU;

ARCHITECTURE behavior OF tb_CompleteALU IS

    -- Calculate the clock period as twice the half-period
    CONSTANT cCLK_PER : TIME := gCLK_HPER * 2;
    COMPONENT CompleteALU
    GENERIC (N : INTEGER := 32);
    PORT (
        i_iput1 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        i_iput2 : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        alucontrol : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        ALUSrc : IN STD_LOGIC;
        o_ASum : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        o_ZERO : OUT STD_LOGIC;
        o_over : OUT STD_LOGIC);
    END COMPONENT;

    -- Temporary signals to connect to the dff component.
    SIGNAL s_CLK, s_RST : STD_LOGIC;
    SIGNAL si_RST : STD_LOGIC;
    SIGNAL si_iput1 : STD_LOGIC_VECTOR(N -1 DOWNTO 0);
    SIGNAL si_iput2 : STD_LOGIC_VECTOR(N -1 DOWNTO 0);
    SIGNAL s_alucontrol : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s_ALUSrc : STD_LOGIC;
    SIGNAL so_ASum : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL so_ZERO : STD_LOGIC;
    SIGNAL so_over : STD_LOGIC;
BEGIN

    CALU : CompleteALU
    PORT MAP(
        i_iput1 => si_iput1,
        i_iput2 => si_iput2,
        alucontrol => s_alucontrol,
        ALUSrc => s_ALUSrc,
        o_ASum => so_ASum,
        o_ZERO => so_ZERO,
        o_over => so_over
        );

    -- This process sets the clock value (low for gCLK_HPER, then high
    -- for gCLK_HPER). Absent a "wait" command, processes restart 
    -- at the beginning once they have reached the final statement.
    P_CLK : PROCESS
    BEGIN
        s_CLK <= '0';
        WAIT FOR gCLK_HPER;
        s_CLK <= '1';
        WAIT FOR gCLK_HPER;
    END PROCESS;
    P_RST : PROCESS
    begin
        -- --add
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "0000";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --add
        -- si_RST <= '0';
        -- si_iput1 <= "00000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "0000";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --addi
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "0000";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --addi
        -- si_RST <= '0';
        -- si_iput1 <= "00000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "0000";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --addiu
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "0001";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --addu
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "0001";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --sub
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000100000000000000";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "0010";
        -- s_ALUSrc <= '1';
        -- WAIT FOR cCLK_PER;

        -- --sub
        -- si_RST <= '0';
        -- si_iput1 <= "01100000000000000100000000000000";
        -- si_iput2 <= "00001110000000000000000000000000";
        -- s_alucontrol <= "0010";
        -- s_ALUSrc <= '1';
        -- WAIT FOR cCLK_PER;

        --srl
        si_RST <= '0';
        si_iput1 <= "10101010111111111111100001111100";
        si_iput2 <= "00000000000000000000000000000010";
        s_alucontrol <= "1000";
        s_ALUSrc <= '0';
        WAIT FOR cCLK_PER;

        -- --subu
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000100000000000000";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "0100";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --and
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000011000000000000";
        -- si_iput2 <= "10000000000000000000110000000000";
        -- s_alucontrol <= "0101";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --nor
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000001";
        -- s_alucontrol <= "0110";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --xor
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000001";
        -- s_alucontrol <= "0111";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --xori
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000001";
        -- s_alucontrol <= "0111";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        --sll ---isolate
        si_RST <= '0';
        si_iput1 <= "00100011000000000000000000000000";
        si_iput2 <= "00000000000000000000000000000010";
        s_alucontrol <= "0011";
        s_ALUSrc <= '0';
        WAIT FOR cCLK_PER;

        -- --or 
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000001";
        -- s_alucontrol <= "1001";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --ori
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000001";
        -- s_alucontrol <= "1001";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --slt
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000000";
        -- si_iput2 <= "10000000000000000000000000000001";
        -- s_alucontrol <= "1010";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --slt
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000001";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "1010";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --slti
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000001";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "1010";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --beq
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000001";
        -- si_iput2 <= "10000000000000000000000000000001";
        -- s_alucontrol <= "1011";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        --  --beq
        --  si_RST <= '0';
        --  si_iput1 <= "10000000000000000000000000000000";
        --  si_iput2 <= "10000000000000000000000000000001";
        --  s_alucontrol <= "1011";
        --  s_ALUSrc <= '0';
        --  WAIT FOR cCLK_PER;

        --sra ---isolate
        si_RST <= '0';
        si_iput1 <= "11000000000000000000000000000000";
        si_iput2 <= "00000000000000000000000000000010";
        s_alucontrol <= "1100";
        s_ALUSrc <= '0';
        WAIT FOR cCLK_PER;

        -- --bne
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000001";
        -- si_iput2 <= "10000000000000000000000000000001";
        -- s_alucontrol <= "1101";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        -- --bne
        -- si_RST <= '0';
        -- si_iput1 <= "10000000000000000000000000000001";
        -- si_iput2 <= "10000000000000000000000000000000";
        -- s_alucontrol <= "1101";
        -- s_ALUSrc <= '0';
        -- WAIT FOR cCLK_PER;

        --lui  ---isolate
        si_RST <= '0';
        si_iput1 <= x"00001001";
        si_iput2 <= "00000000000000000000000000000000";
        s_alucontrol <= "1110";
        s_ALUSrc <= '0';
        WAIT FOR cCLK_PER;

        --default
        si_RST <= '0';
        si_iput1 <= "00000000000000000000000000000000";
        si_iput2 <= "11111111111111111111111111111111";
        s_alucontrol <= "1111";
        s_ALUSrc <= '0';
        WAIT FOR cCLK_PER;
	WAIT;
    END PROCESS;

END behavior;
