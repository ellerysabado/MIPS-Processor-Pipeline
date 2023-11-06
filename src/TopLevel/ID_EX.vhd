library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EX is
  generic(N : integer := 32);
  port(i_CLK         : in std_logic;     -- Clock input
       i_RST         : in std_logic;     -- Reset input
       i_WE          : in std_logic;     -- Write enable input
       i_RegDstMux           : in std_logic_vector(N-1 downto 0);
       i_RegWrite    : out std_logic_vector(N-1 downto 0);
       i_imm         : in std_logic_vector(N-1 downto 0);
       i_Q           : in std_logic_vector(N-1 downto 0);
       i_O           : in std_logic_vector(N-1 downto 0);
       i_ALUSrc      : in std_logic_vector(N-1 downto 0);
       i_ALUOp       : in std_logic_vector(N-1 downto 0);
       i_Branch      : in std_logic_vector(N-1 downto 0);
       i_MemWrite    : in std_logic_vector(N-1 downto 0);
       i_MemRead     : in std_logic_vector(N-1 downto 0);
       i_MemtoReg    : in std_logic_vector(N-1 downto 0);
       o_RegDstMux   : out std_logic_vector(N-1 downto 0);
       o_imm         : out std_logic_vector(N-1 downto 0);
       o_Q           : out std_logic_vector(N-1 downto 0);
       o_O           : out std_logic_vector(N-1 downto 0);
       o_ALUSrc      : out std_logic_vector(N-1 downto 0);
       o_ALUOp       : out std_logic_vector(N-1 downto 0);
       o_Branch      : out std_logic_vector(N-1 downto 0);
       o_RegWrite    : out std_logic_vector(N-1 downto 0);
       o_MemWrite    : out std_logic_vector(N-1 downto 0);
       o_MemRead     : out std_logic_vector(N-1 downto 0);
       o_MemtoReg    : out std_logic_vector(N-1 downto 0));

end ID_EX;

architecture dataflow of ID_EX is

component Register_N
generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end component;


Signal s_ALUSrc : std_logic_vector(N-1 downto 0);

begin
  RegDstMux : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_RegDstMux,
           o_Q             => o_RegDstMux); 

  RegWrite : Register_N
  port MAP(i_CLK           => i_CLK,
          i_RST           => i_RST,
          i_WE            => i_WE,
          i_D             => i_RegWrite,
          o_Q             => o_RegWrite); 

  imm : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_imm,
           o_Q             => o_imm); 


  O : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_O,
           o_Q             => o_O); 

  Q : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_Q,
           o_Q             => o_Q); 


--s_ALUSrc <= "0000000000000000000000000000000" & i_ALUSrc;

  ALUSrc : Register_N
  generic map(N => 1)
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => s_ALUSrc,
           o_Q             => o_ALUSrc); 

--o_ALUSrc <= o_ALUSrc(0);

  ALUOp : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_ALUOp,
           o_Q             => o_ALUOp);        

  Branch : Register_N
  generic map(N => 1)
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_Branch,
           o_Q             => o_Branch); 


  MemWrite : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_MemWrite,
           o_Q             => o_MemWrite); 

  MemRead : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_MemRead,
           o_Q             => o_MemRead); 


  MemtoReg : Register_N
  generic map(N => 5)
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_MemtoReg,
           o_Q             => o_MemtoReg);        

end dataflow;