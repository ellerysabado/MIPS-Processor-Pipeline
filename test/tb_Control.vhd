library IEEE;
use IEEE.std_logic_1164.all;

entity tb_Control is
  generic(gCLK_HPER   : time := 50 ns);
end tb_Control;

architecture behavior of tb_Control is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component Control
  port(i_Opcode : in std_logic_vector(5 downto 0);  --OpCode
       i_Function   : in std_logic_vector(5 downto 0);  --Function
       o_ALUSrc     : out std_logic;
       o_ALUControl : out std_logic_vector(3 downto 0);
       o_Mem2Reg    : out std_logic;
       o_MemWrite   : out std_logic;
       o_RegDst     : out std_logic;
       o_RegWrite   : out std_logic;                    
       o_Jump       : out std_logic;
       o_JumpLink   : out std_logic;
       o_JumpReg    : out std_logic;
       o_Branch     : out std_logic;
       o_ExtSelect  : out std_logic;
       o_MemRead    : out std_logic);

  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK, s_ALUSrc, s_Mem2Reg, s_MemWrite, s_RegDst, s_RegWrite, s_Jump, s_JumpLink, s_JumpReg, s_Branch, s_ExtSelect, s_MemRead  : std_logic;
  signal s_ALUControl : STD_LOGIC_VECTOR(3 downto 0);
  signal s_instruction, s_Function : STD_LOGIC_VECTOR(5 downto 0);

begin

  DUT0: Control 
  port map(i_Opcode => s_instruction,
	   i_Function   => s_Function, 
           o_ALUSrc     => s_ALUSrc,
	   o_ALUControl => s_ALUControl, 
           o_Mem2Reg    => s_Mem2Reg,
	   o_MemWrite   => s_MemWrite, 
           o_RegDst     => s_RegDst,
           o_RegWrite   => s_RegWrite,
	   o_Jump       => s_Jump, 
           o_JumpLink   => s_JumpLink,
	   o_JumpReg    => s_JumpReg, 
           o_Branch     => s_Branch,
           o_ExtSelect  => s_ExtSelect,
           o_MemRead    => s_MemRead
);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin


    -- Test 1
    s_instruction   <= "000000";
    s_Function      <= "100000";
    wait for cCLK_PER;  

    -- Test 2
    s_instruction   <= "001000";
    s_Function      <= "000000";
    wait for cCLK_PER;  

    -- Test 3
    s_instruction   <= "001001";
    s_Function      <= "000000";
    wait for cCLK_PER;  

    -- Test 4
    s_instruction   <= "000000";
    s_Function     <= "100001";
    wait for cCLK_PER;  

    -- Test 5
    s_instruction   <= "000000";
    s_Function     <= "100100";
    wait for cCLK_PER;  

    -- Test 6
    s_instruction   <= "001100";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 7
    s_instruction   <= "001111";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 8
    s_instruction   <= "100011";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 9
    s_instruction   <= "000000";
    s_Function     <= "100111";
    wait for cCLK_PER;  

    -- Test 10
    s_instruction   <= "000000";
    s_Function     <= "100110";
    wait for cCLK_PER;  

    -- Test 11
    s_instruction   <= "001110";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 12
    s_instruction   <= "000000";
    s_Function     <= "100101";
    wait for cCLK_PER;  

    -- Test 13
    s_instruction   <= "001101";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 14
    s_instruction   <= "000000";
    s_Function     <= "101010";
    wait for cCLK_PER;  

    -- Test 15
    s_instruction   <= "001010";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 16
    s_instruction   <= "000000";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 17
    s_instruction   <= "000000";
    s_Function     <= "000010";
    wait for cCLK_PER;  

    -- Test 18
    s_instruction   <= "000000";
    s_Function     <= "000011";
    wait for cCLK_PER;  

    -- Test 19
    s_instruction   <= "101011";
    s_Function     <= "000000";
    wait for cCLK_PER; 

    -- Test 20
    s_instruction   <= "000000";
    s_Function     <= "100010";
    wait for cCLK_PER; 

    -- Test 21
    s_instruction   <= "000000";
    s_Function     <= "100011";
    wait for cCLK_PER;  

    -- Test 22
    s_instruction   <= "000100";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 23
    s_instruction   <= "000101";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 24
    s_instruction   <= "000010";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 25
    s_instruction   <= "000011";
    s_Function     <= "000000";
    wait for cCLK_PER;  

    -- Test 26
    s_instruction   <= "000000";
    s_Function     <= "001000";
    wait for cCLK_PER;  


 

    wait;
  end process;
  
end behavior;