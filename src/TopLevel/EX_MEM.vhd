library IEEE;
use IEEE.std_logic_1164.all;

entity EX_MEM is

  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_Inst_EX           : in std_logic_vector(N-1 downto 0);
       i_RegDstMux  : in std_logic_vector(4 downto 0);
       i_O          : in std_logic_vector(N-1 downto 0);
       i_ALUout     : in std_logic_vector(N-1 downto 0);
       i_MemWrite   : in std_logic;
       i_MemRead    : in std_logic;
       i_MemtoReg    : in std_logic;
       i_RegWrite   : in std_logic;
       o_Inst_EX           : out std_logic_vector(N-1 downto 0);
       o_RegDstMux  : out std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0);
       o_ALUout     : out std_logic_vector(N-1 downto 0);
       o_MemWrite   : out std_logic;
       o_MemRead    : out std_logic;
       o_RegWrite   : out std_logic;
       o_MemtoReg    : out std_logic);

end EX_MEM;

architecture dataflow of EX_MEM is

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

  Inst_EX : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_Inst_EX,
           o_Q             => o_Inst_EX); 

  RegDstMux : Register_N
  generic map(N => 5)
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_RegDstMux,
           o_Q             => o_RegDstMux); 


  O : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_O,
           o_Q             => o_O); 


  ALUout : Register_N
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_ALUout,
           o_Q             => o_ALUout); 


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


  RegWrite : dffg
	port MAP(i_CLK           => i_CLK,
		       i_RST           => i_RST,
           i_WE            => i_WE,
		       i_D             => i_RegWrite,
           o_Q             => o_RegWrite);   

  MemtoReg : dffg
  port MAP(i_CLK           => i_CLK,
          i_RST           => i_RST,
          i_WE            => i_WE,
          i_D             => i_MemtoReg,
          o_Q             => o_MemtoReg);   

end dataflow;
