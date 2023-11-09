LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY MEM_WB IS
generic(N : integer := 32);
  PORT (
    i_CLK : IN STD_LOGIC; -- Clock input
    i_RST : IN STD_LOGIC; -- Reset input
    i_WE : IN STD_LOGIC; -- Write enable input
    i_Inst_MEM           : IN std_logic_vector(N-1 downto 0);
    i_RegWrite : IN STD_LOGIC;
    i_MemToReg : IN STD_LOGIC;
    i_MemReadData : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    i_ALUout : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    i_RegDstMux : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    o_Inst_MEM           : OUT std_logic_vector(N-1 downto 0);
    o_RegWrite : OUT STD_LOGIC;
    o_MemToReg : OUT STD_LOGIC;
    o_MemReadData : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    o_ALUout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    o_RegDstMux : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));

END MEM_WB;

ARCHITECTURE dataflow OF MEM_WB IS

  COMPONENT Register_N
  generic(N : integer := 32);
    PORT (
      i_CLK : IN STD_LOGIC; -- Clock input
      i_RST : IN STD_LOGIC; -- Reset input
      i_WE : IN STD_LOGIC; -- Write enable input
      i_D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- Data value input
      o_Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)); -- Data value output

  END COMPONENT;

  component dffg is

    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  
  end component;
  
BEGIN

Inst_WB : Register_N
PORT MAP(
  i_CLK => i_CLK,
  i_RST => i_RST,
  i_WE => i_WE,
  i_D => i_Inst_MEM,
  o_Q => o_Inst_MEM);

RegWrite : dffg
PORT MAP(
  i_CLK => i_CLK,
  i_RST => i_RST,
  i_WE => i_WE,
  i_D => i_RegWrite,
  o_Q => o_RegWrite);

  MemToReg : dffg
  PORT MAP(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => i_WE,
    i_D => i_MemToReg,
    o_Q => o_MemToReg);

  MemReadData : Register_N
  PORT MAP(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => i_WE,
    i_D => i_MemReadData,
    o_Q => o_MemReadData);

  ALUout : Register_N
  PORT MAP(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => i_WE,
    i_D => i_ALUout,
    o_Q => o_ALUout);

  RegDstMux : Register_N
  generic map(N => 5)
  PORT MAP(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => i_WE,
    i_D => i_RegDstMux,
    o_Q => o_RegDstMux);

END dataflow;