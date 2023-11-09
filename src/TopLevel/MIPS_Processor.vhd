-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH;
	  I : integer := 26);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
component FetchComponent is
  port(i_CLK        : in std_logic;     -- Clock input
       i_jAddr      : in std_logic_vector(I-1 downto 0);     -- Reset input
       i_PC         : in std_logic_vector(N-1 downto 0);     -- Write enable input
       i_branchMuxD1 : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_branchEN   : in std_logic; 
       i_jumpEN     : in std_logic; 
       i_jrAddr     : in std_logic_vector(N-1 downto 0); 
       i_jrEN	    : in std_logic;
       o_pcOut      : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_final  : out std_logic_vector(N-1 downto 0));
end component;

component RegFile is 
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_RS         : in std_logic_vector(4 downto 0);     
       i_RT         : in std_logic_vector(4 downto 0); 
       i_RD         : in std_logic_vector(4 downto 0);    
       o_Q          : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

component Register_N is
generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end component;

component Extender is
	port 
	(
		i_data		: in std_logic_vector(15 downto 0);
		sel             : in std_logic;
		o_data	        : out std_logic_vector(31 downto 0)
	);

end component;


component mux2t1_N is
generic(N : integer := 32);
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

component Control is 
  port(i_OpCode : in std_logic_vector(5 downto 0);  --OpCode
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

component andg2 is 
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;


component Add_Sub
  port(
       iA               : in std_logic_vector(N-1 downto 0);
       iB               : in std_logic_vector(N-1 downto 0);
       i_S		: in std_logic;
       oC		: out std_logic;
       oSum		: out std_logic_vector(N-1 downto 0));

end component;

component CompleteALU is
  port(i_iput1      : in std_logic_vector(N-1 downto 0);
       i_iput2      : in std_logic_vector(N-1 downto 0);
       i_shamt 	    : in std_logic_vector(4 downto 0); 	
       alucontrol   : in std_logic_vector(3 downto 0);
       ALUSrc       : in std_logic;
       o_ASum       : out std_logic_vector(N-1 downto 0);
       o_ZERO       : out std_logic;
       o_over       : out std_logic); 
end component;

component IF_ID is
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_Flush      : in std_logic_vector(31 downto 0);     -- Data value input
       i_PCAdd      : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_InstMem    : in std_logic_vector(N-1 downto 0);     -- Data value input 
       o_PCAdd      : out std_logic_vector(N-1 downto 0);     -- Data value output FIX THIS Data bits--------------------------------
       o_InstMem    : out std_logic_vector(N-1 downto 0));    -- Data value output 
end component;

component ID_EX is
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

end component;


component EX_MEM is
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
end component;

component MEM_WB IS
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
    o_RegDstMux : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
  );

END component;

component HazardDetectionUnit IS
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
END component;

--Extra Added Signals 
signal  s_RD         :  std_logic_vector(4 downto 0);     
signal  s_RegOutData  	   :  std_logic_vector(31 downto 0);
signal  s_imm16            :  std_logic_vector(15 downto 0);
signal  s_imm32, s_IF_Flush 	   :  std_logic_vector(31 downto 0);
signal  s_MuxOutToALU      :  std_logic_vector(N-1 downto 0);
signal  s_ALUSrc           :  std_logic;
signal  s_ALUControl 	   :  std_logic_vector(3 downto 0);
signal  s_Mem2Reg    	   :  std_logic;
signal  s_MemWrite  	   :  std_logic;
signal  s_RegDst    	   :  std_logic;                   
signal  s_Jump       	   :  std_logic;
signal  s_JumpLink   	   :  std_logic;
signal  s_JumpReg    	   :  std_logic;
signal  s_Branch    	   :  std_logic;
signal  s_ExtSelect 	   :  std_logic;
signal	s_MemRead    	   :  std_logic;
signal  s_PC               :  std_logic_vector(N-1 downto 0);     
signal  s_branchAddr 	   :  std_logic_vector(N-1 downto 0);         
signal  s_jrAddr           :  std_logic_vector(N-1 downto 0); 
signal  s_PCsrc  	   :  std_logic;
signal  s_Zero  	   :  std_logic;
signal  s_PCoutput, s_pcDEL, s_Data, s_shiftBranchAddr       :  std_logic_vector(N-1 downto 0); 
signal  s_PCAdd  :  std_logic_vector(N-1 downto 0);
signal  s_InstMem  :  std_logic_vector(N-1 downto 0);
signal  s_imm_EX    :  std_logic_vector(N-1 downto 0);
signal  s_Q_EX    :  std_logic_vector(N-1 downto 0);
signal  s_O_EX    :  std_logic_vector(N-1 downto 0);
signal  s_PCAddBranch_EX, s_PCAddBranch    :  std_logic_vector(N-1 downto 0);
signal s_ALUOp_EX	   :  std_logic_vector(3 downto 0); 
signal s_ALUSrc_EX  :  std_logic;
signal s_Branch_EX  :  std_logic;
signal s_MemWrite_EX   :  std_logic;
signal s_MemRead_EX  :  std_logic;
signal s_MemtoReg_EX, s_RegWr_ID  :  std_logic;
signal s_ALUout_MEM :  std_logic_vector(N-1 downto 0);
signal s_O_MEM  :  std_logic_vector(N-1 downto 0);
signal s_Inst_ID  :  std_logic_vector(N-1 downto 0);
signal s_MemWrite_MEM :  std_logic;
signal s_MemRead_MEM :  std_logic;
signal s_RegWrite_MEM :  std_logic;
signal s_RegWrite_EX :  std_logic;
signal s_MemtoReg_MEM :  std_logic;  
signal s_RegWrite_WB, s_MemWrite_ID  :  std_logic;
signal s_MemtoReg_WB  :  std_logic;
signal s_MemReadData_WB :  std_logic_vector(N-1 downto 0);
signal s_ALUout_WB  :  std_logic_vector(N-1 downto 0);
signal s_RegDstMux_WB :  std_logic_vector(4 downto 0);
signal s_RegDstMux_EX :  std_logic_vector(4 downto 0);
signal s_RegDstMux_MEM :  std_logic_vector(4 downto 0);
signal s_Inst_EX, s_Inst_MEM, s_Inst_WB, sALUOut_in  :  std_logic_vector(N-1 downto 0);
signal s_IF_ID_Write, s_ControlMuxSel, s_PCWrite : std_logic;
signal s_ControlMuxIn, s_ControlMuxOut :  std_logic_vector(14 downto 0);



begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
with s_Inst_WB select
    s_Halt <= '1' when x"50000000",
      '0' when others;
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU
  -- TODO: Implement the rest of your processor below this comment! 
g_extender: Extender 
port map(i_data	=> s_Inst_ID(15 downto 0),
	sel	=> s_ControlMuxOut(1),
	o_data	=> s_imm32);

g_MuxWriteReg: mux2t1_N
generic map(N => 5)
port map(i_S		=> s_ControlMuxOut(7),
	i_D0		=> s_Inst_ID(20 downto 16),
	i_D1		=> s_Inst_ID(15 downto 11),
	o_O		=> s_RD);

g_RegisterFile: RegFile
port map(i_CLK		=> iCLK,
	i_RST		=> iRST,
	i_WE		=> s_RegWr,
	i_D		=> s_RegWrData,
	i_RS		=> s_Inst_ID(25 downto 21),
	i_RT		=> s_Inst_ID(20 downto 16),
	i_RD		=> s_RegDstMux_WB,
	o_Q		=> s_RegOutData,
	o_O		=> s_O_MEM);

g_PCreg : Register_N
port map(i_CLK       => iCLK, 
       i_RST         => iRST,
       i_WE          => s_PCWrite,
       i_D           => s_PCoutput,
       o_Q           => s_NextInstAddr);

g_MuxtoALU: mux2t1_N
port map(i_S		=> s_ALUSrc_EX,
	i_D0		=> s_O_EX,
	i_D1		=> s_imm_EX,
	o_O		=> s_MuxOutToALU);

g_FetchComponent: FetchComponent
port map(i_CLK		=> iCLK,     
       i_jAddr		=> s_Inst_ID(25 downto 0),      
       i_PC		=> s_PCAdd,        
       i_branchMuxD1 => s_PCAddBranch_EX,
       i_branchEN	=> s_PCSrc,       
       i_jumpEN		=> s_ControlMuxOut(5),    
       i_jrAddr		=> s_RegOutData,      
       i_jrEN		=> s_ControlMuxOut(3),	    
       o_pcOut		=> s_PCoutput,     
       o_final	        => s_pcDEL);

s_shiftBranchAddr <= s_imm32(29 downto 0) & "00";


g_PCAdder1: Add_Sub 
port map(
	iA	=> s_PCAdd,
	iB	=> s_shiftBranchAddr,
	i_S	=> '0',
	oC	=> open,
	oSum	=> s_PCAddBranch);


g_ControlUnit: Control
port map(i_OpCode      => s_Inst_ID(31 downto 26),   
       i_Function      => s_Inst_ID(5 downto 0),   
       o_ALUSrc        => s_ALUSrc, 
       o_ALUControl    => s_ALUControl, 
       o_Mem2Reg       => s_Mem2Reg,
       o_MemWrite      => s_MemWrite_ID, 
       o_RegDst        => s_RegDst,
       o_RegWrite      => s_RegWr_ID,                   
       o_Jump          => s_Jump,
       o_JumpLink      => s_JumpLink,
       o_JumpReg       => s_JumpReg,
       o_Branch        => s_Branch,
       o_ExtSelect     => s_ExtSelect,
       o_MemRead       => s_MemRead);

g_andGate: andg2
port map(i_A            => s_Branch_EX,
       i_B              => s_Zero,
       o_F              => s_PCSrc);

g_completeALU: CompleteALU
port map(alucontrol	=> s_ALUOp_EX,
	i_iput1		=> s_Q_EX,
	i_iput2		=> s_MuxOutToALU,
	i_shamt 	=> s_imm_EX(10 DOWNTO 6),
	ALUSrc		=> s_ALUSrc_EX,    
	o_over		=> s_Ovfl,
	o_ZERO		=> s_Zero,
	o_ASum		=> oALUOut);

s_DMemAddr <= s_ALUout_MEM;
sALUOut_in <= oALUOut;

g_MuxMemToReg: mux2t1_N
port map(i_S		=> s_MemtoReg_WB,
	i_D0		=> s_ALUout_WB,
	i_D1		=> s_MemReadData_WB,
	o_O		=> s_RegWrData);

g_jumplinkMUX0: mux2t1_N 
generic map(N => 32)
port map (
    i_S  => s_ControlMuxOut(4),
    i_D0 => s_DMemAddr,      
    i_D1 => s_pcDEL,     
    o_O  => s_Data);

g_jumplinkMUX1: mux2t1_N
generic map(N => 5) 
port map (
    i_S  => s_ControlMuxOut(4),
    i_D0 => s_RegDstMux_WB,      
    i_D1 => "11111",     
    o_O  => s_RegWrAddr);

g_IF_ID: IF_ID 
port map(i_CLK		=> iCLK,     
       i_RST    	=> iRST,    
       i_WE     	=> s_IF_ID_Write,
       i_Flush    => s_IF_Flush,  
       i_PCAdd   	=> s_PCoutput,
       i_InstMem    	=> s_Inst,
       o_PCAdd     	=> s_PCAdd,
       o_InstMem  	=> s_Inst_ID);

g_ID_EX: ID_EX 
  port map(i_CLK          => iCLK,
        i_RST        	=> iRST,
        i_WE          	=> '1',
        i_Inst_ID       => s_Inst_ID,
        i_PCAddBranch  => s_PCAddBranch,
        i_RegDstMux   => s_RD,
        i_imm        	=> s_imm32,
        i_Q           	=> s_RegOutData,
        i_O           	=> s_O_MEM,
        i_ALUSrc      	=> s_ControlMuxOut(14),
        i_ALUOp       	=> s_ControlMuxOut(13 downto 10),
        i_RegWrite      	=> s_ControlMuxOut(6),
        i_Branch      	=> s_ControlMuxOut(2),
        i_MemWrite    	=> s_ControlMuxOut(8),
        i_MemRead     	=> s_ControlMuxOut(0),
        i_MemtoReg   	=> s_ControlMuxOut(9),
        o_Inst_ID       => s_Inst_EX,
        o_PCAddBranch   => s_PCAddBranch_EX,
        o_imm         	=> s_imm_EX,
        o_Q          	=> s_Q_EX,
        o_O           	=> s_O_EX,
        o_ALUSrc      	=> s_ALUSrc_EX,
        o_ALUOp       	=> s_ALUOp_EX,
        o_RegDstMux      	=> s_RegDstMux_EX,
        o_Branch      	=> s_Branch_EX,
        o_RegWrite      => s_RegWrite_EX,
        o_MemWrite    	=> s_MemWrite_EX,
        o_MemRead     	=> s_MemRead_EX,
        o_MemtoReg    	=> s_MemtoReg_EX);
       

g_EX_MEM: EX_MEM 
port map(i_CLK    	=> iCLK,    
        i_RST       	=> iRST,
        i_WE       	=> '1',
        i_Inst_EX     => s_Inst_EX,
        i_RegDstMux  	=> s_RegDstMux_EX,
        i_O         	=> s_O_EX,
        i_ALUout     	=> sALUOut_in,
        i_MemWrite   	=> s_MemWrite_EX,
        i_MemRead    	=> s_MemRead_EX,
        i_RegWrite   	=> s_RegWrite_EX,
        i_MemToReg    => s_MemtoReg_EX,
        o_Inst_EX     => s_Inst_MEM,
        o_RegDstMux 	=> s_RegDstMux_MEM,
        o_O         	=> s_DMemData,
        o_ALUout     	=> s_ALUout_MEM,
        o_MemWrite   	=> s_DMemWr, 
        o_MemRead   	=> s_MemRead_MEM,
        o_RegWrite   	=> s_RegWrite_MEM,
        o_MemtoReg    => s_MemtoReg_MEM);

g_MEM_WB: MEM_WB 
PORT map (
    i_CLK            => iCLK,
    i_RST            => iRST,
    i_WE             => '1', 
    i_Inst_MEM        => s_Inst_MEM,
    i_RegWrite       => s_RegWrite_MEM,
    i_MemtoReg       => s_MemtoReg_MEM,
    i_MemReadData    => s_DMemOut,
    i_ALUout         => s_ALUout_MEM,
    i_RegDstMux      => s_RegDstMux_MEM, 
    o_Inst_MEM       => s_Inst_WB,
    o_RegWrite       => s_RegWr,
    o_MemtoReg       => s_MemtoReg_WB,
    o_MemReadData    => s_MemReadData_WB,
    o_ALUout         => s_ALUout_WB,
    o_RegDstMux      => s_RegDstMux_WB);

g_HazardDetectionUnit: HazardDetectionUnit 
PORT map(
    ID_EX_MemRead     => s_MemRead_EX,
    ID_EX_RegisterRt  => s_Inst_EX(20 downto 16),
    IF_ID_RegisterRs  => s_Inst_ID(15 downto 11),
    IF_ID_RegisterRt  => s_Inst_ID(20 downto 16),
    ControlMUXSel     => s_ControlMuxSel,
    PCWrite           => s_PCWrite,
    IF_ID_Write       => s_IF_ID_Write,
    IF_Flush          => s_IF_Flush);

s_ControlMuxIn <= s_ALUSrc & s_ALUControl & s_Mem2Reg & s_MemWrite_ID & s_RegDst & s_RegWr_ID & s_Jump & s_JumpLink & s_JumpReg
                  & s_Branch & s_ExtSelect & s_MemRead;

g_ControlMuxSel: mux2t1_N
generic map(N => 15)
port map(
    i_S		=> s_ControlMuxSel,
	  i_D0		=> "000000000000000",
	  i_D1		=> s_ControlMuxIn,
  	o_O		=> s_ControlMuxOut);


end structure;

