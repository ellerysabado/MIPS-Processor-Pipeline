library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EX is
  generic(N : integer := 32);
  port(i_CLK         : in std_logic;     -- Clock input
       i_RST         : in std_logic;     -- Reset input
       i_WE          : in std_logic;     -- Write enable input
       i_Inst_ID           : in std_logic_vector(N-1 downto 0);
       i_RegDstMux   : in std_logic_vector(4 downto 0);
       i_RegWrite    : in std_logic;
       i_PCAddBranch         : in std_logic_vector(N-1 downto 0);
       i_imm         : in std_logic_vector(N-1 downto 0);
       i_Q           : in std_logic_vector(N-1 downto 0);
       i_O           : in std_logic_vector(N-1 downto 0);
       i_ALUSrc      : in std_logic;
       i_ALUOp       : in std_logic_vector(3 downto 0);
       i_Branch      : in std_logic;
       i_MemWrite    : in std_logic;
       i_MemRead     : in std_logic;
       i_MemtoReg    : in std_logic;
       o_Inst_ID           : out std_logic_vector(N-1 downto 0);
       o_RegDstMux   : out std_logic_vector(4 downto 0);
       o_PCAddBranch         : out std_logic_vector(N-1 downto 0);
       o_imm         : out std_logic_vector(N-1 downto 0);
       o_Q           : out std_logic_vector(N-1 downto 0);
       o_O           : out std_logic_vector(N-1 downto 0);
       o_ALUSrc      : out std_logic;
       o_ALUOp       : out std_logic_vector(3 downto 0);
       o_Branch      : out std_logic;
       o_RegWrite    : out std_logic;
       o_MemWrite    : out std_logic;
       o_MemRead     : out std_logic;
       o_MemtoReg    : out std_logic);

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

component dffg is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

end component;

begin
  Inst_ID : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_Inst_ID,
           o_Q             => o_Inst_ID); 

  RegDstMux : Register_N
  generic map(N => 5)
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_RegDstMux,
           o_Q             => o_RegDstMux); 

  PCAddBranch : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_PCAddBranch,
           o_Q             => o_PCAddBranch); 

  RegWrite : dffg
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

  ALUSrc : dffg
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_ALUSrc,
           o_Q             => o_ALUSrc); 

  ALUOp : Register_N
  generic map(N => 4)
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_ALUOp,
           o_Q             => o_ALUOp);        

  Branch : dffg
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_Branch,
           o_Q             => o_Branch); 


  MemWrite : dffg
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_MemWrite,
           o_Q             => o_MemWrite); 

  MemRead : dffg
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_MemRead,
           o_Q             => o_MemRead); 


  MemtoReg : dffg
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_MemtoReg,
           o_Q             => o_MemtoReg);        

end dataflow;